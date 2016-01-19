-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--Set up the physics world
local physics = require( "physics" )
physics.start()
-- setup variables
local playerPaddle
local controller_left
local controller_right
local limitLine

local movingLeft=false
local movingRight=false
local playerSpeed = 5
local growPaddleBy = 5
local playerPaddleSize = 20
local gameStatus = "startMenu"
display.setStatusBar(display.HiddenStatusBar)
local boxes = display.newGroup()
print( "display.contentWidth:display.contentHeight " .. display.contentWidth .. ":" .. display.contentHeight)
print( "display.actualcontentWidth:display.contentHeight " .. display.actualContentWidth .. ":" .. display.actualContentHeight)
print( "display.viewableContentWidth    " .. display.viewableContentWidth )
print( "display.screenOriginX " .. display.screenOriginX)

local function removeBox(thisBox)
    display.remove(thisBox)
    thisBox=nil
end

local function spawnBox(boxType,xStart,yStart)
    local box = display.newRect(xStart,yStart,10,10)
    box.id = boxType
   -- transition.to(box, { time=1000 , x=math.random(-10,400), y=300, onComplete=removeBox })
    physics.addBody(box,"dynamic")
    if (boxType == "red") then
        box:setFillColor(1,0,0)
        box.myName = "red"
    elseif (boxType == "blue") then
        box:setFillColor(0,0,1)
        box.myName = "blue"
    end
end

local function growPlayerPaddle()
    playerPaddle.width = playerPaddle.width + growPaddleBy
    if not (physics.removeBody(playerPaddle)) then
        print( "Could not remove physics body" )
    end
    physics.addBody(playerPaddle, "static")
end

local function onCollision( self, event )
    if ( event.phase == "began" ) then
        print ("--------------------------------------------------------------------")
        if ( self.id == "limitLine") then
            removeBox(event.other)
        elseif ( event.other.id == "blue" ) then
            print ("blue hit")
            removeBox(event.other)
            -- grow player paddle
            -- cannot grow player paddle inside collision loop because of box2d limitations.
            local dr timer.performWithDelay(50,growPlayerPaddle)
        end
        --print (self.id .. " : collision began with " .. event.other.id)
    end
    if ( event.phase == "ended") then
        print (self.id .. " : collision began with " .. event.other.id)
    end
end

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

local onEnterFrame = function( event )
    if ( movingLeft ) then
        if ((playerPaddle.x - playerPaddle.width/2) - playerSpeed > display.screenOriginX) then
            playerPaddle.x = playerPaddle.x - playerSpeed
            spawnBox("blue",100,100)
        else
            playerPaddle.x = display.screenOriginX + playerPaddle.width/2
        end
    end
    if (movingRight) then
        if ((playerPaddle.x + playerPaddle.width/2) + playerSpeed < display.actualContentWidth + display.screenOriginX) then
            playerPaddle.x = playerPaddle.x + playerSpeed
            --spawnBox("red")
        else
            playerPaddle.x = display.actualContentWidth + display.screenOriginX - playerPaddle.width/2
        end
    end
end

function showTitleScreen()
        titleScreenGroup = display.newGroup()
        playBtn = display.newRect(50,50,50,50)
        playBtn:setFillColor(0,1,0)
        playBtn.name = "playbutton"
        playBtn:addEventListener("tap",loadGame)
end

function loadGame(event)
    if (event.target.name == "playbutton") then
        transition.to(titleScreenGroup,{time=100, alpha=0, onComplete=initializeGameScreen})
        playBtn:removeEventListener("tap", loadGame)
    end
end

function initializeGameScreen()
    -- initialize before starting game to avoid issues with variable scoping
    local controller_left = display.newRect (display.screenOriginX + display.actualContentWidth/4, display.actualContentHeight/2, display.actualContentWidth/2, display.actualContentHeight)
    controller_left:setFillColor( .5,.1,.2)
    controller_left.id = "Left"
    controller_left.myName = "Left"

    local controller_right = display.newRect (display.screenOriginX + display.actualContentWidth/2 + display.actualContentWidth/4, display.actualContentHeight/2, display.actualContentWidth/2, display.actualContentHeight)
    controller_right:setFillColor( .5,.2,.2)
    controller_right.id = "Right"
    controller_right.myName = "Right"

    playerPaddle = display.newRect( 55, 300, playerPaddleSize, 20 )
    playerPaddle:setFillColor( 0,1,0 )
    playerPaddle.id = "playerPaddle"
    playerPaddle.myName = "playerPaddle"
    physics.addBody(playerPaddle, "static")

    local limitLine = display.newRect(display.actualContentWidth/2,display.actualContentHeight*2,display.actualContentWidth *2,50)
    limitLine.strokeWidth= 2
    limitLine.id = "limitLine"
    limitLine.myName = "limitLine"
    physics.addBody(limitLine, "static")

    --limitLine.collision = onCollision
    --limitLine:addEventListener("collision", limitLine)
    controller_left:addEventListener("touch", onObjectTouch )
    controller_right:addEventListener("touch", onObjectTouch )
    startLevel1()
end

local function spawnBoxes (event)
    spawnBox("red",math.random(display.screenOriginX,display.actualContentWidth),-100)
end

local function spawnGroup (event)
    local patternPicker = math.random(1,3)
    print ("Spawn Group: " .. patternPicker)
    if (patternPicker == 1) then
        for i=1,playerPaddle.width,1 do
            spawnBox("red",math.random(display.screenOriginX,display.actualContentWidth), math.random(10,30)*-1)
        end
    elseif (patternPicker == 2) then
        print("spawn /")
        local startPoint=math.random(display.screenOriginX + 50, display.actualContentWidth/2)
        for i=1,playerPaddle.width,1 do
            spawnBox("red",startPoint + i * 40, -10 + -10 * i)
        end
    elseif (patternPicker == 3) then
        print "spawn "
        local startPoint=math.random(display.actualContentWidth/2, display.actualContentWidth - 100)
         for i=playerPaddle.width,1,-1 do
            spawnBox("red",startPoint - i * 40, -10 + -10 * i)
        end
    end
end

local function onGlobalCollision( event )
    print ("=====================================")
    if ( event.phase == "began" ) then
        print( "began: " .. event.object1.myName .. " and " .. event.object2.myName )

    elseif ( event.phase == "ended" ) then
        print( "ended: " .. event.object1.myName .. " and " .. event.object2.myName )
    end
end



function startLevel1()
    Runtime:addEventListener( "enterFrame", onEnterFrame )
    timer.performWithDelay(1000, spawnBoxes, -1)
    timer.performWithDelay(5000, spawnGroup, -1)
 --   playerPaddle.collision = onCollision
--    playerPaddle:addEventListener("collision", playerPaddle)
    Runtime:addEventListener( "collision", onGlobalCollision )
end

function main()
    print("=============================================main")
    showTitleScreen()
end

main()