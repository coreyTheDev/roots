Plant = Object:extend()

function Plant:new()
	self.nodes = { 
    RootNode(487, gridStartingY), 
    RootNode(500, gridStartingY - 5), 
    RootNode(490, gridStartingY - 10),
    RootNode(480, gridStartingY - 15), 
    RootNode(490, gridStartingY - 25), 
    RootNode(510, gridStartingY - 30),
    RootNode(500, gridStartingY - 35), 
    RootNode(490, gridStartingY - 45),
    RootNode(480, gridStartingY - 50), 
    RootNode(475, gridStartingY - 55),
    RootNode(490, gridStartingY - 58), 
    RootNode(495, gridStartingY - 65), 
    RootNode(505, gridStartingY - 72),
    RootNode(490, gridStartingY - 75),
  }
  
	self.x = 490
	self.y = gridStartingY
  self.foodConsumed = 0 

	self.pathProgress = math.max(self.foodConsumed, 0.1)
	self.foodConsumptionPathProgress = (1.0/ (4 * #self.nodes))
end

function Plant:toCoordinates()
	curvePoints = {}
	for i,rootNode in ipairs(self.nodes) do
    table.insert(curvePoints, rootNode.x) -- subtraction of 0.5 is to make it start in the middle
    table.insert(curvePoints, rootNode.y)
	end
	return curvePoints
end

function Plant:update(dt)
	-- self.pathProgress = self.pathProgress + (self.pathAnimationConstant * dt)
	-- print("path progress", self.pathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
end

function Plant:draw()
  -- Draw Head
  if self.foodConsumed > 50 then
    love.graphics.setColor(black)
    love.graphics.circle("fill", (windowWidth/2) - 9, 23, 18)
    love.graphics.setColor(white)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", (windowWidth/2) - 9, 23, 5, 10)
    love.graphics.circle("line", (windowWidth/2) - 9, 23, 16, 18)
  end
  
  -- Draw Leaves
  if self.foodConsumed > 10 then
    love.graphics.setColor(white)
    love.graphics.draw(leaf, (windowWidth/2) - 8, 78)
  end
  
  if self.foodConsumed > 20 then
    love.graphics.setColor(white)
    love.graphics.draw(leaf, (windowWidth/2) - 6, 74, 0, -1, -1)
  end
  
  if self.foodConsumed > 30 then
    love.graphics.setColor(white)
    love.graphics.draw(leaf, (windowWidth/2) - 11, 50)
  end
  
  if self.foodConsumed > 40 then
    love.graphics.setColor(white)
    love.graphics.draw(leaf, (windowWidth/2) - 9, 43, 0, -1, -1)
    love.graphics.draw(leaf, (windowWidth/2) - 9, 36)
  end
  


end

function Plant:handleFoodConsumed()
  self.foodConsumed = self.foodConsumed + 1
  self.pathProgress = self.pathProgress + (self.foodConsumptionPathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
end