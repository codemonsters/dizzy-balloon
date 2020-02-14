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
    enemyFilter = function(item, other)
        if     other.isPlayer then return "slide"
        elseif other.isBomb   then return "slide"
        else                       return "bounce"
        end
    end,
    states = {
        moving = {
            load = function(self)
                self.vx = math.cos(self.direction) * speed
                self.vy = math.sin(self.direction) * speed
            end,
            update = function(self, dt)
                self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.enemyFilter)
                if len > 0 then
                    local col = cols[1]
                    if col.other.isBlock or col.other.isSeed or col.other.isEnemy or col.other.isMushroom then
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
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.vx * 2, y = self.vy * 2}, self)
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