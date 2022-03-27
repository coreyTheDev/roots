class ('Plant').extends()
local gfx = playdate.graphics
local point = playdate.geometry.point
local black = gfx.kColorBlack
local white = gfx.kColorWhite

-- ideas: wiggle root system while cranking to indicate drinking

-- questions: how do plants / roots talk to each other


-- plant things to be done
-- place plants at x - y
-- make food consumed variable up to a total of 5
-- have this variable control the total number of leaves
-- draw more of path per food consumed (animate up to a leaf when consuming a single food)
local kFoodPerStep = 10

function Plant:init(gridX, numberOfStepsToTop)
  Plant.super.init(self)
  self.x = (gridX - 1) * tileSize + tileSize / 2
  self.totalSteps = numberOfStepsToTop
  
  -- generating a path to the top:
  -- steps go outwards from center in a random direction to get to the first step
  local currentY = gridStartingY
  local pointsInPath = { point.new(self.x, currentY) }
  
  local direction = math.random(2) -- 1 = left, 2 = right
  for i = 1, self.totalSteps do 
    local horDisplacement = math.random(2, 5)
    if direction == 1 then 
      horDisplacement *= -1 
      direction = 2
    else
      direction = 1
    end
    
    currentY -= math.random(10, 15)
    local outwardsPoint = point.new(self.x + horDisplacement, currentY)
    table.insert(pointsInPath, outwardsPoint)
    -- any given step
    -- go outwards to a side
  end
  currentY -= 5
  table.insert(pointsInPath, point.new(self.x, currentY))
  self.points = pointsInPath
  
  -- total points are 7 for a height of 5
  -- origin, 5 curves, point at end of flower
  
	self.y = gridStartingY
  self.flowerGrown = false

  self.foodConsumed = 0
  -- to get from 0 to 1 we need the path to be 2 - 7
  self.currentHeight = 0.5
  self.pathProgress = self.currentHeight / self.totalSteps 
  
	-- self.pathProgress = math.max(self.foodConsumed, 0.1)
  -- self.foodConsumptionPathProgress = (1.0/ #self.points)
  
  self.curvePoints = generateSpline(self.points)
end

-- function Plant:toCoordinates()
-- 	curvePoints = {}
-- 	for i,rootNode in ipairs(self.nodes) do
--     table.insert(curvePoints, rootNode.x) -- subtraction of 0.5 is to make it start in the middle
--     table.insert(curvePoints, rootNode.y)
-- 	end
-- 	return curvePoints
-- end

function Plant:update(dt)
	-- self.pathProgress = self.pathProgress + (self.pathAnimationConstant * dt)
	-- print("path progress", self.pathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
  
  -- COREYTODO: Implement
  -- if self.foodConsumed == 51 and self.flowerGrown == false then
  --   self.flowerGrown = true
  --   flower = love.audio.newSource("audio/flower.wav", "static")
  --   flower:setVolume(0.75)
  --   flower:play()
  -- end
end

function Plant:draw()
  local curvePoints = self.curvePoints
  for i=2, #curvePoints do
    if (i / #curvePoints) < self.pathProgress then
      local x = curvePoints[i-1].x
      local y = curvePoints[i-1].y
      local pX = curvePoints[i].x
      local pY = curvePoints[i].y
      
      gfx.setColor(black)  
      gfx.setLineWidth(5)
      -- gfx.setLineStyle("rough")
      gfx.drawLine(x, y, pX, pY)
    end
  end

  -- Draw Head
  if self.flowerGrown then
    gfx.setColor(gfx.kColorBlack)
    local pointToPlaceFlower = self.points[#self.points]
    gfx.fillCircleAtPoint(pointToPlaceFlower.x, pointToPlaceFlower.y - 15, 15)
    gfx.setColor(white)
    gfx.setLineWidth(1)
    gfx.drawCircleAtPoint(pointToPlaceFlower.x, pointToPlaceFlower.y - 15, 14)--, 10)
    gfx.drawCircleAtPoint(pointToPlaceFlower.x, pointToPlaceFlower.y - 15, 10)--, 18)
    gfx.setColor(black)
  end
  
  -- loop through to draw leaves
  for i=1,math.floor(self.currentHeight) do
    local pointToPlaceLeaf = self.points[i + 1] -- this is the point right after the origin
    gfx.setColor(white)
    if pointToPlaceLeaf.x < self.x then 
      -- we are placing a leaf on the left
      leaf:draw(pointToPlaceLeaf.x - leaf:getSize() / 1.5, pointToPlaceLeaf.y - 5, gfx.kImageFlippedX)
    else 
      leaf:draw(pointToPlaceLeaf.x - 5, pointToPlaceLeaf.y - 5)
    end
  end
end

function Plant:handleFoodConsumed()
  if self.foodConsumed < self.totalSteps * kFoodPerStep then 
    self.foodConsumed = self.foodConsumed + 1 
  else 
    self.flowerGrown = true 
  end
  
  self.currentHeight += (1 / kFoodPerStep)
  
  -- recalculate path progress based on food consumed
  self.pathProgress = self.currentHeight / self.totalSteps
  -- self.pathProgress = self.pathProgress + (self.foodConsumptionPathProgress)
  
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
  
  return self.flowerGrown
end