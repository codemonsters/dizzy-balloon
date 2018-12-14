local SeedClass = {
    x = 0,
    y = 0,
    width = 20,
    height = 20,
    image = love.graphics.newImage("assets/seed.png"),
    name = "Semilla"
}

SeedClass.__index = SeedClass

function SeedClass:new(name)
    local semilla = {}
    semilla.name = name
    setmetatable(semilla, SeedClass) 
    return semilla
end

function SeedClass:load(world, x, y)
    self.world = world
    self.x = x
    self.y = y
    self.world:add(self.name, self.x, self.y, self.width, self.height)
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