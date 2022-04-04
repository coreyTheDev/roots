-- most of the updates in this class were around removing a local tiles table (1D array) and replacing with direct tileset updates (x, y, value)

class ('TileManager').extends()
kManagerUpdateInterval = 0.5
kTileFallRate = 0.5
-- values here correspond to tiles 1-5 
-- ignore value 1, which doesn't ever decrease
tileFalloffSeconds = {0,5,3,2,2}
-- value to set orphaned tiles to
orphanRowValue = 3
tileSize = 20
halfTile = tileSize / 2
didSoak = nil

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
  self.sprite:moveTo(0,gridStartingY)

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
        if currentDropRow < updateTableForThisColumn.finalRowForDrop then -- lower the rain tile
          local currentIndex = updateTableForThisColumn.globalIndex
          currentIndexX, currentIndexY = getXYFrom(currentIndex)
          self.nutrientTileset:setTileAtPosition(currentIndexX, currentIndexY, 3)
          local nextIndex = currentIndex + gridWidth
          nextIndexX, nextIndexY = getXYFrom(nextIndex)
          self.nutrientTileset:setTileAtPosition(nextIndexX, nextIndexY, 5)
          
          self.highestRowByColumn[x] = {
            timeSinceLastUpdate = 0,
            globalIndex = nextIndex,
            finalRowForDrop = updateTableForThisColumn.finalRowForDrop,
            currentRow = currentDropRow + 1,
          }
        elseif currentDropRow == updateTableForThisColumn.finalRowForDrop and columnLastUpdate > tileFalloffSeconds[5] then -- turn rain from 5 to 4
          local currentIndex = updateTableForThisColumn.globalIndex
          local currentIndexX, currentIndexY = getXYFrom(currentIndex)
          self.nutrientTileset:setTileAtPosition(currentIndexX, currentIndexY, 4)
          self.highestRowByColumn[x] = {
            timeSinceLastUpdate = 0,
            globalIndex = currentIndex,
            finalRowForDrop = -1,
            currentRow = currentDropRow,
          }
        else -- decrement highest value tile if necessary
          local currentIndex = updateTableForThisColumn.globalIndex
          local currentIndexX,currentIndexY = getXYFrom(currentIndex)
          local updatingValue = self.nutrientTileset:getTileAtPosition(currentIndexX, currentIndexY)
          if columnLastUpdate > tileFalloffSeconds[updatingValue] then
            self:decrementTile(currentIndex, updatingValue)
          end
        end
      end
    end

    self.timeSinceLastUpdate = 0
  end
end

function TileManager:decrementTile(globalIndex, currentValue) 
 
  local column,row = getXYFrom(globalIndex)
  -- print("decrementing tile column: ", column, " row: ", row) 
  local decrementedTileValue = math.max(currentValue - 1,1)
  self.nutrientTileset:setTileAtPosition(column, row, decrementedTileValue)
  if row == 1 and decrementedTileValue <= 2 then 
    return
  elseif row > 1 and decrementedTileValue <= 2 then
    local previousIndex = globalIndex - gridWidth
    local previousRow = row - 1
    self.highestRowByColumn[column].globalIndex = previousIndex
    self.highestRowByColumn[column].currentRow = previousRow
  end
  
  self.highestRowByColumn[column].timeSinceLastUpdate = 0
end

-- coreytodo: migrate
function TileManager:eatNodeIfPossible(currentHead)
    -- print("eating tile at gridX: ".. currentHead.gridX.." gridY: "..currentHead.gridY)
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
  randomPercentage = math.random(1, 100) --TODO: f addes this, test this more to see how it reacts to rain
  if self.highestRowByColumn[indexOfDroplet].finalRowForDrop == -1 and randomPercentage > 1 then 
    randomEnd = math.random(2, gridHeight)
    -- print("droplet hit at ", indexOfDroplet, " random end: ", randomEnd)
    
    self.nutrientTileset:setTileAtPosition(indexOfDroplet, 1, 5)
    
    -- find any orphans (rows that won't be touched by this drop but were not decremented)
    -- set them to 3
    if randomEnd < self.highestRowByColumn[indexOfDroplet].currentRow then 
      local currentOrphanRow = self.highestRowByColumn[indexOfDroplet].currentRow
      while currentOrphanRow > randomEnd do
        -- get global index
        self.nutrientTileset:setTileAtPosition(indexOfDroplet, currentOrphanRow, orphanRowValue)
        currentOrphanRow -= 1
      end
    end
    self.highestRowByColumn[indexOfDroplet] = {
      globalIndex = indexOfDroplet,
      timeSinceLastUpdate = 0,
      finalRowForDrop = randomEnd,
      currentRow = 1,
    }
    didSoak = true
  else
    self.nutrientTileset:setTileAtPosition(indexOfDroplet, 1, 4)
    didSoak = false
  end
end

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
