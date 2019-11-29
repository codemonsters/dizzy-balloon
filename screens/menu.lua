local PlayerClass = require("gameobjects/player")
local bump = require "libraries/bump/bump"
local BlockClass = require("gameobjects/block")
local animLoader = require("animationLoader")

local menu = {name = "Menú principal"}
local negro = {1, 1, 1, 1}

function menu.load()
    world = bump.newWorld(50)
    jugador = PlayerClass.new(world, nil)
    local borderWidth = 50
    BlockClass.new("Suelo", 0, WORLD_HEIGHT, SCREEN_WIDTH, borderWidth, world)

    -- asociar el animador al jugador y cargar una animación en el
    animLoader:applyAnim(jugador, animacionTestJugador)
end

function menu.update(dt)
    jugador:update(dt)
    animLoader:update(dt)

    widgetsUpdate()
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
    jugador:draw()

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


function widgetsUpdate()
    suit.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.2)
    suit.layout:padding(0, SCREEN_HEIGHT * 0.04)
    local mouseX, mouseY = love.mouse.getPosition()
    suit.updateMouse((mouseX) * factorEscala, (mouseY) * factorEscala)

    if suit.Button("Jugar", suit.layout:row(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.12)).hit then
        game_screen = require("screens/game")
        change_screen(game_screen)
    end
    if suit.Button("Preferencias", suit.layout:row(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.12)).hit then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if suit.Button("Instrucciones", suit.layout:row(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.12)).hit then
        os.exit()
    end
    if suit.Button("Salir", suit.layout:row(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.12)).hit then
        os.exit()
    end


    local input = {text = ""} -- text input data




    --[[ if suit.Button("Jugar", 0, 0).hit then
        show_message = true
        print("BOTÓN JUGAR PULSADO")
    end
    if suit.Button("Instrucciones", 0, 200).hit then
        show_message = true
        print("BOTÓN INSTRUCCIONES PULSADO")
    end    
    if suit.Button("Preferencias", 0, 300).hit then
        show_message = true
        print("BOTÓN PREFERENCIAS PULSADO")
    end ]]
end

function widgetsDraw()
    suit.draw()
end

return menu
