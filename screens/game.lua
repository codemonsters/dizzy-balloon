local game = {name = "Juego"}
local PlayerClass = require("gameobjects/player")
local jugador = PlayerClass.new()
local EnemyClass = require("gameobjects/enemy")
local SkyClass = require("gameobjects/sky")
local sky = SkyClass.new()
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
    jugador:load()
    worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)
    
    enemigos = {}
    for i = 1, 10 do
        local enemy = EnemyClass.new()
        enemy:load(i + (10*i), 0, enemigos)
        table.insert(enemigos, enemy)
    end
    
    sky:load()
    
end

function game.update(dt)
    jugador:update(dt)

    for i, enemigo in ipairs(enemigos) do
        enemigo:update()
    end
    sky:update()
end

function game.draw()
    love.graphics.setCanvas(worldCanvas) -- a partir de ahora dibujamos en el canvas
    do
        love.graphics.setBlendMode("alpha")
        -- El fondo del mundo
        love.graphics.setColor(20, 00, 200)
        love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)
        -- objetos del juego
        jugador:draw()

        for i, enemigo in ipairs(enemigos) do
            enemigo:draw()
        end

        sky:draw()

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
        jugador.up = true
    elseif key == "a" or key == "left" then
        jugador.left = true
    elseif key == "s" or key == "down" then
        jugador.down = true
    elseif key == "d" or key == "right" then
        jugador.right = true
    elseif key == "space" then
        jugador:jump()
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "q" then
        change_screen(require("screens/menu"))
    elseif key == "w" or key == "up" then
        jugador.up = false
    elseif key == "a" or key == "left" then
        jugador.left = false
    elseif key == "s" or key == "down" then
        jugador.down = false
    elseif key == "d" or key == "right" then
        jugador.right = false
    end
end

return game
