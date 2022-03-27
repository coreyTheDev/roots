function heartSpawn()
  floatHeart = {}
  local plantXPosition = plantLocations[currentPlantIndex].uncorrectedPoint.x + 2
  floatHeart.x = plantXPosition - 15--(windowWidth/2) - 15
  floatHeart.y = (gridStartingY)
  floatHeart.acc = 0.05
  floatHeart.variant = math.random(1,2)
  table.insert(floatingHearts, floatHeart)
end