Root = Object:extend()

function Root:new()
	self.nodes = { RootNode(50, 1), RootNode(50, 2), RootNode(51, 2) }
	self.x = x
	self.y = y
end

function Root:toCoordinates()
	curvePoints = {}
	for i,rootNode in ipairs(self.nodes) do
    table.insert(curvePoints, (rootNode.x - 0.5) * tileSize) -- subtraction of 0.5 is to make it start in the middle
    table.insert(curvePoints, gridStartingY + (rootNode.y - 0.5) * tileSize)
	end
	return curvePoints
end

RootNode = Object:extend()

function RootNode:new(x, y)
	self.x = x
	self.y = y
end