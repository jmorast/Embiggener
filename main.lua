-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
print( "display.contentWidth:display.contentHeight " .. display.contentWidth .. ":" .. display.contentHeight)
print( "display.actualcontentWidth:display.contentHeight " .. display.actualContentWidth .. ":" .. display.actualContentHeight)
print( "display.viewableContentWidth    " .. display.viewableContentWidth )
local myWidth = math.round(display.actualContentWidth)
print ("myWidth " .. myWidth)

touchLeft = display.newRect (300,300, 100, 100)
touchLeft:setFillColor( .1,.1,.1 )
touchLeft.id = "Touch Left"

--local controller_left = display.newRect (myWidth/6, display.contentHeight/2, myWidth/2, display.contentHeight)
local controller_left = display.newRect (math.round(myWidth/2/3), display.contentHeight/2, myWidth/2, display.contentHeight)
controller_left:setFillColor( .5,.1,.2)
controller_left.id = "Left"
print ( " left controller x + width : " .. controller_left.x .. " : " .. controller_left.width)
print ( " left controller y + height : " .. controller_left.y .. " : " .. controller_left.height)

local controller_right = display.newRect ((myWidth/2) + (myWidth/2/3), display.contentHeight/2, myWidth/2, display.contentHeight)
controller_right:setFillColor( .5,.2,.2)
controller_right.id = "Right"
print ( " right controller x + width : " .. controller_right.x .. " : " .. controller_right.width)

local myRectangle = display.newRect( 500, 300, 20, 20 )
myRectangle.strokeWidth = 3
myRectangle:setFillColor( 0.5 )
myRectangle:setStrokeColor( 1, 0, 0 )
myRectangle.id = "le box"



local function onObjectTouch( event )
    if ( event.phase == "began" ) then
        print( "Touch event began on: " .. event.target.id )
        if ( event.target.id == "Left") then
        	myRectangle.x = myRectangle.x - 5
		else
			--event.target.x = event.target.x + 5
			myRectangle.x = myRectangle.x + 5
		end
        
    elseif ( event.phase == "ended" ) then
        print( "Touch event ended on: " .. event.target.id )
    end
    return true
end
myRectangle:addEventListener( "touch", onObjectTouch )

controller_left:addEventListener("touch", onObjectTouch )
controller_right:addEventListener("touch", onObjectTouch )