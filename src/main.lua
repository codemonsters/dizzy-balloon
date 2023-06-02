-- enable debugging using local lua debugger vscode extension
if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
    local lldebugger = require "lldebugger"
    lldebugger.start()
    local run = love.run
    function love.run(...)
        local f = lldebugger.call(run, false, ...)
        return function(...) return lldebugger.call(f, false, ...) end
    end
end

log = require("libraries/log/log") -- https://github.com/rxi/log.lua
config = require("misc/config") -- nuestros ajustes de configuración del juego
local SoundClass = require("sounds")
sounds = SoundClass.new()

if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
    mobile = true
else
    mobile = false
end

SCREEN_WIDTH, SCREEN_HEIGHT = 1280, 720 -- El juego se crea por completo dentro de una pantalla de este tamaño (y posteriormente se escala según sea necesario)
WORLD_WIDTH, WORLD_HEIGHT = 720, 720 -- La zona de juego es parte de la pantalla y también tiene tamaño fijo

local screen = nil

function changeScreen(new_screen)
    log.info("cargando pantalla: " .. new_screen.name)
    screen = new_screen
    screen.load()
end

function love.load()
    if arg[#arg] == "-debug" then
        -- if your game is invoked with "-debug" (zerobrane does this by default)
        -- invoke the debugger
        require("mobdebug").start()
        -- disable buffer to read print messages instantly
        io.stdout:setvbuf("no")
    end
    log.level = "trace" -- trace / debug / info / warn / error / fatal
    log.info("Iniciando")

    love.graphics.setDefaultFilter("nearest") -- Cambiamos el filtro usado durante el escalado

    font_title = love.graphics.newFont("assets/fonts/edunline.ttf", 80)
    -- font_hud = love.graphics.newFont("assets/fonts/orangejuice20.ttf", 40) -- https://www.dafont.com/es/pixelmania.font
    font_buttons = love.graphics.newFont("assets/fonts/unlearne.ttf", 60) -- https://www.1001fonts.com/
    font_hud = love.graphics.newFont("assets/fonts/unlearne.ttf", 40) -- https://www.dafont.com/es/pixelmania.font
    font_tutorial = love.graphics.newFont("assets/fonts/unlearne.ttf", 33)

    if mobile then
        --love.window.setFullscreen(true)
        device_width, device_height = love.window.getDimensions()
        log.debug("Corriendo en dispositivo móvil")
    else
        device_width, device_height = love.window.getDesktopDimensions()
        if love.window.getFullscreen() then
            log.debug("Corriendo en pantalla completa (resolución: " .. device_width .. " x " .. device_height .. " px)")
        else
            device_width, device_height = device_width * .7, device_height * .7 -- definimos el tamaño inicial de la ventana
            log.debug("Corriendo en una ventana de: " .. device_width .. " x " .. device_height .. " px")
            love.window.setMode(
                device_width,
                device_height,
                {
                    vsync = true,
                    resizable = true,
                    centered = true
                }
            )
        end
    end


    actualizaVariablesEscalado(device_width, device_height)

    math.randomseed(os.time()) -- NOTE: Quizá redundante, parece que Love ya inicializa la semilla random automáticamente

    -- atlas: la textura que contiene todas las imágenes
    atlasOld = love.graphics.newImage("assets/images/atlasOld.png") -- Créditos: Grafixkid (https://opengameart.org/content/arcade-platformer-assets)
    atlas = love.graphics.newImage("assets/images/atlas.png")
    quads = require("misc/quads") -- quads de todos los elementos incluidos en el atlas
    changeScreen(require("screens/menu"))
    log.info("Juego cargado")
end

function love.update(dt)
    screen.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.setCanvas(mainCanvas)
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)

        screen.draw()
        
    love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
    love.graphics.pop()
end

function love.resize(w, h)
    actualizaVariablesEscalado(w, h)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "q" then
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

function actualizaVariablesEscalado(device_width, device_height)
    -- calcula el valor de las variables: factorEscala, desplazamientoX, desplazamientoY (utilizadas para escalar y desplazar el viewport del juego dentro de la ventana principal)
    log.debug("Recalculando variables escalado para resolución " .. device_width .. " x " .. device_height)
    
    factorEscalaAncho = device_width / SCREEN_WIDTH
    factorEscalaAlto = device_height / SCREEN_HEIGHT
    if factorEscalaAncho < factorEscalaAlto then
        factorEscala = factorEscalaAncho
    else
        factorEscala = factorEscalaAlto
    end

    desplazamientoX = (device_width - factorEscala * SCREEN_WIDTH) / 2
    desplazamientoY = (device_height - factorEscala * SCREEN_HEIGHT) / 2
end

-- Inicia la música. El argumento music es una tabal con dos claves (file y volume), tal y com se puede definir en el nivel
function loadAndStartMusic(m)
    if config.get("music") == true then
        if music then
            music:stop()
        end
        if m then
            music = love.audio.newSource("assets/music/" .. m.file, "stream")
            music:setLooping(true)
            if m.volume then
                music:setVolume(m.volume)
            end
            music:play()
        else
            log.debug("loadAndStartMusic(m): m is nil")
        end
    end
end

function round(num, n)
    local mult = 10 ^ (n or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- devuelve una copia de la tabla que se pasa como primer argumento
function copyTable(obj, seen) -- el segundo parámetro se ignora, es para detectar recursión
    if type(obj) ~= "table" then
        return obj
    end
    if seen and seen[obj] then
        return seen[obj]
    end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do
        res[copyTable(k, s)] = copyTable(v, s)
    end
    return res
end

function getString(str)
    return str[config.get("language")]
end