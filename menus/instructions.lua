local menu = {
    name = "instructions",
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen

    -- creamos los botones del menú
    local strings = require("misc/strings")
    local widgetsClass = require("misc/widgets")
    local buttons = {
        {
            label = getString(strings.goBack),
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    menu.menuManager:changeMenuTo(menu.menuManager:getMenu("main"))
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
    for i = 1, #menu.widgets do
        menu.widgets[i].draw()
    end
end

return menu