local PlayerClass = require("gameobjects/player")
local EnemyClass = require("gameobjects/enemy")
local bump = require("libraries/bump/bump")
local BlockClass = require("gameobjects/block")
local animLoader = require("misc/animationLoader")
local MenuManagerClass = require("menus/menuManager")
local menuManager =
    MenuManagerClass.new(
    {
        {
            name = "main",
            menu = require("menus/main")
        },
        {
            name = "preferences",
            menu = require("menus/preferences")
        },
        {
            name = "instructions",
            menu = require("menus/instructions")
        }
    },
    {
        {
            from = nil,
            to = "main",
            effect = MenuManagerClass.effects.moveDown
        },
        {
            from = "main",
            to = nil,
            effect = MenuManagerClass.effects.fadeOut
        },
        {
            from = "main",
            to = "preferences",
            effect = MenuManagerClass.effects.moveLeft
        },
        {
            from = "preferences",
            to = "main",
            effect = MenuManagerClass.effects.moveRight
        },
        {
            from = "main",
            to = "instructions",
            effect = MenuManagerClass.effects.moveRight
        },
        {
            from = "instructions",
            to = "main",
            effect = MenuManagerClass.effects.moveLeft
        }
    }
)

--[[
    Esta pantalla (menu) tiene distintos estados, por ejemplo para cargar menús y hacer transiciones entre ellos y mostrarlos.
    El estado actual se guarda en menu.screenState, pero debe cambiarse llamando a menu.changeScreenState(screenState) para que así se llame a la función load() del estado al que cambiamos.
    La variable menu.currentMenu apunta hacia el menú actual.
    En menu.nextMenu se guarda el menú hacia el que nos estamos moviendo (el cual una vez finalizada la transición se convertirá en menu.currentMenu).
]]
local menu = {
    name = "Pantalla menú"
}

-- carga este screen
function menu.load()
    factorEscalaExtra = 2
    local MENU_HEIGHT, MENU_WIDTH = SCREEN_HEIGHT/factorEscalaExtra, SCREEN_WIDTH/factorEscalaExtra
    -- música
    canvas = love.graphics.newCanvas(MENU_WIDTH, MENU_HEIGHT)
    loadAndStartMusic({file = "menu.mp3", volume = 1})

    -- animaciones
    local world = bump.newWorld(50)
    jugador = PlayerClass.new(world, 1, MENU_HEIGHT - PlayerClass.height, nil)
    enemigo1 = EnemyClass.new(enemigo, MENU_WIDTH * 0.05, PlayerClass.height * 2, world, nil, 0)
    
    local borderWidth = 50
    suelo = BlockClass.new("Suelo", 0, MENU_HEIGHT, MENU_WIDTH, borderWidth, world)
    BlockClass.new("ParedIzquierda", -borderWidth, 0, borderWidth, MENU_HEIGHT, world)
    pd = BlockClass.new("ParedDerecha", MENU_WIDTH - 1, 0, borderWidth, MENU_HEIGHT, world)
    BlockClass.new("Techo", 0, -borderWidth, MENU_WIDTH, borderWidth, world)
    animLoader:applyAnim(enemigo1, animacionTestEnemigo)
    animLoader:applyAnim(jugador, animacionTestJugador) -- asocia el animador al jugador y cargar una animación en él
end

function menu.update(dt)
    jugador:update(dt)
    enemigo1:update(dt)
    animLoader:update(dt)
    menuManager:update(dt)
end

function menu.draw()
    love.graphics.clear(1, 0, 1)

    love.graphics.setCanvas(canvas) -- volvemos a dibujar en la ventana principal
    love.graphics.clear(1, 0, 1)
    jugador:draw()
    enemigo1:draw()
    suelo:draw()
    pd:draw()

    love.graphics.push()
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)
    

    love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
    love.graphics.draw(
        canvas,
        0,
        0,
        0,
        factorEscalaExtra,
        factorEscalaExtra
    )
    love.graphics.setColor(255, 0, 0, 255)

    -- DEBUG: marcas en los extremos diagonales de la pantalla
    love.graphics.setColor(255, 0, 0)
    love.graphics.line(0, 0, 10, 0)
    love.graphics.line(0, 0, 0, 10)
    love.graphics.line(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1, SCREEN_WIDTH - 11, SCREEN_HEIGHT - 1)
    love.graphics.line(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 11)

    menuManager:draw()
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
