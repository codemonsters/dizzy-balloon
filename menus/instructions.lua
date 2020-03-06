local menu = {
    name = "instructions",
    widgets = suit.new(require("menus/ourTheme"))
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    menu.musicOn = false
end

function menu.update(dt)
    menu.widgets.layout:reset(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.4)
    menu.widgets.layout:padding(SCREEN_HEIGHT * 0.015, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()

    menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

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
        menu.menuManager:changeMenuTo(menu.menuManager:getMenu("main"))
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    menu.widgets:draw()
end

return menu