local player = {}

player.x = 1
player.y = WORLD_HEIGHT - 20
player.left = false
player.right = false
player.up = false
player.down = false

function player.update(dt)
    if player.up and player.y > 0 then
        player.y = player.y - 1
    end
    if player.left and player.x > 0 then
        player.x = player.x - 1
    end
    if player.down and player.y < WORLD_HEIGHT then
        player.y = player.y + 1
    end
    if player.right and player.x < WORLD_WIDTH then
        player.x = player.x + 1
    end
end

function player.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("X", player.x + (SCREEN_WIDTH-WORLD_WIDTH)/2, player.y + (SCREEN_HEIGHT- WORLD_HEIGHT)/2)
end

return player
