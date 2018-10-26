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
    if enemy.x > SCREEN_WIDTH - 12 then
        enemy.velocidad_x = enemy.velocidad_x * -1
    end
    if enemy.x < 0 then
        enemy.velocidad_x = enemy.velocidad_x * -1
    end
    enemy.y = enemy.y + enemy.velocidad_y
    if enemy.y > SCREEN_HEIGHT - 12 then
        enemy.velocidad_y = enemy.velocidad_y * -1
    end
    if enemy.y < 0 then
        enemy.velocidad_y = enemy.velocidad_y * -1
    end
end

function enemy.draw()
    love.graphics.draw(enemy.image, enemy.x, enemy.y)
    love.graphics.print(enemy.x, 0, 0)
    love.graphics.print(enemy.y, 50, 0)
end

return enemy