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

	local button_back = display.newRect(sceneGroup,display.contentCenterX,40,50,20)    
	button_back:setFillColor(0,0,0)
	button_back:addEventListener("tap", function () print("Back button pressed") end)

	local hidden_rect = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterX,display.actualContentWidth,display.actualContentHeight)
	hidden_rect:setFillColor(1,1,1,0)
	hidden_rect.isHitTestable = true
	hidden_rect:addEventListener("tap", function() print("Hidden rect pressed") end)

	local text = native.newTextField(display.contentCenterX, 100, 100, 200)
	text.anchorY = 0
	text.isEditable = true
	text:addEventListener("tap", function() print("Text field pressed") end)
	sceneGroup:insert(text)

	local button_front = display.newRect(sceneGroup,display.contentCenterX,350,50,20)
	button_front:setFillColor(1,0,0)
	button_front:addEventListener("tap", function() print("Front Button pressed") end)
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