local Enemy = {
    name = "Enemigo",
    jugador = nil,
    jugadorMontado = false,
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
            if (not col.other.montado) then
                vector = { x = self.velocidad_x , y = 0}
                col.other:empujar(vector, self)
            end
            
            self.x = self.movSigx
        end
    end 
  
    if len > 0 then
        if (cols[1].other.name ~= "Player") then
            self.velocidad_x = self.velocidad_x * -1
        end
    end

    self.x, self.y, cols, len = self.world:move(self, self.x,self.y + self.velocidad_y)

    for i=1,len do -- Checkeamos choque con jugador
        local col = cols[i]
        if (col.other.name == "Player") then
            vector = { x = 0, y = self.velocidad_y}
            if (self.velocidad_y < 0) then
                self.jugadorMontado = true
                self.jugador = col.other
                col.other:montar(self)
            else
                col.other:empujar(vector, self)
            end
            self.y = self.movSigy
        end
    end

    if self.jugadorMontado then
        vector = { x = self.velocidad_x, y = self.velocidad_y}
        self.jugador:empujar(vector, self)
    end

    if len > 0 then
        if (cols[1].other.name ~= "Player") then
            self.velocidad_y = self.velocidad_y * -1
        end
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