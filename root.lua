class ('Root').extends()
local point = playdate.geometry.point

class ('RootNode').extends()

function RootNode:init(gridX, gridY)
  RootNode.super.init(self)
  local xOffset = tileSize / 2 -- math.floor(math.random(-tileSize / 2,  tileSize / 2))-- / 2
  local globalX = (gridX - 1) * tileSize + xOffset
  local yOffset = gridStartingY + tileSize / 2 -- math.floor(math.random(-tileSize / 2, tileSize / 2))-- tileSize / 2
  local globalY = (gridY - 1) * tileSize + yOffset
  self.point = playdate.geometry.point.new(globalX, globalY)
  self.gridX = gridX
  self.gridY = gridY
  self.hidden = false
end

function RootNode:jitter(scale)
  -- scale 1
  -- 0, tileSize
  -- scale 0.5
  -- 0.25 - 0.75
  -- scale 0.25
  local tileCenter = tileSize / 2
  local rangeOfRandomization = tileSize * scale -- 0.5
  local randomOffsetFromCenter = math.floor(rangeOfRandomization / 2 )
  local xOffset = math.floor(math.random(tileCenter - randomOffsetFromCenter, tileCenter + randomOffsetFromCenter))-- / 2
  local globalX = (self.gridX - 1) * tileSize + xOffset
  local yOffset = gridStartingY + math.floor(math.random(tileCenter - randomOffsetFromCenter, tileCenter + randomOffsetFromCenter))
  local globalY = (self.gridY - 1) * tileSize + yOffset
  self.point = playdate.geometry.point.new(globalX, globalY)
end

-- create root segment (4 points with start and end corrected for next input)

function Root:init()
	Root.super.init(self)
	-- self.nodes = { playdate.geometry.point.new(10, 1), playdate.geometry.point.new(12, 5), playdate.geometry.point.new(9, 4), playdate.geometry.point.new(7, 6) ,playdate.geometry.point.new(5, 4), playdate.geometry.point.new(1, 3) }

  self.nodes = { RootNode(10, 1), RootNode(10, 2), RootNode(11,2) }--, RootNode(10, 3), RootNode(9, 4), RootNode(8, 2), RootNode(7, 3) }
	self.x = x
	self.y = y
	self.pathProgress = 0.025
	self.pathAnimationConstant = (1.0/#self.nodes)
end

function Root:toCoordinates(offsetFromEnd)
  local endIndex = #self.nodes - offsetFromEnd
	curvePoints = {}
  -- local xOffset = tileSize / 2
  -- local yOffset = gridStartingY + tileSize / 2
	for i,node in ipairs(self.nodes) do
    -- local globalX = (point.x - 1) * tileSize + xOffset
    -- local globalY = (point.y - 1) * tileSize + yOffset
    --     local yOffset = gridStartingY + tileSize / 2
    
    table.insert(curvePoints, node.point) 
    if i + 1 > endIndex then return curvePoints end
    -- if not node.hidden then
      
    -- end
	end
	return curvePoints
end

function Root:update(dt)
	self.pathProgress = self.pathProgress + (self.pathAnimationConstant * 2 * dt)
	print("path progress", self.pathProgress)
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
		if head.gridY + 1 <= gridHeight and (head.gridY + 1) ~= previous.gridY then 
			local newPoint = RootNode(head.gridX, head.gridY + 1)
      table.insert(self.nodes, newPoint)
      -- 1 in 2 chance to delete node above
      self:updateVisibilityOfNodes()
			print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "a" or key == "left" then
  	if head.gridX - 1 >= 1 and (head.gridX - 1) ~= previous.gridX then 
  		local newPoint = RootNode(head.gridX - 1, head.gridY)
  		table.insert(self.nodes, newPoint)
      -- 1 in 2 chance to delete node to your right
      
      self:updateVisibilityOfNodes()
  		print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "d" or key == "right" then
  	if head.gridX + 1 <= gridWidth and (head.gridX + 1) ~= previous.gridX then 
  		local newPoint = RootNode(head.gridX + 1, head.gridY)
  		table.insert(self.nodes, newPoint)
  		print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
      
      self:updateVisibilityOfNodes()
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  elseif key == "w" or key == "up" then
		if head.gridY - 1 >= 1 and (head.gridY - 1) ~= previous.gridY then 
			local newPoint = RootNode(head.gridX, head.gridY - 1)
  		table.insert(self.nodes, newPoint)
  		print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		
      self:updateVisibilityOfNodes()
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  end

  -- print(self.pathAnimationConstant)
end



function Root:updateVisibilityOfNodes()
  local headIndex = #self.nodes
  
  if #self.nodes < 2 then return end
  
  self.nodes[#self.nodes - 1]:jitter(0.75)
  
  for i=1, #self.nodes - 1 do
    local reversedIndex = #self.nodes - i
    -- local percentageToShow = reversedIndex / (#self.nodes - 2) * 0.5
    local percentageToShow = 1 / (1.5 ^ i)
    
    
    -- percentageToShow *= percentageToShow
    print("percentage to show for index: "..reversedIndex.."= "..percentageToShow)
    if math.random(1, 100) < percentageToShow * 100 then self.nodes[reversedIndex]:jitter(percentageToShow) end
    if percentageToShow * 100 < 1 then return end
  end
  
end


  -- if #self.nodes >= 3 and math.random(1, 100) < 50 then self.nodes[#self.nodes - 2]:jitter(0.5) end
  -- if #self.nodes >= 4 and math.random(1, 100) < 25 then self.nodes[#self.nodes - 2]:jitter(0.25) end
  -- if #self.nodes >= 5 and math.random(1, 100) < 13 then self.nodes[#self.nodes - 2]:jitter(0.125) end
  
  
  -- for i=#self.nodes - 3, #self.nodes - 1 do
  --   -- chance for this to be hidden  
  --   -- local difference = #self.nodes - i
  --   -- local chanceToBeHidden = (1 / (1 + difference)) * 100 -- 0 - 1
  --   -- local shouldHide = math.random(1, 100) < chanceToBeHidden
  --   -- self.nodes[i].hidden = self.nodes[i].hidden or shouldHide
  -- end
  
  
  -- if math.random(1, 100) < 50 then 
  --   table.remove(self.nodes, #self.nodes - 1)-- self.nodes[i].hidden = self.nodes[i].hidden or shouldHide
  -- end