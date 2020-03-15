local menu = {
    name = "inGame"
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    menu.widgets = suit.new(require("menus/ourTheme"))
    menu.closing = false -- flag que cuando vale true indica que estamos cerrando este menú
end

function menu.update(dt)
    menu.widgets.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.15)
    menu.widgets.layout:padding(0, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()

    menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    menu.widgets:Label("Dizzy Balloon", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12))

    if menu.widgets:Button("Continuar", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            menu.continueGame()
        end
    end
    if menu.widgets:Button("Salir", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            if not menu.closing then
                menu.closing = true
                sounds.play(sounds.uiRollOver)
                    menu.menuManager:changeMenuTo(
                    nil,
                    function()
                        changeScreen(require("screens/menu"))
                        menu.menuManager:init()
                    end
                )
            end
        end
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    menu.widgets:draw()
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "escape" and not menu.closing then
        menu.closing = true
        menu.continueGame()
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

function menu.continueGame()
    sounds.play(sounds.uiClick)
    menu.menuManager:changeMenuTo(
        nil,
        function()
            menu.screen.continue()
            menu.menuManager:init()
        end
    )
end
return menu
