require "data"

local composer = require("composer")
composer.isDebug = True
display.setStatusBar(display.HiddenStatusBar)

composer.gotoScene("main_screen")
--composer.gotoScene("test")

-- convert to byte, subtract 40 so that they are all double digits, if less than 10, add a leading zero