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

local match_num = 0

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function flash_delay(time, circle)
	circle.isVisible = false
	timer.performWithDelay(time, function() circle.isVisible = true end)
end

local function flash_error(dim,time,blinks,sceneGroup)
	local err_cir = display.newRoundedRect(sceneGroup, dim[1], dim[2], dim[3]+10, dim[4], (math.min(dim[3],dim[4]) / 2))
	local stroke = {1,0,0}
	err_cir.stroke = stroke
	err_cir.strokeWidth = 2
	err_cir:setFillColor(0,0,0,0)
	flash_delay(time, err_cir)
    timer.performWithDelay(time*2, function() flash_delay(time, err_cir) end, blinks-1)
	timer.performWithDelay(blinks*time*2, function() display.remove(err_cir) end)
end

local function submit_page (sceneGroup)
	if table.getn(Data.errors) > 0 then
		print("Flashing error circle")
		flash_error(Data.error_circle, 200, 10, sceneGroup)
	else
		composer.gotoScene("auto_input")
	end
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

	local submit_button = display.newImageRect(sceneGroup, asset_loc.."submit_button.png", 100, 50)
	submit_button.anchorX=0.5
	submit_button.anchorY=1
	submit_button.x=display.contentCenterX
	submit_button.y=display.contentHeight - 10
	submit_button:addEventListener("tap", function() submit_page(sceneGroup) end)
	match_num = Objects.FreeNumInput.init(sceneGroup, 0, "Match Number", 25, 70, 10, 15, 70, "0", 15, 0, 99)
	local team_select = Objects.SingleSelect.init(sceneGroup, 1, "Team Select", 25, 120, 10, 15, 16, 30, {"Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"}, 10, 2, {"red", "red", "red", "blue", "blue", "blue"}, "Red 1")
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		match_num.line_input.isVisible=true

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
		print(match_num)
		--match_num.line_input:removeSelf()
		match_num.line_input.isVisible=false
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