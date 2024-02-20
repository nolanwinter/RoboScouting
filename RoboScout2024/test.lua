-----------------------------------------------------------------------------------------
--
-- test.lua
--
-----------------------------------------------------------------------------------------
require "objects"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

-- -----------------------
-- Generic Event Functions
-- -----------------------

-- ---------------------
-- Scene Event Functions
-- ---------------------

function scene:create(event)
    local sceneGroup = self.view

    local bckgnd_grad = {
        type = "gradient",
        color1 = {1,1,1},
        color2 = {0.42,0,0},
        direction="down"
    }
    local background = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.actualContentWidth,display.actualContentHeight)
    background.fill = bckgnd_grad
	--background.alpha=0.3

	-- Gather insets (function returns these in the order of top, left, bottom, right)
	local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
	
	-- Create a vector rectangle sized exactly to the "safe area"
	local safeArea = display.newRect(
		display.screenOriginX + leftInset, 
		display.screenOriginY + topInset, 
		display.actualContentWidth - ( leftInset + rightInset ), 
		display.actualContentHeight - ( topInset + bottomInset )
	)
	--safeArea:translate( safeArea.width*0.5, safeArea.height*0.5 )
	safeArea.anchorX=0
	safeArea.anchorY=0
	safeArea.x = 0
	--safeArea.y = 0
	safeArea:setFillColor(0,0,1)
	safeArea.alpha = 0.3

	--test_qr = Objects.QRCode.init(sceneGroup, "Hello World! This is Nolan successfully talking to my phone!", 250, 20, 60)
    
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene