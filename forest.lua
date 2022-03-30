function treeSpawn()
  tree = {}
  tree.width = math.random(1,4)
  tree.height = gridStartingY + math.random(-tileSize, tileSize)
  tree.y = -tileSize
  tree.x = math.random(-10, (width + 10))
  
  -- pick a variant of the 5 nutrient textures
  tree.variant = gfx.image.new("images/n"..tostring(math.random(3,5)))
  tree.sprite = gfx.sprite.new(tree.variant)
  tree.sprite:setCenter(0,0)
  tree.sprite:setZIndex(math.random(-5,0)) -- ocassionally draw the raindrop behind the trees
  
  -- create various types of trees
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