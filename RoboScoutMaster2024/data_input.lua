require "objects"

local asset_loc = "Assets/"

local composer = require("composer")
local scene = composer.newScene()

local data_in = nil
local match_type = nil
local match_num = nil
local team_pos_hint = nil
local team_num = nil
local data_fields = {}
local ids = {0,1,2,3,4,20,21,22,23,24,40,41,42,43,44,45,46,47,98,99}
local match_data_table = {}
local cleared = true

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function preview_data()
	match_data = data_in.get_text()
	for i,v in ipairs(ids) do
		data_id = tonumber(match_data:sub(4*i-3, 4*i-2))
		if data_id == v then
			if data_id == 98 then
				idx_99 = match_data:find("99", 4*i-2)
				match_data_table[98] = match_data:sub(4*i-1,idx_99-1)
				match_data_table[99] = match_data:sub(idx_99+2,-1)
				break
			else
				match_data_table[v] = match_data:sub(4*i-1,4*i)
			end
		else
			no_data_alert = Objects.Alert.init("The data is improperly\nformatted at id "..tostring(v).."\nand is instead "..tostring(data_id)..".", 20, "OK", 25)
			return
		end
	end
	print("Updating "..tostring(table.getn(data_fields)).." data fields.")
	for i,v in ipairs(data_fields) do
		id = ids[i]
		if id == 3 then
			v.update(match_data_table[3] + match_data_table[4]*100)
		elseif id == 4 then
			do end
		else
			v.update(match_data_table[id])
		end
	end
	cleared = false
end

local function reset_data()
	if not cleared then
		for i,v in ipairs(data_fields) do
			id = ids[i]
			if id == 0 then
				if match_data_table[0] == 1 then
					v.update("Qual")
				else
					v.update("Test")
				end
			elseif id == 3 then
				v.update(match_data_table[3] + match_data_table[4]*100)
			elseif id == 4 then
				do end
			else
				v.update(match_data_table[id])
			end
		end
	end
end

local function clear_input()
	if not cleared then
		data_in.line_input.text = ""
		for i,v in ipairs(data_fields) do
			v.clear()
		end
		cleared = true
	end
	native.setKeyboardFocus(data_in.line_input)
end

local function submit_data()
	if not cleared then
		data_string = ""
		for i,v in ipairs(data_fields) do
			if ids[i] ~= 4 then
				data_string = data_string..tostring(ids[i]).."::"..v.text_display.text.."_/"
			end
		end
		data_string = string.sub(data_string, 1, -2)
		print("Data to send:  "..data_string)
		Data.add_match_to_queue(data_string)
		Data.send_match_to_server()
		clear_input()
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
    local background_top = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.actualContentWidth,display.actualContentHeight)
    background_top:setFillColor(1,1,1)
	local background_bottom = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY+(display.actualContentHeight/4),display.actualContentWidth,display.actualContentHeight/2)
    background_bottom.fill = bckgnd_grad

	local back_button = display.newImageRect(sceneGroup, asset_loc.."back_button.png", 30, 30)
	back_button.anchorX=0
	back_button.anchorY=0
	back_button.x=5 + Data.sx
	back_button.y=5 + Data.sy
    back_button:addEventListener("tap", function() composer.gotoScene("main_screen") end)

	-- local data_in = native.newTextField(display.contentCenterX, 50 + Data.sy, Data.sw - 30, 25)
	-- data_in.anchorY = 0
	-- data_in.size = 10

	data_in = Objects.SingleLineInput.init("", 10, 50, 20, 0, Data.sw - 60, "Match Data", 12, true)

	local clear_button = display.newImageRect(sceneGroup, asset_loc.."red_x.png", 20, 20)
	clear_button.anchorX=1
	clear_button.y = data_in.top_y + (data_in.height/2) + Data.sy
	clear_button.x = Data.sx + Data.sw - 5
	clear_button:addEventListener("tap", clear_input)

	local preview_button = display.newImageRect(sceneGroup, asset_loc.."preview_button.png", 70, 35)
	preview_button.anchorX = 0
	preview_button.anchorY = 0
	preview_button.x = 10 + Data.sx
	preview_button.y = data_in.bottom_y + 10 + Data.sy
	preview_button:addEventListener("tap", preview_data)

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."submit_button.png", 70, 35)
	submit_button.anchorX = 0
	submit_button.anchorY = 0
	submit_button.x = preview_button.x + preview_button.width + 20
	submit_button.y = data_in.bottom_y + 10 + Data.sy
	submit_button:addEventListener("tap", submit_data)

	local reset_button = display.newImageRect(sceneGroup, asset_loc.."reset_button.png", 35, 35)
	reset_button.anchorX = 0
	reset_button.anchorY = 0
	reset_button.x = submit_button.x + submit_button.width + 20
	reset_button.y = data_in.bottom_y + 10 + Data.sy
	reset_button:addEventListener("tap", reset_data)

	local button_width = reset_button.x + reset_button.width - preview_button.x
	preview_button.x = display.contentCenterX - (button_width/2)
	submit_button.x = preview_button.x + preview_button.width + 20
	reset_button.x = submit_button.x + submit_button.width + 20

	-- local test_rect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	-- test_rect:setFillColor(0,1,0,0.5)

	match_type = Objects.EditableSingleLineDisplay.init("Match Type:", 17, preview_button.y + preview_button.height + 20 - Data.sy, 10, 1, 13, true)
	table.insert(data_fields, match_type)
	match_type_hint = display.newText({parent=sceneGroup, text="1 = Qual, 2 = Test", x=match_type.left_x + (match_type.width/2) + Data.sx, y=match_type.bottom_y + 2 + Data.sy, font=native.systemFont, fontSize=12, align="center"})
	match_type_hint.anchorY=0
	match_type_hint:setFillColor(0,0,0)

	team_pos = Objects.EditableSingleLineDisplay.init("Team Pos.:", 17, preview_button.y + preview_button.height + 20 - Data.sy, match_type.right_x + 10, 1, 13, true)
	team_pos_hint = display.newText({parent=sceneGroup, text="1 = Red 1, 6 = Blue 3", x=team_pos.left_x + (team_pos.width/2) + Data.sx, y=team_pos.bottom_y + 2 + Data.sy, font=native.systemFont, fontSize=12, align="center"})
	team_pos_hint.anchorY=0
	team_pos_hint:setFillColor(0,0,0)

	match_num = Objects.EditableSingleLineDisplay.init("Match Number:", 17, match_type_hint.y + match_type_hint.height + 2 - Data.sy, 10, 1, 13, true)
	table.insert(data_fields, match_num)
	table.insert(data_fields, team_pos)

	team_num = Objects.EditableSingleLineDisplay.init("Team #:", 17, team_pos_hint.y + team_pos_hint.height + 2 - Data.sy, match_num.right_x + 10, 1, 13, true)
	table.insert(data_fields, team_num)
	table.insert(data_fields, team_num) -- double since it takes two ids, I wanna do this better some day
	auto_heading = display.newText({parent=sceneGroup, text="Auto Data", x=display.contentCenterX + Data.sx, y=match_num.bottom_y + 2 + Data.sy, font=native.systemFont, fontSize=18, align="center"})
	auto_heading.anchorY=0
	auto_heading:setFillColor(0,0,0)
	auto_line = Objects.EditableSingleLineDisplay.init("Crossed Line:", 17, auto_heading.y + auto_heading.height - Data.sy + 5, 10, 1, 13, true)
	table.insert(data_fields, auto_line)
	auto_speak_in = Objects.EditableSingleLineDisplay.init("Speaker Made:", 17, auto_line.bottom_y + 10, 10, 1, 13, true)
	table.insert(data_fields, auto_speak_in)
	auto_speak_out = Objects.EditableSingleLineDisplay.init("Speaker Missed:", 15, auto_line.bottom_y + 10, auto_speak_in.right_x + 7, 1, 13, true)
	table.insert(data_fields, auto_speak_out)
	auto_amp_in = Objects.EditableSingleLineDisplay.init("Amp Made:", 17, auto_speak_in.bottom_y + 10, 10, 1, 13, true)
	table.insert(data_fields, auto_amp_in)
	auto_amp_out = Objects.EditableSingleLineDisplay.init("Amp Missed:", 17, auto_speak_out.bottom_y + 10, auto_amp_in.right_x + 10, 1, 13, true)
	table.insert(data_fields, auto_amp_out)
	tele_heading = display.newText({parent=sceneGroup, text="Teleop Data", x=display.contentCenterX + Data.sx, y=auto_amp_in.bottom_y + 5 + Data.sy, font=native.systemFont, fontSize=18, align="center"})
	tele_heading.anchorY=0
	tele_heading:setFillColor(0,0,0)
	tele_speak_in = Objects.EditableSingleLineDisplay.init("Speaker Made:", 17, tele_heading.y + tele_heading.height - Data.sy + 5, 10, 1, 13, true)
	table.insert(data_fields, tele_speak_in)
	tele_speak_out = Objects.EditableSingleLineDisplay.init("Speaker Missed:", 15, tele_speak_in.top_y, tele_speak_in.right_x + 7, 1, 13, true)
	table.insert(data_fields, tele_speak_out)
	tele_amp_in = Objects.EditableSingleLineDisplay.init("Amp Made:", 17, tele_speak_in.bottom_y + 10, 10, 1, 13, true)
	table.insert(data_fields, tele_amp_in)
	tele_amp_out = Objects.EditableSingleLineDisplay.init("Amp Missed:", 17, tele_speak_out.bottom_y + 10, tele_amp_in.right_x + 10, 1, 13, true)
	table.insert(data_fields, tele_amp_out)
	tele_trap_in = Objects.EditableSingleLineDisplay.init("Trap Made:", 17, tele_amp_in.bottom_y + 10, 10, 1, 13, true)
	table.insert(data_fields, tele_trap_in)
	tele_trap_out = Objects.EditableSingleLineDisplay.init("Trap Missed:", 17, tele_amp_out.bottom_y + 10, tele_trap_in.right_x + 10, 1, 13, true)
	table.insert(data_fields, tele_trap_out)
	defense_rating = Objects.EditableSingleLineDisplay.init("Defense:", 17, tele_trap_in.bottom_y + 10, 10, 1, 13, true)
	table.insert(data_fields, defense_rating)
	climb_result = Objects.EditableSingleLineDisplay.init("Climb:", 17, tele_trap_out.bottom_y + 10, defense_rating.right_x + 30, 1, 13, true)
	table.insert(data_fields, climb_result)
	scout_name = Objects.EditableSingleLineDisplay.init("Scout Name:", 17, defense_rating.bottom_y + 10, 10, 1, 13, false)
	table.insert(data_fields, scout_name)
	add_notes = Objects.EditableMultiLineDisplay.init("Additional Notes", 20, scout_name.bottom_y+10, 12, 10, Data.sh - scout_name.bottom_y - 10, 15)
	table.insert(data_fields, add_notes)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		data_in.line_input.isVisible = true
		match_type.edit(false)
		match_num.edit(false)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		native.setKeyboardFocus(data_in.line_input)
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
		data_in.line_input.isVisible = false
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