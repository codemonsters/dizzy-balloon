local seed = { name = "Semilla" }

-- Traduce una coordenada X del mundo del juego a su correspondiente coordenada X en pantalla
function translate_x(x_world)
    local shift_x = (SCREEN_WIDTH - WORLD_WIDTH) / 2 -- IMPROVEME: Mejorar eficiencia eliminando parte del cálculo (o mejor todavía: hacer una metatabla común para todos los gameobjects que incluya dos funciones que devuelvan la x y la y de cada gameobject pero ya desplazados)
    return x_world + shift_x
end

-- Traduce una coordenada Y del mundo del juego a su correspondiente coordenada Y en pantalla
function translate_y(y_world)
    local shift_y = (SCREEN_HEIGHT - WORLD_HEIGHT) / 2
    return y_world + shift_y
end

function seed.load()
    seed.x = 0
    seed.y = 0
    seed.image = love.graphics.newImage("assets/seed.png")
end

function seed.update(dt)
end

function seed.draw()
    love.graphics.print(seed.image, translate_x(seed.x), translate_y(seed.y))
end

return seed