require "objects"
require "data"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

local captured_info
local data_qr
local popup
local qr_size

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function go_back_screen()
	composer.gotoScene("info_submit")
end

local function start_next_match()
	composer.removeScene("match_info", true)
	composer.removeScene("auto_input", true)
	composer.removeScene("tele_input", true)
	composer.removeScene("info_submit", true)
	Data.match_num = Data.recorded_data[1] + 1
	Data.scout_name = Data.recorded_data[98]
	Data.team_to_scout = Data.teams_to_scout[Data.recorded_data[2]]
	Data.update_qr_history()
	Data.save_history()
	Data.recorded_data = {}
	Data.ids = {}
	-- REPLACED BY SETTING TO FALSE IN EACH SCENE DESTROY OPTION
	-- ids = {}
	-- for i=0, 99 do
	-- 	ids[i] = false
	-- end
	composer.gotoScene("match_info")
	composer.removeScene("qr_upload", true)
end

local function handle_reset(confirm)
	display.remove(popup.popup_group)
	if confirm then
		start_next_match()
	end
end

-- ---------------------
-- Scene Event Functions
-- ---------------------

function scene:create(event)
    local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)

    local bckgnd_grad = {
        type = "gradient",
        color1 = {1,1,1},
        color2 = {0.42,0,0},
        direction="down"
    }
    local background = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.actualContentWidth,display.actualContentHeight)
    background.fill = bckgnd_grad

	local back_button = display.newImageRect(sceneGroup, asset_loc.."back_button.png", 30, 30)
	back_button.anchorX=0
	back_button.anchorY=0
	back_button.x=5 + Data.sx
	back_button.y=5 + Data.sy

	local next_match_button = display.newImageRect(sceneGroup, asset_loc.."next_match_button.png", 100, 50)
	next_match_button.anchorX=0.5
	next_match_button.anchorY=1
	next_match_button.x=display.contentCenterX
	next_match_button.y=Data.sh - 5 + Data.sy

    captured_info = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=50 + Data.sy, font=native.systemFont, font_size=100, align="center"})
	captured_info:setFillColor(0,0,0)
	captured_info.anchorY=0

	qr_size = math.min(Data.sw - 10, (next_match_button.y - next_match_button.height) - (captured_info.y + captured_info.height) - 10)

	--next_match_button:addEventListener("tap", start_next_match)
	next_match_button:addEventListener("tap", function() popup = Objects.PopUp.init("Are you sure you want to\nreset for a new match?", 15, "Cancel", "Continue", 15, handle_reset) end)
	back_button:addEventListener("tap", go_back_screen)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		captured_info.text=Data.get_readable_data_peak_vert()
		captured_info.size=35
		data_qr = Objects.QRCode.init(Data.get_data_short(), qr_size, (display.contentCenterX -(qr_size/2)), captured_info.y + captured_info.height + 5 - Data.sy)
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