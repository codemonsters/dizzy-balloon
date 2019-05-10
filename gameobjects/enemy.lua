local Enemy = {
    name = "Enemigo",
    x = 0,
    y = 0,
    riders = nil,
    width = 40,
    height = 40,
    velocidad_x = 2,
    velocidad_y = 2,
    isEnemy = true,
    image = love.graphics.newImage("assets/enemy.png"),
    enemyFilter = function(item, other)
        if other.isPlayer then
            return "slide"
        elseif other.isBomb then
            return "slide"
        else
            return "bounce"
        end
    end
}
Enemy.__index = Enemy

function Enemy.new(name, x, y, world, game)
    local enemy = {}
    enemy.riders = {}
    enemy.name = name
    enemy.game = game
    enemy.world = world
    enemy.dead = false
    enemy.x = x
    enemy.y = y
    world:add(enemy, enemy.x, enemy.y, Enemy.width, Enemy.height)
    setmetatable(enemy, Enemy)
    return enemy
end

function Enemy:update(dt)
    if self.dead then
        self.game.remove_enemy(self)
        return
    end
    self.movSigx = self.x + self.velocidad_x
    self.movSigy = self.y + self.velocidad_y

    --vemos si hay algún choque con el eje x
    cols, len = self.world:queryRect(self.movSigx, self.y, self.width, self.height)
    if len > 0 then
        for i = 1, len do
            --print(cols[i].name)
        end
        local col = cols[1]
        if col.isPlayer then
            col:empujar({x = self.velocidad_x*2, y = 0}, self);
        end
    end

    --choques con el eje y
    cols, len = self.world:queryRect(self.x, self.movSigy, self.width, self.height)
    if len > 0 then
        local col = cols[1]
        if col.isPlayer then
            col:empujar({x = 0, y = self.velocidad_y*2}, self);
        end
    end

    if table.getn(self.riders) > 0 then
        for key, rider in ipairs(self.riders) do
            if not rider.montado then -- eliminar de la tabla riders los que se desmonten
                table.remove(self.riders, key)
            else
                vector = {x = self.velocidad_x, y = self.velocidad_y}
                rider:empujar(vector, self)
            end
        end
    end
    
    self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.enemyFilter)

    if len > 0 then
        local col = cols[1]
        if col.other.isBlock or col.other.isSeed or col.other.isEnemy then
            vecBounce = {x = col.bounce.x - col.touch.x, y = col.bounce.y - col.touch.y}
            modulo = math.sqrt(math.pow(vecBounce.x, 2) + math.pow(vecBounce.y, 2))
            vectorUnitario = {x = 0, y = 0}
            vectorUnitario.x = vecBounce.x / modulo
            vectorUnitario.y = vecBounce.y / modulo
            self.velocidad_x = vectorUnitario.x * 4
            self.velocidad_y = vectorUnitario.y * 4
        elseif col.other.isPlayer then
            col.other:empujar({x = self.velocidad_x*2, y = self.velocidad_y*2}, self);
        end
    end
end

function Enemy:draw()

    if self.dead then
        return
    end
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.image:getWidth(),
        self.height / self.image:getHeight()
    )
end

function Enemy:montado(rider)
    table.insert(self.riders, rider)
end

function Enemy:die()
    self.dead = true
end

return Enemy
