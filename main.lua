local push = require "libraries/push/push" -- https://github.com/Ulydev/push
log = require "libraries/log/log" -- https://github.com/rxi/log.lua

local menu_state = require ("screens/menu")

SCREEN_WIDTH, SCREEN_HEIGHT = 512, 288
WORLD_WIDTH, WORLD_HEIGHT = 280, 280

local window_width, window_height
local state = nil

function change_state(newState)
    state = newState
    log.info("cargando estado: " .. state.name)
    state.load()
end

function love.load()
    log.level = "trace" -- trace / debug / info / warn / error / fatal
    log.info("Iniciado programa")

    -- scale the window of the game (without changing game width and heigth)
    window_width, window_height = love.window.getDesktopDimensions()
    if not love.window.getFullscreen == true then
        -- scale the window to match the screen resolution
        log.debug("Escalando en pantalla completa")
    else
        -- make the window a bit smaller than the display
        log.debug("Escalando dentro de una ventana")
        window_width, window_height = window_width * .7, window_height * .7
    end
    push:setupScreen(SCREEN_WIDTH, SCREEN_HEIGHT, window_width, window_height, {fullscreen = love.window.getFullscreen()})

    math.randomseed(os.time())
    change_state(menu_state)
    log.info("Juego cargado")
end

function love.update(dt)
    state.update(dt)
end

function love.draw()
    push:start()
    state.draw()
    push:finish()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        log.info("Finalizado")
        love.event.quit()
    else
        state.keypressed(key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    state.keyreleased(key, scancode, isrepeat)
end
