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

-- -----------------------
-- Generic Event Functions
-- -----------------------

local function go_back_screen()
	composer.gotoScene("match_info")
end

local function show_prev_qr()
end

local function show_next_qr()
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
    local background = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY,display.actualContentWidth,display.actualContentHeight)
    background.fill = bckgnd_grad

	local back_button = display.newImageRect(sceneGroup, asset_loc.."back_button.png", 30, 30)
	back_button.anchorX=0
	back_button.anchorY=0
	back_button.x=5 + Data.sx
	back_button.y=5 + Data.sy

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

	heading = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=Data.sy + 5, font=native.systemFont, font_size=30, align="center"})
	heading.anchorY = 0
	heading:setFillColor(0,0,0)

    captured_info = display.newText({parent=sceneGroup, text="", x=display.contentCenterX, y=50 + Data.sy, font=native.systemFont, font_size=100, align="center"})
	captured_info:setFillColor(0,0,0)
	captured_info.anchorY=0

	back_button:addEventListener("tap", go_back_screen)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		--captured_info.text=Data.get_readable_data_peak_vert()
		heading.text = "1 match ago"
		heading.size=20
		captured_info.size=35
		data_lines = {}
		for s in Data.data_history[1]:gmatch("[^\r\n]+") do
			table.insert(data_lines, s)
		end
		print("Parsed History Data: "..tostring(data_lines[table.getn(data_lines)]))
		data_qr = Objects.QRCode.init(sceneGroup, data_lines[table.getn(data_lines)], 250, (display.contentCenterX -(250/2)), 220)
		print()
		--Data.print_recorded_data()
		
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