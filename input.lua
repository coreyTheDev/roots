function playdate.leftButtonDown() 
  if not plantsGrown then rootsInProgress[currentPlantIndex]:handleInput("left") end
end

function playdate.rightButtonDown() 
  if not plantsGrown then  rootsInProgress[currentPlantIndex]:handleInput("right") end
end

function playdate.upButtonDown()
  if not plantsGrown then rootsInProgress[currentPlantIndex]:handleInput("up") end
end

function playdate.downButtonDown()
  if not plantsGrown then rootsInProgress[currentPlantIndex]:handleInput("down") end
end

local kAButtonDisabled = true

function playdate.AButtonDown()
  if kAButtonDisabled then return end
  --sound of not eating
  -- if key == "space" then
    -- check if we are on a tile with a 5
    -- print("A button down")
  if not plantsGrown then 
    local currentRoot = rootsInProgress[currentPlantIndex]
    currentHead = currentRoot.nodes[#currentRoot.nodes]
    result = tileManager:eatNodeIfPossible(currentHead)
    if result then
      print("eat successful")
      heartSpawn()
      -- munch = love.audio.newSource("audio/munch.wav", "static")
      -- munch:setVolume(0.5)
      -- munch:play()
      local currentPlant = plantsInProgress[currentPlantIndex]
      local completed = currentPlant:handleFoodConsumed()
      
      if completed then
        if currentPlantIndex == 3 then currentPlantIndex = 2 
        elseif currentPlantIndex == 2 then currentPlantIndex = 4
        elseif currentPlantIndex == 4 then currentPlantIndex = 1
        elseif currentPlantIndex == 1 then currentPlantIndex = 5
        else 
          plantsGrown = true 
          currentPlantIndex = -1
        end
      end
    else
      
      print("eat failed")
      -- cancel = love.audio.newSource("audio/cancel.wav", "static")
      -- cancel:setVolume(0.5)
      -- cancel:play()
    end
  end
  
  -- used to move the intro title card forward to the tutorial
  -- if introIndex < 3 then
  --   introIndex = introIndex + 1
  --   titleWidth = intro[introIndex]:getWidth()
  --   titleHeight = intro[introIndex]:getHeight()
  -- elseif introIndex == 3 then
  --   introIndex = introIndex + 1
  -- end
end

function handleCrankInput() 
  if plantsGrown then return end
  
  local crankTicked = playdate.getCrankTicks(3)
  if math.abs(crankTicked) == 1 then 
    print ("crank ticked at position: "..playdate.getCrankPosition())
    local currentRoot = rootsInProgress[currentPlantIndex]
    currentRoot:jitterForCrankInput()
    currentHead = currentRoot.nodes[#currentRoot.nodes]
    result = tileManager:eatNodeIfPossible(currentHead)
    if result then
      print("eat successful")
      heartSpawn()

      munch = playdate.sound.sampleplayer.new("audio/munch.wav")
      -- munch:setRate((math.random(8,12)/10)) -- sets variation in pitch
      munch:setVolume(math.random(3, 4)/10)
      munch:play()
      
      local currentPlant = plantsInProgress[currentPlantIndex]
      local completed = currentPlant:handleFoodConsumed()
      
      if completed then
        if currentPlantIndex == 3 then currentPlantIndex = 2 
        elseif currentPlantIndex == 2 then currentPlantIndex = 4
        elseif currentPlantIndex == 4 then currentPlantIndex = 1
        elseif currentPlantIndex == 1 then currentPlantIndex = 5
        else 
          plantsGrown = true 
          currentPlantIndex = -1
        end
      end
    else  
      print("eat failed")
      
      cancel = playdate.sound.sampleplayer.new("audio/cancel.wav")
      -- cancel:setRate(0.5) -- sets variation in pitch
      cancel:setVolume(math.random(2, 3)/10)
      cancel:play()
    end
  end
end

-- function love.keypressed(key, scancode, isrepeat) 
--   root:handleInput(key)
  
-- end


