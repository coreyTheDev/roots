-- most of the updates in this class were around removing a local tiles table (1D array) and replacing with direct tileset updates (x, y, value)

class ('TileManager').extends()
kManagerUpdateInterval = 0.5
kTileFallRate = 0.5
kHoldLength = 3
tileSize = 20
halfTile = tileSize / 2
didSoak = nil
function getXYFrom(globalIndex)

  local currentIndexY = math.floor(globalIndex / gridWidth)-- 51 / 50 = 1 + 1 101 / 50 + 1 = 3
  local currentIndexX = (globalIndex) % gridWidth -- 111 % 50 = 11

  -- this is a solve for the math above. Because lua is not 0 indexed we need to correct the column if it calculates to 0, otherwise we add 1 to the row calculation
  if currentIndexX == 0 then 
    currentIndexX = gridWidth
  else 
    currentIndexY += 1
  end
  
  -- print("setting tile at x: ".. currentIndexX .. "y: "..currentIndexY.. " from globalIndex: "..globalIndex)
  return currentIndexX, currentIndexY
end


function TileManager:init()
  TileManager.super.init()
  self.timeSinceLastUpdate = 0
  self.highestRowByColumn = {}

  --nutrients
  self.nutrientImagetable = gfx.imagetable.new("images/ground")
  self.nutrientTileset = gfx.tilemap.new()
  self.nutrientTileset:setImageTable(self.nutrientImagetable)
  self.nutrientTileset:setSize(gridWidth, gridHeight)
  
  -- create a sprite from the tilemap
  self.sprite = gfx.sprite.new(gridWidth, gridHeight)
  self.sprite:setTilemap(self.nutrientTileset)
  self.sprite:setCenter(0,0)
  self.sprite:setZIndex(-200)
  self.sprite:add()
  self.sprite:moveTo(0,120)

  self:createTiles()

  for x=1,gridWidth do 
    maxTileValueForColumn = -1
    maxIndexForColumn = -1
    -- print("calculate`d max index for row: ", x, " to be: ", maxIndexForColumn)
    updateTable = {
      timeSinceLastUpdate = 0,
      globalIndex = -1, --maxIndexForColumn
      finalRowForDrop = -1,
      currentRow = -1,

    }
    table.insert(self.highestRowByColumn, updateTable)
  end
end

function TileManager:update(dt)
  self.timeSinceLastUpdate = self.timeSinceLastUpdate + dt
  for i,v in ipairs(self.highestRowByColumn) do
    v.timeSinceLastUpdate = v.timeSinceLastUpdate + dt
  end

  if self.timeSinceLastUpdate > kManagerUpdateInterval then
    -- print("updating tile manager")
    -- print("number of tiles: ", #self.tiles)
    for x=1,gridWidth do 
      updateTableForThisColumn = self.highestRowByColumn[x]
      currentDropRow = updateTableForThisColumn.currentRow
      columnLastUpdate = updateTableForThisColumn.timeSinceLastUpdate
      if columnLastUpdate > kTileFallRate and currentDropRow > 0 then 
        -- print("updating column: "..x)
        if currentDropRow < updateTableForThisColumn.finalRowForDrop then 
          -- coreytodo: finalRowForDrop
          
          -- move drop down
          -- update current drop to 4
          -- print("current index: ", currentIndex)
          -- print("current drop row: ", currentDropRow)
          local currentIndex = updateTableForThisColumn.globalIndex
          currentIndexX, currentIndexY = getXYFrom(currentIndex)

          self.nutrientTileset:setTileAtPosition(currentIndexX, currentIndexY, 3)--.tile = 3

          local nextIndex = currentIndex + gridWidth
          nextIndexX, nextIndexY = getXYFrom(nextIndex)
          self.nutrientTileset:setTileAtPosition(nextIndexX, nextIndexY, 5) -- we need to disable this 
          
          self.highestRowByColumn[x] = {
            timeSinceLastUpdate = 0,
            globalIndex = nextIndex, --maxIndexForColumn
            finalRowForDrop = updateTableForThisColumn.finalRowForDrop,
            currentRow = currentDropRow + 1,
          }
          -- reset
        elseif currentDropRow == updateTableForThisColumn.finalRowForDrop and columnLastUpdate > kHoldLength then 
          local currentIndex = updateTableForThisColumn.globalIndex
          local currentIndexX, currentIndexY = getXYFrom(currentIndex)
          self.nutrientTileset:setTileAtPosition(currentIndexX, currentIndexY, 4)
          self.highestRowByColumn[x] = {
            timeSinceLastUpdate = 0,
            globalIndex = currentIndex,
            finalRowForDrop = -1,
            currentRow = currentDropRow,
          }
        else
          local currentIndex = updateTableForThisColumn.globalIndex
          local currentIndexX,currentIndexY = getXYFrom(currentIndex)
          local updatingValue = self.nutrientTileset:getTileAtPosition(currentIndexX, currentIndexY)
          local tileFalloffSeconds = {7,7,5,4,3}
          if columnLastUpdate > tileFalloffSeconds[updatingValue] then 
            self:decrementTile(currentIndex, updatingValue)
          end
        end
      end
    end

    self.timeSinceLastUpdate = 0
  end
end

function TileManager:draw()
  
  -- self.nutrientTileset:draw(0, height / 2)
  -- Draw tiles
  -- for index,tile in ipairs(self.tiles) do 
  --     tile:draw()
  -- end
end

function TileManager:decrementTile(globalIndex, currentValue) 
 
  local column,row = getXYFrom(globalIndex)
  -- print("decrementing tile column: ", column, " row: ", row) 

  local tilesToUpdate = self:calculateTilesToUpdate(globalIndex, currentValue, column, row)
  for i,tileCoordinates in ipairs(tilesToUpdate) do 
    local updateX = tileCoordinates[1]
    local updateY = tileCoordinates[2]
    self.nutrientTileset:setTileAtPosition(updateX, updateY, math.max(currentValue - 1, 1))
  end 

  self.highestRowByColumn[column].timeSinceLastUpdate = 0
end 

function TileManager:calculateTilesToUpdate(globalIndex, currentValue, column, row)
  local tilesToUpdate = {}
  local tileValues = {7,7,5,3,1}
  local numberToUpdate = tileValues[currentValue]
  table.insert(tilesToUpdate, {column, row}) -- problem 1: storing an index to update
  for i=0,numberToUpdate do
    local rowToUpdate = row + (i + 1)
    if rowToUpdate <= gridHeight then 
      local globalIndexToUpdate = (rowToUpdate - 1) * 50 + globalIndex
      local updateX, updateY = getXYFrom(globalIndexToUpdate)
      table.insert(tilesToUpdate, {updateX, updateY})
    end
  end

  return tilesToUpdate
end

-- coreytodo: migrate
function TileManager:eatNodeIfPossible(currentHead)
    print("eating tile at gridX: ".. currentHead.gridX.." gridY: "..currentHead.gridY)
    if self.nutrientTileset:getTileAtPosition(currentHead.gridX, currentHead.gridY) == 5 then 
      
      -- self.highestRowByColumn[currentHead.gridX] = {
      --   timeSinceLastUpdate = 0,
      --   globalIndex = currentHead.gridX + ((currentHead.gridY - 1) * gridWidth),
      --   finalRowForDrop = -1,
      --   currentRow = currentHead.gridY,
      -- }
      -- self.nutrientTileset:setTileAtPosition(currentHead.gridX, currentHead.gridY, 4)
      
      -- local updateTable = {
      --   timeSinceLastUpdate = 0,
      --   globalIndex = -1, --maxIndexForColumn
      --   finalRowForDrop = -1,
      --   currentRow = -1,
      -- }
      -- self.tiles[tileToEat].tile = 2
      -- self.highestRowByColumn[columnOffset] = updateTable
      return true
    else 
      return false
    end
end

function TileManager:tileHit(indexOfDroplet) 
  randomPercentage = math.random(1,rainfallDelay) --TODO: f addes this, test this more to see how it reacts to rain
  if self.highestRowByColumn[indexOfDroplet].finalRowForDrop == -1 and randomPercentage > 1 then 
    randomEnd = math.random(2, gridHeight)
    -- print("droplet hit at ", indexOfDroplet, " random end: ", randomEnd)

    self.nutrientTileset:setTileAtPosition(indexOfDroplet, 1, 5)
    self.highestRowByColumn[indexOfDroplet] = {
      globalIndex = indexOfDroplet,
      timeSinceLastUpdate = 0,
      finalRowForDrop = randomEnd,
      currentRow = 1
    }
    didSoak = true
  else
    self.nutrientTileset:setTileAtPosition(indexOfDroplet, 1, 4)
    didSoak = false
  end
end

-- Tile = Object:extend()



-- next steps: have this not return an array, and rely on tileset to set / update the value
function TileManager:createTiles()
	-- local createdTiles = {}
  for y=1, gridHeight do 
    for x=1, gridWidth do 
      newTileValue = math.random(1,2)
      self.nutrientTileset:setTileAtPosition(x, y, newTileValue)
      -- newTile = Tile(x, y, love.math.random(1, 2))
      -- table.insert(createdTiles, newTileValue)
      -- print("created tile: ",#createdTiles, " value: ", newTile.tile)
    end
  end

  -- return createdTiles
end

-- function Tile:new(gridX, gridY, nutrientValue)
-- 	self.gridX = gridX
-- 	self.gridY = gridY
-- 	self.x = (gridX - 1) * tileSize
-- 	self.y = gridStartingY + (gridY - 1) * tileSize
-- 	self.tile = nutrientValue
-- end

-- function Tile:draw()
--   if self.tile == Nutrients.ONE then 
--   	self:drawOne()
--   elseif self.tile == Nutrients.TWO then 
--   	self:drawTwo()
--   elseif self.tile == Nutrients.THREE then 
--   	self:drawThree()
--   elseif self.tile == Nutrients.FOUR then 
--   	self:drawFour()
--   elseif self.tile == Nutrients.FIVE then 
--     self:drawFive()
--   end
-- end

-- function Tile:drawOne()
--   love.graphics.translate(self.x, self.y)
-- 	love.graphics.draw(n1, 0, 0)
--   love.graphics.origin()
-- end

-- function Tile:drawTwo()
--   love.graphics.translate(self.x, self.y)
--   love.graphics.draw(n2, 0, 0)
--   love.graphics.origin()
-- end

-- function Tile:drawThree()
--   love.graphics.translate(self.x, self.y)
--   love.graphics.draw(n3, 0, 0)
--   love.graphics.origin()
-- end

-- function Tile:drawFour()
--   love.graphics.translate(self.x, self.y)
--   love.graphics.draw(n4, 0, 0)
--   love.graphics.origin()
-- end

-- function Tile:drawFive()
--   love.graphics.translate(self.x, self.y)
--   love.graphics.draw(n5, 0, 0)
--   love.graphics.origin()
-- end

-- function Tile:drawFog()
--   love.graphics.translate(self.x, self.y)
--   love.graphics.setColor(black)
--   love.graphics.rectangle("fill", 0, 0, tileSize, tileSize)
--   love.graphics.setColor(white)
--   love.graphics.origin()
-- end

