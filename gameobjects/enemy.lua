local Enemy = {
    name = "Enemigo",
    x = 0,
    y = 0,
    width = 40,
    height = 40,
    velocidad_x = 2,
    velocidad_y = 2,
    image = love.graphics.newImage("assets/enemy.png")
}
Enemy.__index = Enemy

function Enemy:new()
    local enemigo = {}
    setmetatable(enemigo, Enemy)
    return enemigo
end


function Enemy:load(x, y, world)
    self.world = world
    self.x = x
    self.y = y

    self.world:add(self, self.x, self.y, self.width, self.height)
end

function Enemy:update(dt)
    self.x, self.y, cols, len = self.world:move(self, self.x + self.velocidad_x,self.y)

    if self.x > WORLD_WIDTH - self.width then
        self.velocidad_x = self.velocidad_x * -1
    end
    if self.x < 0 then
        self.velocidad_x = self.velocidad_x * -1
    end
    self.x, self.y, cols, len = self.world:move(self, self.x,self.y + self.velocidad_y)
    if self.y > WORLD_HEIGHT - self.height then
        self.velocidad_y = self.velocidad_y * -1
    end
    if self.y < 0 then
        self.velocidad_y = self.velocidad_y * -1
    end
end

function Enemy:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.image:getWidth(),
        self.height/ self.image:getHeight())
    love.graphics.print(self.x, 0, 0)
    love.graphics.print(self.y, 50, 0)
end

return Enemy