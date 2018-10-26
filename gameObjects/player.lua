local player = {}

player.x = 0
player.y = GAME_HEIGHT - 20
player.left = false
player.right = false
player.up = false
player.down = false

function player.update(dt)
    if player.up then
        player.y = player.y - 1
    end
    if player.left then
        player.x = player.x - 1
    end
    if player.down then
        player.y = player.y + 1
    end
    if player.right then
        player.x = player.x + 1
    end
end

function player.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("X", player.x, player.y)
end

return player
