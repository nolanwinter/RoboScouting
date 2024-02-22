module("Data", package.seeall)

local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
sx = display.screenOriginX + leftInset
sy = display.screenOriginY + topInset
sw = display.actualContentWidth - ( leftInset + rightInset )
sh = display.actualContentHeight - ( topInset + bottomInset )