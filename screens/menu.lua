local PlayerClass = require("gameobjects/player")
local EnemyClass = require("gameobjects/enemy")
local bump = require "libraries/bump/bump"
local BlockClass = require("gameobjects/block")
local animLoader = require("animationLoader")
local ourTheme = require("ourTheme")

--[[
    A grandes rasgos:
        * Esta pantalla (menu) tiene distintos estados, por ejemplo para cargar menús y hacer transiciones entre ellos y mostrarlos
        * El estado actual se guarda en menu.screenState, pero debe cambiarse llamando a menu.changeScreenState(screenState) para que así se llame a la función load() del estado al que cambiamos
        * La variable menu.currentMenu apunta hacia el menú actual
        * En menu.nextMenu se guarda el menú hacia el que nos estamos moviendo (el cual una vez finalizada la transición se convertirá en menu.currentMenu)
]]
local menu = {
    name = "Pantalla menú principal"
}

menu.screenStates = {
    -- TODO: ¿Añadir un estado exitingScreen" para utilizar mientras abandonamos esta pantalla?
    enteringScreen = {
        -- entrando por primera vez en esta pantalla (o volviendo desde otro screen)
        name = "enteringScreen",
        load = function()
            -- menu.currentMenu = nil
            menu.nextMenu = require("menus/main")
            menu.nextMenu.load(menu)
            menu.screenStates.enteringScreen.shiftY = SCREEN_HEIGHT -- desplazamiento vertical del menú (aparece en la pantalla desde la parte superior)
        end,
        update = function(dt)
            menu.screenStates.enteringScreen.shiftY = menu.screenStates.enteringScreen.shiftY - dt * 1000
            if menu.screenStates.enteringScreen.shiftY <= 0 then
                menu.currentMenu = menu.nextMenu
                menu.nextMenu = nil
                menu.changeScreenState(menu.screenStates.showingMenu)
            else
                menu.nextMenu.update(dt)
            end
        end,
        draw = function()
            love.graphics.push()
            love.graphics.translate(0, -menu.screenStates.enteringScreen.shiftY)
            menu.nextMenu.draw()
            love.graphics.pop()
        end
    },
    loadingMenu = {
        -- cargando un nuevo menú
        name = "loadingMenu",
        load = function()
            menu.loadMenu(require("menus/main"))
        end,
        update = function(dt)
        end,
        draw = function()
        end
    },
    changingMenu = {
        -- transición de un menú a otro
        name = "chagingMenu",
        load = function()
        end,
        update = function(dt)
        end,
        draw = function()
        end
    },
    showingMenu = {
        -- mostrando un menú
        name = "showingMenu",
        load = function()
        end,
        update = function(dt)
            menu.currentMenu.update(dt)
        end,
        draw = function()
            menu.currentMenu.draw()
        end
    }
}

-- devuelve un menú dentro de este screen
function menu.loadMenu(newMenu)
    log.info("cargando menú: " .. newMenu.name)
    currentMenu = newMenu
    currentMenu.load(menu) -- al menú le pasamos como argumento la pantalla para que pueda acceder a ella por ejemplo cuando ese menú quiere pedir que se cambie a otro distinto
end

function menu.changeScreenState(screenState)
    if screenState == nil then
        error("menu.changeScreenState() received a nil screenState argument")
    end
    menu.screenState = screenState
    menu.screenState.load()
end

-- carga este screen
function menu.load()
    music = love.audio.newSource("assets/music/menu.mp3", "stream")
    world = bump.newWorld(50)
    jugador = PlayerClass.new(world, nil)
    enemigo1 = EnemyClass.new(enemigo, SCREEN_WIDTH * 0.05, PlayerClass.height * 3, world, nil, 0)
    local borderWidth = 50
    BlockClass.new("Suelo", 0, WORLD_HEIGHT, SCREEN_WIDTH, borderWidth, world)
    BlockClass.new("ParedIzquierda", 0, 0, 1, SCREEN_HEIGHT, world)
    BlockClass.new("ParedDerecha", SCREEN_WIDTH, 0, 1, SCREEN_HEIGHT, world)
    BlockClass.new("Techo", 0, 0, SCREEN_WIDTH, 1, world)
    animLoader:applyAnim(enemigo1, animacionTestEnemigo)
    -- asociar el animador al jugador y cargar una animación en él
    animLoader:applyAnim(jugador, animacionTestJugador)
    music:setLooping(true)
    music:play()
    menu.changeScreenState(menu.screenStates.enteringScreen)
end

function menu.update(dt)
    jugador:update(dt)
    enemigo1:update(dt)
    animLoader:update(dt)
    menu.screenState.update(dt)
end

function menu.draw()
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

    menu.screenState.draw()
    --print("Estado del menú: " .. menu.screenState.name)

    love.graphics.pop()
end

function menu.keypressed(key, scancode, isrepeat)
    if menu.currentMenu then
        menu.currentMenu.keypressed(key, scancode, isrepeat)
    end
end

function menu.keyreleased(key, scancode, isrepeat)
    if menu.currentMenu then
        menu.currentMenu.keyreleased(key, scancode, isrepeat)
    end
end

return menu
