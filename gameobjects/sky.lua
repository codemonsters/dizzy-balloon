local SeedClass = require("gameobjects/seed")

local SkyClass = {}

SkyClass.__index = SkyClass

function SkyClass.new(world)
    local sky = {
        name = "sky",
        semillas = {}
    }
    sky.world = world

    for i = 0, WORLD_WIDTH / SeedClass.width + 1 do
        local semilla = SeedClass.new("seed" .. (i + 1), sky, world, i * SeedClass.width, 0)
        table.insert(sky.semillas, semilla)
    end
    sky.semillas[10]:change_state(SeedClass.states.falling)

    setmetatable(sky, SkyClass)
    return sky
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
            world:remove(seed)
            return
        end
    end
    log.error("ERROR: Se ha intentado eliminar una semilla que no existe")    
end

return SkyClass