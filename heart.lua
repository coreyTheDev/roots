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
    self.panning = math.random(-3, 0)/10
  else
    self.variant = 1
    prevVariant = 1
    self.panning = math.random(0, 3)/10
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

munchNotes = { 'A#2', 'B2', 'D#3', 'F#3', 'C#4'}
availableNotes = { 'A#2', 'B2', 'D#3', 'F#3', 'C#4' }
munchChannel = playdate.sound.channel.new()
munchChannel:setVolume(0.12)
crush = playdate.sound.bitcrusher.new()
crush:setAmount(0.1)
crush:setUndersampling(0.89)
munchChannel:addEffect(crush)

function heart:munchSFX()
  
  -- If availableNotes is empty, refill it
  if #availableNotes == 0 then
    for i=1, #munchNotes do
      table.insert(availableNotes, munchNotes[i])
    end
    printTable(availableNotes)
  end
  
  local currentNote = math.random(1, #availableNotes)

  munch = playdate.sound.synth.new()
  
  munch:setWaveform(playdate.sound.kWaveTriangle)
  munch:setADSR(0.2, 0.1, 0, 0.1)
  munchChannel:addSource(munch)
  munchChannel:setPan(self.panning)
  munch:playNote(availableNotes[currentNote])
  
  table.remove(availableNotes, currentNote)
  printTable(availableNotes)
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