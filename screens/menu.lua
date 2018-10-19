local menu = { name = "Menú principal" }
local negro = {1, 1, 1, 1}

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.print("AASFDSASADAS", 0, 0)
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        game_state = require("screens/game")
        change_state(game_state)
    end
end

return menu
