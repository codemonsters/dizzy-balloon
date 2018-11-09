local seed = {}

function seed.create(x, y)
    local semilla = { name = "Semilla" }
    
    semilla.x = x
    semilla.y = y
    semilla.image = love.graphics.newImage("assets/seed.png")
    
    function semilla.update(dt)
    end
    
    function semilla.draw()
        love.graphics.draw(semilla.image, semilla.x, semilla.y)
    end
    
    return semilla
end

return seed