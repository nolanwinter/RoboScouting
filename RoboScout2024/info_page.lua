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

local function go_back_screen()
    composer.gotoScene("match_info")
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
    back_button:addEventListener("tap", go_back_screen)

    local info_str_1 = "Created by Nolan Winter,\nan alum of FRC Team 7103\n\nQR Generator Copyright\n(c) 2012-2020,\nPatrick Gundlach and contributors, see"
    local link_str_1 = "https://github.com/speedata/luaqrcode"
    local info_str_2 = "All rights reserved.\n\nFor full copyright, see"
    local link_str_2 = "https://github.com/nolanwinter/\nRoboScouting/blob/main/README.md"
    local info_1 = display.newText({parent=sceneGroup, text=info_str_1, x=display.contentCenterX,y=100 + Data.sy, font=native.systemFont, fontSize=15, align="center"})
    info_1.anchorY=0
    info_1:setFillColor(0,0,0)
    local link_1 = display.newText({parent=sceneGroup, text=link_str_1..".", x=display.contentCenterX,y=info_1.y+info_1.height, font=native.systemFont, fontSize=15, align="center"})
    link_1.anchorY=0
    link_1:setFillColor(0.2,0.2,0.2)
    local link_1_line = display.newLine( sceneGroup, link_1.x - (link_1.width/2), link_1.y + link_1.height, link_1.x + (link_1.width/2), link_1.y + link_1.height)
    link_1_line:setStrokeColor(0.2,0.2,0.2)
    link_1_line.strokeWidth=1
    local info_2 = display.newText({parent=sceneGroup, text=info_str_2, x=display.contentCenterX,y=link_1.y+link_1.height, font=native.systemFont, fontSize=15, align="center"})
    info_2.anchorY=0
    info_2:setFillColor(0,0,0)
    local link_2 = display.newText({parent=sceneGroup, text=link_str_2..".", x=display.contentCenterX,y=info_2.y+info_2.height, font=native.systemFont, fontSize=15, align="center"})
    link_2.anchorY=0
    link_2:setFillColor(0.2,0.2,0.2)
    local link_2_line_upper = display.newLine(sceneGroup, link_2.x - (link_2.width/2)+27, link_2.y + (link_2.height/2), link_2.x + (link_2.width/2)-27, link_2.y + (link_2.height/2))
    link_2_line_upper:setStrokeColor(0.2,0.2,0.2)
    link_2_line_upper.strokeWidth=1
    local link_2_line_lower = display.newLine(sceneGroup, link_2.x - (link_2.width/2), link_2.y + link_2.height, link_2.x + (link_2.width/2), link_2.y + link_2.height)
    link_2_line_lower:setStrokeColor(0.2,0.2,0.2)
    link_2_line_lower.strokeWidth=1
    link_1:addEventListener("tap", function() system.openURL(link_str_1) end)
    link_2:addEventListener("tap", function() system.openURL(link_str_2) end)
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