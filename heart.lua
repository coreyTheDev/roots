function heartSpawn()
  floatHeart = {}
  floatHeart.x = (windowWidth/2) - 15
  floatHeart.y = (gridStartingY)
  floatHeart.acc = 0.05
  floatHeart.variant = math.random(1,2)
  table.insert(floatingHearts, floatHeart)
end