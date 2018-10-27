local game = {name = "Juego"}
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
    local shift_x = (SCREEN_WIDTH - WORLD_WIDTH) / 2 -- TODO: este cálculo es común a todo lo que queramos dibujar en el mundo. Deberíamos hacer estas dos constantes globales (o mejor todavía: hacer una metatabla común para todos los gameobjects que incluya dos funciones que devuelvan la x y la y de cada gameobject pero ya desplazados)
    local shift_y = (SCREEN_HEIGHT - WORLD_HEIGHT) / 2
    love.graphics.setColor(20, 00, 200)
    love.graphics.rectangle("fill", shift_x, shift_y, WORLD_WIDTH, WORLD_HEIGHT)
    -- objetos del juego
    player.draw()
    enemy.draw()
end

function game.keypressed(key, scancode, isrepeat)
    if key == "q" then
        change_state(require("screens/menu"))
    elseif key == "w" or key == "up" then
        player.up = true
    elseif key == "a" or key == "left" then
        player.left = true
    elseif key == "s" or key == "down" then
        player.down = true
    elseif key == "d" or key == "right" then
        player.right = true
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "q" then
        change_state(require("screens/menu"))
    elseif key == "w" or key == "up" then
        player.up = false
    elseif key == "a" or key == "left" then
        player.left = false
    elseif key == "s" or key == "down" then
        player.down = false
    elseif key == "d" or key == "right" then
        player.right = false
    end
end

return game
