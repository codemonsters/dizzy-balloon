local menu = {
    name = "main"
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen

    -- creamos los botones del menú
    local widgetsClass = require("misc/widgets")
    local strings = require("misc/strings")
    local buttons = {
        {
            label = getString(strings.play),
            callback = function()
                sounds.play(sounds.uiClick)
                menu.menuManager:changeMenuTo(
                    nil,
                    function()
                        changeScreen(require("screens/game"))
                        menu.menuManager:init()
                    end,
                    true
                )
            end,
        },
        {
            label = getString(strings.preferences),
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    menu.menuManager:changeMenuTo(menu.menuManager:getMenu("preferences"))
                end
            end
        },
        {
            label = getString(strings.instructions),
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    menu.menuManager:changeMenuTo(menu.menuManager:getMenu("instructions"))
                end
            end
        },
        {
            label = getString(strings.quit),
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    os.exit()
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
    if key == "space" then
        music:stop()
        changeScreen(require("screens/game"))
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

return menu
