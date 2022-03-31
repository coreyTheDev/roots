heartGraphic = gfx.image.new("images/heart.png")
heartAccRate = 0.05
prevVariant = 1

class('heart').extends(gfx.sprite)
function heart:init()
  heart.super.init(self)
  self.plantXPosition = plantLocations[currentPlantIndex].uncorrectedPoint.x + 2

  self.acc = 1
  self.animate = true
  
  -- makes every other heart a variant
  if prevVariant == 1 then
    self.variant = 2
    prevVariant = 2
  else
    self.variant = 1
    prevVariant = 1
  end
    
  self.img = heartGraphic
  self:setImage(self.img)
  self:setCenter(0,0)
  self:setZIndex(100)
  self:add()
  
  self.x = self.plantXPosition
  self.y = (gridStartingY)
  self:moveTo(self.x, self.y)
end

function heart:update()
  self:moveTo(self.x, self.y)
  
  if self.animate and self.y > -20 then
    self:moveTo(self.x, self.y)
    self.acc = self.acc + heartAccRate
    self.y = self.y - self.acc
    if self.variant == 1 then
      self.x = self.x + (math.random())
    else
      self.x = self.x - (math.random())
    end
  elseif self.animate == true then
    self:remove()
  end
  
end

function heart:munchSFX()
  munch = playdate.sound.sampleplayer.new("audio/munch.wav")
  -- munch:setRate((math.random(8,12)/10)) -- sets variation in pitch
  munch:setVolume(math.random(3, 4)/10)
  munch:play()
end

function seedsSpawn()
  for i,value in ipairs(plantLocations) do 
    local hrt = heart()
    hrt.x = value.uncorrectedPoint.x + 2
    hrt.y = gridStartingY + 1
    hrt.animate = false
    hrt:moveTo(hrt.x, hrt.y)
  end
end