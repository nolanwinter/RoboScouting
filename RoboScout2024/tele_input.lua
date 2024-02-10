-----------------------------------------------------------------------------------------
--
-- auto_input.lua
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
    local background = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.contentWidth,1.5*display.contentHeight)
    background.fill = bckgnd_grad

    local test_id_1 = Objects.Inc_Dec.init(sceneGroup,"Notes Scored\nin Amp", 20, 10, 10, 20, 20, 30, 30, 30, 25, 0, 20)
    local test_id_2 = Objects.Inc_Dec.init(sceneGroup,"Text 2", 20, 60, 15, 20, 20, 30, 35, 30, 25, 0, 7)
    local test_radio_1 = Objects.Radio.init(sceneGroup,"Radio Test\nMultiLine", 20, 110, 15, 20, 20, 35, true, false)
    local test_radio_2 = Objects.Radio.init(sceneGroup,"Radio Test\n#2", 20, 160, 15, 20, 20, 35, false, true)
    local text_input = Objects.TextInput.init(sceneGroup, "Anything special about the team\nto mention?", 20, 210, 10, 20, 200, "Test hint.", 18)
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