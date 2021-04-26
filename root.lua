Root = Object:extend()

function Root:new()
	self.nodes = { RootNode(25, 1), RootNode(25, 2), RootNode(26, 2) }
	self.x = x
	self.y = y
	self.pathProgress = 0.025
	self.pathAnimationConstant = (1.0/#self.nodes)
end

function Root:toCoordinates()
	curvePoints = {}
	for i,rootNode in ipairs(self.nodes) do
    table.insert(curvePoints, (rootNode.x - 0.5) * tileSize) -- subtraction of 0.5 is to make it start in the middle
    table.insert(curvePoints, gridStartingY + (rootNode.y - 0.5) * tileSize)
	end
	return curvePoints
end

function Root:update(dt)
	self.pathProgress = self.pathProgress + (self.pathAnimationConstant * dt)
	-- print("path progress", self.pathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
end

function Root:handleInput(key)
	head = self.nodes[#self.nodes]
  previous = self.nodes[#self.nodes - 1]
	if key == "s" or key == "down" then
		if head.y + 1 <= gridHeight and (head.y + 1) ~= previous.y then 
  		table.insert(self.nodes, RootNode(head.x, head.y + 1))
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "a" or key == "left" then
  	if head.x - 1 >= 1 and (head.x - 1) ~= previous.x then 
  		table.insert(self.nodes, RootNode(head.x - 1, head.y))
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "d" or key == "right" then
  	if head.x + 1 <= gridWidth and (head.x + 1) ~= previous.x then 
  		table.insert(self.nodes, RootNode(head.x + 1, head.y))
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "w" or key == "up" then
		if head.y - 1 >= 1 and (head.y - 1) ~= previous.y then 
  		table.insert(self.nodes, RootNode(head.x, head.y - 1))
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  end

  self.pathAnimationConstant = 1.0/#self.nodes
  -- print(self.pathAnimationConstant)
end

RootNode = Object:extend()

function RootNode:new(x, y)
	self.x = x
	self.y = y
end
