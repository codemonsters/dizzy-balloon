local player = {name = "Player"}

local states = {
    standing = {
        love.graphics.newImage("assets/player/p.png")
    },
    right = {
        love.graphics.newImage("assets/player/r1.png"),
        love.graphics.newImage("assets/player/r2.png"),
        love.graphics.newImage("assets/player/r3.png")
    },
    left = {
        love.graphics.newImage("assets/player/l1.png"),
        love.graphics.newImage("assets/player/l2.png"),
        love.graphics.newImage("assets/player/l3.png")
    }
}

function player.load()
    player.x = 1
    player.y = WORLD_HEIGHT - 20
    player.velocidad_y = 0
    player.left = false
    player.right = false
    player.up = false
    player.down = false
    player.jumping = false
    player.state = states.standing
    print("--> " .. #player.state)
end

function player.jump()
    if not player.jumping then
        player.jumping = true
        player.velocidad_y = 1
    end
end

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
    --[[
    if player.jumping and player.y < (WORLD_HEIGHT + 20) then
        player.y = player.y - player.velocidad_y
        player.velocidad_y = player.velocidad_y - 0.25 * dt
    else
        player.velocidad_y = 0
        player.jumping = false
    end
    --]]
    if player.jumping then
        player.y = player.y - player.velocidad_y
        player.velocidad_y = player.velocidad_y - 0.25 * dt
        if player.y > WORLD_HEIGHT + 20 then
            player.jumping = false
        end
    end

end

function player.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        player.state[1], -- TODO: Cambiar la imagen del sprite según su estado
        player.x,
        player.y
    )
end

return player
