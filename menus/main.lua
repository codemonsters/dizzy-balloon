local menu = {
    name = "main",
    widgets = suit.new(require("menus/ourTheme")),widgetsNew = {}
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen

    -- creamos los botones del menú
    local widgetsClass = require("misc/widgets")
    local buttons = {
        {
            label = "Jugar",
            callback = function()
                sounds.play(sounds.uiClick)
                --sounds.ui_click:play()
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
            label = "Preferencias",
            callback = function()
            end
        },
        {
            label = "Instrucciones",
            callback = function()
            end
        },
        {
            label = "Salir",
            callback = function()
            end
         }
    }
    for i = 1, #buttons do
        table.insert(menu.widgetsNew, widgetsClass.newButton(buttons[i].label, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, buttons[i].callback, font_buttons))
    end
end

function menu.update(dt)

    menu.widgets.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.05)
    menu.widgets.layout:padding(0, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()

    -- menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    -- menu.widgets:Label("Dizzy Balloon", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.2))
    for i = 1, #menu.widgetsNew do
        menu.widgetsNew[i].update()
    end
    if menu.widgets:Button("Jugar", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            sounds.play(sounds.uiClick)
            --sounds.ui_click:play()
            menu.menuManager:changeMenuTo(
                nil,
                function()
                    changeScreen(require("screens/game"))
                    menu.menuManager:init()
                end,
                true
            )
        end
    end
    if menu.widgets:Button("Preferencias", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            menu.menuManager:changeMenuTo(menu.menuManager:getMenu("preferences"))
        end
    end
    if menu.widgets:Button("Instrucciones", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            menu.menuManager:changeMenuTo(menu.menuManager:getMenu("instructions"))
        end
    end
    if menu.widgets:Button("Salir", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            os.exit()
        end
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    love.graphics.printf( "Dizzy Balloon", font_title, 0, SCREEN_HEIGHT * 0.1, 1280, "center")
    for i = 1, #menu.widgetsNew do
        menu.widgetsNew[i].draw()
    end
    --menu.widgets:draw()

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
