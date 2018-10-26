local menu = { name = "Menú principal" }
local negro = {1, 1, 1, 1}

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.clear(255, 255, 255)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("Hola mundo", 0, 0)
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        game_state = require("screens/game")
        change_state(game_state)
    end
end

function menu.keyreleased(key, scancode, isrepeat)

end

return menu
