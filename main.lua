-- io.stdout:setvbuf("no")

import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "rain"
import "tiles"
import "root"
import "input"
import "catmull"
import "plant"
import "rootNode"
import "heart"
import "forest"
gfx = playdate.graphics
geo = playdate.geometry

function forestSpawn()
  forest = {}
  forestSize = 150
  for i=1, forestSize do
    treeSpawn()
    
    for j=0,5 do
      forest[i].sprite:add() -- add it 
      forest[i].sprite:moveTo(forest[i].x, forest[i].y + (j*tileSize)) -- move it
      forest[i].sprite:copy() -- copy it
      forest[i].sprite:setClipRect(forest[i].x, forest[i].y, forest[i].width, forest[i].height) -- mask it
    end
  end
end

function horizonSpawn()
  horizonImg = gfx.image.new(width, 3)
  gfx.pushContext(horizonImg)
    gfx.setLineWidth(1.5)
    gfx.drawLine(0, 1, width, 1)
  gfx.popContext()
  horizonSprite = gfx.sprite.new(horizonImg)
  horizonSprite:add()
  horizonSprite:moveTo(halfWidth, gridStartingY)
end

function myGameSetup()
  width, height = playdate.display.getSize()
  halfWidth = width / 2
  gridWidth = width / 20
  gridHeight = height / 2 / 20
  gridStartingY = height / 2
  tileSize = 20
  gridStartingY = height / 2
  
  local executeOnce = false
  local lastDawnRootCount = 0
  
  floatingHearts = {}
  heart = gfx.image.new("images/heart.png")
  leaf = gfx.image.new("images/leaf.png")

  
  math.randomseed(playdate.getSecondsSinceEpoch())
  
  -- frame timer
  rainfallTimer = playdate.frameTimer.new(rainfallDelay)
  
  tileManager = TileManager()
  
  totalPlantsGrown = 0
  
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
  
  forestSpawn()
  horizonSpawn()
end

myGameSetup()

function playdate.update()

  gfx.sprite.update()
  
  -- Manually setting this could be problematic
  dt = 1/30
  
  playdate.frameTimer.updateTimers()
  
  handleCrankInput()

  -- every second move any 5 tiles down by one
  if currentPlantIndex > 0 then
    rootsInProgress[currentPlantIndex]:update(dt)
  end
  
  tileManager:update(dt)
  tileManager:draw()
  
  -- --call droplets at a rate based on rainfallDelay variable
  if rainfallTimer.frame >= rainfallDelay then
    rainfallTimer = playdate.frameTimer.new(rainfallDelay)
    for i=1, math.random(0, rainfallDensity) do
      droplet()
    end
    rainfallTimer:reset()
  end
  
  -- some way to make this work
  -- flourish = math.random(1,100)
  -- if flourish >= 70 then
  --   rainfallDelay = 2
  --   print('flourish')
  -- else
  --   rainfallDelay = 27
  -- end
  
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
  
  -- update heart positions
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
  
  -- Draw Floating Hearts
  for i,v in ipairs(floatingHearts) do
    gfx.setImageDrawMode('NXOR')
    v.sprite:moveTo(v.x + tileSize, v.y)
    gfx.setImageDrawMode('copy')
  end

end