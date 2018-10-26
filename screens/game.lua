local game = { name = "Juego" }

local enemy = require("gameObjects/enemy")

function game.load()
    enemy.load()
end

function game.update(dt)
    enemy.update(dt)
end

function game.draw()
    love.graphics.print("Hello World", 400, 300)
    enemy.draw()
end

function game.keypressed(key, scancode, isrepeat)
    --[[ if key == "space" then
        game_state = require("game")
        change_state(game_state)
    end ]]--
end

return game
