local PlayerClass = require("gameobjects/player")
local EnemyClass = require("gameobjects/enemy")
local bump = require "libraries/bump/bump"
local BlockClass = require("gameobjects/block")
local animLoader = require("animationLoader")

local menu = {name = "Menú principal"}
local negro = {1, 1, 1, 1}

function menu.load()
    world = bump.newWorld(50)
    jugador = PlayerClass.new(world, nil)
    enemigo1 = EnemyClass.new(enemigo, SCREEN_WIDTH * 0.05, PlayerClass.height * 3, world, nil, 0)
    local borderWidth = 50
    BlockClass.new("Suelo", 0, WORLD_HEIGHT, SCREEN_WIDTH, borderWidth, world)
    BlockClass.new("ParedIzquierda", 0, 0, 1, SCREEN_HEIGHT, world)
    BlockClass.new("ParedDerecha", SCREEN_WIDTH, 0, 1, SCREEN_HEIGHT, world)
    BlockClass.new("Techo", 0, 0, SCREEN_WIDTH, 1, world)


    animLoader:applyAnim(enemigo1, animacionTestEnemigo)
    -- asociar el animador al jugador y cargar una animación en el
    animLoader:applyAnim(jugador, animacionTestJugador)
    
end

function menu.update(dt)
    jugador:update(dt)
    enemigo1:update(dt)
    animLoader:update(dt)

    widgetsUpdate()
end

function menu.draw()

    love.graphics.clear(255, 255, 255)
    love.graphics.push()
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)
    love.graphics.setColor(255, 0, 0, 255)
    
    jugador:draw()
    enemigo1:draw()

    -- DEBUG: marcas en los extremos diagonales de la pantalla
    love.graphics.setColor(255, 0, 0)
    love.graphics.line(0, 0, 10, 0)
    love.graphics.line(0, 0, 0, 10)
    love.graphics.line(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1, SCREEN_WIDTH - 11, SCREEN_HEIGHT - 1)
    love.graphics.line(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 11)

    widgetsDraw()

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

--[[ function love.mousepressed(id, x, y, dx, dy, pressure)
    game_screen = require("screens/game")
    change_screen(game_screen)
end ]]

--ESta función hace cosas :)
function widgetsUpdate()
    suit.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.1)
    suit.layout:padding(0, SCREEN_WIDTH * 0.025)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setFont(font_buttons)

    suit.updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    suit.Label("DIZZY BALLOON", suit.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.20))


    


    if suit.Button("Jugar", {color = {normal = {bg = {0, 0, 0, 0.1}, fg = {0, 0, 0}}, active = {bg = {0, 0, 0, 0.1}, fg = {255, 255, 255}}}},  suit.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        game_screen = require("screens/game")
        change_screen(game_screen)
    end
    if suit.Button("Preferencias", {color = {normal = {bg = {0, 0, 0, 0.1}, fg = {0, 0, 0}}, active = {bg = {0, 0, 0, 0.1}, fg = {255, 255, 255}}}}, suit.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if suit.Button("Instrucciones", {color = {normal = {bg = {0, 0, 0, 0.1}, fg = {0, 0, 0}}, active = {bg = {0, 0, 0, 0.1}, fg = {255, 255, 255}}}}, suit.layout:row(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.12)).hit then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if suit.Button("Salir", {color = {normal = {bg = {0, 0, 0, 0.1}, fg = {0, 0, 0}}, active = {bg = {0, 0, 0, 0.1}, fg = {255, 255, 255}}}}, suit.layout:row(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.12)).hit then
        os.exit()
    end
    


end

function widgetsDraw()
    suit.draw()
end

return menu
