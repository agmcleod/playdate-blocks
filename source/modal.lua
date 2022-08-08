local gfx <const> = playdate.graphics

local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()
local image = gfx.image.new('images/modal.png')
assert(image)

class('Modal').extends()

function Modal:init(text)
  self.background = gfx.sprite.new(image)
  self.textSprite = gfx.sprite.new()
  self.textSprite:setSize(self.background.width - 20, self.background.height - 20)
  self.textSprite:moveTo(screenWidth / 2, screenHeight / 2)
  self.background:moveTo(screenWidth / 2, screenHeight / 2)
  self.textSprite.text = text

  function self.textSprite:draw()
    gfx.drawTextAligned(self.text, self.width / 2, 0, kTextAlignment.center)
  end
end

function Modal:add()
  self.background:add()
  self.textSprite:add()
end

function Modal:remove()
  self.background:remove()
  self.textSprite:remove()
end
