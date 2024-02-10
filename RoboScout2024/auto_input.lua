-----------------------------------------------------------------------------------------
--
-- auto_input.lua
--
-----------------------------------------------------------------------------------------
require "objects"
require "data"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

-- -----------------------
-- Generic Event Functions
-- -----------------------
	local function go_back_screen()
		local prev_scene = composer.getSceneName("previous")
		composer.gotoScene(prev_scene)
	end

	local function submit_page ()
		Data.print_recorded_data()
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
    local background = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.contentWidth,1.5*display.contentHeight)
    background.fill = bckgnd_grad

	local back_button = display.newImageRect(sceneGroup, asset_loc.."back_button.png", 30, 30)
	back_button.anchorX=0
	back_button.anchorY=0
	back_button.x=5
	back_button.y=5

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."submit_button.png", 100, 50)
	submit_button.anchorX=0.5
	submit_button.anchorY=1
	submit_button.x=display.contentCenterX
	submit_button.y=display.contentHeight - 10

	local debug_text = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=display.contentHeight - 100, font=native.systemFont, font_szie=15, align="center"})
	debug_text:setFillColor(0,0,0)
	debug_text.anchorY=1

    local test_id_1 = Objects.Inc_Dec.init(sceneGroup, 2, "Notes Scored\nin Amp", 20, 70, 10, 20, 20, 30, 30, 30, 25, 0, 20)
    local test_id_2 = Objects.Inc_Dec.init(sceneGroup,3,"Text 2", 20, 120, 15, 20, 20, 30, 35, 30, 25, 0, 7)
    local test_radio_1 = Objects.Radio.init(sceneGroup,4,"Radio Test\nMultiLine", 20, 170, 15, 20, 20, 12, 6, 35, true, false)
    local test_radio_2 = Objects.Radio.init(sceneGroup,5,"Radio Test\n#2", 20, 230, 15, 20, 20, 12, 6, 35, false, true)
	local function submit_page_onscreen()
		debug_text.text = Data.get_recorded_data()
	end
	back_button:addEventListener("tap", go_back_screen)
	submit_button:addEventListener("tap", submit_page_onscreen)
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