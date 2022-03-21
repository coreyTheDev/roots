class ('Plant').extends()
local gfx = playdate.graphics
local point = playdate.geometry.point
local black = gfx.kColorBlack
local white = gfx.kColorWhite
function Plant:init()
  Plant.super.init(self)
	self.points = { 
    -- width / 2 = 500
    -- local seedZero = 
    point.new(halfWidth - 10, gridStartingY),
    -- point.new(halfWidth, gridStartingY - 5),
    point.new(halfWidth, gridStartingY -  15),
    point.new(halfWidth - 15, gridStartingY - 25), 
    point.new(halfWidth - 10, gridStartingY - 30), 
    point.new(halfWidth - 15, gridStartingY - 25), 
    point.new(halfWidth - 10, gridStartingY - 30), 
    point.new(halfWidth, gridStartingY - 40), 
    point.new(halfWidth - 10, gridStartingY - 48), 
    point.new(halfWidth - 15, gridStartingY - 53), 
    -- point.new(halfWidth, gridStartingY - 20),
    -- point.new(halfWidth + 5, gridStartingY - 24),
    -- point.new(halfWidth, gridStartingY - 28), 
    -- point.new(halfWidth - 5, gridStartingY - 45), 
    -- point.new(halfWidth - 10, gridStartingY - 45),
    -- point.new(halfWidth - 14, gridStartingY - 50), 
    point.new(halfWidth - 8, gridStartingY - 60),
    -- point.new(halfWidth - 10, gridStartingY - 58), 
    -- point.new(halfWidth - 5, gridStartingY - 65), 
    -- point.new(halfWidth + 5, gridStartingY - 72),
    -- point.new(halfWidth - 10, gridStartingY - 75),
  }
  
	self.x = halfWidth - 10
	self.y = gridStartingY
  self.foodConsumed = 0 
  self.flowerGrown = false

	self.pathProgress = math.max(self.foodConsumed, 0.1)
	self.foodConsumptionPathProgress = (1.0/ (4 * #self.points))
  
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
  if self.foodConsumed > 50 then
    gfx.setColor(gfx.kColorBlack)
    gfx.fillCircleAtPoint(halfWidth - 3, 35, 15)
    gfx.setColor(white)
    gfx.setLineWidth(1)
    gfx.drawCircleAtPoint(halfWidth - 3, 35, 14)--, 10)
    gfx.drawCircleAtPoint(halfWidth - 3, 35, 10)--, 18)
    gfx.setColor(black)
    -- gfx.setFont(font)
    gfx.drawText("NICE GROWING!", halfWidth + 35, gridStartingY - 20)
  end
  
  -- Draw Leaves
  if self.foodConsumed > 10 then
    gfx.setColor(white)
    leaf:draw(halfWidth - 5, gridStartingY - 20)
  end
  
  if self.foodConsumed > 20 then
    gfx.setColor(white)
    leaf:draw(halfWidth - 20, gridStartingY - 40, gfx.kImageFlippedX)--, 0, -1, -1)
  end
  
  if self.foodConsumed > 30 then
    gfx.setColor(white)
    leaf:draw(halfWidth - 5, gridStartingY - 50)
  end
  
  if self.foodConsumed > 40 then
    gfx.setColor(white)
    leaf:draw(halfWidth - 9, gridStartingY - 70)--, 0, -1, -1)
    leaf:draw(halfWidth - 25, gridStartingY - 70, gfx.kImageFlippedX)
  end
end

function Plant:handleFoodConsumed()
  self.foodConsumed = self.foodConsumed + 1
  self.pathProgress = self.pathProgress + (self.foodConsumptionPathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
end