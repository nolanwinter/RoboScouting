require "data"

local composer = require("composer")
composer.isDebug = True
display.setStatusBar(display.HiddenStatusBar)

Data.read_history()

--composer.gotoScene("test")
composer.gotoScene("match_info")
-- convert to byte, subtract 40 so that they are all double digits, if less than 10, add a leading zero