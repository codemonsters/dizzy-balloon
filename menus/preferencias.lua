local menu = {
    name = "Menú preferencias",
    widgets = suit.new(ourTheme)
}

function menu.load()
    canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
end

function menu.update(dt)
    love.graphics.setBlendMode("alpha")

    menu.widgets.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.1)
    menu.widgets.layout:padding(0, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setFont(font_menu)

    menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    menu.widgets:Label("Preferencias", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12))

    love.graphics.setFont(font_buttons)

    if menu.widgets:Button("Sonido", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
    end
    if menu.widgets:Button("Música", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
    end
    if menu.widgets:Button("Idioma", menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
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
            menu.widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)
        ).hit
     then
        changeMenu(require("menus/mainMenu"))
    end
end

function menu.draw()
    love.graphics.setCanvas(menu.canvas) -- canvas del HUD
    do
        love.graphics.setBlendMode("alpha")
        menu.widgets:draw()
    end
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        changeScreen(require("screens/menu"))
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

return menu
