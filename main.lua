WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

CW = 1280
CH = 720


winTimer = 60
time = 0

function love.load()

    love.graphics.setDefaultFilter('nearest','nearest')

    love.window.setTitle('Space Race')

    math.randomseed(os.time())

    class = require("libs.class")
  
    player = {}
  
    player.left = class:extend({filename = "left"})
    player.left:load()
    player.left.x = CW/3
    player.left.y = CH - player.left.height*1.2
    player.left.speed = 200
    player.left.score = 0
    player.left.upButton = "w"
    player.left.downButton = "s"
  
    player.right = class:extend({filename = "right"})
    player.right:load()
    player.right.x = CW/1.5
    player.right.y = CH - player.right.height*1.2
    player.right.speed = 200
    player.right.score = 0
    player.right.upButton = "up"
    player.right.downButton = "down"
  
    debris = {}
    for i = 1, 50 do
      table.insert(debris, {
        speed = math.random(250),
        width = math.random(10),
        height =  math.random(10),
        y = math.random(tonumber(CH)-100),
        toRight = false,
        toLeft = false,
        update = function(self, dt)
          if (self.toRight) then
            self.x = self.x + self.speed * dt
          elseif (self.toLeft) then
            self.x = self.x - self.speed * dt
          end
  
          if (self.x >= CW) then
            self.toRight = false
            self.toLeft = true
          elseif (self.x + self.width <= 0) then
            self.toLeft = false
            self.toRight = true
          end
        end
      })
      
      if (math.random(1) == 0) then
        debris[#debris].x = 0 - debris[#debris].width
        debris[#debris].toRight = true
      else
        debris[#debris].x = CW + debris[#debris].width
        debris[#debris].toLeft = true
      end
    end
  end
  
  
  function love.update(dt)
    player.left:update(dt)
    player.left:collision(debris)
  
    player.right:update(dt)
    player.right:collision(debris)

    if player.left.score == 10 then 
      love.graphics.printf('Player 1 wins!', 0, 10, CW, 'center')
      gameState = 'done'
    else
      love.graphics.printf('Player 2 wins!', 0, 10, CW, 'center')
      gameState = 'done'

      winTimer = winTimer - dt
      if winTimer <= time then 
        love.graphics.print('Timer: ' .. tostring(love.timer.getTime()), 10 ,10)
        winTimer = 0
      end
  
    for i, _ in ipairs(debris) do
      debris[i]:update(dt)
    end
  end
  
  
  function love.draw()
    player.left:draw()
    player.right:draw()

    displayFPS()

    love.graphics.print(player.left.score, 50, CH-50, 0, 2, 2)
    love.graphics.print(player.right.score, CW-50, CH-50, 0, 2, 2)
    
  
    for i, _ in ipairs(debris) do
      love.graphics.circle("fill", debris[i].x, debris[i].y, debris[i].width, debris[i].height)
    end
  end
  
  function love.keypressed(key)
    if (key == "escape") then
      love.event.quit()
    end
  end

  function displayFPS()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
  end

end