TileManager = Object:extend()
kManagerUpdateInterval = 2

function TileManager:new()
  self.timeSinceLastUpdate = 0
  self.tiles = createTiles()
  self.highestRowByColumn = {}
  for x=1,50 do 
    maxTileValueForColumn = -1
    maxIndexForColumn = -1

    for y=1,gridHeight do 
      currentTileIndex = x + (y - 1) * gridWidth

      print("computing current tile index of: ", currentTileIndex, "value: ", self.tiles[currentTileIndex].tile, " max tile value: ", maxTileValueForColumn)
      if self.tiles[currentTileIndex].tile > maxTileValueForColumn then 
        -- print("current tile index greater than maxTileValueForColumn", maxTileValueForColumn)
        maxTileValueForColumn = self.tiles[currentTileIndex].tile
        maxIndexForColumn = currentTileIndex
      end
    end 
    print("calculated max index for row: ", x, " to be: ", maxIndexForColumn)
    updateTable = {
      timeSinceLastUpdate = 0,
      highestIndex = maxIndexForColumn
    }
    table.insert(self.highestRowByColumn, updateTable)
  end
  -- find highest values in columns
end

function TileManager:update(dt)
  self.timeSinceLastUpdate = self.timeSinceLastUpdate + dt
  if self.timeSinceLastUpdate > kManagerUpdateInterval then
    print("updating tile manager")
    for x=1,gridWidth do 
      updateTableForThisColumn = self.highestRowByColumn[x]
      tileToUpdate = updateTableForThisColumn.highestIndex
      updatingValue = self.tiles[tileToUpdate].tile
      lastUpdate = updateTableForThisColumn.timeSinceLastUpdate + self.timeSinceLastUpdate
      tileFalloffSeconds = {7,7,5,4,3}
      if lastUpdate > tileFalloffSeconds[updatingValue] then 
        self:decrementTile(tileToUpdate, updatingValue)
      else 
        self.highestRowByColumn[x].timeSinceLastUpdate = lastUpdate
      end
    end

    self.timeSinceLastUpdate = 0
  end
end

function TileManager:draw()
  -- Draw tiles
  for index,tile in ipairs(self.tiles) do 
      tile:draw()
  end
end

function TileManager:decrementTile(globalIndex, currentValue) 
  column = globalIndex % 50
  row = math.floor(globalIndex / 50)

  -- this is a solve for the math above. Because lua is not 0 indexed we need to correct the column if it calculates to 0, otherwise we add 1 to the row calculation
  if column == 0 then 
    column = 50
  else 
    row = row + 1
  end
  print("decrementing tile column: ", column, " row: ", row) 

  tilesToUpdate = self:calculateTilesToUpdate(globalIndex, currentValue, column, row)
  for i,tile in ipairs(tilesToUpdate) do 
    tile.tile = math.max(currentValue - 1, 1)
  end 

  self.highestRowByColumn[column].timeSinceLastUpdate = 0
end 

function TileManager:calculateTilesToUpdate(globalIndex, currentValue, column, row)
  tilesToUpdate = {}
  tileValues = {7,7,5,3,1}
  numberToUpdate = tileValues[currentValue]
  table.insert(tilesToUpdate, self.tiles[globalIndex])
  for i=0,numberToUpdate do
    rowToUpdate = row + (i + 1)
    if rowToUpdate <= 7 then 
      globalIndexToUpdate = (rowToUpdate - 1) * 50 + globalIndex
      table.insert(tilesToUpdate, self.tiles[globalIndexToUpdate])
    end
  end

  return tilesToUpdate
end

function TileManager:tileHit(indexOfDroplet) 
  print("droplet hit at ", indexOfDroplet)
  self.tiles[indexOfDroplet].tile = 5
  self.highestRowByColumn[indexOfDroplet].highestIndex = indexOfDroplet
  self.highestRowByColumn[indexOfDroplet].timeSinceLastUpdate = 0
end

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
  for y=1, gridHeight do 
    for x=1, gridWidth do 
      newTile = Tile(x, y, love.math.random(1, 5))
      table.insert(createdTiles, newTile)
      print("created tile: ",#createdTiles, " value: ", newTile.tile)
    end
  end

  return createdTiles
end

function Tile:new(gridX, gridY, nutrientValue)
	self.gridX = gridX
	self.gridY = gridY
	self.x = (gridX - 1) * tileSize
	self.y = gridStartingY + (gridY - 1) * tileSize
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

