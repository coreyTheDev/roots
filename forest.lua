function forestSpawn()
  tree = {}
  tree.width = 5
  tree.height = gridStartingY
  tree.x = math.random(0, windowWidth)
  
  --use modulo to leave a "gap" in the randomness for the Title / Plant
  if tree.x > (windowWidth/2) - (titleWidth/2) - (titlePadding) then
    tree.x = tree.x % (windowWidth - ((windowWidth/2) + (titleWidth/2) + titlePadding))
    tree.x = tree.x + ((windowWidth/2) + ((titleWidth/2) + titlePadding))
  end
  
  tree.y = -1
  tree.border = 2
  
  -- pick a variant of the 5 nutrient textures
  tree.variant = "n"..tostring(math.random(1,5))
  tree.variant = _G[tree.variant]
  
  -- create various "depths" of trees
  if #forest < forestSize*(1/4) then
    tree.width = tree.width - 4
    tree.height = tree.height - math.random(45,60)
  
  elseif #forest > forestSize*(1/4) and #forest < forestSize*(3/4) then
    tree.width = tree.width - 2
    tree.height = tree.height - math.random(25,40)
  
  else
    tree.height = tree.height - math.random(8, 25)
  end
  
  table.insert(forest, tree)
end