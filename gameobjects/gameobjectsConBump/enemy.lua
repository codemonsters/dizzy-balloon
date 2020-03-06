local Enemy = {
    name = "Enemigo",
    wipe = false,
    x = 0,
    y = 0,
    width = 40,
    height = 40,
    speed = 300,
    vx = 0,
    vy = 0,
    isEnemy = true,
    image = love.graphics.newImage("assets/images/old/enemy.png"),
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
                    return
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
                        other:empujar({x = self.vx * dt, y = self.vy * dt}, self, dt)
                    else
                        local vecBounce = {x = cols[i].bounce.x - cols[i].touch.x, y = cols[i].bounce.y - cols[i].touch.y}
                        local moduloBounce = math.sqrt(math.pow(vecBounce.x, 2) + math.pow(vecBounce.y, 2))
                        local vectorUnitario = {x = vecBounce.x / moduloBounce, y = vecBounce.y / moduloBounce}
                        self.vx = vectorUnitario.x * self.speed
                        self.vy = vectorUnitario.y * self.speed
                        if math.abs(((math.asin(self.vy / self.speed) * 360) / (2 * math.pi))) <= 20 then
                            self:changeState(self.states.swiping)
                        end
                    end
                end
            end,
            draw = function(self, dt)
            end
        },
        swiping = {
            collisionFilter = function(item, other)
                if other.isPlayer then
                    return
                else
                    return "touch"
                end
            end,
            queryFilter = function(item)
                if item.isGoal then
                    return false
                else
                    return true
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
                self.x, self.y, cols, len = self.world:move(self, self.x + self.vx * dt, self.y + self.vy * dt, self.state.collisionFilter)

                if len > 0 then
                    local col = cols[1]
                    if not col.other.isBomb and not col.other.isPlayer then
                        if self.horizontal then
                            self.speed = -self.speed * 1.15
                            self.horizontal = false
                            self.divingStartingY = self.y
                            self.vx = 0
                            self.vy = math.abs(self.speed)
                        else
                            self.bounceCounter = self.bounceCounter + 1
                            self.horizontal = true
                            self.vx = self.speed
                            self.vy = 0
                        end
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.vx * dt, y = self.vy * dt}, self, dt)
                    end
                end

                if not self.horizontal then
                    if self.y - self.divingStartingY >= self.height * 2 then
                        self.bounceCounter = 0
                        self.horizontal = true
                        self.vx = self.speed
                        self.vy = 0
                    end
                end

                if self.bounceCounter > 3 then
                    self.direction = 45
                    self.speed = self.startingSpeed
                    self:changeState(self.states.moving)
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
        self.game.removeEnemy(self)
        return
    end

    self.state.update(self, dt)
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

function Enemy:die()
    self.dead = true
end

return Enemy
