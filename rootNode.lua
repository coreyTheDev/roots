local point = playdate.geometry.point

class ('RootNode').extends()

function RootNode:init(gridX, gridY)
	RootNode.super.init(self)
	local xOffset = tileSize / 2 -- math.floor(math.random(-tileSize / 2,  tileSize / 2))-- / 2
	local globalX = (gridX - 1) * tileSize
	local yOffset = gridStartingY + tileSize / 2 -- math.floor(math.random(-tileSize / 2, tileSize / 2))-- tileSize / 2
	local globalY = (gridY - 1) * tileSize
	self.point = playdate.geometry.point.new(globalX + xOffset, globalY + yOffset)
	self.uncorrectedPoint = playdate.geometry.point.new(globalX, globalY + yOffset)
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
