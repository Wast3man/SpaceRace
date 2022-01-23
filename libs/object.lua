local object = {}

object["player"] = {
    filename = "player",
    speed = 200,
    score = 0,
    update = function(self, dt)
        if (love.keyboard.isDown(self.upButton)) then 
            self.y = self.y - self.speed * dt
        elseif (love.keyboard.isDown(self.downButton)) then 
            self.y = self.y + self.speed * dt
        end

        if (self.y + self.height <= 0) then
            self.y = love.graphics.getHeight - self.height
            self.score = self.score + 1
        end
    end
}

return object 