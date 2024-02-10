-----------------------------------------------------------------------------------------
--
-- test.lua
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
	background.alpha=0.3


	local cont = display.newContainer(sceneGroup, display.contentWidth, display.contentHeight)
	cont.x = background.x
    cont.y = 100--background.y
    cont.anchorX=0.5
    cont.anchorY=0
    cont.anchorChildren=true

	local background2 = display.newRect(cont,0,0,display.contentWidth,1.5*display.contentHeight)
    background2.fill = bckgnd_grad
	local cont_origin =display.newCircle( cont, 0, 0, 10 )

	local origin =display.newCircle( sceneGroup, 0, 0, 10 )
	origin:setFillColor(0,0,1)
	local bound =display.newCircle( sceneGroup, display.contentWidth, display.contentHeight, 10 )
	bound:setFillColor(0,1,0)
    
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