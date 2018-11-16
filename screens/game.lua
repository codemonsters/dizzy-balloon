local game = {name = "Juego"}
local player = require("gameobjects/player")
local enemy = require("gameobjects/enemy")
local seed = require("gameobjects/seed")
local worldCanvas = nil
local bordes = 4

function pillarEscala()

    if (window_height >= window_width) then
        return (window_width - bordes*2) / WORLD_WIDTH
    else
        return (window_height - bordes*2) / WORLD_HEIGHT
    end

end

local scaleCanvas = pillarEscala()

function game.load()
    worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)
    
    enemy.load()
    player.load()
    sky = {}
    for i = 1, 28 do
        local semilla = seed.create(i * 10, 0)
        table.insert(sky, semilla)
    end
end

function game.update(dt)
    player.update(dt)
    enemy.update(dt)
    for i, semilla in ipairs(sky) do
        semilla.update()
    end
end

function game.draw()
    love.graphics.setCanvas(worldCanvas) -- a partir de ahora dibujamos en el canvas
    do
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
        love.graphics.setColor(255, 255, 255)
        love.graphics.points(0, 0, WORLD_WIDTH - 1, WORLD_HEIGHT - 1)
    end
    love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(worldCanvas, (window_width / 2) - (WORLD_WIDTH * scaleCanvas / 2), (window_height / 2) - (WORLD_HEIGHT * scaleCanvas / 2),0, scaleCanvas, scaleCanvas)
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
