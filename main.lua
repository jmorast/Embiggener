-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local movingLeft=false
local movingRight=false
local playerSpeed = 5
local direction='Stopped'
display.setStatusBar(display.HiddenStatusBar)
print( "display.contentWidth:display.contentHeight " .. display.contentWidth .. ":" .. display.contentHeight)
print( "display.actualcontentWidth:display.contentHeight " .. display.actualContentWidth .. ":" .. display.actualContentHeight)
print( "display.viewableContentWidth    " .. display.viewableContentWidth )
print( "display.screenOriginX " .. display.screenOriginX)

local controller_left = display.newRect (display.screenOriginX + display.actualContentWidth/4, display.actualContentHeight/2, display.actualContentWidth/2, display.actualContentHeight)
controller_left:setFillColor( .5,.1,.2)
controller_left.id = "Left"

local controller_right = display.newRect (display.screenOriginX + display.actualContentWidth/2 + display.actualContentWidth/4, display.actualContentHeight/2, display.actualContentWidth/2, display.actualContentHeight)
controller_right:setFillColor( .5,.2,.2)
controller_right.id = "Right"

local playerPaddle = display.newRect( 55, 300, 80, 20 )
playerPaddle:setFillColor( 0,1,0 )
playerPaddle.id = "le box"

local function onObjectTouch( event )
    if ( event.phase == "began" ) then
        print( "Touch event began on: " .. event.target.id )
        if ( event.target.id == "Left") then
 			movingLeft=true
		else
			movingRight=true
		end
    elseif ( event.phase == "ended" ) then
        print( "Touch event ended on: " .. event.target.id )
        if ( event.target.id == "Left") then
 			movingLeft=false
		else
			movingRight=false
		end
    end
    --print ("myrect x : width : " .. myRectangle.width .. ":" .. myRectangle.x)
    return true
end

controller_left:addEventListener("touch", onObjectTouch )
controller_right:addEventListener("touch", onObjectTouch )

local myListener = function( event )

    if ( movingLeft ) then
    	if ((playerPaddle.x - playerPaddle.width/2) - playerSpeed > display.screenOriginX) then
            playerPaddle.x = playerPaddle.x - playerSpeed
        else
            playerPaddle.x = display.screenOriginX + playerPaddle.width/2
        end
    end
    if (movingRight) then
        if ((playerPaddle.x + playerPaddle.width/2) + playerSpeed < display.actualContentWidth + display.screenOriginX) then
        	playerPaddle.x = playerPaddle.x + playerSpeed
        else
            playerPaddle.x = display.actualContentWidth + display.screenOriginX - playerPaddle.width/2
        end
    end
end
Runtime:addEventListener( "enterFrame", myListener )