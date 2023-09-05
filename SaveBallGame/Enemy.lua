local love = require "love"

function enemy(level)

    local side = math.random(1, 4)
    local _radius = math.random(15, 25)
    local _level = level
    local _x = 0
    local _y = 0

    -- which side the enemy will appear from ..
    if side == 1 then
        _x = math.random(0, love.graphics.getWidth())
        _y = -_radius * 2
    elseif side == 2 then
        _x = math.random(0, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_radius * 2)
    elseif side == 3 then
        _x = -_radius * 2
        _y = math.random(0, love.graphics.getHeight())
    else
        _x = love.graphics.getWidth() + (_radius * 2)
        _y = math.random(0, love.graphics.getHeight())
    end


    return {

        level = _level,
        radius = _radius,
        x = _x,
        y = _y,

        move = function(self, player_x, player_y)

            if player_x - self.x > 0 then
                self.x = self.x + self.level
            end

            if player_x - self.x < 0 then
                self.x = self.x - self.level
            end

            if player_y - self.y > 0 then
                self.y = self.y + self.level
            end

            if player_y - self.y < 0 then
                self.y = self.y - self.level
            end

        end,

        draw = function(self)

            love.graphics.setColor(0.2,0.7,0.6)
            love.graphics.circle("fill", self.x, self.y, self.radius)

        end

    }

end

return enemy