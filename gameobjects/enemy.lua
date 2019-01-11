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
    self.movSigx = self.x + self.velocidad_x;
    self.movSigy = self.y + self.velocidad_y;
    self.x, self.y, cols, len = self.world:move(self, self.x + self.velocidad_x, self.y )
    
    for i=1,len do -- Checkeamos choque con jugador
        local col = cols[i]
        if (col.other.name == "Player") then
            col.other:empujar("x", self)
            self.x = self.movSigx
        end
    end 
  
    if len > 0 then
        if (cols[1].other.name ~= "Player") then
            self.velocidad_x = self.velocidad_x * -1
        end
    end

    if self.x > WORLD_WIDTH - self.width and self.velocidad_x > 0 then
        self.velocidad_x = self.velocidad_x * -1
    end
    if self.x < 0 and self.velocidad_x < 0 then
        self.velocidad_x = self.velocidad_x * -1
    end

    self.x, self.y, cols, len = self.world:move(self, self.x,self.y + self.velocidad_y)

    for i=1,len do -- Checkeamos choque con jugador
        local col = cols[i]
        if (col.other.name == "Player") then
            col.other:empujar("y", self)
            self.y = self.movSigy
        end
    end

    if len > 0 then
        if (cols[1].other.name ~= "Player") then
            self.velocidad_y = self.velocidad_y * -1
        end
    end

    if self.y > WORLD_HEIGHT - self.height and self.velocidad_y > 0 then
        self.velocidad_y = self.velocidad_y * -1
    end
    if self.y < 0 and self.velocidad_x < 0 then
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