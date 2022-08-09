import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "score"
import "modal"

local gfx <const> = playdate.graphics

local ballSprite = nil
local paddleSprite = nil

local paddleVelocity <const> = 8

local blocks = {}
local ballAttachedToPaddle = true
local velocityDir = playdate.geometry.vector2D.new(0, 0)
local velocity <const> = 5
local defeatedBlocks = 0
local totalBlocks = 0
local lives = 5
local gameEnded = false
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()
local activeModal = nil
local blockImage = nil

function setup()
  gfx.setBackgroundColor(gfx.kColorWhite)

  local font = gfx.font.new('fonts/Bitmore/font-Bitmore-Medieval-Bold')
  assert(font)
  gfx.setFont(font)

  blockImage = gfx.image.new('images/block.png')
  assert(blockImage)

  assert(scoreSprite)
  scoreSprite:moveTo(10, 220)
  scoreSprite:add()

  local paddleImage = gfx.image.new('images/paddle.png')
  assert(paddleImage)

  paddleSprite = gfx.sprite.new(paddleImage)
  paddleSprite:moveTo(200, 220)
  paddleSprite:setCollideRect(0, 0, paddleSprite:getSize())
  paddleSprite:add()

  local ballImage = gfx.image.new('images/ball.png')
  assert(ballImage)

  ballSprite = gfx.sprite.new(ballImage)
  ballSprite:moveTo(200, 190)
  ballSprite:setCollideRect(0, 0, ballSprite:getSize())
  ballSprite:add()

  resetGame()
end

function resetGame()
  lives = 5
  defeatedBlocks = 0
  ballAttachedToPaddle = true
  totalBlocks = 0
  gameEnded = false

  scoreSprite:setScore(lives)

  blocks = {}

  for _, block in pairs(blocks) do
    block:remove()
  end

  for row = 1, 7 do
    for col = 1, 10 do
      local blockSprite = gfx.sprite.new(blockImage)
      blockSprite:moveTo((col - 1) * 40 + 20, (row - 1) * 20 + 10)
      blockSprite:setCollideRect(0, 0, blockSprite:getSize())
      blockSprite:add()
      totalBlocks += 1

      table.insert(blocks, blockSprite)
    end
  end
end

setup()

function scanBlocksToDelete()
  local overlappingSprites = ballSprite:overlappingSprites()
  local collided = false
  for _, block in pairs(overlappingSprites) do
    if block ~= paddleSprite then
      block:remove()
      defeatedBlocks += 1

      if defeatedBlocks >= totalBlocks then
        gameEnded = true
        activeModal = Modal('You Won! Press any\nbutton to restart')
        activeModal:add()
      end
    else
      ballSprite:moveBy(0, -ballSprite.height / 2)
      if ballSprite.x <= paddleSprite.x then
        velocityDir.x = -1
      else
        velocityDir.x = 1
      end
    end

    collided = true
  end

  if collided then
    velocityDir.y *= -1
  end
end

function handleBallHeld()
  ballSprite:moveTo(paddleSprite.x, paddleSprite.y - 12)
  if playdate.buttonIsPressed(playdate.kButtonA) or playdate.buttonIsPressed(playdate.kButtonB) then
    ballAttachedToPaddle = false
    local xDir = - 1
    if math.random(0, 1) == 1 then
      xDir = 1
    end
    velocityDir.x = xDir
    velocityDir.y = -1
  end
end

function handleBallMovement()
  local halfBallWidth = ballSprite.width / 2
  ballSprite:moveBy(velocityDir.x * velocity, velocityDir.y * velocity)

  -- right edge
  if ballSprite.x + halfBallWidth > screenWidth then
    ballSprite:moveTo(screenWidth - halfBallWidth, ballSprite.y)
    velocityDir.x *= -1
  end

  -- left edge
  if ballSprite.x - halfBallWidth <= 0 then
    ballSprite:moveTo(halfBallWidth, ballSprite.y)
    velocityDir.x *= -1
  end

  -- top
  if ballSprite.y - halfBallWidth <= 0 then
    ballSprite:moveTo(ballSprite.x, halfBallWidth)
    velocityDir.y *= -1
  end

  -- ball fell below screen
  if ballSprite.y + ballSprite.height / 2 >= screenHeight then
    ballAttachedToPaddle = true
    lives -= 1
    scoreSprite:setScore(lives)
    if lives == 0 then
      gameEnded = true
      activeModal = Modal('Game Over! Press any\nbutton to restart')
      activeModal:add()
    end
  end
end

function playdate.update()
  local halfPaddleW = paddleSprite.width / 2

  if gameEnded then
    if playdate.buttonIsPressed(playdate.kButtonA) or playdate.buttonIsPressed(playdate.kButtonB) then
      activeModal:remove()
      activeModal = nil
      resetGame()
    end
  else
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

    if ballAttachedToPaddle then
      handleBallHeld()
    else
      handleBallMovement()

      scanBlocksToDelete()
    end
  end

  gfx.sprite.update()

  playdate.timer.updateTimers()
end