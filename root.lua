class ('Root').extends()
local point = playdate.geometry.point

function Root:init()
	Root.super.init()
	self.nodes = { point.new(10, 1), point.new(10, 2), point.new(11, 2) }
	self.x = x
	self.y = y
	self.pathProgress = 0.025
	self.pathAnimationConstant = (1.0/#self.nodes)
end

function Root:toCoordinates()
	curvePoints = {}
	for i,point in ipairs(self.nodes) do
    table.insert(curvePoints, (point.x - 0.5) * tileSize) -- subtraction of 0.5 is to make it start in the middle
    table.insert(curvePoints, gridStartingY + (point.y - 0.5) * tileSize)
	end
	return curvePoints
end

function Root:update(dt)
	self.pathProgress = self.pathProgress + (self.pathAnimationConstant * 2 * dt)
	-- print("path progress", self.pathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
end

function Root:handleInput(key)
	print("root handle input w/ key ".. key)
	head = self.nodes[#self.nodes]
  previous = self.nodes[#self.nodes - 1]
  self.pathAnimationConstant = 1.0/#self.nodes
	if key == "s" or key == "down" then
		if head.y + 1 <= gridHeight and (head.y + 1) ~= previous.y then 
			local newPoint = point.new(head.x, head.y + 1)
			table.insert(self.nodes, newPoint)
			print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "a" or key == "left" then
  	if head.x - 1 >= 1 and (head.x - 1) ~= previous.x then 
  		local newPoint = point.new(head.x - 1, head.y)
  		table.insert(self.nodes, newPoint)
  		print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "d" or key == "right" then
  	if head.x + 1 <= gridWidth and (head.x + 1) ~= previous.x then 
  		local newPoint = point.new(head.x + 1, head.y)
  		table.insert(self.nodes, newPoint)
  		print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "w" or key == "up" then
		if head.y - 1 >= 1 and (head.y - 1) ~= previous.y then 
			local newPoint = point.new(head.x, head.y - 1)
  		table.insert(self.nodes, newPoint)
  		print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  end

  -- print(self.pathAnimationConstant)
end