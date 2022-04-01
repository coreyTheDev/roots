class ('Root').extends()
local point = playdate.geometry.point

-- create root segment (4 points with start and end corrected for next input)

function Root:init(gridX)
	Root.super.init(self)
	-- self.nodes = { playdate.geometry.point.new(10, 1), playdate.geometry.point.new(12, 5), playdate.geometry.point.new(9, 4), playdate.geometry.point.new(7, 6) ,playdate.geometry.point.new(5, 4), playdate.geometry.point.new(1, 3) }
  
  self.nodes = { RootNode(gridX, 1), RootNode(gridX, 2), RootNode(gridX + 1,2) }--, RootNode(10, 3), RootNode(9, 4), RootNode(8, 2), RootNode(7, 3) }
  self.gridX = gridX
  self.curvePoints = generateSpline(self:toCoordinates(0))
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
	-- print("path progress", self.pathProgress)
  if self.pathProgress > 1 then 
    self.pathProgress = 1
  end
  
  
end

function Root:draw(isActiveRoot)
  local curvePoints = self.curvePoints
  for i=2, #curvePoints do
    if (i / #curvePoints) < self.pathProgress then
      local x = curvePoints[i-1].x
      local y = curvePoints[i-1].y
      local pX = curvePoints[i].x
      local pY = curvePoints[i].y
      
      -- testing --
      -- local width = math.ceil(math.abs(x - pX))
      -- local height = math.ceil(math.abs(y - pY))
      -- 
      -- print(width, height)
      -- 
      -- self.img = gfx.image.new(width + 1, height + 1)
      -- self.sprite = gfx.sprite.new(self.img)
      -- self.sprite:setCenter(0,0)
      -- self.sprite:add()
      -- self.sprite:setZIndex(500)
      -- self.sprite:moveTo(0,0)
      -- testing -- 
      
      if isActiveRoot then 
        -- gfx.pushContext(self.img)
          gfx.setLineWidth(8)
          gfx.setColor(gfx.kColorBlack)
          gfx.drawLine(x, y, pX, pY)
        
          gfx.setLineWidth(3)
          gfx.setColor(gfx.kColorWhite)
          gfx.drawLine(x, y, pX, pY)
        -- gfx.popContext()
      else  
        gfx.setLineWidth(4)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawLine(x, y, pX, pY)
      end
      
      -- self.sprite:remove()
    end
  end
  
end
function Root:handleInput(key)
	-- print("root handle input w/ key ".. key)
	head = self.nodes[#self.nodes]
  previous = self.nodes[#self.nodes - 1]
  self.pathAnimationConstant = 1.0/#self.nodes
  local needsUpdate = false
	if key == "s" or key == "down" then
		if head.gridY + 1 <= gridHeight and (head.gridY + 1) ~= previous.gridY then 
			local newPoint = RootNode(head.gridX, head.gridY + 1)
      table.insert(self.nodes, newPoint)
      -- 1 in 2 chance to delete node above
      self:updateVisibilityOfNodes()
			-- print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
      needsUpdate = true
  	end
  elseif key == "a" or key == "left" then
  	if head.gridX - 1 >= 1 and (head.gridX - 1) ~= previous.gridX then 
  		local newPoint = RootNode(head.gridX - 1, head.gridY)
  		table.insert(self.nodes, newPoint)
      -- 1 in 2 chance to delete node to your right
      
      self:updateVisibilityOfNodes()
  		-- print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
      needsUpdate = true
  	end
  elseif key == "d" or key == "right" then
  	if head.gridX + 1 <= gridWidth and (head.gridX + 1) ~= previous.gridX then 
  		local newPoint = RootNode(head.gridX + 1, head.gridY)
  		table.insert(self.nodes, newPoint)
  		-- print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
      
      self:updateVisibilityOfNodes()
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
  		-- print("self.pathProgress = ", self.pathProgress)
      needsUpdate = true
  	end
  elseif key == "w" or key == "up" then
		if head.gridY - 1 >= 1 and (head.gridY - 1) ~= previous.gridY then 
			local newPoint = RootNode(head.gridX, head.gridY - 1)
  		table.insert(self.nodes, newPoint)
  		-- print("adding new point: ".. tostring(newPoint).." to self.nodes w/ total count: ".. #self.nodes)
  		
      self:updateVisibilityOfNodes()
  		self.pathProgress = math.min(((#self.nodes - 1) / #self.nodes), 1)
      needsUpdate = true
  		-- print("self.pathProgress = ", self.pathProgress)
  	end
  end
  
  if needsUpdate then
    self.curvePoints = generateSpline(self:toCoordinates(0))
  end
  -- print(self.pathAnimationConstant)
end

function Root:jitterForCrankInput()
  self:updateVisibilityOfNodes()
  self.curvePoints = generateSpline(self:toCoordinates(0))  
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
    -- print("percentage to show for index: "..reversedIndex.."= "..percentageToShow)
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