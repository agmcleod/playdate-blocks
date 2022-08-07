import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

scoreSprite = gfx.sprite.new()

scoreSprite.text = ''

function scoreSprite:draw()
  gfx.pushContext()

  print(self.text)
  gfx.drawText(self.text, self.x, self.y)

  gfx.popContext()
end
