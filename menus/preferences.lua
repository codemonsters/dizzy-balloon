local menu = {
    name = "preferences",
    widgets = suit.new(require("menus/ourTheme"))
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
end

function menu.update(dt)
    menu.widgets.layout:reset(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.2)
    menu.widgets.layout:padding(SCREEN_HEIGHT * 0.015, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()

    menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    if menu.widgets:Button("Sonido", menu.widgets.layout:row(SCREEN_WIDTH * .7, SCREEN_HEIGHT * 0.11)).hit then
    end

    if
        menu.widgets:Button(
            "X",
            {id = 1},
            menu.widgets.layout:col(SCREEN_WIDTH * (.1 - (0.015 / 2)), SCREEN_HEIGHT * 0.11)
        ).hit
     then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            sounds.play(sounds.uiClick)
        end
    end

    if
        menu.widgets:Button(
            "X",
            {id = 2},
            menu.widgets.layout:down(SCREEN_WIDTH * (.1 - (0.015 / 2)), SCREEN_HEIGHT * 0.11)
        ).hit
     then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            if enablemusic then
                music:pause()
                enablemusic = false
            else
                music:play()
                enablemusic = true
            end
        end
    end

    if menu.widgets:Button("Música", menu.widgets.layout:left(SCREEN_WIDTH * .7, SCREEN_HEIGHT * 0.11)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            -- TODO: Implementar
        end
    end

    if menu.widgets:Button("Español", menu.widgets.layout:row(SCREEN_WIDTH * .7, SCREEN_HEIGHT * 0.11)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            -- TODO: Implementar
        end
    end

    if
        menu.widgets:Button(
            "X",
            {id = 3},
            menu.widgets.layout:col(SCREEN_WIDTH * (.1 - (0.015 / 2)), SCREEN_HEIGHT * 0.11)
        ).hit
     then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            sounds.play(sounds.uiClick)
        end
    end

    if
        menu.widgets:Button(
            "X",
            {id = 4},
            menu.widgets.layout:down(SCREEN_WIDTH * (.1 - (0.015 / 2)), SCREEN_HEIGHT * 0.11)
        ).hit
     then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            sounds.play(sounds.uiClick)
        end
    end

    if menu.widgets:Button("English", menu.widgets.layout:left(SCREEN_WIDTH * .7, SCREEN_HEIGHT * 0.11)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            -- TODO: Implementar
        end
    end

    if
        menu.widgets:Button(
            "Volver",
            {
                color = {
                    normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}},
                    hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
                    active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
                }
            },
            menu.widgets.layout:down(SCREEN_WIDTH * .8, SCREEN_HEIGHT * 0.11)
        ).hit
     then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            menu.menuManager:changeMenuTo(menu.menuManager:getMenu("main"))
        end
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    menu.widgets:draw()
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
