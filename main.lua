-- io.stdout:setvbuf("no")

import "CoreLibs/graphics"
import "CoreLibs/object"
import "rain"
import "tiles"
import "root"
import "input"

gfx = playdate.graphics

width, height = playdate.display.getSize()
gridWidth = width / 20
gridHeight = height / 2 / 20
gridStartingY = height / 2

local executeOnce = false
local lastDawnRootCount = 0
-- heart = love.graphics.newImage("images/heart.png")
-- heartOutline = love.graphics.newImage("images/heart-outline.png")

function myGameSetup()
  -- Object = require "classic"
  -- require "tiles"
  -- require "root"
  -- require "rain"
  -- require "forest"
  -- require "plant"
  -- require "heart"
  -- require "input"

  -- white = {1, 1, 1}
  -- black = {0, 0, 0}

  -- scene setup

  -- love.graphics.setBackgroundColor(white)
  -- love.window.setTitle("Roots") 

  -- love.window.setMode(1000, 240, 
  --   {
  --     highdpi = false, --?
  --     msaa = 0 -- antialias
  --   })
  
  -- windowWidth, windowHeight = love.window.getMode()
  
  -- -- setting a seed seems to be required to actually get randomization during dev?
  -- math.randomseed(love.timer.getTime())

  tileSize = 20
  -- gridWidth = 50
  -- gridHeight = 7
  gridStartingY = height / 2
  
  -- --font
  -- font = love.graphics.newFont("fonts/press-start.ttf", 9)

  -- --title and tutorial
  -- title = love.graphics.newImage("images/title.png")
  -- titleWidth = title:getWidth()
  -- titleHeight = title:getHeight()
  -- titlePadding = 40
  
  -- credits = love.graphics.newImage("images/credits.png")
  -- tutorial = love.graphics.newImage("images/tutorial.png")
  
  -- introIndex = 1
  -- intro = {title, credits, tutorial}
  
  -- --leaf
  -- leaf = love.graphics.newImage("images/leaf.png")

  -- --water
  droplets = {}
  dropletTimer = math.random(0, 2)

  dropletGraphic = gfx.image.new("images/droplet.png")
  dropletWidth, dropletHeight = dropletGraphic:getSize()
  dropletAcc = 0.005 --controls how quickly the droplet speeds up over (lower is faster)
  dropletTick = 0
  
  rainfall = 5 --controls how heavy its raining
  
  -- --splashes
  splashes = {}
  splashGraphic = gfx.image.new("images/splash.png")
  splashTick = 0
  splashTimer = 0.1 --controls how long the splash shows for
  
  -- --forest
  -- forest = {}
  -- forestSize = 150
  
  -- floatingHearts = {}
  
  -- for i=1, forestSize do
  --   forestSpawn()
  -- end

  tileManager = TileManager()
  root = Root()
  -- plant = Plant()
end



myGameSetup()



function playdate.update()
  -- Don't know if this call is causing any inefficiencies, but needed to remove the raindrops which are drawn directly on screen
  -- coreytodo: uncomment
  -- gfx.clear()
  
  -- Manually setting this could be problematic
  dt = 1/30
  
  -- coreytodo: uncomment
  tileManager:update(dt)
  tileManager:draw()


  -- every second move any 5 tiles down by one
  -- root:update(dt)
  -- plant:update(dt)
  -- tileManager:update(dt)
  -- --call droplets randomly
  

  -- coreytodo: uncomment
  -- dropletTick += (dt * rainfall)
  -- if dropletTick > dropletTimer then
  --   -- print("spawning droplet")
  --   dropletSpawn()
  --   dropletTimer = math.random(1, math.random(2, 4))
  --   dropletTick = 0
  -- end

  -- -- --update droplet positions
  -- for i,v in ipairs(droplets) do
  --   if v.y < (gridStartingY - dropletHeight) then
  --     v.acc = v.acc + dt
  --     v.y = v.y + (dt*100)*v.acc
  --   else
  --     --play musical tone
  --     -- tone = love.audio.newSource("audio/" .. "tone" .. v.musicIndex .. ".wav", "static")
  --     -- tone:setVolume(math.random(0.4, 0.5))
  --     -- tone:play()
      
  --     -- add Splash graphic in same position
  --     splashSpawn(v.x, v.y)

  --     --remove Droplet graphic from table
  --     table.remove(droplets, i)

  --     -- update tile
  --     indexOfDroplet = (v.x + 15) / tileSize
  --     -- print("tile hit: "..indexOfDroplet)
  --     tileManager:tileHit(indexOfDroplet)
  --   end
  -- end
  
  -- -- -- show Splash for a set, short amount of time
  -- for i,v in ipairs(splashes) do
  --   v.timer = v.timer - dt
  --   if v.timer < 0 then
  --     table.remove(splashes, i)
  --   end
  -- end



  
  -- --update heart positions
  -- for i,v in ipairs(floatingHearts) do
  --   if v.y > -20 then
  --     v.acc = v.acc + dt
  --     v.y = v.y - (dt*100)*v.acc
  --     if v.variant == 1 then
  --       v.x = v.x + (dt*math.random(30, 60))
  --     else
  --       v.x = v.x - (dt*math.random(30, 60))
  --     end
  --   else
  --     table.remove(floatingHearts, i)
  --   end
  -- end
  
-- end


-- function love.draw()
  
  -- coreytodo: uncomment
  -- tileManager:draw()


  
--   -- Draw Ground line
--   love.graphics.setColor(black)
--   love.graphics.rectangle("fill", 0, gridStartingY-1, windowWidth, 1)
--   love.graphics.setColor(white)
  
--   -- Draw Forest
--   for i,v in ipairs(forest) do
--     local function myStencilFunction()
--        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
--     end
    
--     love.graphics.stencil(myStencilFunction, "replace", 1)
--     love.graphics.setStencilTest("greater", 0)
    
--     for i=0,5 do
--       love.graphics.draw(v.variant, v.x, v.y + (i*tileSize))
--     end
--     love.graphics.setStencilTest()
--   end
  
--   -- Draw Title
--   if introIndex <= 3 then
--     love.graphics.draw(intro[introIndex], (windowWidth/2) - (titleWidth/2), (gridStartingY/2) - (titleHeight/2)) 
--   end 
  
--   -- Draw Water drop



  -- coreytodo: uncomment
--   for i,v in ipairs(droplets) do
--     if v.y < (gridStartingY - (dropletHeight)) then
--       dropletGraphic:draw(v.x, v.y)   
--     end
--   end
  
-- --   -- Draw Splashes
--   for i,v in ipairs(splashes) do
--     splashGraphic:draw(v.x, v.y) 
--   end

  -- playdate.drawFPS(5, 5)

  -- playdate.graphics.drawArc(100, 100, 20, 0, 90)



  -- if not executeOnce then
  --   gfx.drawPolygon(25, 25, 50, 100, 60, 75, 100, 25)
  --   -- curveLine(25, 25, 50, -100, 30, 75, 100, 25)
  --   -- curveLine(width / 2, gridStartingY - 50, width / 2, gridStartingY - 50 + 20, (width / 2) + 20, gridStartingY - 50+ 20, width / 2 + 40, gridStartingY - 50 + 20)
  --   executeOnce = true
  -- end


--   -- Draw Root
--   -- plantPoints = {
--   --   490, gridStartingY,
--   --   500, gridStartingY - 5,
--   --   490, gridStartingY - 10,
--   --   480, gridStartingY - 15,

--   --   490, gridStartingY - 25,
--   --   510, gridStartingY - 30,
--   --   500, gridStartingY - 35,
--   --   490, gridStartingY - 45,
--   -- }
  
--   -- Draw Plant
--   plantCurve = love.math.newBezierCurve(plant:toCoordinates())
--   plantCoordinates = plantCurve:renderSegment(0.0, plant.pathProgress, 2)

--   love.graphics.setColor(0, 0, 0, alpha)  
--   love.graphics.setLineWidth(5)
--   love.graphics.setLineStyle("rough")
--   love.graphics.line(plantCoordinates)

--   plant:draw()

  
--   -- love.graphics.arc( "line", "open", 500, gridStartingY, 20, math.pi, 1.5 * math.pi, 5)

--   -- print("# root line coordinates: ", #coordinates)

--   -- Draw Root



  -- coreytodo: uncomment
  
  playdate.graphics.setLineWidth(1)
  
  for i = 1, #root.nodes - 1 do
    
    local currentNode = root.nodes[i]
    local nextNode = root.nodes[i+1]
    -- print("drawing line segment start: ".. tostring(currentNode).." end: "..tostring(nextNode))
    -- gfx.drawLine(currentNode.x * tileSize + tileSize / 2, gridStartingY + (currentNode.y - 1) * tileSize + tileSize / 2, nextNode.x * tileSize + tileSize / 2, gridStartingY + (nextNode.y - 1) * tileSize + tileSize / 2)
  end
  
  playdate.graphics.setLineWidth(3)
  
  -- divide #root.nodes / 4 - that is the number of bezier curves to draw
  
  -- % #root.nodes / 4 and draw those as arcs or something
  
  -- root improvement: 
  -- idea 1: go 1 back instead of 2 on the double bezier approach
  -- head: keep in progress curve w/ 3,2,1 overlapping points, etc. 
  
  currentRootCurveCount = math.floor(#root.nodes / 4)
  -- if lastDawnRootCount ~= currentRootCurveCount then
    -- print("updating root count from "..lastDawnRootCount.. " to: "..currentRootCurveCount)
    -- lastDawnRootCount = currentRootCurveCount
    for i=1, math.floor(#root.nodes / 4) do
      -- print ("drawing bezier curve "..i)
      local startingIndex = i * 4
      local xOffset = tileSize / 2
      local yOffset = gridStartingY + tileSize / 2
      
      local correctedInitialX = 0
      local correctedInitialY = 0
      if i > 1 then 
        local currentNode = root.nodes[startingIndex - 3] -- get first node in this curve
        local previousNode = root.nodes[(i - 1) * 4] -- get the last node from the previous draw
        
        if previousNode.x < currentNode.x then 
          -- we approached this node from the left
          correctedInitialX = -tileSize / 2
        elseif previousNode.x > currentNode.x then 
          -- we approached this node from the right
          correctedInitialX = tileSize / 2
        elseif previousNode.y > currentNode.y then 
          -- we approached this node from the bottom (higher y)
          correctedInitialY = tileSize / 2
        elseif previousNode.y < currentNode.y then 
          -- we approached this node from the top (lower y)
          correctedInitialY = -tileSize / 2
        end
      end
      
      
      local correctedEndingX = 0
      local correctedEndingY = 0
      if i < math.floor(#root.nodes / 4) then 
        local currentNode = root.nodes[startingIndex] -- get last node in this curve (we draw backwards atm)
        local nextNode = root.nodes[startingIndex + 1] -- get the last node from the previous draw
        
        if nextNode.x < currentNode.x then 
          -- we exited this curve from the left
          correctedEndingX = -tileSize / 2
        elseif nextNode.x > currentNode.x then 
          -- we approached this node from the right
          correctedEndingX = tileSize / 2
        elseif nextNode.y > currentNode.y then 
          -- we approached this node from the bottom (higher y)
          correctedEndingY = tileSize / 2
        elseif nextNode.y < currentNode.y then 
          -- we approached this node from the top (lower y)
          correctedEndingY = -tileSize / 2
        end
      end
      
      local p0X = root.nodes[startingIndex].x * tileSize + xOffset + correctedEndingX
      local p0Y =  (root.nodes[startingIndex].y - 1)* tileSize + yOffset + correctedEndingY
      local p1X = root.nodes[startingIndex-1].x * tileSize + xOffset
      local p1Y = (root.nodes[startingIndex-1].y - 1) * tileSize + yOffset
      local p2X = root.nodes[startingIndex - 2].x * tileSize + xOffset
      local p2Y = (root.nodes[startingIndex - 2].y - 1) * tileSize + yOffset
      local p3X = root.nodes[startingIndex - 3].x * tileSize + xOffset + correctedInitialX
      local p3Y = (root.nodes[startingIndex - 3].y - 1) * tileSize + yOffset + correctedInitialY
      curveLine(
        p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y
      )
      
      -- if we've drawing the second root then we need to connect this drawn root above to the previous root via an additional curve
      -- if i ~= 1 then 
      --   
      --   local p0X = root.nodes[startingIndex - 1].x * tileSize + xOffset
      --   local p0Y =  (root.nodes[startingIndex - 1].y - 1)* tileSize + yOffset
      --   local p1X = root.nodes[startingIndex - 2].x * tileSize + xOffset
      --   local p1Y = (root.nodes[startingIndex - 2].y - 1) * tileSize + yOffset
      --   local p2X = root.nodes[startingIndex - 3].x * tileSize + xOffset
      --   local p2Y = (root.nodes[startingIndex - 3].y - 1) * tileSize + yOffset
      --   local p3X = root.nodes[startingIndex - 4].x * tileSize + xOffset
      --   local p3Y = (root.nodes[startingIndex - 4].y - 1) * tileSize + yOffset
      --   
      --   -- playdate.graphics.setLineWidth(2)
      --   -- curveLine(
      --   --   p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y
      --   -- )
      -- end
      
      local currentNode = root.nodes[i]
      local nextNode = root.nodes[i+1]
      print("drawing line segment start: ".. tostring(currentNode).." end: "..tostring(nextNode))
  
      -- gfx.drawLine(currentNode.x * tileSize + tileSize / 2, gridStartingY + (currentNode.y - 1) * tileSize + tileSize / 2, nextNode.x * tileSize + tileSize / 2, gridStartingY + (nextNode.y - 1) * tileSize + tileSize / 2)
    end
    
  
  
  
  if #root.nodes % 4 ~= 0 then
    -- print ("drawing bezier curve "..i)
    local pointsInCurrentCurve = #root.nodes % 4
    local pointsNeededToCompleteCurve = 4 - pointsInCurrentCurve
    local startingIndex = #root.nodes
    local xOffset = tileSize / 2
    local yOffset = gridStartingY + tileSize / 2
    
    local p0X = root.nodes[startingIndex].x * tileSize + xOffset
    local p0Y =  (root.nodes[startingIndex].y - 1)* tileSize + yOffset
    local p1Index
    if pointsInCurrentCurve > 1 then p1Index = startingIndex - 1 else p1Index = startingIndex end
    local p2Index
    if pointsInCurrentCurve > 2 then p2Index = startingIndex - 2 else p2Index = p1Index end
    local p3Index = p2Index
    
    local p1X = root.nodes[p1Index].x * tileSize + xOffset
    local p1Y = (root.nodes[p1Index].y - 1) * tileSize + yOffset
    local p2X = root.nodes[p2Index].x * tileSize + xOffset
    local p2Y = (root.nodes[p2Index].y - 1) * tileSize + yOffset
    local p3X = root.nodes[p3Index].x * tileSize + xOffset
    local p3Y = (root.nodes[p3Index].y - 1) * tileSize + yOffset
    
    curveLine(
      p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y
    )
  end
  
  
  -- end





--   curve = love.math.newBezierCurve(root:toCoordinates())
--   coordinates = curve:renderSegment(0.0, root.pathProgress, 5)

--   love.graphics.setColor(1, 1, 1, alpha)  
--   love.graphics.setLineWidth(8)
--   love.graphics.line(coordinates)
  
--   love.graphics.setColor(0, 0, 0, alpha)  
--   love.graphics.setLineWidth(6)
--   love.graphics.line(coordinates)

--   love.graphics.setColor(1, 1, 1, alpha)
--   love.graphics.setLineWidth(3)
--   love.graphics.line(coordinates)
  
--   -- Draw Heart
--   love.graphics.draw(heart, (windowWidth/2) - tileSize+2, gridStartingY+1)
  
--   -- Draw Floating Hearts
--   for i,v in ipairs(floatingHearts) do
--     love.graphics.draw(heartOutline, v.x, v.y) 
--   end
end


Correction = {
  LEFT=0,
	RIGHT=1,
	TOP=2,
	BOTTOM=3,
}

-- I more or less understand this function and the high level math behind it
-- Left off looking at https://github.com/love2d/love/blob/main/src/modules/math/BezierCurve.cpp to see what they do and it involves subdividing a larger bezier curve using some method to then rendering that with a degree of accuracy. The accuracy is used to determine the subdivision level

-- Options as they exist
-- port over love2d arbirary curve length - XL
-- try some concatenation logic to render roots based on 4 point bezier curves - M
-- looking at polygon support in playdate - S
-- trying to get the effect with arcs - M

local accuracy = 0.005
function bezier(t, p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y)
  -- not 100% sure what this math is doing outside of some bezier calculation based on control point t and influenced by 
  local cX = 3 * (p1X - p0X)
  local bX = 3 * (p2X - p1X) - cX
  local aX = p3X - p0X - cX - bX
  
  local cY = 3 * (p1Y - p0Y)
  local bY = 3 * (p2Y - p1Y) - cY
  local aY = p3Y - p0Y - cY - bY
  
  return ((aX * math.pow(t, 3)) + (bX * math.pow(t, 2)) + (cX * t) + p0X),
      ((aY * math.pow(t, 3)) + (bY * math.pow(t, 2)) + (cY * t) + p0Y)
end

function curveLine(p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y)
  local x, y = p0X, p0Y
  local pX, pY = 0, 0
  
  print("("..p0X..","..p0Y..") ("..p1X..","..p1Y..") ("..p2X..","..p2Y..") ("..p3X..","..p3Y..")")

  for t = 0, 1, accuracy do
    pX, pY = bezier(t, p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y)
    
    gfx.drawLine(x, y, pX, pY)

    -- print("accuracy: "..t.." (x, y)= ("..x..","..y..") to (px,py): ("..pX..","..pY..")")
    x, y = pX, pY
  end
end

-- curveLine(10, 10, 30, 20, 30, 200, 380, 230)