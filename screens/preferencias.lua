local PlayerClass = require("gameobjects/player")
local EnemyClass = require("gameobjects/enemy")
local bump = require "libraries/bump/bump"
local BlockClass = require("gameobjects/block")
local animLoader = require("animationLoader")
local music = love.audio.newSource("assets/music/PP_Fight_or_Flight_FULL_Loop.wav", "stream")

local pantallaPreferencias = {
    name = "Preferencias"
}

local negro = {1, 1, 1, 1}

function pantallaPreferencias.load()
    suit.theme.cornerRadius = 29
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

    music:setLooping(true)
    music:play()
end

function pantallaPreferencias.update(dt)
    jugador:update(dt)
    enemigo1:update(dt)
    animLoader:update(dt)

    widgetsUpdate()
end

function pantallaPreferencias.draw()
    love.graphics.clear(1, 0, 1)

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

function pantallaPreferencias.keypressed(key, scancode, isrepeat)
    if key == "space" then
        change_screen(require("screens/menu"))
    end
end

function pantallaPreferencias.keyreleased(key, scancode, isrepeat)
end

--[[ function love.mousepressed(id, x, y, dx, dy, pressure)
    game_screen = require("screens/game")
    change_screen(game_screen)
end ]]
--ESta función hace cosas :)
function widgetsUpdate()
    love.graphics.setBlendMode("alpha")

    suit.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.1)
    suit.layout:padding(0, SCREEN_WIDTH * 0.02)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setFont(font_menu)

    suit.updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    suit.Label(
        "Dizzy Balloon",
        {color = {normal = {fg = {0, 0, 0}}}},
        suit.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.20)
    )

    love.graphics.setFont(font_buttons)

    if
        suit.Button(
            "Sonido",
            {
                color = {
                    normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}},
                    hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
                    active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
                }
            },
            suit.layout:row(SCREEN_WIDTH * .3, SCREEN_HEIGHT * 0.12)
        ).hit
     then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if
        suit.Button(
            "Musica",
            {
                color = {
                    normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}},
                    hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
                    active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
                }
            },
            suit.layout:row(SCREEN_WIDTH * .3, SCREEN_HEIGHT * 0.12)
        ).hit
     then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if
        suit.Button(
            "Idioma",
            {
                color = {
                    normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}},
                    hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
                    active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
                }
            },
            suit.layout:row(SCREEN_WIDTH * .3, SCREEN_HEIGHT * 0.12)
        ).hit
     then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if
        suit.Button(
            "Volver",
            {
                color = {
                    normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}},
                    hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
                    active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
                }
            },
            suit.layout:row(SCREEN_WIDTH * .3, SCREEN_HEIGHT * 0.12)
        ).hit
     then
        change_screen(require("screens/menu"))
    end
end

function widgetsDraw()
    suit.draw()
end

return pantallaPreferencias
