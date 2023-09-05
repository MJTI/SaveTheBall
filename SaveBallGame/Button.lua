local love = require "love"


local font = love.graphics.newFont(22)

love.graphics.setFont(font)

function button(text, _func, _func_var, button_y)
    local _text_width = font:getWidth(text)
    local _text_height = font:getHeight()
    local _width = 160
    local _height = 60
    local _x = ((love.graphics.getWidth()/2) - (_width/2))
    local _y = ((love.graphics.getHeight()/2) - (_height/2)) - button_y

    return {
        width = _width,
        height = _height,
        x = _x,
        y = _y,
        text = text or "Button",
        text_width = font:getWidth(text),
        text_height = font:getHeight(),
        text_x = (_x + (_width/2)) - (_text_width/2),
        text_y = (_y + (_height/2)) - (_text_height/2),
        func = _func or function() love.graphics.print("nothing in here", 10, 10) end,
        func_var = _func_var,
        opacity = 1,


        draw = function(self)
            
            love.graphics.setColor(1,1,1,self.opacity)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

            love.graphics.setColor(0,0,0)
            love.graphics.print(self.text, self.text_x, self.text_y)

        end,


        checkMouseOn = function(self, mouse_x, mouse_y)
            local isX = ((mouse_x >= self.x) and (mouse_x <= (self.x + self.width)))
            local isY = ((mouse_y >= self.y) and (mouse_y <= (self.y + self.height)))
            if not (isX and isY) then
                self.opacity = 1
            elseif isX and isY then
                self.opacity = 0.5
            end

        end,

        checkPressed = function(self, mouse_x, mouse_y)
            local isX = ((mouse_x >= self.x) and (mouse_x <= (self.x + self.width)))
            local isY = ((mouse_y >= self.y) and (mouse_y <= (self.y + self.height)))
            if isX and isY then
                self.func(self.func_var)
            end
        end
    }



end

return button