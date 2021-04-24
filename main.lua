io.stdout:setvbuf("no")


function love.load()
  Object = require "classic"
  require "tiles"

  primaryColor = {0.1, 0.1, 0.1}
  blueprintColor = {0.41, 0.53, 0.97}
  primaryWhite = {0.97, 0.97, 0.97}

  -- scene setup
  love.graphics.setBackgroundColor(primaryColor)
  --love.graphics.setBackgroundColor(0.1, 0, 0)
  love.window.setTitle("Untitled flower clone") 

  love.window.setMode(1000, 240, 
    {
      highdpi = true, --for retina displays
      msaa = 4 -- antialias
    })
  windowWidth, windowHeight = love.window.getMode()

  tileSize = 10
  gridWidth = 100
  gridHeight = 15
  gridStartingY = 90

  tiles = createTiles()

  
  rootNodes = {}
  seed = {
    x =  50,
    y = 1
  }
  table.insert(rootNodes, seed)
  table.insert(rootNodes, {x = 51, y = 2})

  head = {
    x = 52, 
    y = 2
  }
  table.insert(rootNodes, head)


  pathProgress = 0.025
  
end

function love.update(dt)
  pathProgress = pathProgress + 0.01
  if pathProgress > 1 then 
    pathProgress = 1
  end
end

function love.keypressed(key, scancode, isrepeat) 
  if key == "s" or key == "down" then
    headIncremented = {
      x = head.x,
      y = math.min(head.y + 1, gridHeight)
    }
    table.insert(rootNodes, headIncremented)
  elseif key == "a" or key == "left" then
    headIncremented = {
      x = math.max(0, head.x - 1),
      y = head.y
    }
    table.insert(rootNodes, headIncremented)
  end

  -- if love.keyboard.isDown("w") then
  --   camera:move(0, -DEBUG_VELOCITY_PIXELS_PER_SECOND * dt)
  -- -- elseif love.keyboard.isDown("s") then
  -- --   camera:move(0, DEBUG_VELOCITY_PIXELS_PER_SECOND * dt)
  -- end
end

function love.draw()
  for index,tile in ipairs(tiles) do 
      tile:draw()
  end

  -- TODO: Draw tiles

  -- love.graphics.arc("line", "open", 200, 100, 10, math.pi / 2, math.pi, 30)
  -- love.graphics.arc("line", "open", 200, 100, 20, math.pi, 0, 30)
  -- love.graphics.arc("line", "open", 200, 150, 20, math.pi, math.pi / 2, 30)
  -- love.graphics.arc("line", "open", 200, 200, 20, math.pi, 3 * math.pi / 2, 30)
  -- love.graphics.arc("fill", "open", 240, 100, 20, -math.pi, 0, 30)
  -- 10 x 10
  -- 100 x 15 - underground grid
  -- aka 1000 x 150 pixels
--   curvePoints = {}
--   for index,node in ipairs(rootNodes) do 
--     print("adding node.x: ", (node.x * tileSize)," - node.y: ", (gridStartingY + node.y * tileSize))
--     table.insert(curvePoints, node.x * tileSize)
--     table.insert(curvePoints, gridStartingY + node.y * tileSize)
--   end

-- print{curvePoints}

--   -- curve = love.math.newBezierCurve({25,25,35,50,45,25,55,0,75,25,85,50})
--   curve = love.math.newBezierCurve(curvePoints)
--   coordinates = curve:renderSegment(0.0, pathProgress, 5)

--   -- coordinates = curve:render()
--   love.graphics.line(coordinates)
  -- love.graphics.line(400, 100, 400, 150, 420, 200)
  -- love.graphics.arc("line", "open", 300, 100, 100, math.pi, math.pi / 2, 15)
  -- love.graphics.arc("line", "open", 300, 100, 100, math.pi, math.pi / 2, 15)
end