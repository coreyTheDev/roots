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

  --nutrients
  n1 = love.graphics.newImage("images/n1.png")
  n2 = love.graphics.newImage("images/n2.png")
  n3 = love.graphics.newImage("images/n3.png")
  n4 = love.graphics.newImage("images/n4.png")
  n5 = love.graphics.newImage("images/n5.png")

  --water
  droplets = {}
  dropletGraphic = love.graphics.newImage("images/droplet.png")
  dropletHeight = 15
  dropletAcc = 0.005 --controls how quickly the droplet speeds up over (lower is faster)
  dropletTick = 0
  dropletTimer = math.random(0, 2)
  rainfall = 5 --controls how heavy its raining
  
  --splashes
  splashes = {}
  splashGraphic = love.graphics.newImage("images/splash.png")
  splashTick = 0
  splashTimer = 0.1 --controls how long the splash shows for

  tiles = createTiles()
  root = Root()
end

function love.update(dt)
  root:update(dt)

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
      v.acc = v.acc + dt
      v.y = v.y + (dt*100)*v.acc
    else
      --play musical tone
      tone = love.audio.newSource("audio/" .. "tone" .. v.musicIndex .. ".wav", "static")
      tone:setVolume(math.random(0.4, 0.6))
      tone:play()
      
      -- add Splash graphic in same position
      splashSpawn(v.x, v.y)

      --remove Droplet graphic from table
      table.remove(droplets, i)
    end 
  end
  
  -- show Splash for set amount of time
  for i,v in ipairs(splashes) do
    v.timer = v.timer - dt
    if v.timer < 0 then
      table.remove(splashes, i)
    end
  end
  
end

function love.keypressed(key, scancode, isrepeat) 
  root:handleInput(key)
  
  if key == "space" then
    munch = love.audio.newSource("audio/munch.wav", "static")
    munch:setVolume(0.5)
    munch:play()
  end
end

function splashSpawn(dropletX, dropletY)
  splash = {}
  splash.x = dropletX - 10
  splash.y = dropletY + 5
  splash.timer = splashTimer
  table.insert(splashes, splash)
end

function dropletSpawn()
  droplet = {}
  droplet.x = math.random(1, gridWidth)
  droplet.musicIndex = droplet.x
  droplet.x = (droplet.x * tileSize) - 15
  droplet.y = -dropletHeight
  droplet.acc = dropletAcc
  table.insert(droplets, droplet)
end

function love.draw()
  -- Draw tiles
  for index,tile in ipairs(tiles) do 
      tile:draw()
  end
  
  -- Draw Ground line
  love.graphics.setColor(black)
  love.graphics.rectangle("fill", 0, gridStartingY-1, windowWidth, 1)
  love.graphics.setColor(white)
  
  -- Draw Water drop
  for i,v in ipairs(droplets) do
    if v.y < (gridStartingY - (dropletHeight)) then
      love.graphics.draw(dropletGraphic, v.x, v.y)   
    end
  end
  
  for i,v in ipairs(splashes) do
    love.graphics.draw(splashGraphic, v.x, v.y) 
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