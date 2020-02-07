local SeedClass = require("gameobjects/seed")
local PowerUps = require("powerups")
local levelDefinitions = require("levelDefinitions")

local SkyClass = {}

SkyClass.__index = SkyClass

function SkyClass.new(world, game, level)
    local sky = {
        name = "sky",
        semillas = {}
    }
    sky.world = world
    sky.game = game

    local seedNumber = WORLD_WIDTH / SeedClass.width + 1

    for i = 0, seedNumber do
        local semilla = SeedClass.new("seed" .. (i + 1), sky, world, i * SeedClass.width, 0, sky.game)
        table.insert(sky.semillas, semilla)
    end

    local puCounter = 0

    for k, v in pairs(level.levelDefinition.powerups) do
        local totalPU = v
        while totalPU > 0 and puCounter < seedNumber do
            local num = math.random(1, seedNumber)
            if sky.semillas[num].powerUp == nil then
                sky.semillas[num].powerUp = PowerUps[k]
                totalPU = totalPU - 1
                puCounter = puCounter + 1
            end
        end
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
            if self.world:hasItem(seed) then
                self.world:remove(seed)
            end
            return
        end
    end
    log.error("ERROR: Se ha intentado eliminar una semilla que no existe")
end

return SkyClass
