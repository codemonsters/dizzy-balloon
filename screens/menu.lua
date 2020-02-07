local PlayerClass = require("gameobjects/player")
local EnemyClass = require("gameobjects/enemy")
local bump = require "libraries/bump/bump"
local BlockClass = require("gameobjects/block")
local animLoader = require("animationLoader")
--local music = love.audio.newSource("assets/music/PP_Silly_Goose_FULL_Loop.wav", "stream")
music = love.audio.newSource("assets/music/Menu.wav", "stream")
local ourTheme = require("ourTheme")
local menu = {
    name = "Pantalla menú principal"
}

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
    music:setLooping(true)
    music:play()
    changeMenu(require("screens/menus/mainMenu"))
end

function menu.update(dt)
    jugador:update(dt)
    enemigo1:update(dt)
    animLoader:update(dt)

    currentMenu.update(dt)
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

    currentMenu.draw()

    love.graphics.pop()
end

function menu.keypressed(key, scancode, isrepeat)
    currentMenu.keypressed(key, scancode, isrepeat)
end

function menu.keyreleased(key, scancode, isrepeat)
    currentMenu.keyreleased(key, scancode, isrepeat)
end

--Esta función actualiza los widgets
function widgetsUpdate()
    love.graphics.setBlendMode("alpha")

    menuWidgets.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.1)
    menuWidgets.layout:padding(0, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setFont(font_menu)

    menuWidgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)


    menuWidgets:Label("Dizzy Balloon", menuWidgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12))

    love.graphics.setFont(font_buttons)



    
    if menuWidgets:Button("Jugar",  menuWidgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        changeScreen()
    end
    if menuWidgets:Button("Preferencias", menuWidgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if menuWidgets:Button("Instrucciones", menuWidgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if menuWidgets:Button("Salir", {color = {normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}}, hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}}, active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}} }},  menuWidgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then

        os.exit()
    end
end

function changeMenu(newMenu)
    log.info("cargando menú: " .. newMenu.name)
    currentMenu = newMenu
    currentMenu.load()
end

return menu
