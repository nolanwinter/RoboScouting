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
		composer.gotoScene("match_info")
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

	local function submit_page()
		if table.getn(Data.errors) > 0 then
			flash_error(Data.error_circle, 200, 10)
		else
			composer.gotoScene("tele_input")
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

	local team_num = display.newText({parent=sceneGroup, text="Team #: "..tostring(Data.recorded_data[3] + Data.recorded_data[4]*100), x=display.contentCenterX,y=back_button.y + (back_button.height/2), font=native.systemFont, fontSize=17, align="center"})
	team_num:setFillColor(0,0,0)

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."continue_button.png", 100, 50)
	submit_button.anchorX=0.5
	submit_button.anchorY=1
	submit_button.x=display.contentCenterX
	submit_button.y=Data.sh - 5 + Data.sy

	back_button:addEventListener("tap", go_back_screen)
	submit_button:addEventListener("tap", submit_page)
    
    local auto_heading = display.newText({parent=sceneGroup, text="Autonomous\nPeriod", x=display.contentCenterX,y=60 + Data.sy, font=native.systemFont, fontSize=32, align="center"})
	auto_heading.anchorY=0
	auto_heading:setFillColor(0,0,0)
	
	local crossed_start = Objects.Radio.init(20,"Cross Line","Crossed\nStart Line?", 25, 170, 10, 20, 20, 13, 3, 40, true, false)
    
	local speaker_heading = display.newText({parent=sceneGroup, text="Speaker Shots", x=display.contentCenterX,y=230 + Data.sy, font=native.systemFont, fontSize=25, align="center"})
	speaker_heading.anchorY=0
	speaker_heading:setFillColor(0,0,0)
	local speaker_made = Objects.Inc_Dec.init(21, "Auto Speaker Made","Made",15,290,10,5,5,5,35,23,20,0,99)
	local speaker_miss = Objects.Inc_Dec.init(22, "Atuo Speaker Miss","Missed",15,290,display.contentCenterX,5,5,5,35,23,20,0,99)

	local amp_heading = display.newText({parent=sceneGroup, text="Amp Shots", x=display.contentCenterX,y=320 + Data.sy, font=native.systemFont, fontSize=25, align="center"})
	amp_heading.anchorY=0
	amp_heading:setFillColor(0,0,0)
	local amp_made = Objects.Inc_Dec.init(23, "Auto Amp Made","Made",15,380,10,5,5,5,35,23,20,0,99)
	local amp_miss = Objects.Inc_Dec.init(24, "Auto Amp Miss","Missed",15,380,display.contentCenterX,5,5,5,35,23,20,0,99)
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
	Data.ids[20] = false
	Data.ids[21] = false
	Data.ids[22] = false
	Data.ids[23] = false
	Data.ids[24] = false
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