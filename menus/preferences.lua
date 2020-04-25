local menu = {
    name = "preferences",
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    menu.musicOn = false

    local widgetsClass = require("misc/widgets")
    local buttons = {
        {
            type = "toggle",
            labelOn = "Sonido activado",
            labelOff = "Sonido desactivado",
            callback = function()
                -- TODO: Añadir el código que se ejecutará cuando el botón cambia de un estado a otro
                --[[
                if self.on then
                    self.on = false
                else
                    self.on = true
                end
                --]]
            end,
        },
        {
            type = "toggle",
            labelOn = "Música activada",
            labelOff = "Música desactivada",
            callback = function()
                -- TODO: Añadir el código que se ejecutará cuando el botón cambia de un estado a otro
            end
        },
        {
            type = "toggle",
            labelOn = "Español",
            labelOff = "English",
            callback = function()
                -- TODO: Añadir el código que se ejecutará cuando el botón cambia de un estado a otro
            end
        },
        {
            type = "standard",
            label = "Volver",
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    menu.menuManager:changeMenuTo(menu.menuManager:getMenu("main"))
                end
            end
        }
    }
    menu.widgets = {}
    for i = 1, #buttons do
        local button = buttons[i]
        if button.type == "standard" then
            table.insert(menu.widgets, widgetsClass.newButton(button.label, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, button.callback, font_buttons))
        elseif button.type == "toggle" then
            table.insert(menu.widgets, widgetsClass.newToggleButton(button.labelOn, button.labelOff, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, button.callback, font_buttons))
        else
            error("Error: tipo de botón no soportado: '" .. button.type)
        end
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

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            -- TODO: ¿Es correcto que al pulsar espacio se ejecute esto?
            changeScreen(require("screens/menu"))
        end
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

return menu
