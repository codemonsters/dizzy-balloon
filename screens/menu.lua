--local PlayerClass = require("gameobjects/player")
--local EnemyClass = require("gameobjects/enemy")
--local bump = require "libraries/bump/bump"
--local BlockClass = require("gameobjects/block")
-- local animLoader = require("animationLoader")

local menu = {name = "Menú principal"}
local negro = {1, 1, 1, 1}

function menu.load()
    -- world = bump.newWorld(50)
    -- jugador = PlayerClass.new(world, nil)
    -- enemigo1 = EnemyClass.new(enemigo, WORLD_HEIGHT, WORLD_HEIGHT/2, world, nil, 0)
    -- local borderWidth = 50
    -- BlockClass.new("Suelo", 0, WORLD_HEIGHT, SCREEN_WIDTH, borderWidth, world)


    -- animLoader:applyAnim(enemigo1, animacionTestEnemigo)
    -- asociar el animador al jugador y cargar una animación en el
    -- animLoader:applyAnim(jugador, animacionTestJugador)
    
end

function menu.update(dt)
    -- jugador:update(dt)
    -- enemigo1:update(dt)
    -- animLoader:update(dt)
end

function menu.draw()

    love.graphics.clear(255, 255, 255)
    love.graphics.push()
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf(
        "DIZZY BALLOON\n\n=PRESS FIRE TO START=",
        font_menu,
        0,
        math.floor((SCREEN_HEIGHT - font_menu:getHeight() * 2) / 2),
        SCREEN_WIDTH,
        "center"
    )
    -- jugador:draw()
    -- enemigo1:draw()

    -- DEBUG: marcas en los extremos diagonales de la pantalla
    love.graphics.setColor(255, 0, 0)
    love.graphics.line(0, 0, 10, 0)
    love.graphics.line(0, 0, 0, 10)
    love.graphics.line(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1, SCREEN_WIDTH - 11, SCREEN_HEIGHT - 1)
    love.graphics.line(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 11)

    love.graphics.pop()
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        game_screen = require("screens/game")
        change_screen(game_screen)
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

function love.mousepressed(id, x, y, dx, dy, pressure)
    game_screen = require("screens/game")
    change_screen(game_screen)
end

return menu
