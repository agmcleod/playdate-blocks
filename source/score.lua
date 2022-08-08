local gfx <const> = playdate.graphics

scoreSprite = gfx.sprite.new()
scoreSprite:setSize(60, 20)
scoreSprite.text = ''

function scoreSprite:draw()
  gfx.drawTextAligned(self.text, 0, 0, kTextAlignment.left)
end

function scoreSprite:setScore(s)
  self.text = "Lives: " .. s
  self:markDirty()
end

function scoreSprite:moveTo(x, y)
  local xResult = x + self.width / 2
  gfx.sprite.moveTo(self, xResult, y)
end