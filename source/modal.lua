local gfx <const> = playdate.graphics

local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()
local image = gfx.image.new('images/modal.png')
assert(image)

class('Modal').extends(gfx.sprite)

function Modal:init(text)
  Modal.super.init(self, image)
  self.text = text
  self:moveTo(screenWidth / 2, screenHeight / 2)
end

function Modal:draw()
  Modal.super.draw()

  gfx.drawText(self.text, 0, 0)
end
