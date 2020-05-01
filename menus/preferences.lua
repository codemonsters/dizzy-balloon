local menu = {
    name = "preferences",
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen

    local widgetsClass = require("misc/widgets")
    local buttons = {
        {
            type = "toggle",
            labelOn = "Sonido activado",
            labelOff = "Sonido desactivado",
            initialstatus = config.get("audio"),
            callback = function()
                -- TODO: Añadir el código que se ejecutará cuando el botón cambia de un estado a otro
                if config.get("audio") == "on" then
                    config.set("audio", "off")
                else
                    config.set("audio", "on")
                    sounds.play(sounds.uiClick)
                end
                print("sounds = " .. config.get("audio"))
            end,
        },
        {
            type = "toggle",
            labelOn = "Música activada",
            labelOff = "Música desactivada",
            initialstatus = config.get("music"),
            callback = function()
                -- TODO: Añadir el código que se ejecutará cuando el botón cambia de un estado a otro
                if config.get("music") == "on" then
                    config.set("music", "off")
                    sounds.play(sounds.uiClick)
                    music:stop()
                else
                    config.set("music", "on")
                    sounds.play(sounds.uiClick)
                    loadAndStartMusic({file = "menu.mp3", volume = 1})
                end
                print("music = " .. config.get("music"))
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
            table.insert(menu.widgets, widgetsClass.newToggleButton(button.labelOn, button.labelOff, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, button.initialstatus, button.callback, font_buttons))
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
