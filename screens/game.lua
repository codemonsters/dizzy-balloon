local bump = require 'libraries/bump/bump'
local game = {name = "Juego"}
local PlayerClass = require("gameobjects/player")
local jugador = PlayerClass.new()
local EnemyClass = require("gameobjects/enemy")
local SkyClass = require("gameobjects/sky")
local sky = SkyClass.new()
local PointerClass = require("gameobjects/pointer")
local leftFinger = PointerClass.new(game, "Izquierdo")
local rightFinger = PointerClass.new(game, "Derecho")
local mousepointer = PointerClass.new(game, "Puntero")
local worldCanvas = nil
local bordes = 4
local jugadorpuedesaltar = true
local jugadorquieremoverse = false
local jugadorquieredisparar = false

function pillarEscala()

    if (window_height >= window_width) then
        return (window_width - bordes*2) / WORLD_WIDTH
    else
        return (window_height - bordes*2) / WORLD_HEIGHT
    end

end

local scaleCanvas = pillarEscala()

function game.load()
    local world = bump.newWorld(50)

    jugador:load(world)

    worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)
    
    enemigos = {}
    for i = 1, 10 do
        local enemy = EnemyClass.new()
        enemy:load(i + (10*i), 0, world)
        table.insert(enemigos, enemy)
    end
    
    sky:load(world)
    
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

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        jugadorquieremoverse = true
        jugadorquieredisparar = true
        mousepointer.touchpressed(mousepointer, x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        jugadorquieremoverse = false
        jugadorquieredisparar = false
        mousepointer.touchreleased(mousepointer, dx, dy)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    mousepointer.touchmoved(mousepointer, dx, dy)
end

function game.pointerpressed(pointer)
    if pointer.x > SCREEN_WIDTH / 2 then
        jugador:jump()
    end
end

function game.pointerreleased(pointer)
    if pointer.x < SCREEN_WIDTH / 2 then
        jugador.left, jugador.right = false, false
    else
        jugadorpuedesaltar = true
    end
end

function game.pointermoved(pointer)
    if pointer.x < SCREEN_WIDTH / 2 then
        if jugadorquieremoverse == true then
            if pointer.x < pointer.x + pointer.dx then
                log.debug("...")
                jugador.left = false
                jugador.right = true
            elseif pointer.x > pointer.x + pointer.dx then
                log.debug(",,,")
                jugador.right = false
                jugador.left = true
            end
        end
        if jugadorquieredisparar == true then
            if pointer.y < pointer.y + pointer.dy then
                log.debug("Disparo hacia abajo")
            elseif pointer.y > pointer.y + pointer.dy then
                log.debug("Disparo hacia arriba")
            end
        end
    end
end

--[[
function love.touchpressed(id, x, y, dx, dy, pressure)
    if x < SCREEN_WIDTH / 2 then       -- dedo izquierdo
        ratonx, ratony = love.mouse.getPosition()
        leftFinger:touchpressed(ratonx, ratony)
    else                               -- dedo derecho
        rightFinger:touchpressed(x, y)
        --rightFinger.touchpressed(self, x, y)
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if x < SCREEN_WIDTH / 2 then       -- dedo izquierdo
        ratondx, ratondy = love.mouse.getPosition()
        leftFinger:touchreleased(ratondx, ratondy)
    else                               -- dedo derecho
        rightFinger:touchreleased(dx, dy)
    end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    if x < SCREEN_WIDTH / 2 then       -- dedo izquierdo
        ratondx, ratondy = love.mouse.getPosition()
        leftFinger:touchmoved(ratondx, ratondy)
    else
        rightFinger:touchmoved(dx, dy)
    end
end
]]

return game
