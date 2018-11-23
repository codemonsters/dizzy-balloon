local push = require "libraries/push/push" -- https://github.com/Ulydev/push
log = require "libraries/log/log" -- https://github.com/rxi/log.lua

SCREEN_WIDTH, SCREEN_HEIGHT = 1280, 720 -- 512, 288
WORLD_WIDTH, WORLD_HEIGHT = 700, 700 -- 280, 280

local screen = nil

function change_screen(new_screen)
    screen = new_screen
    log.info("cargando pantalla: " .. screen.name)
    screen.load()
end

function love.load()
    log.level = "trace" -- trace / debug / info / warn / error / fatal
    log.info("Iniciado programa")

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

    math.randomseed(os.time())
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
