-- io.stdout:setvbuf("no")

import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "rain"
import "tiles"
import "root"
import "input"
import "catmull"
import "plant"
import "rootNode"
import "heart"
gfx = playdate.graphics
geo = playdate.geometry

width, height = playdate.display.getSize()
halfWidth = width / 2
gridWidth = width / 20
gridHeight = height / 2 / 20
gridStartingY = height / 2

local executeOnce = false
local lastDawnRootCount = 0
heart = gfx.image.new("images/heart.png")
heartOutline = gfx.image.new("images/heart-outline.png")

function myGameSetup()
  
  math.randomseed(playdate.getSecondsSinceEpoch())
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
  leaf = gfx.image.new("images/leaf.png")

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
  
  floatingHearts = {}
  
  -- --forest
  -- forest = {}
  -- forestSize = 150
  -- for i=1, forestSize do
  --   forestSpawn()
  -- end

  tileManager = TileManager()
  
  plantLocations = {
    RootNode(4, 1), RootNode(7, 1), RootNode(10, 1), RootNode(13, 1), RootNode(16, 1)
  }
  
  plantsInProgress = {}
  for i,location in ipairs(plantLocations) do
    local randomCeiling = 5
    if i > (#plantLocations - 1) then randomCeiling = 4 end
    local newPlant = Plant(location.gridX, math.random(2,randomCeiling)) -- we'll need to create multiple plants
    table.insert(plantsInProgress, newPlant)
  end
  
  rootsInProgress = {}
  for i,location in ipairs(plantLocations) do
    local newRoot = Root(location.gridX)
    table.insert(rootsInProgress, newRoot)
  end
  
  currentPlantIndex = 3
  plantsGrown = false
end

myGameSetup()

function playdate.update()
  -- Don't know if this call is causing any inefficiencies, but needed to remove the raindrops which are drawn directly on screen
  gfx.clear()
  
  -- Manually setting this could be problematic
  dt = 1/30
  
  handleCrankInput()

  -- every second move any 5 tiles down by one
  if currentPlantIndex > 0 then
    rootsInProgress[currentPlantIndex]:update(dt)
  end
  tileManager:update(dt)
  tileManager:draw()
  
  -- --call droplets randomly
  dropletTick += (dt * rainfall)
  if dropletTick > dropletTimer then
    -- print("spawning droplet")
    dropletSpawn()
    dropletTimer = math.random(1, math.random(2, 4))
    dropletTick = 0
  end

  -- --update droplet positions
  for i,v in ipairs(droplets) do
    if v.y < (gridStartingY - dropletHeight) then
      v.acc = v.acc + dt
      v.y = v.y + (dt*100)*v.acc
    else
      --play musical tone
      -- tone = love.audio.newSource("audio/" .. "tone" .. v.musicIndex .. ".wav", "static")
      -- tone:setVolume(math.random(0.4, 0.5))
      -- tone:play()
      
      -- add Splash graphic in same position
      splashSpawn(v.x, v.y)

      --remove Droplet graphic from table
      table.remove(droplets, i)

      -- update tile
      indexOfDroplet = (v.x + 15) / tileSize
      -- print("tile hit: "..indexOfDroplet)
      tileManager:tileHit(indexOfDroplet)
    end
  end
  
  -- -- show Splash for a set, short amount of time
  for i,v in ipairs(splashes) do
    v.timer = v.timer - dt
    if v.timer < 0 then
      table.remove(splashes, i)
    end
  end

  -- coreytodo: uncomment
  for i,v in ipairs(droplets) do
    if v.y < (gridStartingY - (dropletHeight)) then
      dropletGraphic:draw(v.x, v.y)   
    end
  end
  
--   -- Draw Splashes
  for i,v in ipairs(splashes) do
    splashGraphic:draw(v.x, v.y) 
  end

  playdate.drawFPS(5, 5)
  
  
  for i,plant in ipairs(plantsInProgress) do
    plant:draw()
  end

  -- Draw Root
  -- rootsInProgress[currentPlantIndex]:draw() -- we can have up to 5 of these
  
  for i=1,#rootsInProgress do 
    if currentPlantIndex ~= i then rootsInProgress[i]:draw(false) end
  end
  if currentPlantIndex > 0 then 
    rootsInProgress[currentPlantIndex]:draw(true)
  end

  -- Draw Heart
  for i,value in ipairs(plantLocations) do 
    heart:draw(value.uncorrectedPoint.x + 2, gridStartingY + 1)
  end
  
  if plantsGrown then
    gfx.drawText("NICE GROWING!", width - 125, 15)
  end
  
  
  -- heart:draw((width/2) - tileSize+2, gridStartingY+1)
  
  
    -- --update heart positions
    for i,v in ipairs(floatingHearts) do
      if v.y > -20 then
        v.acc = v.acc + dt
        v.y = v.y - (dt*100)*v.acc
        if v.variant == 1 then
          v.x = v.x + (dt*math.random(30, 60))
        else
          v.x = v.x - (dt*math.random(30, 60))
        end
      else
        table.remove(floatingHearts, i)
      end
    end
    
  -- end
  
--   -- Draw Floating Hearts
  for i,v in ipairs(floatingHearts) do
    heartOutline:draw(v.x, v.y)
    -- love.graphics.draw(heartOutline, v.x, v.y) 
  end

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

end