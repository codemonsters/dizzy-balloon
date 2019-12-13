log = require "libraries/log/log" -- https://github.com/rxi/log.lua
suit = require "libraries/suit"

mobile = false

if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
    mobile = true
end

SCREEN_WIDTH, SCREEN_HEIGHT = 1280, 720 -- El juego se crea por completo dentro de una pantalla de este tamaño (y posteriormente se escala según sea necesario)
WORLD_WIDTH, WORLD_HEIGHT = 720, 720 -- La zona de juego es parte de la pantalla y también tiene tamaño fijo

local screen = nil

function change_screen(new_screen)
    screen = new_screen
    log.info("cargando pantalla: " .. screen.name)
    screen.load()
end

function love.load()
    log.level = "trace" -- trace / debug / info / warn / error / fatal
    log.info("Iniciado programa")

    love.graphics.setDefaultFilter("nearest", "linear") -- Cambiamos el filtro usado durante el escalado

    font_menu = love.graphics.newFont("assets/fonts/orangejuice20.ttf", 50) -- Orange Juice 2.0 by Brittney Murphy Design https://brittneymurphydesign.com

    font_hud = love.graphics.newFont("assets/fonts/orangejuice20.ttf", 40) -- https://www.dafont.com/es/pixelmania.font
    love.graphics.setFont(font_menu)

    local window_width, window_height = love.window.getDesktopDimensions()
    if love.window.getFullscreen() then
        -- scale the window to match the screen resolution
        log.debug("Corriendo en pantalla completa (resolución: " .. window_width .. " x " .. window_height .. " px)")
    else
        -- definimos el tamaño inicial de la ventana
        window_width, window_height = window_width * .8, window_height * .8
        log.debug("Corriendo en una ventana de: " .. window_width .. " x " .. window_height .. " px")
        love.window.setMode(
            window_width,
            window_height,
            {
                vsync = true,
                resizable = true,
                centered = true
            }
        )
    end
    actualizaVariablesEscalado(window_width, window_height)

    math.randomseed(os.time()) -- NOTE: Quizá redundante, parece que Love ya inicializa la semilla random automáticamente

    -- atlas: la textura que contiene todas las imágenes
    atlas = love.graphics.newImage("assets/atlas/arcade_platformerV2.png") -- Créditos: Grafixkid (https://opengameart.org/content/arcade-platformer-assets)

    change_screen(require("screens/menu"))
    log.info("Juego cargado")
end

function love.update(dt)
    screen.update(dt)
end

function love.draw()
    screen.draw()
end

function love.resize(w, h)
    actualizaVariablesEscalado(w, h)
end


function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        log.info("Finalizado")
        love.event.quit()
    elseif key == "f" then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false)
        else
            love.window.setFullscreen(true)
        end
    else
        screen.keypressed(key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    screen.keyreleased(key, scancode, isrepeat)
end

function actualizaVariablesEscalado(window_width, window_height)
    -- calcula el valor de las variables: factorEscala, desplazamientoX, desplazamientoY (utilizadas para escalar y desplazar el viewport del juego dentro de la ventana principal)

    factorEscalaAncho = window_width / SCREEN_WIDTH
    factorEscalaAlto = window_height / SCREEN_HEIGHT
    if factorEscalaAncho < factorEscalaAlto then
        factorEscala = factorEscalaAncho
    else
        factorEscala = factorEscalaAlto
    end

    desplazamientoX = (window_width - factorEscala * SCREEN_WIDTH) / 2
    desplazamientoY = (window_height - factorEscala * SCREEN_HEIGHT) / 2
end
