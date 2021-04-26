Plant = Object:extend()

function Plant:new()
	self.nodes = { 
    RootNode(490, gridStartingY), 
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

function Plant:handleFoodConsumed()
  self.pathProgress = self.pathProgress + (self.foodConsumptionPathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
end