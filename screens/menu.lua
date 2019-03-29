local menu = { name = "Menú principal" }
local negro = {1, 1, 1, 1}

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.clear(255, 255, 255)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf(
        "DIZZY BALLOON\n\n=PRESS FIRE TO START=",
        0,
        math.floor((SCREEN_HEIGHT - font:getHeight() * 2) / 2),
        SCREEN_WIDTH,
        "center"
    )
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        game_screen = require("screens/game")
        change_screen(game_screen)
    end
end

function menu.keyreleased(key, scancode, isrepeat)

end

function love.mousepressed(id, x, y, dx, dy, pressure)
    game_screen = require("screens/game")
    change_screen(game_screen)
end

return menu
