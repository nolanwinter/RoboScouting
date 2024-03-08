require "objects"
require "data"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

local match_num = nil
local scout_name = nil
local reset_popup = nil

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function flash_delay(time, circle)
	circle.isVisible = false
	timer.performWithDelay(time, function() circle.isVisible = true end)
end

local function flash_error(dim,time,blinks)
	local err_cir = display.newRoundedRect(Objects.get_scene_group(), dim[1], dim[2], dim[3]+10, dim[4], (math.min(dim[3],dim[4]) / 2))
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
		system.vibrate("notification", "error")
		for i,v in ipairs(Data.errors) do
			flash_error(Data.error_circle[i], 200, 10)
		end
	else
		composer.gotoScene("auto_input") 
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

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."continue_button.png", 100, 50)
	submit_button.anchorX=0.5
	submit_button.anchorY=1
	submit_button.x=display.contentCenterX
	submit_button.y=Data.sh - 5 + Data.sy
	submit_button:addEventListener("tap", submit_page)

	local history_button = display.newImageRect(sceneGroup, asset_loc.."history_button.png", 70, 35)
	history_button.anchorY = 0
	history_button.x = Data.sw/2
	history_button.y = Data.sy + 10
	history_button:addEventListener("tap", function() composer.gotoScene("qr_history") end)

	local info_button = display.newImageRect(sceneGroup, asset_loc.."info_button.png", 20, 20)
	info_button.anchorX = 1
	info_button.anchorY = 0
	info_button.x = Data.sx + Data.sw - 15
	info_button.y = Data.sy
	info_button:addEventListener("tap", function() composer.gotoScene("info_page") end)

	scout_name = Objects.SingleLineInput.init(98, "Scout Name", "Scout's name", 25, 80, 30, 10, 100, "Dr. Jerry", 15, tostring(Data.scout_name))
	local match_type = Objects.SingleSelect.init(0,"Match type","Match Type",20,100,0,7,10,30,{"Qual","Test"},15,1,{"black","red"},Data.match_type)
	match_num = Objects.FreeNumInput.init(1, "Match #","Match Number", 25, 220, 30, 15, 70, "0", 15, 0, 99,tonumber(Data.match_num))
	team_num = Objects.FreeNumInput.init(3, "Team #","Team Number", 25, 270, 30, 10, 100, "254", 15, 0, 9789,"")
	local team_select = Objects.SingleSelect.init(2, "Team","Team Select", 25, team_num.bottom_y + 15, 0, 10, 10, 30, Data.teams_to_scout, 15, 2, {"red", "red", "red", "blue", "blue", "blue"}, Data.team_to_scout)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	Objects.set_scene_group(sceneGroup)
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		match_num.line_input.isVisible=true
		scout_name.line_input.isVisible=true
		team_num.line_input.isVisible=true
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
		match_num.line_input.isVisible=false
		scout_name.line_input.isVisible=false
		team_num.line_input.isVisible=false
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	Data.ids[98] = false
	Data.ids[0] = false
	Data.ids[1] = false
	Data.ids[2] = false
	Data.ids[3] = false
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