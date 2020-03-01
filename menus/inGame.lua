local menu = {
    name = "inGame"
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    menu.widgets = suit.new(require("menus/ourTheme"))
    --menu.canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
end

function menu.update(dt)
    love.graphics.setBlendMode("alpha")

    menu.widgets.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.15)
    menu.widgets.layout:padding(0, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()

    menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    menu.widgets:Label("Dizzy Balloon", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12))

    if menu.widgets:Button("Continuar", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        sounds.ui_click:play()
        menu.menuManager:changeMenuTo(
            nil,
            function()
                menu.screen.continue()
                menu.menuManager:init()
            end
        )
    end
    if menu.widgets:Button("Salir", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        sounds.ui_rollover:play()
        menu.menuManager:changeMenuTo(
            nil,
            function()
                changeScreen(require("screens/menu"))
                menu.menuManager:init()
            end
        )
    end
end

function menu.draw()
    --love.graphics.setCanvas(menu.canvas)
    --do
    love.graphics.setBlendMode("alpha")
    menu.widgets:draw()
    --end
    --love.graphics.setCanvas()
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        music:stop()
        changeScreen(require("screens/game"))
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

return menu
