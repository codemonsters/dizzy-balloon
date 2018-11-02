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

-- Traduce una coordenada X del mundo del juego a su correspondiente coordenada X en pantalla
function translate_x(x_world)
    local shift_x = (SCREEN_WIDTH - WORLD_WIDTH) / 2 -- IMPROVEME: Mejorar eficiencia eliminando parte del cálculo (o mejor todavía: hacer una metatabla común para todos los gameobjects que incluya dos funciones que devuelvan la x y la y de cada gameobject pero ya desplazados)
    return x_world + shift_x
end

-- Traduce una coordenada Y del mundo del juego a su correspondiente coordenada Y en pantalla
function translate_y(y_world)
    local shift_y = (SCREEN_HEIGHT - WORLD_HEIGHT) / 2
    return y_world + shift_y
end

function game.draw()
    -- El fondo del mundo
    love.graphics.setColor(20, 00, 200)
    love.graphics.rectangle("fill", translate_x(0), translate_y(0), WORLD_WIDTH, WORLD_HEIGHT)
    -- objetos del juego
    player.draw()
    enemy.draw()
    -- puntos de las dos esquinas del mundo
    love.graphics.setColor(0, 0, 255)
    love.graphics.points(translate_x(0), translate_y(0), translate_x(WORLD_WIDTH - 1), translate_y(WORLD_HEIGHT - 1))
end

function game.keypressed(key, scancode, isrepeat)
    if key == "q" then
        change_screen(require("screens/menu"))
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
        change_screen(require("screens/menu"))
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
