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

    if love.mouse.isDown(1) then
        love.touchpressed(mousepointer, love.mouse.getX(), love.mouse.getY(), 0, 0, 1)
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


function love.touchpressed(id, x, y, dx, dy, pressure)
    if x < SCREEN_WIDTH / 2 then       -- dedo izquierdo
        leftFinger:touchpressed(x, y)
    else                               -- dedo derecho
        log.debug()
        rightFinger:touchpressed(x, y)
        --rightFinger.touchpressed(self, x, y)
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if x < SCREEN_WIDTH / 2 then       -- dedo izquierdo
        leftFinger:touchreleased(dx, dy)
    else                               -- dedo derecho
        rightFinger:touchreleased(dx, dy)
    end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    if x < SCREEN_WIDTH / 2 then       -- dedo izquierdo
        leftFinger:touchmoved(dx, dy)
    else
        rightFinger:touchmoved(dx, dy)
    end
end

function game.pointerpressed(pointer)
    if self.x > SCREEN_WIDTH / 2 and self.y < SCREEN_HEIGHT / 2 then
    jugador:jump()                          -- esquina derecha inferior -> ¿saltar?
    else                                    -- esquina derecha superior -> ¿disparar?
    -- TODO: implementar disparo cuando esté listo
    end
end

function game.pointerreleased(pointer)
    if self.x < SCREEN_WIDHT / 2 then       -- lado izquierdo de la pantalla -> movimiento
        if self.x < self.dx then -- ha dejado de moverse hacia la derecha
            jugador.right = false
        else                     -- ha dejado de moverse hacia la izquierda
            jugador.left = false
        end
    end
    -- no es necesario implementar pointerreleased para saltar y disparar porque ocurren en el momento
    -- en el que la pantalla se toca en esa zona
end

function game.pointermoved(pointer)
    if self.x < SCREEN_WIDHT / 2 then       -- lado izquierdo de la pantalla -> movimiento
        if self.x < self.dx then -- se ha movido hacia la derecha
            jugador.right = true
        else                     -- se ha movido hacia la izquierda
            jugador.left = true
        end
    end
end

return game
