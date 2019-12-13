--[[
ID opcional
canvas del mundo
posicion inicial del jugador
gameobjects { 
    plataformas
    enemigos
    globos
    setas
    cielo/s
    salida, limite
}
numero maximo de enemigos X
bump.world X
--]]

local LevelClass = {
    name = "Level"
}

LevelClass.__index = LevelClass

function LevelClass.new(levelDefinition)
    local level = {}
    setmetatable(level, LevelClass)
    level.world = bump.newWorld(50)
    level.levelDefinition = levelDefinition
    level.max_enemies = levelDefinition.max_enemies
    level.plataformas = {}
    for plataforma in levelDefinition.plataformas do --TODO revisar
        table.insert(level.plataformas, BlockClass.new(plataforma.name, plataforma.x, plataforma.y, plataforma.width, plataforma.height, level.world))
    end
    return level
end

return LevelClass