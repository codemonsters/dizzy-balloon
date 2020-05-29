local Enemy = {
    wipe = false,
    name = "Enemigo",
    x = 0,
    y = 0,
    riders = nil,
    width = 40,
    height = 40,
    moduloVelocidadInicial = 3,
    moduloVelocidad = 3,
    velocidad_x = 0,
    velocidad_y = 0,
    isEnemy = true,
    image = love.graphics.newImage("assets/images/old/enemy.png"),
    enemyFilter = function(item, other)
        if other.isPlayer then
            return "slide"
        elseif other.isBomb and not other.montado then
            if not other.state == (other.states.launching or other.states.exploding) then
                return
            else
                return "touch"
            end
        elseif other.isBomb and other.montado then
            return "slide"
        elseif other.isMushroom then
            return "bounce"
        elseif other.isLimit then
            return "bounce"
        elseif other.isCloud then
            return "cross"
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
                    if col.other.isBlock or col.other.isSeed or col.other.isEnemy or col.other.isMushroom then
                        self:rebotar(col)
                    elseif col.other.isBomb then
                        if not col.other.state == (col.other.states.launching or col.other.states.exploding) then
                            self:rebotar(col)
                        end
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.velocidad_x - col.other:vx() * dt, y = 0}, self)
                    end
                end
            end,
            draw = function(self, dt)
            end
        },
        swiping = {
            load = function(self)
                self.initalVel = self.moduloVelocidadInicial
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
                            -- aumenta la velocidad cada choque lateral
                            self.moduloVelocidad = self.moduloVelocidad + (self.moduloVelocidad /10)
                            if self.moduloVelocidad > 13 then self.moduloVelocidad = 13 end -- máximo
                            self.velocidad_x = 0
                            self.velocidad_y = self.moduloVelocidad
                        else -- colisión yendo hacia abajo
                            self.upBounceCounter = self.upBounceCounter + 1
                            self.horizontal = true
                            self.velocidad_x = -self.lastXvelocity
                            self.velocidad_y = 0
                        end
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.velocidad_x - col.other:vx() * dt, y = 0}, self)
                    end
                end

                if not self.horizontal then
                    if math.abs(self.yAfterDiving - self.y) >= self.height then
                        self.upBounceCounter = 0 -- reseteamos si el enemigo es capaz de bajar
                        self.horizontal = true
                        if self.lastXvelocity < 0 then
                            self.velocidad_x = self.moduloVelocidad
                        else
                            self.velocidad_x = -self.moduloVelocidad
                        end
                        self.velocidad_y = 0
                    end
                end

                if self.upBounceCounter == 3 then
                    self.direction = 45
                    self.moduloVelocidad = self.moduloVelocidadInicial -- la velocidad vuelve a normal
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
            col:empujar({x = self.velocidad_x - col:vx() * dt, y = 0}, self)
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
