heartOutline = gfx.image.new("images/heart.png")
prevVariant = 1

function heartSpawn()
  floatHeart = {}
  local plantXPosition = plantLocations[currentPlantIndex].uncorrectedPoint.x + 2
  floatHeart.x = plantXPosition - 15
  floatHeart.y = (gridStartingY) + 10
  floatHeart.acc = 0.05
  
  -- makes every other heart a variant
  if prevVariant == 1 then
    floatHeart.variant = 2
    prevVariant = 2
  else
    floatHeart.variant = 1
    prevVariant = 1
  end
    
  floatHeart.img = heartOutline
  floatHeart.sprite = gfx.sprite.new(floatHeart.img)
  floatHeart.sprite:setZIndex(100)
  floatHeart.sprite:add()
  floatHeart.sprite:moveTo(floatHeart.x, floatHeart.y)
  table.insert(floatingHearts, floatHeart)
end