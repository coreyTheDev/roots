Tile = Object:extend()

Nutrients = {
  ZERO=0,
	ONE=1,
	TWO=2,
	THREE=3,
	FOUR=4,
  FIVE=5,
  FOG=6
}

function createTiles()
	createdTiles = {}
  for y=0, gridHeight do 
    for x=0, gridWidth do 
      newTile = Tile(x, y, love.math.random(0, 5))
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
  if self.tile == Nutrients.ONE then 
  	self:drawOne()
  elseif self.tile == Nutrients.TWO then 
  	self:drawTwo()
  elseif self.tile == Nutrients.THREE then 
  	self:drawThree()
  elseif self.tile == Nutrients.FOUR then 
  	self:drawFour()
  elseif self.tile == Nutrients.FIVE then 
    self:drawFive()
  end
end

function Tile:drawOne()
  love.graphics.translate(self.x, self.y)
	love.graphics.draw(n1, 0, 0)
  love.graphics.origin()
end

function Tile:drawTwo()
  love.graphics.translate(self.x, self.y)
  love.graphics.draw(n2, 0, 0)
  love.graphics.origin()
end

function Tile:drawThree()
  love.graphics.translate(self.x, self.y)
  love.graphics.draw(n3, 0, 0)
  love.graphics.origin()
end

function Tile:drawFour()
  love.graphics.translate(self.x, self.y)
  love.graphics.draw(n4, 0, 0)
  love.graphics.origin()
end

function Tile:drawFive()
  love.graphics.translate(self.x, self.y)
  love.graphics.draw(n5, 0, 0)
  love.graphics.origin()
end

function Tile:drawFog()
  love.graphics.translate(self.x, self.y)
  love.graphics.setColor(black)
  love.graphics.rectangle("fill", 0, 0, tileSize, tileSize)
  love.graphics.setColor(white)
  love.graphics.origin()
end

