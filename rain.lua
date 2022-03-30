gfx = playdate.graphics

dropletGraphic = gfx.image.new("images/droplet.png")
dropletWidth, dropletHeight = dropletGraphic:getSize()

rainfallDelay = 27 -- frames before next raindrop; lower is faster; must be integer greater than 1
rainfallDensity = 3 -- maximum number of drops produced each time drops are produced; integer less than 8 ideally
rainfallAcc = 7 -- raindrop visual acceleration rate (generic speed value added per frame, cumulatively added)
rainfallRate = (rainfallDelay * rainfallDensity) -- used as a general rainfall rate number

splashGraphic = gfx.image.new("images/splash.png")
splashTimer = 5 -- controls how long the splash shows

prevDropX = nil

-- phase 1 (27, 2, 7)

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
  
  self.acc = 1
  self.img = dropletGraphic
  self:setImage(self.img)
  self.x = math.random(1, gridWidth)
  
  if self.x == prevDropX then
    self.x = math.random(1, gridWidth) -- re-roll! helps (mostly) prevent raindrops spawning in same spot
    print('re-roll the droplet!')
  end
  prevDropX = self.x
  
  self.musicIndex = self.x
  self.x = (self.x * tileSize) - 15 --limit it to and center it on tile
  self.y = -dropletHeight + math.random(-10,10)
  self:setCenter(0,0)
  self:moveTo(self.x, self.y)
  self:add()
end

function droplet:update()
  self:moveTo(self.x, self.y)
  
  if self.y < (gridStartingY - (dropletHeight - 6)) then
    self.acc = self.acc + (rainfallAcc/100)
    self.y = self.y + self.acc
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