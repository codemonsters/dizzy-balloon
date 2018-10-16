local menu = {name = "Menú principal"}

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.print("Hello World!", 400, 300)
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        game_state = require(game)
        change_state(game_state)
    end
end

return menu
