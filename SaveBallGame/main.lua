local love = require "love"
local enemy = require "Enemy"
local button = require "Button"


math.randomseed(os.time())

-- state of the game ..
local game = {
    diffiuculty = 1,
    state = {
        menu = true,
        lost = false,
        running = false,
        new_game = false,
        paused = false
    },
    level = 1,
    points = 0
}


-- player's ball ..
local player = {
    radius = 20,
    x = 30,
    y = 30
}

function changeState(state)
    game.state.menu = state == "menu"
    game.state.running = state == "running"
    game.state.lost = state == "lost"
    game.state.new_game = state == "newGame"
    game.state.paused = state == "paused"
end

local buttonsMenu = {}
local buttonsPaused = {}

local enemies = {}

local font = love.graphics.newFont(22)

love.graphics.setFont(font)

function love.load()

    -- hide mouse & set Title .
    love.mouse.setVisible(false)
    love.window.setTitle("Save The Ball")

    -- table.insert(enemies, enemy(game.level))

    buttonsMenu.play_game = button("Play",changeState, "running", 70)
    buttonsMenu.exit_game = button("Exit",love.event.quit,nil, 0)

    buttonsPaused.new_game = button("New Game",changeState, "running", 70)
    buttonsPaused.exit_game = button("Exit",love.event.quit,nil, 0)

end

local saveMouseX = love.graphics.getWidth()/2
local saveMouseY = love.graphics.getHeight()/2

function love.mousepressed(x, y, button, istouch, presses)
    if not game.state.running then
        if button == 1 then
            if game.state.menu then
                for index in pairs(buttonsMenu) do
                    buttonsMenu[index]:checkPressed(x,y)
                end
                love.mouse.setX(saveMouseX)
                love.mouse.setY(saveMouseY)
            end
            if game.state.paused then
                for index in pairs(buttonsPaused) do
                    buttonsPaused[index]:checkPressed(x,y)
                end
            end
        end
    end

    if game.state.running then
        if button == 2 then
            saveMouseX = love.mouse.getX()
            saveMouseY = love.mouse.getY()
            changeState("menu")
        end
    end
end

local timer = 0
local interval = 1
local fives = 0


function love.update(dt)

    timer = timer + dt

    -- player ball place ..
    player.x, player.y = love.mouse.getPosition()

    if game.state.lost then
        fives = 0
        game.level = 1
        game.points = 0
        saveMouseX = love.graphics.getWidth()/2
        saveMouseY = love.graphics.getHeight()/2
        for k in next, enemies do rawset(enemies, k, nil) end
        math.randomseed(os.time())
        changeState("paused")
    end

    if game.state.running then
        if game.state.running then
            if timer >= interval then 
                game.points = game.points + 1
                timer = 0
            end
        end

        for i = 1, #enemies do
            enemies[i]:move(player.x, player.y)
            if detectCollision(player.x, player.y, enemies[i].x, enemies[i].y) then
                changeState("lost")
            end
        end

    end

    if game.points == fives then
        table.insert(enemies, enemy(game.level))

        for index = 1, #enemies do
            enemies[index].level = enemies[index].level + 1
        end

        fives = fives + 5
    end

    if game.state.menu then
        for index in pairs(buttonsMenu) do
            buttonsMenu[index]:checkMouseOn(love.mouse.getX(), love.mouse.getY())
        end
    elseif game.state.paused then
        for index in pairs(buttonsPaused) do
            buttonsPaused[index]:checkMouseOn(love.mouse.getX(), love.mouse.getY())
        end
    end

end

function detectCollision(playerX, playerY, enemyX, enemyY)
    local condX = (((playerX - enemyX) <= 30) and ((playerX - enemyX) >= 0))
    local condY = (((playerY - enemyY) <= 30) and ((playerY - enemyY) >= 0))
    if (condX and condY) then
        return true
    else
        return false
    end
end


function love.draw()

    -- print time(points) in seconds ..
    love.graphics.setColor(1, 1, 1) -- Set text color to white
    love.graphics.printf(
        game.points,
        font,
        0,10,
        love.graphics.getWidth(),
        "center"
    )

    -- set the FPS ..
    local fps = love.timer.getFPS()
    love.graphics.printf(
        "FPS : " .. fps,
        love.graphics.newFont(12),
        10,10,
        love.graphics.getWidth()
    )


    -- check if state of game is running show ball and hide mouse ..
    if game.state.running then
        -- draw the player ball & hide the mouse ..
        love.mouse.setVisible(false)
        love.graphics.setColor(1,1,1)
        love.graphics.circle("fill", player.x, player.y, player.radius, 100)

        -- draw the enemies ..
        for i = 1, #enemies do
            enemies[i]:draw()
        end

    -- else if game on menu state show the menu options ..
    elseif game.state.menu then
        buttonsMenu.play_game:draw()
        buttonsMenu.exit_game:draw()
    elseif game.state.paused then
        buttonsPaused.new_game:draw()
        buttonsPaused.exit_game:draw()
    end


    -- if game not in running state show the mouse ..
    if not game.state.running then
        love.mouse.setVisible(true)
        love.graphics.print(game.points, (love.graphics.getWidth()/2) - (font:getWidth(game.points)/2), 10)
    end

end