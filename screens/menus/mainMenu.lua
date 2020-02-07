local menu = {
    name = "Menú principal",
}

function menu.load()
    canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    widgets = suit.new(ourTheme)
end

function menu.update(dt)
    love.graphics.setBlendMode("alpha")

    widgets.layout:reset(SCREEN_WIDTH * 0.2, SCREEN_HEIGHT * 0.1)
    widgets.layout:padding(0, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setFont(font_menu)

    widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)

    widgets:Label("Dizzy Balloon", widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12))

    love.graphics.setFont(font_buttons)

    if widgets:Button("Jugar",  widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        music:stop()
        changeScreen(require("screens/game"))
    end
    if widgets:Button("Preferencias", widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        changeScreen(require("screens/menus/preferencias"))
    end
    if widgets:Button("Instrucciones", widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        print("Te esperas. Todavía no está hecho. Si lo quieres usar, lo escribes y todos contentos :)")
    end
    if widgets:Button("Salir", {color = {normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}}, hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}}, active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}} }},  widgets.layout:row(SCREEN_WIDTH * .6, SCREEN_HEIGHT * 0.12)).hit then
        os.exit()
    end
end

function menu.draw()
    love.graphics.setCanvas(menu.canvas) -- canvas del HUD
    do
        love.graphics.setBlendMode("alpha")
        widgets:draw()
    end
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        music:stop()
        changeScreen(require('screens/game'))
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

return menu
