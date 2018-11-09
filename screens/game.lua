local game = {name = "Juego"}
local player = require("gameobjects/player")
local enemy = require("gameobjects/enemy")
local seed = require("gameobjects/seed")
local worldCanvas = nil

function game.load()
    worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)
    enemy.load()
    player.load()
    sky = {}
    for i = 1, 28 do
        table.insert(sky, seed)
    end
    for i, semilla in ipairs(sky) do
        semilla.x = i * 10
    end
end

function game.update(dt)
    player.update(dt)
    enemy.update(dt)
    seed.update(dt)
end

function game.draw()
    love.graphics.setCanvas(worldCanvas) -- a partir de ahora dibujamos en el canvas
        love.graphics.clear()
        love.graphics.setBlendMode("alpha")
    -- El fondo del mundo
    love.graphics.setColor(20, 00, 200)
    love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)
    -- objetos del juego
    player.draw()
    enemy.draw()
    for i, semilla in ipairs(sky) do
        semilla.draw()
    end
    -- puntos de las dos esquinas del mundo
    love.graphics.setColor(0, 0, 255)
    love.graphics.points(0, 0, WORLD_WIDTH - 1, WORLD_HEIGHT - 1)
    love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(worldCanvas, (SCREEN_WIDTH - WORLD_WIDTH) / 2, (SCREEN_HEIGHT - WORLD_HEIGHT) / 2)
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
