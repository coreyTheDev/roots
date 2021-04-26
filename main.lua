io.stdout:setvbuf("no")

function love.load()
  Object = require "classic"
  require "tiles"
  require "root"
  require "rain"
  require "forest"
  require "plant"
  require "heart"

  white = {1, 1, 1}
  black = {0, 0, 0}

  -- scene setup
  love.graphics.setBackgroundColor(white)
  love.window.setTitle("Roots") 

  love.window.setMode(1000, 240, 
    {
      highdpi = false, --?
      msaa = 0 -- antialias
    })
  windowWidth, windowHeight = love.window.getMode()
  
  -- setting a seed seems to be required to actually get randomization during dev?
  math.randomseed(love.timer.getTime())

  tileSize = 20
  gridWidth = 50
  gridHeight = 7
  gridStartingY = 100
  
  --font
  font = love.graphics.newFont("fonts/press-start.ttf", 9)

  --title and tutorial
  title = love.graphics.newImage("images/title.png")
  titleWidth = title:getWidth()
  titleHeight = title:getHeight()
  titlePadding = 40
  
  credits = love.graphics.newImage("images/credits.png")
  tutorial = love.graphics.newImage("images/tutorial.png")
  
  introIndex = 1
  intro = {title, credits, tutorial}

  --nutrients
  n1 = love.graphics.newImage("images/n1.png")
  n2 = love.graphics.newImage("images/n2.png")
  n3 = love.graphics.newImage("images/n3.png")
  n4 = love.graphics.newImage("images/n4.png")
  n5 = love.graphics.newImage("images/n5.png")
  heart = love.graphics.newImage("images/heart.png")
  heartOutline = love.graphics.newImage("images/heart-outline.png")
  
  --leaf
  leaf = love.graphics.newImage("images/leaf.png")

  --water
  droplets = {}
  dropletGraphic = love.graphics.newImage("images/droplet.png")
  dropletHeight = dropletGraphic:getHeight()
  dropletAcc = 0.005 --controls how quickly the droplet speeds up over (lower is faster)
  dropletTick = 0
  dropletTimer = math.random(0, 2)
  rainfall = 5 --controls how heavy its raining
  
  --splashes
  splashes = {}
  splashGraphic = love.graphics.newImage("images/splash.png")
  splashTick = 0
  splashTimer = 0.1 --controls how long the splash shows for
  
  --forest
  forest = {}
  forestSize = 150
  
  floatingHearts = {}
  
  for i=1, forestSize do
    forestSpawn()
  end

  tileManager = TileManager()
  root = Root()
  plant = Plant()
end

function love.update(dt)
  -- every second move any 5 tiles down by one
  root:update(dt)
  plant:update(dt)
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
      v.acc = v.acc + dt
      v.y = v.y + (dt*100)*v.acc
    else
      --play musical tone
      tone = love.audio.newSource("audio/" .. "tone" .. v.musicIndex .. ".wav", "static")
      tone:setVolume(math.random(0.4, 0.5))
      tone:play()
      
      -- add Splash graphic in same position
      splashSpawn(v.x, v.y)

      --remove Droplet graphic from table
      table.remove(droplets, i)

      -- update tile
      indexOfDroplet = (v.x + 15) / tileSize
      tileManager:tileHit(indexOfDroplet)
    end
  end
  
  -- show Splash for a set, short amount of time
  for i,v in ipairs(splashes) do
    v.timer = v.timer - dt
    if v.timer < 0 then
      table.remove(splashes, i)
    end
  end
  
  --update heart positions
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
  
end


function love.keypressed(key, scancode, isrepeat) 
  root:handleInput(key)
  
  --sound of not eating
  if key == "space" then
    cancel = love.audio.newSource("audio/cancel.wav", "static")
    cancel:setVolume(0.5)
    cancel:play()
  end
  
  --sound of eating
  if key == "e" then
    heartSpawn()
    munch = love.audio.newSource("audio/munch.wav", "static")
    munch:setVolume(0.5)
    munch:play()
    plant:handleFoodConsumed()
  end
  
  -- used to move the intro title card forward to the tutorial
  if introIndex < 3 then
    introIndex = introIndex + 1
    titleWidth = intro[introIndex]:getWidth()
    titleHeight = intro[introIndex]:getHeight()
  elseif introIndex == 3 then
    introIndex = introIndex + 1
  end
end


function love.draw()
  tileManager:draw()
  
  -- Draw Ground line
  love.graphics.setColor(black)
  love.graphics.rectangle("fill", 0, gridStartingY-1, windowWidth, 1)
  love.graphics.setColor(white)
  
  -- Draw Forest
  for i,v in ipairs(forest) do
    local function myStencilFunction()
       love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end
    
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    
    for i=0,5 do
      love.graphics.draw(v.variant, v.x, v.y + (i*tileSize))
    end
    love.graphics.setStencilTest()
  end
  
  -- Draw Title
  if introIndex <= 3 then
    love.graphics.draw(intro[introIndex], (windowWidth/2) - (titleWidth/2), (gridStartingY/2) - (titleHeight/2)) 
  end 
  
  -- Draw Water drop
  for i,v in ipairs(droplets) do
    if v.y < (gridStartingY - (dropletHeight)) then
      love.graphics.draw(dropletGraphic, v.x, v.y)   
    end
  end
  
  -- Draw Splashes
  for i,v in ipairs(splashes) do
    love.graphics.draw(splashGraphic, v.x, v.y) 
  end
  
  -- Draw Root
  -- plantPoints = {
  --   490, gridStartingY,
  --   500, gridStartingY - 5,
  --   490, gridStartingY - 10,
  --   480, gridStartingY - 15,

  --   490, gridStartingY - 25,
  --   510, gridStartingY - 30,
  --   500, gridStartingY - 35,
  --   490, gridStartingY - 45,
  -- }
  
  -- Draw Plant
  plantCurve = love.math.newBezierCurve(plant:toCoordinates())
  plantCoordinates = plantCurve:renderSegment(0.0, plant.pathProgress, 2)

  love.graphics.setColor(0, 0, 0, alpha)  
  love.graphics.setLineWidth(5)
  love.graphics.setLineStyle("rough")
  love.graphics.line(plantCoordinates)

  plant:draw()

  
  -- love.graphics.arc( "line", "open", 500, gridStartingY, 20, math.pi, 1.5 * math.pi, 5)

  -- print("# root line coordinates: ", #coordinates)

  -- Draw Root
  curve = love.math.newBezierCurve(root:toCoordinates())
  coordinates = curve:renderSegment(0.0, root.pathProgress, 5)

  love.graphics.setColor(1, 1, 1, alpha)  
  love.graphics.setLineWidth(8)
  love.graphics.line(coordinates)
  
  love.graphics.setColor(0, 0, 0, alpha)  
  love.graphics.setLineWidth(6)
  love.graphics.line(coordinates)

  love.graphics.setColor(1, 1, 1, alpha)
  love.graphics.setLineWidth(3)
  love.graphics.line(coordinates)
  
  -- Draw Heart
  love.graphics.draw(heart, (windowWidth/2) - tileSize+2, gridStartingY+1)
  
  -- Draw Floating Hearts
  for i,v in ipairs(floatingHearts) do
    love.graphics.draw(heartOutline, v.x, v.y) 
  end
end