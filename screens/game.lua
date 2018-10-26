local game = { name = "Juego" }
local player = require("gameObjects/player")

local enemy = require("gameObjects/enemy")

function game.load()
    enemy.load()
end

function game.update(dt)
    player.update(dt)
    enemy.update(dt)
end

function game.draw()
    love.graphics.print("Hello World", 400, 300)
    player.draw()
    enemy.draw()
end

function game.keypressed(key, scancode, isrepeat)
    if key == "q" then
        change_state(require("screens/menu"))
    elseif key == "w" then
        player.up = true
    elseif key == "a" then
        player.left = true
    elseif key == "s" then
        player.down = true
    elseif key == "d" then
        player.right = true
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "q" then
        change_state(require("screens/menu"))
    elseif key == "w" then
        player.up = false
    elseif key == "a" then
        player.left = false
    elseif key == "s" then
        player.down = false
    elseif key == "d" then
        player.right = false
    end
end

return game
