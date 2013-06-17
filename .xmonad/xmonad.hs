import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Circle
import XMonad.Layout.ShowWName
import System.IO
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- import XMonad.Util.Run(spawnPipe)
-- import XMonad.Util.EZConfig(additionalKeys)

myTerminal      = "uxterm"
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#bd96bd"
myFocusedBorderColor = "#ff208c"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask .|. shiftMask  , xK_Return ), spawn $ XMonad.terminal conf)			  -- launch a terminal
    , ((modMask .|. shiftMask  , xK_p      ), spawn "gmrun")					  -- launch gmrun
    , ((modMask                , xK_p      ), spawn "exe=`dmenu_run`  && eval \"exec $exe\"")	  -- launch dmenu
    , ((modMask .|. shiftMask  , xK_c      ), kill)						  -- Close focused window 
    , ((modMask                , xK_space  ), sendMessage NextLayout)				  -- Rotate through the available layout algorithms
    , ((modMask .|. shiftMask  , xK_space  ), setLayout $ XMonad.layoutHook conf)		  -- Reset the layouts on the current workspace to default
    , ((modMask                , xK_n      ), refresh)						  -- Resize viewed windows to the correct size
    , ((mod1Mask               , xK_Tab    ), windows W.focusDown)				  -- Move focus to the next window
    , ((modMask                , xK_j      ), windows W.focusDown)				  -- Move focus to the next window
    , ((modMask                , xK_k      ), windows W.focusUp)				  -- Move focus to the previous window
    , ((mod1Mask .|. shiftMask , xK_Tab    ), windows W.focusUp)				  -- Move focus to the previous window
    , ((modMask                , xK_m      ), windows W.focusMaster)				  -- Move focus to the master window
    , ((modMask                , xK_Return ), windows W.swapMaster)				  -- Swap the focused window and the master window
    , ((modMask .|. shiftMask  , xK_j      ), windows W.swapDown)				  -- Swap the focused window with the next window
    , ((modMask .|. shiftMask  , xK_k      ), windows W.swapUp)					  -- Swap the focused window with the previous window
    , ((modMask                , xK_h      ), sendMessage Shrink)				  -- Shrink the master area
    , ((modMask                , xK_l      ), sendMessage Expand)				  -- Expand the master area
    , ((modMask                , xK_t      ), withFocused $ windows . W.sink)			  -- Push window back into tiling
    , ((modMask                , xK_comma  ), sendMessage (IncMasterN 1))			  -- Increment the number of windows in the master area
    , ((modMask                , xK_period ), sendMessage (IncMasterN (-1)))			  -- Deincrement the number of windows in the master area
    , ((modMask                , xK_q      ), restart "xmonad" True)                              -- XMonad restart
    , ((modMask .|. shiftMask  , xK_q      ), io (exitWith ExitSuccess))                          -- XMonad quit
    , ((modMask .|. shiftMask  , xK_b      ), spawn "killall -s SIGUSR1 xmobar &> /dev/null")     -- Switch xmobar to next screen
    , ((modMask                , xK_x      ), spawn "xscreensaver-command -lock")                 -- lock session with xscreensaver
    , ((0                      , 0x1008ff2f), spawn "sudo hibernate-ram &> /dev/null")            -- hibernate
    , ((modMask                , xK_w      ), spawn "wpa_cli scan reassociate")                   -- scan for wi-fi networks and reassociate
    , ((modMask .|. shiftMask  , xK_v      ), spawn "pavucontrol &> /dev/null")                   -- run pavucontrol
    , ((0                      , xK_Print  ), spawn "scrot -q 100 /tmp/screen_%Y-%m-%d.png -d 1") -- Take screenshot
    -- Audio control: lower,raise,mute
    , ((0                      , 0x1008FF11), spawn "pacmd dump|awk --non-decimal-data '$1~/set-sink-volume/{system (\"pacmd \"$1\" \"$2\" \"$3-1000)}'")
    , ((0                      , 0x1008FF13), spawn "pacmd dump|awk --non-decimal-data '$1~/set-sink-volume/{system (\"pacmd \"$1\" \"$2\" \"$3+1000)}'")
    , ((0                      , 0x1008FF12), spawn "pacmd dump|awk --non-decimal-data '$1~/set-sink-mute/{system (\"pacmd \"$1\" \"$2\" \"($3==\"yes\"?\"no\":\"yes\"))}'")
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))	-- mod-button1, Set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))	-- mod-button2, Raise the window to the top of the stack
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))	-- mod-button3, Set the window to floating mode and resize by dragging
--    , ((modMask, button4), (sendMessage MagnifyMore))
--    , ((modMask, button5), (sendMessage MagnifyLess))			-- switch to next workspace
    ]

------------------------------------------------------------------------
-- Layouts:
myLayout = tiled ||| Mirror tiled ||| Full ||| Circle -- ||| magnifier (Tall 1 (3/100) (1/2))
  where
     tiled       = Tall nmaster delta ratio	-- default tiling algorithm partitions the screen into two panes
     nmaster     = 1				-- The default number of windows in the master pane
     ratio       = 3/4				-- Default proportion of screen occupied by master pane
     delta       = 25/1000			-- Percent of screen to increment by when resizing panes

------------------------------------------------------------------------
-- Window rules:
myManageHook = composeAll
    [ className =? "MPlayer"			--> doFloat
    , title     =? "Firefox Preferences"	--> doFloat	-- Firefox Preferences
    , title     =? "Firefox Add-on Updates"	--> doFloat	-- Firefox Add-ons
    , title     =? "Clear Private Data"		--> doFloat	-- Firefox Clear private data
    , title     =? "Certificate Manager"	--> doFloat	-- Firefox Certificate manager
    , className =? "Gimp"			--> doFloat
    , resource  =? "desktop_window"		--> doIgnore
    , resource  =? "kdesktop"			--> doIgnore ]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- myLogHook = return ()
myLogHook            = dynamicLogWithPP $ xmobarPP { 
				 ppTitle = xmobarColor "green" "" . shorten 70,
                                 ppHiddenNoWindows = xmobarColor "grey" "" 
                             }
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
-- main = xmonad defaults
-- myBar = "xmobar"
main = xmonad =<< xmobar defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
      -- hooks, layouts
        layoutHook         = showWName myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
