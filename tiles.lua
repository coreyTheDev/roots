Tile = Object:extend()

Nutrients = {
	ONE=1,
	TWO=2,
	THREE=3,
	FOUR=4
}

function createTiles()
	createdTiles = {}
  for y=0, gridHeight do 
    for x=0, gridWidth do 
      newTile = Tile(x, y, love.math.random(1, 4))
      table.insert(createdTiles, newTile)
    end
  end

  return createdTiles
end

function Tile:new(gridX, gridY, nutrientValue)
	self.gridX = gridX
	self.gridY = gridY
	self.x = gridX * tileSize
	self.y = gridStartingY + gridY * tileSize
	self.tile = nutrientValue
end

function Tile:draw()
  love.graphics.setColor(1, 1, 1, 0.10)

  if self.tile == Nutrients.ONE then 
  	self:drawOne()
  elseif self.tile == Nutrients.TWO then 
  	self:drawTwo()
  elseif self.tile == Nutrients.THREE then 
  	self:drawThree()
  elseif self.tile == Nutrients.FOUR then 
  	self:drawFour()
  end

  love.graphics.setColor(1, 1, 1, 1)
end

function Tile:drawOne()
  love.graphics.setColor(1, 1, 1, 0.10)
	love.graphics.rectangle("fill", self.x, self.y, tileSize, tileSize)
end

function Tile:drawTwo()
  love.graphics.setColor(1, 1, 1, 0.25)
	love.graphics.rectangle("fill", self.x, self.y, tileSize, tileSize)
end

function Tile:drawThree()
  love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", self.x, self.y, tileSize, tileSize)
end

function Tile:drawFour()
  love.graphics.setColor(1, 1, 1, 0.75)
	love.graphics.rectangle("fill", self.x, self.y, tileSize, tileSize)
end