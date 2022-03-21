function playdate.leftButtonDown() 
  root:handleInput("left")
end

function playdate.rightButtonDown() 
  root:handleInput("right")
end

function playdate.upButtonDown()
  root:handleInput("up")
end

function playdate.downButtonDown()
  root:handleInput("down")
end

function playdate.AButtonDown()
  --sound of not eating
  -- if key == "space" then
    -- check if we are on a tile with a 5
    -- print("A button down")
    currentHead = root.nodes[#root.nodes]
    result = tileManager:eatNodeIfPossible(currentHead)
    if result then
      print("eat successful")
      -- heartSpawn()
      -- munch = love.audio.newSource("audio/munch.wav", "static")
      -- munch:setVolume(0.5)
      -- munch:play()
      plant:handleFoodConsumed()
    else 
      
      print("eat failed")
      -- cancel = love.audio.newSource("audio/cancel.wav", "static")
      -- cancel:setVolume(0.5)
      -- cancel:play()
    end
  -- end
  
  -- used to move the intro title card forward to the tutorial
  -- if introIndex < 3 then
  --   introIndex = introIndex + 1
  --   titleWidth = intro[introIndex]:getWidth()
  --   titleHeight = intro[introIndex]:getHeight()
  -- elseif introIndex == 3 then
  --   introIndex = introIndex + 1
  -- end
end

-- function love.keypressed(key, scancode, isrepeat) 
--   root:handleInput(key)
  
-- end
