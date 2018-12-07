local SeedClass = require("gameobjects/seed")

local SkyClass = {
    semillas = {}
}

SkyClass.__index = SkyClass

function SkyClass.new()
    local sky = {}
    setmetatable(sky, SkyClass)
    return sky
end

function SkyClass:load()
    for i = 0, WORLD_WIDTH / SeedClass.width do
        local semilla = SeedClass.new()
        semilla:load(i * semilla.width, 0)
        table.insert(self.semillas, semilla)
    end
end

function SkyClass:update()
    for i, semilla in ipairs(self.semillas) do
        semilla:update()
    end
end

function SkyClass:draw()
    for i, semilla in ipairs(self.semillas) do
        semilla:draw()
    end
end

return SkyClass