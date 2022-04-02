gfx = playdate.graphics

dropletGraphic = gfx.image.new("images/droplet.png")
dropletWidth, dropletHeight = dropletGraphic:getSize()

weather = {
  phase = nil, -- keeps track of the current phase of weather it is
  rainfallDelay = 27, -- frames before next raindrop; lower is faster; must be integer greater than 1
  rainfallDensity = 3, -- maximum number of drops produced each time drops are produced; integer less than 8 ideally
  rainfallAccRate = 7, -- acceleration (somewhat generic speed value); best between 3 - 30
}

rainfallTimer = playdate.frameTimer.new(weather.rainfallDelay)
rainfallTimer.destroyOnComplete = false
rainfallTimer.repeats = true
rainfallDiff = 0 -- helper to adjust timer based on any dynamically changed delay values

rainChannelL = playdate.sound.channel.new()
rainChannelR = playdate.sound.channel.new()

flux = playdate.frameTimer.new(0)
flux.repeats = true
fluxTrigger = 100 -- number of frames between each flux call
fluxMod = 2 -- the amount that rainfallDelay is modified each trigger

splashGraphic = gfx.image.new("images/splash.png")
splashTimer = 5 -- controls how long the splash shows

prevDropX = nil

class('splash').extends(gfx.sprite)
function splash:init(dropletX, dropletY)
  splash.super.init(self)
  self.img = splashGraphic
  self:setImage(self.img)
  self.x = dropletX - 10
  self.y = dropletY + 3
  self:setCenter(0,0)
  self:add()
  self:moveTo(self.x, self.y)
  self.timer = playdate.frameTimer.new(splashTimer)

  self.timer.timerEndedCallback = function(timer)
    self:remove()
  end
end


class('droplet').extends(gfx.sprite)
function droplet:init()
  droplet.super.init(self)
  
  self.acc = weather.rainfallAccRate
  self.img = dropletGraphic
  self:setImage(self.img)
  self.x = math.random(1, gridWidth)
  
  -- Get position between -0.5 and 0.5 for audio panning (reducing it for less dramatic effect)
  if self.x < (gridWidth/2) then
    local leftPan = playdate.math.lerp(-0.5, 0, (self.x/10))
    self.panning = round(leftPan, 2)
  else
    local rightPan = playdate.math.lerp(0, 0.5, (self.x/10)-1)
    self.panning = round(rightPan, 2)
  end
  
  if self.x == prevDropX then
    self.x = math.random(1, gridWidth) -- re-roll! helps (mostly) prevent raindrops spawning in same spot
    print('re-roll the droplet X pos!')
  end
  if self.x == prevDropX then
    self.x = math.random(1, gridWidth) -- re-roll... again...
    print('re-roll the droplet X pos... again !')
  end
  prevDropX = self.x
  
  self.musicIndex = self.x
  self.x = (self.x * tileSize) - 15 --limit it to and center it on tile
  self.y = -dropletHeight + math.random(-3, 3)
  self:setCenter(0,0)
  self:moveTo(self.x, self.y)
  self:add()
end

function droplet:update()
  self:moveTo(self.x, self.y)
  
  if self.y < (gridStartingY - (dropletHeight - 6)) then
    self.acc = self.acc * 1.055
    self.y = self.y + (self.acc/10)
  else
    
    -- play sfx tone
    local index = nil
    if math.random(1,2)%2 == 0 then 
      index = self.musicIndex * 2
    else
      index = (self.musicIndex * 2) + 1
    end
    
    local dropletTone = playdate.sound.sampleplayer.new("audio/" .. "tone" .. index .. ".wav")
    
    if dropletTone ~= nil then -- to prevent crashing if system didn't have bandwidth to create the tone
      
      -- Reduce the panning effect during heavy rainfall
      if weather.phase == 3 then
        self.panning = self.panning/2
      end
      
      if self.panning <= 0 then
        -- Left channel
        rainChannelL:setPan(self.panning)
        rainChannelL:addSource(dropletTone)
      else
        -- Right channel
        rainChannelR:setPan(self.panning)
        rainChannelR:addSource(dropletTone)
      end
      
      
      dropletTone:setVolume(math.random(4, 5)/10)
      dropletTone:play()
    end
    
    self:remove()

    -- update tile
    indexOfDroplet = (self.x + 15) / tileSize -- what is this doing
    tileManager:tileHit(indexOfDroplet)
    
    -- add Splash graphic in same position
    if not didSoak then
      splash(self.x, self.y - 8)
    end
  end
end

function weatherUpdate()

  if rainfallTimer.frame >= (weather.rainfallDelay - rainfallDiff) then
    for i=1, math.random(0, weather.rainfallDensity) do
      droplet()
    end
    rainfallTimer:reset()
  end
  
  if weather.phase ~= totalPlantsGrown then --attach this more firmly 
    weatherPhase(totalPlantsGrown)
  end
end

function weatherPhase(phase)
  fluxMod = 2
  rainfallDiff = 0
  
  weather.phase = phase
  print("phase:" .. weather.phase)
  
  if weather.phase == 0 then
    
    print('- - itty bitty drips - -')
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 13, 1, 6
    
    flux.duration = 600
    flux:reset()
    flux:start()
  elseif weather.phase == 1 then
    
    print('- - chunky chords - -')
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 24, 5, 2
    
    flux.duration = 200
    flux:reset()
    flux:start()
  elseif weather.phase == 2 then
    
    print('- - steady syncopation - -')
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 13, 2, 7
    
    flux.duration = 300
    flux:reset()
    flux:start()
  elseif weather.phase == 3 then
    
    print('- - downpour - -')
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 11, 2, 5 --13 goes down to 3 over time
    
    -- Ease down the delay, into the downpour to be less jarring
    downpourEaseIn = playdate.frameTimer.new(160)
    downpourEaseIn.updateCallback = function(timer)
      if timer.frame%20 == 0 then
        weather.rainfallDelay -= 1
      end
    end
    
    flux.duration = 200
    flux:reset()
    flux:start()
  elseif weather.phase == 4 then
    
    print('- - after the storm - -')
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 1, 1, 2 --1 goes up to 15 over time
    
    -- Ease up the delay, out of the downpour to be more natural
    downpourEaseOut = playdate.frameTimer.new(420)
    downpourEaseOut.updateCallback = function(timer)
      if timer.frame%30 == 0 then
        weather.rainfallDelay += 1
      end
    end
    
    -- Wait to start the flucuation timer until after transition
    downpourEaseOut.timerEndedCallback = function(timer)
      flux.duration = 500
      flux:reset()
      flux:start()
    end
    
    flux:pause()
    
  elseif weather.phase == 5 then
    
    print('- - forever rain - -')
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 20, 3, 3
    
    flux.duration = 500  
    flux:reset()
    flux:start()     
  end
  
  printWeather()
  
  flux.updateCallback = function(timer)
    if timer.frame%fluxTrigger == 0 then
      weather.rainfallDelay += fluxMod
      rainfallDiff += fluxMod
    end
  end
  
  flux.timerEndedCallback = function(timer)
    print('flip flux direction')
    fluxMod = fluxMod * -1
  end
end

function printWeather()
  print('delay: ' .. weather.rainfallDelay, 'density: ' .. weather.rainfallDensity, 'acc: ' .. weather.rainfallAccRate)
end

-- Debugging tool
function playdate.keyPressed(key)
  if key == '0' then
    totalPlantsGrown = 0
  elseif key == '1' then
    totalPlantsGrown = 1
  elseif key == '2' then
    totalPlantsGrown = 2
  elseif key == '3' then
    totalPlantsGrown = 3
  elseif key == '4' then
    totalPlantsGrown = 4
  elseif key == '5' then
    totalPlantsGrown = 5
  end
end