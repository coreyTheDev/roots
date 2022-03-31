gfx = playdate.graphics

dropletGraphic = gfx.image.new("images/droplet.png")
dropletWidth, dropletHeight = dropletGraphic:getSize()

-- rainfallDelay, rainfallDensity, rainfallAccRate = weatherPhase
weather = {
  phase = nil,
  rainfallDelay = 27, -- frames before next raindrop; lower is faster; must be integer greater than 1
  rainfallDensity = 3, -- maximum number of drops produced each time drops are produced; integer less than 8 ideally
  rainfallAccRate = 7, -- acceleration (somewhat generic speed value); best between 3 - 30
  dynamic = true
}

rainfallTimer = playdate.frameTimer.new(weather.rainfallDelay)
rainfallTimer.destroyOnComplete = false

splashGraphic = gfx.image.new("images/splash.png")
splashTimer = 5 -- controls how long the splash shows

prevDropX = nil

-- test

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
  
  if self.x == prevDropX then
    self.x = math.random(1, gridWidth) -- re-roll! helps (mostly) prevent raindrops spawning in same spot
    print('re-roll the droplet!')
  end
  if self.x == prevDropX then
    self.x = math.random(1, gridWidth) -- re-roll... again...
    print('re-roll the droplet... again !')
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
    local tone = playdate.sound.sampleplayer.new("audio/" .. "tone" .. index .. ".wav")
    
    if tone ~= nil then -- to prevent crashing if system didn't have time to create the tone
      tone:setVolume(math.random(4, 5)/10)
      tone:play()
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
  if rainfallTimer.frame >= weather.rainfallDelay then
    for i=1, math.random(0, weather.rainfallDensity) do
      droplet()
    end
    
    if math.random(weather.phase, 6) == 6 and weather.dynamic then
      weatherDynamic()
    end
    
    rainfallTimer:reset()
  end
  
  if weather.phase ~= totalPlantsGrown then
    weatherPhase(totalPlantsGrown)
  end
  
  
end

function weatherPhase(phase)
  print('change phase')
  if phase == 0 then
    weather.phase = 0
    weather.dynamic = false
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 17, 1, 6
  elseif phase == 1 then
    weather.phase = 1
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 22, 4, 3
  elseif phase == 2 then
    weather.phase = 2
    weather.dynamic = false
    weather.rainfallDelay, weather.rainfallDensity, weather.rainfallAccRate = 6, 1, 9
  end
  
  -- variation constants
  delayMax, delayMin = weather.rainfallDelay + 3, weather.rainfallDelay - weather.phase
  densityMax, densityMin = weather.rainfallDensity + 1, weather.rainfallDensity - 1
  accRateMax, accRateMin = weather.rainfallAccRate + weather.phase, weather.rainfallAccRate - 1
end

function weatherDynamic()
  weather.rainfallDelay = math.random(delayMin, delayMax)
  weather.rainfallDensity = math.random(densityMin, densityMax)
  weather.rainfallAccRate = math.random(accRateMin, accRateMax)
  printTable(weather)
end

  -- some way to make this work
-- flourish = math.random(1,100)
-- if flourish >= 70 then
--   rainfallDelay = 2
--   print('flourish')
-- else
--   rainfallDelay = 27
-- end