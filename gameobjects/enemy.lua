local Enemy = {
    wipe = false,
    name = "Enemigo",
    x = 0,
    y = 0,
    riders = nil,
    width = 40,
    height = 40,
    moduloVelocidad = math.sqrt(12), -- velocidad inicial (2 unidades en el eje x y 2 en el y a 45º)
    velocidad_x = 0,
    velocidad_y = 0,
    isEnemy = true,
    image = love.graphics.newImage("assets/images/old/enemy.png"),
    enemyFilter = function(item, other)
        if other.isPlayer then
            return "slide"
        elseif other.isBomb then
            return "slide"
        elseif other.isMushroom then
            return "bounce"
        elseif other.isLimit then
            return "bounce"
        else
            return "bounce"
        end
    end,
    states = {
        moving = {
            load = function(self)
                self.velocidad_x = math.cos(self.direction) * self.moduloVelocidad
                self.velocidad_y = math.sin(self.direction) * self.moduloVelocidad
            end,
            update = function(self, dt)
                self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.enemyFilter)

                if len > 0 then
                    local col = cols[1]
                    if col.other.isBlock or col.other.isSeed or col.other.isEnemy or col.other.isMushroom then -- si se pone "if not other.col.isBomb" then da un error cuando el enemigo choca con algo, puede ser problema de la bomba no teniendo un collision_filter o algo por el estilo
                        self:rebotar(col)
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.velocidad_x * 2, y = self.velocidad_y * 2}, self)
                    end
                end
            end,
            draw = function(self, dt)
            end
        },
        swiping = {
            load = function(self)
                self.initalVel = self.moduloVelocidad
                self.horizontal = true
                self.lastXvelocity = self.initalVel
                self.yAfterDiving = 0
                self.upBounceCounter = 0
                -- cuenta los choques cuando el enemigo no puede seguir bajando
                self.velocidad_x = self.initalVel
                self.velocidad_y = 0
            end,
            update = function(self, dt)
                self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.enemyFilter)

                if len > 0 then
                    local col = cols[1]
                    if not col.other.isBomb and not col.other.isPlayer then --col.other.isBlock or col.other.isSeed or col.other.isEnemy or col.other.isMushroom then
                        if self.horizontal then -- colisión yendo hacia arriba
                            self.horizontal = false
                            self.yAfterDiving = self.y
                            self.lastXvelocity = self.velocidad_x
                            self.velocidad_x = 0
                            self.velocidad_y = 4
                        else -- colisión llendo hacia abajo
                            self.upBounceCounter = self.upBounceCounter + 1
                            self.horizontal = true
                            self.velocidad_x = -self.lastXvelocity
                            self.velocidad_y = 0
                        end
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.velocidad_x * 2, y = self.velocidad_y * 2}, self)
                    end
                end

                if not self.horizontal then
                    if math.abs(self.yAfterDiving - self.y) >= self.height then
                        self.upBounceCounter = 0 -- reseteamos si el enemigo es capaz de bajar
                        self.horizontal = true
                        self.velocidad_x = -self.lastXvelocity
                        self.velocidad_y = 0
                    end
                end

                if self.upBounceCounter == 3 then
                    self.direction = 45
                    self:change_state(self.states.moving)
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
    enemy:change_state(enemy.states.moving)
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
        local col = cols[1]
        if col.isPlayer then
            col:empujar({x = self.velocidad_x * 2, y = 0}, self)
        end
    end

    --choques con el eje y
    cols, len = self.world:queryRect(self.x, self.movSigy, self.width, self.height)
    if len > 0 then
        local col = cols[1]
        if col.isPlayer then
            col:empujar({x = 0, y = self.velocidad_y * 2}, self)
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

function Enemy:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function Enemy:montado(rider)
    table.insert(self.riders, rider)
end

function Enemy:die()
    self.dead = true
end

function Enemy:rebotar(col)
    -- TODO: calculo de velocidad tras el choque
    vecBounce = {x = col.bounce.x - col.touch.x, y = col.bounce.y - col.touch.y}
    
    moduloBounce = math.sqrt(math.pow(vecBounce.x, 2) + math.pow(vecBounce.y, 2))
    vectorUnitario = {x = vecBounce.x / moduloBounce, y = vecBounce.y / moduloBounce}

    self.velocidad_x = vectorUnitario.x * self.moduloVelocidad
    self.velocidad_y = vectorUnitario.y * self.moduloVelocidad

    seno = self.velocidad_y / self.moduloVelocidad -- calculo del ángulo con relación a la vertical tras el choque
    anguloEnGradosConVertical = math.asin(seno) * 360 / (2 * math.pi)

    if math.abs(anguloEnGradosConVertical) <= 15 then
        self:change_state(self.states.swiping)
    end
end

return Enemy
