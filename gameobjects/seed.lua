local SeedClass = {
    x = 0,
    y = 0,
    image = love.graphics.newImage("assets/seed.png"),
    name = "Semilla"
}

SeedClass.__index = SeedClass

function SeedClass:new()
    local semilla = {}

    setmetatable(semilla, SeedClass) 
    
    return semilla
end

function SeedClass:load(x, y)
    self.x = x
    self.y = y
end

function SeedClass:update(dt)
end

function SeedClass:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return SeedClass