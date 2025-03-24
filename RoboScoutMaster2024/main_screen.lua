--require "objects"

local asset_loc = "Assets/"

local composer = require("composer")
local scene = composer.newScene()
local warning
local retry

-- -----------------------
-- Generic Event Functions
-- -----------------------

function show_warning(show)
	if show then
		warning.isVisible = true
		retry.isVisible = true
	else
		warning.isVisible = false
		retry.isVisible = false
	end
end

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
    local background_top = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.actualContentWidth,display.actualContentHeight)
    background_top:setFillColor(1,1,1)
	local background_bottom = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY+(display.actualContentHeight/4),display.actualContentWidth,display.actualContentHeight/2)
    background_bottom.fill = bckgnd_grad

	warning = display.newImageRect(sceneGroup, asset_loc.."error_icon.png", 30, 30)
	warning.anchorX=1
	warning.anchorY=0
	warning.x = Data.sx + Data.sw - 10
	warning.y = 5 + Data.sy
	warning.isVisible = false
	
	retry = display.newImageRect(sceneGroup, asset_loc.."reset_button.png", 30, 30)
	retry.anchorX=1
	retry.x = warning.x - warning.width - 5
	retry.y = warning.y + (warning.height/2)
	retry.isVisible = false
	retry:addEventListener("tap", function() warning.isVisible = false success = Data.send_match_to_server() show_warning(not success) end)

	local input_button = display.newImageRect(sceneGroup, asset_loc.."data_input_button.png", 80, 40)
	input_button.x = display.contentCenterX--/2 + Data.sx
	input_button.y = display.contentCenterY
	input_button:addEventListener("tap", function() composer.gotoScene("data_input") end)
    
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		show_warning(Data.queue_len() > 0)
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