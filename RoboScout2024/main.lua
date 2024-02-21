-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

require "data"

system.activate("multitouch")

local composer = require("composer")
composer.isDebug = True
display.setStatusBar(display.HiddenStatusBar)

Data.read_history()

--composer.gotoScene("test")
composer.gotoScene("match_info")

-- convert to byte, subtract 40 so that they are all double digits, if less than 10, add a leading zero

--properly attribute the qr generation by https://github.com/speedata/luaqrcode/blob/master/qrencode.lua