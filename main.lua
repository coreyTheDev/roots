-- Playdate library
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
gfx = playdate.graphics
geo = playdate.geometry

-- Global variables
width, height = playdate.display.getSize()
halfWidth = width / 2
halfHeight = height / 2
gridWidth = width / 20
gridHeight = height / 2 / 20
gridStartingY = height / 2
tileSize = 20
dt = 1/30

-- Imports
import "rain"
import "tiles"
import "root"
import "rootNode"
import "input"
import "catmull"
import "plant"
import "heart"
import "forest"

function myGameSetup()  
  tileManager = TileManager()
  
  plantsSpawn()
  rootsSpawn()
  forestSpawn()
  horizonSpawn()
  seedsSpawn()
end

myGameSetup()

function playdate.update()

  gfx.sprite.update()
  playdate.frameTimer.updateTimers()
  
  tileManager:update(dt)
  
  weatherUpdate()
  
  handleCrankInput()

  -- every second move any 5 tiles down by one
  if currentPlantIndex > 0 then
    rootsInProgress[currentPlantIndex]:update(dt)
  end
  
  for i,plant in ipairs(plantsInProgress) do
    plant:draw()
  end
  
  for i=1,#rootsInProgress do 
    if currentPlantIndex ~= i then rootsInProgress[i]:draw(false) end
  end
  if currentPlantIndex > 0 then 
    rootsInProgress[currentPlantIndex]:draw(true)
  end

  if plantsGrown then
    gfx.drawText("NICE GROWING!", width - 125, 15)
  end

end