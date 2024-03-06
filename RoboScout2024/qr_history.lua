require "objects"
require "data"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

local captured_info
local heading
local data_qr
local popup
local history_spot = 0 --check if nil

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function go_back_screen()
	composer.gotoScene("match_info")
end

local function show_next_qr(forward)
	local dir = 1
	if forward then
		dir = -1
	end
	local history_check_count = 0
	local checked = false
	while (checked == false) or ((Data.data_history[history_spot] == nil or Data.data_history[history_spot] == "\n" or Data.data_history[history_spot] == "") and history_check_count < 51) do
		history_check_count = history_check_count + 1
		checked = true
		history_spot = history_spot + dir
		if history_spot > 50 then
			history_spot = 1
		elseif history_spot < 1 then
			history_spot = 50
		end
	end
	if history_check_count > 50 then
		captured_info.text="No History\nto Display."
		captured_info.size=40
		return
	end
	if history_spot == 1 then
		heading.text = "1 match ago"
	else
		heading.text = tostring(history_spot).." matches ago"
	end
	heading.size=20
	data_lines = {}
	for s in Data.data_history[history_spot]:gmatch("[^\r\n]+") do
		table.insert(data_lines, s)
	end
	match_data = data_lines[3]
	match_type = string.sub(match_data,3,4)
	if match_type == 1 then
		match_type = "Qual"
	else
		match_type = "Test"
	end
	peak_str = string.gsub(data_lines[1]," ","\n").."\n"..match_type.." Match\nMatch #"..tostring(string.sub(match_data,7,8)).."\n Team #"..tostring(string.sub(match_data,19,20))..tostring(string.sub(match_data,15,16))
	captured_info.text=peak_str
	captured_info.size=40
	if data_qr ~= nil then
		for i,p in ipairs(data_qr.pixels) do
			display.remove(p)
		end
	end
	data_qr = Objects.QRCode.init(match_data, 250, (display.contentCenterX -(250/2)), Data.sh - 250 - 65)
end

local function reset_history(confirm)
	display.remove(reset_popup.popup_group)
	if confirm == true then
		local path = system.pathForFile("qr_history.txt", system.DocumentsDirectory)
		local file, errorStr = io.open(path, "w")
		if not file then
			error("Could not find qr_history.txt.", 1)
		else
			io.close(file)
		end
		file = nil
		Data.data_history = {}
		for i=1,100 do
			Data.data_history[i] = ""
		end
		next_qr(false)
	end
end

local function confirm_reset()
	reset_popup = Objects.PopUp.init("Are you sure you want to reset\nthe match history?\n\nWARNING: This action is irreversible.", 15, "Cancel", "Reset", 15, reset_history)
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

	local back_button = display.newImageRect(sceneGroup, asset_loc.."back_button_wide.png", 60, 30)
	back_button.anchorX=0
	back_button.anchorY=0
	back_button.x=5 + Data.sx
	back_button.y=5 + Data.sy

	heading = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=back_button.y + (back_button.height/2), font=native.systemFont, font_size=30, align="center"})
	heading:setFillColor(0,0,0)

	local prev_qr = display.newImageRect(sceneGroup, asset_loc.."back_button.png", 30, 30)
	prev_qr.anchorX=1
	prev_qr.anchorY=0
	prev_qr.x = Data.sx + Data.sw - 50
	prev_qr.y = 5 + Data.sy

	local next_qr = display.newImageRect(sceneGroup, asset_loc.."forward_button.png", 30, 30)
	next_qr.anchorX=1
	next_qr.anchorY=0
	next_qr.x = Data.sx + Data.sw - 5
	next_qr.y = 5 + Data.sy

	local history_reset = display.newImageRect(sceneGroup, asset_loc.."reset_button.png", 25,25)
	history_reset.x = Data.sx + Data.sw - 30
	history_reset.y = Data.sy + Data.sh - 20
	history_reset.anchorX=1
	history_reset.anchorY=1
	history_reset:addEventListener("tap", confirm_reset)

    captured_info = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=50 + Data.sy, font=native.systemFont, font_size=100, align="center"})
	captured_info:setFillColor(0,0,0)
	captured_info.anchorY=0

	back_button:addEventListener("tap", go_back_screen)
	prev_qr:addEventListener("tap", function() show_next_qr(false) end)
	next_qr:addEventListener("tap", function() show_next_qr(true) end)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		show_next_qr(false)
		
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
		composer.removeScene("qr_history")
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