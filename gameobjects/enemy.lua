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
            return "bounce"
        elseif other.isBlock then
            return "bounce"
        elseif other.isSeed then
            return "bounce"
        elseif other.isBomb then
            other:explode()
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
    self.x, self.y, cols, len = self.world:move(self, self.x + self.velocidad_x, self.y)

    if len > 0 then
        local col = cols[1]
        if col.other.isPlayer then
            if not col.other.montado then
                vector = {x = self.velocidad_x * 2, y = 0}
                col.other:empujar(vector, self)
            end

            self.x = self.movSigx
        end
        if col.other.isBlock or col.other.isSeed or col.other.isEnemy then
            self.velocidad_x = self.velocidad_x * -1
        end
    end

    self.x, self.y, cols, len = self.world:move(self, self.x, self.y + self.velocidad_y)

    if len > 0 then
        local col = cols[1]
        if col.other.isPlayer then
            if not col.other.montado then
                vector = {x = 0, y = self.velocidad_y * 2}
                col.other:empujar(vector, self)
            end
            self.y = self.movSigy
        end
        if col.other.isBlock or col.other.isSeed or col.other.isEnemy then
            self.velocidad_y = self.velocidad_y * -1
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
