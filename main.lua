local push = require "libraries/push/push" -- https://github.com/Ulydev/push
log = require "libraries/log/log" -- https://github.com/rxi/log.lua

mobile = false

if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
    mobile = true
end

SCREEN_WIDTH, SCREEN_HEIGHT = 1280, 720
WORLD_WIDTH, WORLD_HEIGHT = 700, 700

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

    -- scale the window of the game (without changing game width and heigth)
    window_width, window_height = love.window.getDesktopDimensions()
    if love.window.getFullscreen() == true then
        -- scale the window to match the screen resolution
        log.debug("Escalando en pantalla completa")
    else
        -- make the window a bit smaller than the display
        log.debug("Escalando dentro de una ventana")
        window_width, window_height = window_width * .7, window_height * .7
    end
    push:setupScreen(
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
        window_width,
        window_height,
        {fullscreen = love.window.getFullscreen()}
    )

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
    push:start()
    screen.draw()
    push:finish()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        log.info("Finalizado")
        love.event.quit()
    else
        screen.keypressed(key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    screen.keyreleased(key, scancode, isrepeat)
end
