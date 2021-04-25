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
  
  dropletYStart = -15

  --nutrients
  n1 = love.graphics.newImage("images/n1.png")
  n2 = love.graphics.newImage("images/n2.png")
  n3 = love.graphics.newImage("images/n3.png")
  n4 = love.graphics.newImage("images/n4.png")
  n5 = love.graphics.newImage("images/n5.png")

  --water
  droplets = {}
  droplet1 = love.graphics.newImage("images/droplet1.png")

  tiles = createTiles()
  root = Root()
end

function love.update(dt)
  root:update(dt)

  for i=1, #droplets do
    droplets[i].y = droplets[i].y + 1
  end
end

function love.keypressed(key, scancode, isrepeat) 
  root:handleInput(key)
  if key == "space" then
    dropletSpawn()
  end
end

function dropletSpawn()
  droplet = {}
  droplet.x = math.random(0, windowWidth)
  droplet.y = dropletYStart
  table.insert(droplets, droplet)
end

function love.draw()
  for index,tile in ipairs(tiles) do 
      tile:draw()
  end
  
  -- Draw Ground line
  love.graphics.setColor(black)
  love.graphics.rectangle("fill", 0, gridStartingY-1, windowWidth, 1)
  love.graphics.setColor(white)
  
  -- Draw Water drop
  for i=1, #droplets do
    love.graphics.draw(droplet1, droplets[i].x, droplets[i].y)
  end

  curve = love.math.newBezierCurve(root:toCoordinates())
  coordinates = curve:renderSegment(0.0, root.pathProgress, 5)

  love.graphics.setColor(0, 0, 0, alpha)  
  love.graphics.setLineWidth(4)
  love.graphics.line(coordinates)

  love.graphics.setColor(1, 1, 1, alpha)
  love.graphics.setLineWidth(2)
  love.graphics.line(coordinates)
end