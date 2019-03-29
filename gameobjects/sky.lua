local SeedClass = require("gameobjects/seed")

local SkyClass = {
    semillas = {}
}

SkyClass.__index = SkyClass

function SkyClass:new(world)
    local sky = {
        name = "sky"
    }
    setmetatable(sky, SkyClass)
    return sky
end

function SkyClass:load(world)
    self.world = world
    
    for i = 0, WORLD_WIDTH / SeedClass.width + 1 do
        local semilla = SeedClass.new("seed" .. (i + 1), self)
        semilla:load(world, i * semilla.width, 0)
        table.insert(self.semillas, semilla)
    end
    
    self.semillas[10]:change_state(SeedClass.states.falling)
end

function SkyClass:update(dt)
    for i, semilla in ipairs(self.semillas) do
        semilla:update(dt)
    end
end

function SkyClass:draw()
    for i, semilla in ipairs(self.semillas) do
        semilla:draw()
    end
end

function SkyClass:deleteSeed(seed)
    for i, semilla in ipairs(self.semillas) do
        if semilla.name == seed.name then
            table.remove(self.semillas, i)
            return
        end
    end
    log.error("ERROR: Se ha intentado eliminar una semilla que no existe")    
end

return SkyClass