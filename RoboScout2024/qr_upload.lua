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

local text_input = 0
local captured_info
local data_qr

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function go_back_screen()
	composer.gotoScene("info_submit")
end

local function start_next_match()
	composer.removeScene("match_info", true)
	composer.removeScene("auto_input", true)
	composer.removeScene("info_submit", true)
	Data.update_qr_history()
	Data.save_history()
	Data.recorded_data = {}
	Data.ids = {}
	composer.gotoScene("match_info")
	composer.removeScene("qr_upload", true)
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

	local next_match_button = display.newImageRect(sceneGroup, asset_loc.."next_match_button.png", 100, 50)
	next_match_button.anchorX=0.5
	next_match_button.anchorY=1
	next_match_button.x=display.contentCenterX
	next_match_button.y=display.contentHeight - 10

    captured_info = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=300, font=native.systemFont, font_size=60, align="center"})
	captured_info:setFillColor(0,0,0)
	captured_info.anchorY=0

	next_match_button:addEventListener("tap", start_next_match)
	back_button:addEventListener("tap", go_back_screen)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		captured_info.text=Data.get_readable_data_peak_vert()
		data_qr = Objects.QRCode.init(sceneGroup, Data.get_data_short(), 250, (display.contentCenterX -(250/2)), (30))
		Data.print_recorded_data()
		
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
		for i,p in ipairs(data_qr.pixels) do
			display.remove(p)
		end
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