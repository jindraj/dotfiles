colors = {
  {  88,  24,  28 }, --
  {  89,  29,  28 }, -- not bad
  {  90,  29, 100 }, -- not bad
  {  91,  34, 142 }, --
  {  92,  40, 184 }, -- nice not bad
  {  93,  82, 154 }, --
  {  94,  18,  30 }, --
  {  95,  60,  65 }, --
  {  96,  66, 101 }, --
  {  97,  71, 143 }, --
  {  98, 113, 185 }, --
  {  99, 155, 227 }, -- nice
  { 100,  54,  30 }, --
  { 101,  96,  66 }, -- BAD: unreadable
  { 103, 108, 138 }, --
  { 104, 150, 174 }, --
  { 105, 192, 210 }, -- nice
  { 106,  55,  19 }, --
  { 107, 133,  61 }, --
  { 108, 138, 103 }, --
  { 109, 144, 139 }, -- BAD: unreadable
  { 110, 186, 174 }, --
  { 111, 228, 210 }, --
  { 112,  92,  20 }, -- not bad
  { 113, 170,  62 }, -- not bad
  { 114, 175, 104 }, -- not bad
  { 115, 174, 176 }, -- not bad
  { 116, 180, 176 }, --
  { 117, 222, 210 }, -- BAD: unreadable
  { 118, 129,  57 }, --
  { 119, 207, 135 }, --
  { 120, 212, 105 }, -- not bad
  { 121, 211, 213 }, -- not bad
  { 122, 210, 213 }, -- not bad
  { 123, 216, 213 }, --
  {  51, 202, 201 }, --
  { 196,  45,  50 }, -- nice
  { 197,  50,  48 }, -- nice
  { 198,  49,  47 }, -- nice
  { 199,  48,  46 }, -- nice
  { 200,  47,  46 }, --
  { 201,  47, 226 }, --
  { 202,  33,  45 }, -- nice
  { 203,  81,  86 }, -- nice
  { 204,  87,  85 }, -- nice
  { 205,  86,  84 }, -- not bad
  { 206,  85,  83 }, -- not bad
  { 207,  84, 119 }, -- not bad
  { 208,  27,  39 }, -- not bad
  { 209,  75,  87 }, -- nice
  { 210, 117, 120 }, --
  { 211, 123, 120 }, -- not bad
  { 212, 122, 120 }, -- not bad
  { 213, 121, 228 }, -- not bad
  { 214,  21,  33 }, --
  { 215,  69,  81 }, --
  { 216, 111, 123 }, --
  { 217, 153, 157 }, -- BAD: unreadable
  { 218, 159, 157 }, --
  { 219, 158, 229 }, --
  { 220,  21,  27 }, --
  { 221,  63,  75 }, --
  { 222, 105, 123 }, -- not bad
  { 223, 147, 159 }, -- BAD: unreadable
  { 224, 189, 194 }, --
  { 225, 195, 230 }, --
  { 226,  57,  51 }, -- nice
  { 227,  99,  69 }, -- nice
  { 228, 141, 123 }, --
  { 229, 183, 159 }, --
  { 230, 225, 195 }, --
}

current = mutt.get("my_theme_number")
repeat
  i = math.random(#colors)
until current ~= colors[i][1]

mutt.set("my_theme_number", ''..colors[i][1])
mutt.set("my_theme_color","color" .. colors[i][2])
mutt.set("my_theme_color2","color" .. colors[i][3])
mutt.set("my_theme_color3","color" .. colors[i][1])
mutt.set("my_textcolor","color" .. colors[i][1])
if not mutt.get("arrow_cursor") then
  mutt.enter("source ~/.neomutt/toggle/neomuttrc.arrow_cursor_off")
end
mutt.enter("source ~/.neomutt/neomuttrc.profile-common")
--mutt.enter("exec refresh;echo 'a'")
--mutt.call("echo","'Color scheme: '" ..i)
