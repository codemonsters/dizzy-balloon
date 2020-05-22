local menu = {
    name = "inGame"
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    menu.closing = false -- flag que cuando vale true indica que estamos cerrando este menú
    local widgetsClass = require("misc/widgets")
    local strings = require("misc/strings")
    local buttons = {
        {
            label = getString(strings.continue),
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    menu.continueGame()
                end
            end,
        },
        {
            label = getString(strings.quit),
            callback = function()
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
        }
    }
    menu.widgets = {}
    for i = 1, #buttons do
        table.insert(menu.widgets, widgetsClass.newButton(buttons[i].label, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, buttons[i].callback, font_buttons))
    end
end

function menu.update(dt)
    for i = 1, #menu.widgets do
        menu.widgets[i].update()
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    love.graphics.printf( "Dizzy Balloon", font_title, 0, SCREEN_HEIGHT * 0.1, 1280, "center")
    for i = 1, #menu.widgets do
        menu.widgets[i].draw()
    end
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
