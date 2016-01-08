-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
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

local myRectangle = display.newRect( 55, 300, 20, 20 )
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

controller_left:addEventListener("touch", onObjectTouch )
controller_right:addEventListener("touch", onObjectTouch )