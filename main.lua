io.stdout:setvbuf("no")

function love.load()
  Object = require "classic"
  require "tiles"
  require "root"

  white = {1, 1, 1}
  black = {0, 0, 0}

  -- scene setup
  love.graphics.setBackgroundColor(white)
  --love.graphics.setBackgroundColor(0.1, 0, 0)
  love.window.setTitle("Roots") 

  love.window.setMode(1000, 240, 
    {
      highdpi = false, --?
      msaa = 0 -- antialias
    })
  windowWidth, windowHeight = love.window.getMode()

  tileSize = 20
  gridWidth = 50
  gridHeight = 7
  gridStartingY = 100
  
  dropletHeight = 15
  dropletTick = 0
  dropletTimer = math.random(0, 2)
  rainfall = 8 --controls how heavy its raining

  --nutrients
  n1 = love.graphics.newImage("images/n1.png")
  n2 = love.graphics.newImage("images/n2.png")
  n3 = love.graphics.newImage("images/n3.png")
  n4 = love.graphics.newImage("images/n4.png")
  n5 = love.graphics.newImage("images/n5.png")

  --water
  droplets = {}
  dropletGraphic = love.graphics.newImage("images/droplet.png")

  tileManager = TileManager()
  root = Root()
end

function love.update(dt)
  -- every second move any 5 tiles down by one
  root:update(dt)
  tileManager:update(dt)
  --call droplets randomly
  dropletTick = dropletTick + (dt * rainfall)
  if dropletTick > dropletTimer then
    dropletSpawn()
    dropletTimer = math.random(1, math.random(2, 4))
    dropletTick = 0
  end

  --update droplet positions
  for i,v in ipairs(droplets) do
    if v.y < (gridStartingY - dropletHeight) then
      v.y = v.y + 1
    else
      --play musical tone
      tone = love.audio.newSource("audio/" .. "tone" .. v.musicIndex .. ".wav", "static")
      tone:setVolume(0.8)
      tone:play()

      table.remove(droplets, i)

      -- update tile
      indexOfDroplet = (v.x + 15) / tileSize
      tileManager:tileHit(indexOfDroplet)
    end
  end
end

function love.keypressed(key, scancode, isrepeat) 
  root:handleInput(key)
end

function dropletSpawn()
  droplet = {}
  droplet.x = math.random(1, gridWidth)
  droplet.musicIndex = droplet.x
  droplet.x = (droplet.x * tileSize) - 15
  droplet.y = -dropletHeight
  table.insert(droplets, droplet)
end

function love.draw()
  tileManager:draw()
  
  -- Draw Ground line
  love.graphics.setColor(black)
  love.graphics.rectangle("fill", 0, gridStartingY-1, windowWidth, 1)
  love.graphics.setColor(white)
  
  -- Draw Water drop
  for i=1, #droplets do
    love.graphics.draw(dropletGraphic, droplets[i].x, droplets[i].y)
  end
-- 
  curve = love.math.newBezierCurve(root:toCoordinates())
  coordinates = curve:renderSegment(0.0, root.pathProgress, 5)

  love.graphics.setColor(0, 0, 0, alpha)  
  love.graphics.setLineWidth(4)
  love.graphics.line(coordinates)

  love.graphics.setColor(1, 1, 1, alpha)
  love.graphics.setLineWidth(2)
  love.graphics.line(coordinates)
end