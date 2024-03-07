require "objects"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function go_back_screen()
	composer.gotoScene("auto_input")
end

local function flash_delay(time, circle)
	circle.isVisible = false
	timer.performWithDelay(time, function() circle.isVisible = true end)
end

local function flash_error(dim,time,blinks)
	local err_cir = display.newRoundedRect(Objects.get_scene_group, dim[1], dim[2], dim[3]+10, dim[4], (math.min(dim[3],dim[4]) / 2))
	local stroke = {1,0,0}
	err_cir.stroke = stroke
	err_cir.strokeWidth = 2
	err_cir:setFillColor(0,0,0,0)
	flash_delay(time, err_cir)
    timer.performWithDelay(time*2, function() flash_delay(time, err_cir) end, blinks-1)
	timer.performWithDelay(blinks*time*2, function() display.remove(err_cir) end)
end

local function submit_page ()
	if table.getn(Data.errors) > 0 then
		flash_error(Data.error_circle, 200, 10)
	else
		composer.gotoScene("info_submit")
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

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."continue_button.png", 100, 50)
	submit_button.anchorX=0.5
	submit_button.anchorY=1
	submit_button.x=display.contentCenterX
	submit_button.y=Data.sh - 5 + Data.sy

	back_button:addEventListener("tap", go_back_screen)
	submit_button:addEventListener("tap", submit_page)

	local heading_size
	if Data.tele_heading_size == nil then
		heading_size = 25
	else
		heading_size = Data.tele_heading_size
	end
	local sized = false
	while not sized do
		local speaker_heading = display.newText({parent=sceneGroup, text="Speaker Shots", x=display.contentCenterX,y=30 + Data.sy, font=native.systemFont, fontSize=heading_size, align="center"})
		speaker_heading.anchorY=0
		speaker_heading:setFillColor(0,0,0)
		local speaker_made = Objects.Inc_Dec.init(40, "Speaker Shots Made","Made",15,speaker_heading.y+speaker_heading.height+20-Data.sy,10,5,5,5,30,23,20,0,99)
		local speaker_miss = Objects.Inc_Dec.init(41, "Speaker Shots Miss","Missed",15,speaker_made.top_y+(speaker_made.height/2),display.contentCenterX,5,5,5,30,23,20,0,99)

		local amp_heading = display.newText({parent=sceneGroup,text="Amp Shots", x=display.contentCenterX,y=speaker_made.bottom_y + 10 + Data.sy, font=native.systemFont, fontSize=heading_size, align="center"})
		amp_heading.anchorY=0
		amp_heading:setFillColor(0,0,0)
		local amp_made = Objects.Inc_Dec.init(42, "Amp Shots Made","Made",15,amp_heading.y+amp_heading.height+20-Data.sy,10,5,5,5,30,23,20,0,99)
		local amp_miss = Objects.Inc_Dec.init(43, "Amp Shots Miss","Missed",15,amp_made.top_y+(amp_made.height/2),display.contentCenterX,5,5,5,30,23,20,0,99)

		local trap_heading = display.newText({parent=sceneGroup,text="Trap Shots", x=display.contentCenterX,y=amp_made.bottom_y + 10 + Data.sy, font=native.systemFont, fontSize=heading_size, align="center"})
		trap_heading.anchorY=0
		trap_heading:setFillColor(0,0,0)
		local trap_made = Objects.Inc_Dec.init(44, "Trap Shots Made","Made",15,trap_heading.y+trap_heading.height+20-Data.sy,10,5,5,5,30,23,20,0,3)
		local trap_miss = Objects.Inc_Dec.init(45, "Trap Shots Miss","Missed",15,trap_made.top_y+(trap_made.height/2),display.contentCenterX,5,5,5,30,23,20,0,99)

		defense_clarification_str = "If they primarily played defense,\nplease include more information\non the next page."
		harmony_clarification_str = "Single, Double, Triple climb refers to\nthe number of robots on the same chain\nas the robot you are scouting."
		local defense_report = Objects.SingleSelect.init(46, "Defense", "Defensive Rating", 20, trap_made.bottom_y + 10, 10, 5, 1, 40, {"Did Not\nAttempt", "\nIneffective", "\nEffective"}, 15, 1, {"black", "red", "green"}, "Did Not\nAttempt")
		local defense_text = defense_report.select_text
		local defense_clarify = display.newImageRect(sceneGroup, asset_loc.."question_button.png",  defense_text.height, defense_text.height)
		defense_clarify.anchorX = 0
		defense_clarify.x = defense_text.x + (defense_text.width/2) + 7
		defense_clarify.y = defense_text.y + (defense_text.height/2)
		defense_clarify:addEventListener("tap", function() Objects.Alert.init(defense_clarification_str, 20, "OK", 20) end)

		local endgame_report = Objects.SingleSelect.init(47, "Endgame", "Climb Result", 20, defense_report.bottom_y + 5, 10, 5, 1, 40, {"Did Not\nAttempt", "\nFailed", "Single\nClimb", "Double\nClimb", "Triple\nClimb"}, 15, 1, {"black", "red", "black", "black", "black"}, "Did Not\nAttempt")
		local endgame_text = endgame_report.select_text
		local endgame_clarify = display.newImageRect(sceneGroup, asset_loc.."question_button.png",  endgame_text.height, endgame_text.height)
		endgame_clarify.anchorX = 0
		endgame_clarify.x = endgame_text.x + (endgame_text.width/2) + 7
		endgame_clarify.y = endgame_text.y + (endgame_text.height/2)
		endgame_clarify:addEventListener("tap", function() Objects.Alert.init(harmony_clarification_str, 15, "OK", 20) end)
		submit_top_y = (submit_button.y - submit_button.height)
		if (endgame_report.bottom_y > submit_top_y) then
			print("Lowering heading size.")
			heading_size = heading_size - 1
			display.remove(speaker_heading)
			speaker_made.remove()
			speaker_miss.remove()
			display.remove(amp_heading)
			amp_made.remove()
			amp_miss.remove()
			display.remove(trap_heading)
			trap_made.remove()
			trap_miss.remove()
			defense_report.remove()
			display.remove(defense_clarify)
			endgame_report.remove()
			display.remove(endgame_clarify)
		else
			Data.tele_hint_size = hint_size
			sized = true
		end
	end
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)
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
	Data.ids[40] = false
	Data.ids[41] = false
	Data.ids[42] = false
	Data.ids[43] = false
	Data.ids[44] = false
	Data.ids[45] = false
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