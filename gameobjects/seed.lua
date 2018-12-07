local SeedClass = {
    x = 0,
    y = 0,
    width = 20,
    height = 20,
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
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.image:getWidth(),
        self.height/ self.image:getHeight())
end

return SeedClass