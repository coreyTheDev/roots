forestIndex = 0
forestSize = 90 --150

class('tree').extends(gfx.sprite)
function tree:init(image)
  tree.super.init(self)

  self.w = math.random(5, 8)
  self.h = gridStartingY + math.random(-tileSize, tileSize*2)
  self.index = forestIndex += 1
  self.anim = playdate.frameTimer.new(300, 0, 0, playdate.easingFunctions.inOutBack)
  self.anim.delay = math.random(1, 200)
  self.anim.repeats = true
  self.animDir = math.floor(math.random(-1,1))
  self.randomTile = math.random(1,3)
  -- pick a variant of the 5 nutrient textures
  self.img = gfx.image.new(image)
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


trees = {}
treeCount = 0
function treeGrow()
  local treeParts = {}
  local x = nil
  local y = nil
  local w = nil
  local h = nil
  local img = "images/n"..tostring(math.random(3,5))
  
  for j=1, math.random(2,5) do
    local treePart = tree(img) -- make it 
    
    if j == 1 then
      x = treePart.x
      y = treePart.y
      w = treePart.w
      h = treePart.h
    end
    
    treePart:setClipRect(x, y, w, h)
    treePart:add() -- add part
    treePart:moveTo(x, (j*tileSize)-tileSize) -- move it
    
    treeParts[j] = treePart
  end
  
  treeCount += 1
  trees[treeCount] = treeParts
end

function forestSpawn()
  for i=1, forestSize do
    treeGrow()
  end
  
  forestAnimation()
end

function forestAnimation()
  -- this is terrible code, sorry
  if treeCount == forestSize then
    for j=1, #trees do
      for k=1, #trees[j] do
        if k >= 2 and k < #trees[j] then
          trees[j][k].anim.updateCallback = function(timer)
            trees[j][k]:setClipRect(trees[j][k].x + (timer.frame/(220)) * trees[j][k].animDir, trees[j][k].y, trees[j][k].w + (timer.frame/(400)) * trees[j][k].animDir, trees[j][k].h)
          end
          
          trees[j][k].anim.timerEndedCallback = function(timer)
            print('rev')
            trees[j][k].animDir = trees[j][k].animDir * -1
          end
        else
        trees[j][k].anim:remove() -- discard the anims that didn't end up getting used
        end
        
        -- w .00005
        -- x .0005
      end
  
    end
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