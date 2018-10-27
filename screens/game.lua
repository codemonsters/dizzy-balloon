local game = { name = "Juego" }
local player = require("gameobjects/player")
local enemy = require("gameobjects/enemy")

function game.load()
    enemy.load()
end

function game.update(dt)
    player.update(dt)
    enemy.update(dt)
end

function game.draw()
    -- El fondo del mundo
    local desplazamiento_x = (SCREEN_WIDTH - WORLD_WIDTH) / 2
    local desplazamiento_y = (SCREEN_HEIGHT - WORLD_HEIGHT) / 2
    love.graphics.setColor(20, 00, 200)
    -- FIXME: Este rectángulo no coincide con el mundo!
    love.graphics.rectangle("fill", 
        desplazamiento_x,
        desplazamiento_y,
        desplazamiento_x + WORLD_WIDTH,
        desplazamiento_y + WORLD_HEIGHT)
    -- objetos del juego
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
