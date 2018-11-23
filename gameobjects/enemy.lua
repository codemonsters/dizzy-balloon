local enemy = {}

function enemy.load(x, y)
    local enemigo = { name = "Enemigo" }
    enemigo.x = x
    enemigo.y = y
    enemigo.velocidad_x = 2
    enemigo.velocidad_y = 2
    enemigo.image = love.graphics.newImage("assets/enemy.png")

    function enemigo.update(dt)
        enemigo.x = enemigo.x + enemigo.velocidad_x
        if enemigo.x > WORLD_WIDTH - 12 then
            enemigo.velocidad_x = enemigo.velocidad_x * -1
        end
        if enemigo.x < 0 then
            enemigo.velocidad_x = enemigo.velocidad_x * -1
        end
        enemigo.y = enemigo.y + enemigo.velocidad_y
        if enemigo.y > WORLD_HEIGHT - 12 then
            enemigo.velocidad_y = enemigo.velocidad_y * -1
        end
        if enemigo.y < 0 then
            enemigo.velocidad_y = enemigo.velocidad_y * -1
        end
    end

    function enemigo.draw()
        love.graphics.draw(enemigo.image, enemigo.x, enemigo.y)
        love.graphics.print(enemigo.x, 0, 0)
        love.graphics.print(enemigo.y, 50, 0)
    end

    return enemigo
end

return enemy