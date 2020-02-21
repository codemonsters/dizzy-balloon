local Enemy = {
    name = "Enemigo",
    wipe = false,
    x = 0,
    y = 0,
    riders = {},
    width = 40,
    height = 40,
    speed = math.sqrt(12),
    vx = 0,
    vy = 0,
    isEnemy = true,
    image = love.graphics.newImage("assets/image/old/enemy.png"),
    states = {
        moving = {
            collisionFilter = function(item, other)
                if other.isBlock then
                    return "bounce"
                elseif other.isSeed then
                    return "bounce"
                elseif other.isEnemy then
                    return "bounce"
                elseif other.isMushroom then
                    return "bounce"
                elseif other.isLimit then
                    return "bounce"
                elseif other.isPlayer then
                    return "touch"
                end
            end,
            load = function(self)
                self.vx = math.cos(self.direction) * self.speed
                self.vy = math.sin(self.direction) * self.speed
            end,
            update = function(self, dt)
                local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
                local actualX, actualY, cols, len = self.world:move(self, goalX, goalY, self.state.collisionFilter)
                self.x, self.y = actualX, actualY
                for i = 1, len do
                    local other = cols[i].other
                    if other.isPlayer then
                        other:empujar({x = self.vx * 2, y = self.vy * 2}, self)
                    end
                end
            end,
            draw = function(self, dt)
            end
        },
        swiping = {
            collisionFilter = function(item, other)
                if true then
                    return "slide"
                end
            end,
            load = function(self)
                self.startingSpeed = self.speed
                self.horizontal = true
                self.divingStartingY = 0
                self.bounceCounter = 0
                -- cuenta los choques cuando el enemigo no puede seguir bajando
                self.vx = self.speed
                self.vy = 0
            end,
            update = function(self, dt)
                local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
                local actualX, actualY, cols, len = self.world:move(self, goalX, goalY, self.state.collisionFilter)
                self.x, self.y = actualX, actualY

                if len > 0 then
                    local other = cols[i].other
                    if self.horizontal then
                        for i = 1, len do
                            if other.isBlock or other.isMushroom or other.isSeed then
                                self.speed = self.speed * 1.25
                                local checkX, checkY, checkCols, checkLen = self.world:queryRect(self.x, self.y, self.x + self.width, self.y + self.height * 2, self.state.collisionFilter)
                                if checkLen == 0 then
                                    self.horizontal = false
                                    self.divingStartingY = self.y
                                    self.vx = 0
                                    self.vy = self.speed
                                end
                            elseif other.isPlayer then
                                other:empujar({x = self.vx * 2, y = 0}, self)
                            end
                        end
                    else
                        for i = 1, len do
                            if other.isBlock or other.isMushroom or other.isSeed then
                                self.speed = self.speed * 1.25
                                self.horizontal = true
                                self.divingStartingY = 0
                                self.vx = self.speed
                                self.vy = 0
                                self.bounceCounter = self.bounceCounter + 1
                            elseif other.isPlayer then
                                other:empujar({x = 0, y = self.vy * 2}, self)
                            end
                        end
                        if self.y - self.divingStartingY >= self.height * 2 then
                            self.horizontal = true
                            self.divingStartingY = 0
                            self.vx = self.speed
                            self.vy = 0
                            self.bounceCounter = 0
                        end
                    end
                    
                    if self.bounceCounter >= 3 then
                        self.direction = 45
                        self.speed = self.startingSpeed
                        self.vx, self.vy = self.speed, self.speed
                        self:changeState(self.states.moving)
                    end
                end
            end,
            draw = function(self, dt)
            end
        },
        dying = {
            load = function(self)
            end,
            update = function(self, dt)
            end,
            draw = function(self, dt)
            end
        }
    }
}

Enemy.__index = Enemy

function Enemy.new(name, x, y, world, game, direction)
    local enemy = {}
    enemy.riders = {}
    enemy.name = name
    enemy.game = game
    enemy.world = world
    enemy.dead = false
    enemy.direction = direction
    enemy.x = x
    enemy.y = y
    enemy.world:add(enemy, enemy.x, enemy.y, Enemy.width, Enemy.height)
    setmetatable(enemy, Enemy)
    enemy:changeState(enemy.states.moving)
    return enemy
end

function Enemy:update(dt)
    if self.dead then
        self.game.remove_enemy(self)
        return
    end

    self.state.update(self, dt)

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

function Enemy:changeState(newState)
    if self.state ~= newState then
        self.state = newState
        self.state.load(self)
    end
end

function Enemy:montado(rider)
    table.insert(self.riders, rider)
end

function Enemy:die()
    self.dead = true
end

return Enemy
