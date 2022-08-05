import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local ballSprite = nil
local paddleSprite = nil

local paddleVelocity <const> = 8
local paddleWidth <const> = 50

local blocks = {}

function setup()
  local ballImage = gfx.image.new('images/ball.png')
  assert(ballImage)

  ballSprite = gfx.sprite.new(ballImage)
  ballSprite:moveTo(200, 190)
  ballSprite:add()

  gfx.setBackgroundColor(gfx.kColorWhite)

  local blockImage = gfx.image.new('images/block.png')
  assert(blockImage)

  for row = 1, 7 do
    for col = 1, 10 do
      local blockSprite = gfx.sprite.new(blockImage)
      blockSprite:moveTo((col - 1) * 40 + 20, (row - 1) * 20 + 10)
      blockSprite:add()

      table.insert(blocks, blockSprite)
    end
  end

  local paddleImage = gfx.image.new('images/paddle.png')
  assert(paddleImage)

  paddleSprite = gfx.sprite.new(paddleImage)
  paddleSprite:moveTo(200, 220)
  paddleSprite:add()
end

setup()

function playdate.update()
  local screenWidth = playdate.display.getWidth()
  local halfPaddleW = paddleWidth / 2

  if playdate.buttonIsPressed(playdate.kButtonLeft) then
    paddleSprite:moveBy(-paddleVelocity, 0)
    if paddleSprite.x - halfPaddleW <= 0 then
      paddleSprite:moveTo(halfPaddleW, paddleSprite.y)
    end
  end
  if playdate.buttonIsPressed(playdate.kButtonRight) then
    paddleSprite:moveBy(paddleVelocity, 0)
    if paddleSprite.x + halfPaddleW > screenWidth then
      paddleSprite:moveTo(screenWidth - halfPaddleW, paddleSprite.y)
    end
  end

  gfx.sprite.update()
  playdate.timer.updateTimers()
end