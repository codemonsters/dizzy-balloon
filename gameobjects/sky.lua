local SeedClass = require("gameobjects/seed")
local PowerUps = require("powerups")

local SkyClass = {}

SkyClass.__index = SkyClass

function SkyClass.new(world, game)
    local sky = {
        name = "sky",
        semillas = {}
    }
    sky.world = world
    sky.game = game

    for i = 0, WORLD_WIDTH / SeedClass.width + 1 do
        local num = math.random(1, 100)
        if num <= 20 then -- semilla normal 90%
            boost = nil
        else              -- semilla con boost 10%
            local keyset = {}
            for k in pairs(PowerUps) do
                table.insert(keyset, k)
            end
            boost = PowerUps[keyset[math.random(#keyset)]]
        end

        local semilla = SeedClass.new("seed" .. (i + 1), sky, world, i * SeedClass.width, 0, sky.game, boost)
        table.insert(sky.semillas, semilla)
    end

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
            self.world:remove(seed)
            return
        end
    end
    log.error("ERROR: Se ha intentado eliminar una semilla que no existe")
end

return SkyClass
