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
local boxTable = {}

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
local gx, gy = physics.getGravity()
print( "x gravity: " .. gx .. ", y gravity: " .. gy )
physics.setGravity( 0, 6 )

local function removeBox(thisBox)
   -- if not(physics.removeBody(thisBox)) then
   --     print ("could not remove physics body")
   -- end
   -- display.remove(thisBox)
   -- thisBox=nil
   thisBox:removeSelf()
   thisBox=nil

end



local function spawnBox(boxType,xStart,yStart,angle)
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
            --spawnBox("blue",100,100)
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

    local limitLine = display.newRect(display.actualContentWidth/2,display.actualContentHeight*2,display.actualContentWidth *3,50)
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

local function spawnRandomReds (event)
    spawnBox("red",math.random(display.screenOriginX,display.actualContentWidth),-100)
end

local function spawnRandomBlues (event)
    --spawnBox("blue",math.random(display.screenOriginX,display.actualContentWidth),-100)
    spawnBox("blue",100,-100)
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



local function burstBox(startX,startY,dir)
    local function DestroyPop(Obj)
        display.remove(Obj)
        Obj = nil
    end
    local function createShard()
        partDown = display.newRect(0,0,10,10)
        partDown:setFillColor(200,200,0)
        partDown.myName = "explosion"
        physics.addBody( partDown, "dynamic",{ density = 1, gravity=.75, isSensor=true } )
        partDown.x = startX --+(starRnd(-5, 5))
        partDown.y = startY
        if ( dir == 0 ) then
            partDown:applyForce(starRnd(-15,15),starRnd(-20,20), partDown.x*(starRnd(1,5)), partDown.y)
            --partDown:applyTorque(5*starRnd(5,10))
        else
            partDown:applyForce(dir*(starRnd(5,15)),-1*starRnd(10,60), partDown.x*(starRnd(1,5)), partDown.y)
           -- partDown:applyTorque(5*starRnd(5,10))
        end
        transition.to(partDown, {time=1500, onComplete=DestroyPop})
        --transition.fadeOut(partDown, {time=1500, onComplete=DestroyPop})
    end
    timer.performWithDelay(1, function()
        local function createParts()
            starRnd = math.random
            for i=1,starRnd(3,7) do
                createShard()
            end
    
        end
    createParts()
    end, 1)
end


local function onGlobalCollision( event )
   
    if ( event.phase == "began" ) then
       
        if ( event.object1.myName == "limitLine") then
            -- cannot grow player paddle inside collision loop because of box2d limitations.
            --local dr timer.performWithDelay(50,removeBox(event.object2))
            event.object2:removeSelf()
            event.object2 = nil
            --removeBox(event.object2)      
        elseif ( event.object2.myName == "limitLine") then
            event.object1:removeSelf()
            event.object1 = nil
        elseif ( event.object1.myName == "playerPaddle") then
            if ( event.object2.myName == "blue") then
                local burstX=event.object2.x
                local burstY=event.object2.y
                local burstDir=1
                if ( event.object1.x > event.object2.x ) then
                    print (" Blue collision left side")
                    burstDir=-1
                else
                    print ("blue collision right side")
                    burstDir=1
                end
                event.object2:removeSelf()
                event.object2=nil
                burstBox(burstX,burstY,burstDir)
                --spawnBox("blue",event.object2.x,event.object2.y)
                -- explodeOnDeath(event.object2,1)
                --local dr timer.performWithDelay(50,growPlayerPaddle)
                 playerPaddle.width = playerPaddle.width + growPaddleBy
            end
        elseif ( event.object1.myName == "explosion") then
            if ( event.object1.y > 0 ) then
                if ( event.object2.myName == "red") then
                    print ("here we go")
                    burstBox(event.object2.x,event.object2.y,0)
                    event.object1:removeSelf()
                    event.object1=nil
                    event.object2:removeSelf()
                    event.object2=nil
                end
            end
        elseif (event.object1.y > display.actualContentHeight ) then
            print ("=====================================")
            --print( "began: " .. event.object1.myName .. " and " .. event.object2.myName )
        end
    elseif ( event.phase == "ended" ) then
       -- print( "ended: " .. event.object1.myName .. " and " .. event.object2.myName )
    end
end



function startLevel1()
    Runtime:addEventListener( "enterFrame", onEnterFrame )
    timer.performWithDelay(1000, spawnRandomReds, -1)
    timer.performWithDelay(800, spawnRandomBlues, -1)
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