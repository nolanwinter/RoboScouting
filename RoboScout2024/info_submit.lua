require "objects"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

local text_input = 0

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function go_back_screen()
	composer.gotoScene("tele_input")
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
		composer.gotoScene("qr_upload")
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

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."submit_button.png", 100, 50)
	submit_button.anchorX=0.5
	submit_button.anchorY=1
	submit_button.x=display.contentCenterX
	submit_button.y=Data.sh - 5 + Data.sy

    text_input = Objects.TextInput.init(99,"Team notes","Any additional notes?\n(e.g. robot was disabled)\nLeave empty if there's\nnothing to add.", 20, 110, 10, 20, 250, "Test hint.", 18, 180, 15)
	back_button:addEventListener("tap", go_back_screen)
	submit_button:addEventListener("tap", submit_page)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		text_input.text_input.isVisible=true
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
		text_input.text_input.isVisible=false
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	Data.ids[99] = false
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