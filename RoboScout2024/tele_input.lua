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

    local speaker_heading = display.newText({parent=sceneGroup, text="Speaker Shots", x=display.contentCenterX,y=30 + Data.sy, font=native.systemFont, fontSize=25, align="center"})
	speaker_heading.anchorY=0
	speaker_heading:setFillColor(0,0,0)
	local speaker_made = Objects.Inc_Dec.init(40, "Speaker Shots Made","Made",15,80,10,5,5,5,30,23,20,0,10)
	local speaker_miss = Objects.Inc_Dec.init(41, "Speaker Shots Miss","Missed",15,80,display.contentCenterX,5,5,5,30,23,20,0,10)

	local amp_heading = display.newText({parent=sceneGroup,text="Amp Shots", x=display.contentCenterX,y=100 + Data.sy, font=native.systemFont, fontSize=25, align="center"})
	amp_heading.anchorY=0
	amp_heading:setFillColor(0,0,0)
	local amp_made = Objects.Inc_Dec.init(42, "Amp Shots Made","Made",15,150,10,5,5,5,30,23,20,0,10)
	local amp_miss = Objects.Inc_Dec.init(43, "Amp Shots Miss","Missed",15,150,display.contentCenterX,5,5,5,30,23,20,0,10)

	local trap_heading = display.newText({parent=sceneGroup,text="Trap Shots", x=display.contentCenterX,y=170 + Data.sy, font=native.systemFont, fontSize=25, align="center"})
	trap_heading.anchorY=0
	trap_heading:setFillColor(0,0,0)
	local trap_made = Objects.Inc_Dec.init(44, "Trap Shots Made","Made",15,220,10,5,5,5,30,23,20,0,3)
	local trap_miss = Objects.Inc_Dec.init(45, "Trap Shots Miss","Missed",15,220,display.contentCenterX,5,5,5,30,23,20,0,99)

	local hint_size = 0
	if Data.tele_hint_size == nil then
		hint_size = 15
	else
		hint_size = Data.tele_hint_size
	end
	local sized = false
	while not sized do
		local defense_report = Objects.SingleSelect.init(46, "Defense", "Defensive Rating", 20, 245, 10, 5, 1, 40, {"Did Not\nAttempt", "\nIneffective", "\nEffective"}, 15, 1, {"black", "red", "green"}, "Did Not\nAttempt")
		defense_clarification_str = "If they primarily played defense, please\ninclude more information on the next page."
		local defense_note = display.newText({parent=sceneGroup, text=defense_clarification_str, x=display.contentCenterX,y=defense_report.bottom_y + Data.sy + 3, font=native.systemFont, fontSize=hint_size, align="center"})
		defense_note.anchorY=0
		defense_note:setFillColor(0.2,0.2,0.2)
		local endgame_report = Objects.SingleSelect.init(47, "Endgame", "Climb Result", 20, defense_note.y + defense_note.height + 5 - Data.sy, 10, 5, 1, 40, {"Did Not\nAttempt", "\nFailed", "Single\nClimb", "Double\nClimb", "Triple\nClimb"}, 15, 1, {"black", "red", "black", "black", "black"}, "Did Not\nAttempt")
		harmony_clarification_str = "Single, Double, Triple climb above refers to\nthe number of robots on the same chain\nas the robot you are scouting."
		local harmony_note = display.newText({parent=sceneGroup, text=harmony_clarification_str, x=display.contentCenterX,y=endgame_report.bottom_y + Data.sy + 3, font=native.systemFont, fontSize=hint_size, align="center"})
		harmony_note.anchorY=0
		harmony_note:setFillColor(0.5,0.5,0.5)
		harm_note_bot_y = (harmony_note.y + harmony_note.height)
		submit_top_y = (submit_button.y - submit_button.height)
		print("Note bottom:"..tostring(harm_note_bot_y).." Button top:"..tostring(submit_top_y))
		if (harm_note_bot_y > submit_top_y) then
			print("Lowering hint size.")
			hint_size = hint_size - 1
			defense_report.remove()
			display.remove(defense_note)
			endgame_report.remove()
			display.remove(harmony_note)
			Data.ids[46] = false
			Data.ids[47] = false
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