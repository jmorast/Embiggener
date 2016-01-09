-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
print( "display.contentWidth:display.contentHeight " .. display.contentWidth .. ":" .. display.contentHeight)
print( "display.actualcontentWidth:display.contentHeight " .. display.actualContentWidth .. ":" .. display.actualContentHeight)
print( "display.viewableContentWidth    " .. display.viewableContentWidth )
print( "pixel width " .. display.pixelWidth)
print ("screen origin : " ..display.screenOriginX)

--local myWidth = math.round(display.viewableContentWidth)
local myWidth = display.contentWidth - display.screenOriginX*2
local controllerHeight = display.contentHeight
local controllerWidth = myWidth/2
print ("myWidth " .. myWidth)
print ("controllerWidth " .. controllerWidth)



local bg=display.newRect(0,0,10000,10000)
bg:setFillColor(1,1,1)
bg.x=0
bg.y=0
--local controller_left = display.newRect (myWidth/6, display.contentHeight/2, myWidth/2, display.contentHeight)
local controller_left = display.newRect(myWidth*.1722,0, controllerWidth, controllerHeight)
controller_left:setFillColor( .2,.1,.2)
controller_left.id = "Left"
--controllerGroup:insert(controller_left)
print ( "  left controller x + width : " .. controller_left.x .. " : " .. controller_left.width)


local controller_right = display.newRect(myWidth*.718, 0, controllerWidth, controllerHeight)
controller_right:setFillColor( .5,.2,.2)
controller_right.id = "Right"
print ( " right controller x + width : " .. controller_right.x .. " : " .. controller_right.width)
-- iphone 5s - .673
-- kindle 7 - .718
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