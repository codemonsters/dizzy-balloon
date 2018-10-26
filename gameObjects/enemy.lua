local enemy = { name = "Enemigo" }

function enemy.load()
    enemy.x = 10
    enemy.y = 10
    enemy.velocidad_x = 2
    enemy.velocidad_y = 2
    enemy.image = love.graphics.newImage("assets/enemy.png")
end

function enemy.update(dt)
    enemy.x = enemy.x + enemy.velocidad_x
    if enemy.x > WORLD_WIDTH - 12 then
        enemy.velocidad_x = enemy.velocidad_x * -1
    end
    if enemy.x < 0 then
        enemy.velocidad_x = enemy.velocidad_x * -1
    end
    
end

function enemy.draw()
    love.graphics.draw(enemy.image, enemy.x + (SCREEN_WIDTH-WORLD_WIDTH)/2, enemy.y + (SCREEN_HEIGHT- WORLD_HEIGHT)/2)
    love.graphics.print(enemy.x, 0, 0)
    love.graphics.print(enemy.y, 0, 20)
end

return enemy