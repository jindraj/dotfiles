xrdb -merge ~/.Xresources
xset +dpms
xset dpms 500 1000 1500
eval `ssh-agent`
eval $(gpg-agent --daemon)
xscreensaver &> /dev/null &
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --height 12 --transparent true --tint 0x000000 &
xsetbg ~/downloads/wallpapers/Xmbindings.png

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session xmonad
