local game = { name = "Juego" }

function game.load()
end

function game.update(dt)
end

function game.draw()
    love.graphics.print("Hello World", 400, 300)
end

function game.keypressed(key, scancode, isrepeat)
    --[[ if key == "space" then
        game_state = require(game)
        change_state(game_state)
    end ]]--
end

return game
