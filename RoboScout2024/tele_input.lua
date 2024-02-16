-----------------------------------------------------------------------------------------
--
-- auto_input.lua
--
-----------------------------------------------------------------------------------------
require "objects"

local asset_loc = "Assets/"
local notes_in_amp = 0

local composer = require("composer")
local scene = composer.newScene()

-- -----------------------
-- Generic Event Functions
-- -----------------------

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

    local speaker_heading = display.newText({parent=sceneGroup, text="Speaker Shots", x=display.contentCenterX,y=10, font=native.systemFont, fontSize=20, align="center"})
	speaker_heading.anchorY=0
	speaker_heading:setFillColor(0,0,0)
	local speaker_made = Objects.Inc_Dec.init(sceneGroup, 50, "Speaker Shots Made","Made",15,50,10,5,5,5,30,20,20,0,10)
	local speaker_miss = Objects.Inc_Dec.init(sceneGroup, 51, "Speaker Shots Miss","Missed",15,50,display.contentCenterX,5,5,5,30,20,20,0,10)

	local amp_heading = display.newText({parent=sceneGroup, text="Amp Shots", x=display.contentCenterX,y=70, font=native.systemFont, fontSize=20, align="center"})
	amp_heading.anchorY=0
	amp_heading:setFillColor(0,0,0)
	local amp_made = Objects.Inc_Dec.init(sceneGroup, 52, "Amp Shots Made","Made",15,110,10,5,5,5,30,20,20,0,10)
	local amp_miss = Objects.Inc_Dec.init(sceneGroup, 53, "Amp Shots Miss","Missed",15,110,display.contentCenterX,5,5,5,30,20,20,0,10)

	local trap_heading = display.newText({parent=sceneGroup, text="Trap Shots", x=display.contentCenterX,y=130, font=native.systemFont, fontSize=20, align="center"})
	trap_heading.anchorY=0
	trap_heading:setFillColor(0,0,0)
	local trap_made = Objects.Inc_Dec.init(sceneGroup, 54, "Trap Shots Made","Made",15,170,10,5,5,5,30,20,20,0,10)
	local trap_miss = Objects.Inc_Dec.init(sceneGroup, 55, "Trap Shots Miss","Missed",15,170,display.contentCenterX,5,5,5,30,20,20,0,10)

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
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