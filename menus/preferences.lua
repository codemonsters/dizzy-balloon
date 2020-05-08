local menu = {
    name = "preferences",
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    local strings = require("misc/strings")
    local widgetsClass = require("misc/widgets")
    local buttons = {
        {
            type = "toggle",
            labelOn = getString(strings.sound.on),
            labelOff = getString(strings.sound.off),
            value = config.get("sound"),
            callback = function(self)
                sounds.play(sounds.uiClick)
                config.set("sound", self.on)
                log.debug("Estado del sonido: " .. tostring(config.get("sound")))
            end,
        },
        {
            type = "toggle",
            labelOn = getString(strings.music.on),
            labelOff = getString(strings.music.off),
            value = config.get("music"),
            callback = function(self)
                sounds.play(sounds.uiClick)
                config.set("music", self.on)
                if config.get("music") == true then
                    loadAndStartMusic({file = "menu.mp3", volume = 1})
                else
                    if music then music:stop() end
                end
                log.debug("Estado de la música " .. tostring(config.get("music")))
            end,
        },
        {
            type = "toggle",
            labelOn = "Español",
            labelOff = "English",
            value = config.get("language"),
            callback = function(self)
                sounds.play(sounds.uiClick)
                if self.on then
                    config.set("language", "es")
                else
                    config.set("language", "en")
                end
                print("Idioma: " .. tostring(config.get("language")))
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then -- TODO: Hacer esto más elegante.
                    menu.menuManager:changeMenuTo(menu.menuManager:getMenu("preferences"))
                end
            end,
        },
        {
            type = "standard",
            label = getString(strings.goBack),
            callback = function(self)
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
            local value = button.value
            if button.value == "es" then
                value = true
            elseif button.value == "en" then
                value = false
            end
            local newButton = widgetsClass.newToggleButton(button.labelOn, button.labelOff, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, value, button.callback, font_buttons)
            table.insert(menu.widgets, newButton)
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
