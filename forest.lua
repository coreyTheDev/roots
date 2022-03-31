forestIndex = 0
forestSize = 100 --150

class('tree').extends(gfx.sprite)
function tree:init()
  tree.super.init(self)

  self.w = math.random(5, 8)
  self.h = gridStartingY + math.random(-tileSize, tileSize*2)
  self.index = forestIndex += 1
  
  -- pick a variant of the 5 nutrient textures
  self.img = gfx.image.new("images/n"..tostring(math.random(3,5)))
  self:setImage(self.img)
  
  self.y = -5
  self.x = math.random(-10, width + 10)
  self:setCenter(0,0)
  self:setZIndex(math.random(-5,0)) -- ocassionally draw the raindrop behind the trees
  
  -- create various types of trees
  if forestIndex < forestSize*(1/4) then
    self.w = self.w - 4
    self.h = self.h - math.random(45,60)
  
  elseif forestIndex > forestSize*(1/4) and forestIndex < forestSize*(3/4) then
    self.w = self.w - 2
    self.h = self.h - math.random(25,40)
  
  else
    self.h = self.h - math.random(8, 25)
  end
  
end

function treeGrow()
  treePart = tree() -- make it 

  treePart:setClipRect(treePart.x, treePart.y, treePart.w, treePart.h)
  
  for j=0,5 do
    treePart:add() -- add part
    treePart:moveTo(treePart.x, j*tileSize) -- move it
    treePart:copy() -- copy it
  end
  
end

function forestSpawn()
  for i=1, forestSize do
    treeGrow()
  end
end

function horizonSpawn()
  horizonImg = gfx.image.new(width, 3)
  gfx.pushContext(horizonImg)
    gfx.setLineWidth(1.5)
    gfx.drawLine(0, 1, width, 1)
  gfx.popContext()
  horizonSprite = gfx.sprite.new(horizonImg)
  horizonSprite:add()
  horizonSprite:moveTo(halfWidth, gridStartingY)
end