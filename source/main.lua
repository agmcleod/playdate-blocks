import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local ballSprite = nil
local paddleSprite = nil

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
  gfx.sprite.update()
  playdate.timer.updateTimers()
end