local Bomb = {
    name = "Bomb",
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
    width = 40,
    height = 40,
    isBomb = true,
    montado = false,
    montura = nil,
    lastExplosionHits = 0,
    states = {
        inactive = {
            name = "inactive",
            load = function(self)
            end,
            update = function(self, dt)
            end,
            draw = function(self)
            end
        },
        planted = {
            name = "planted",
            quads = {
                {
                    quad = love.graphics.newQuad(194, 18, 12, 12, atlas:getDimensions()),
                    width = 12,
                    height = 12
                }
            },
            load = function(self)

                local items, len = world:queryRect(self.x, self.y + self.height, self.width, self.height)
                for i = 1, len do
                    if items[i].isEnemy then
                        self.montado = true
                        self.montura = items[i]
                        self.y = self.montura.y - self.height
                        self.montura:montado(self)
                    end
                end
                self.world:add(self, self.x, self.y, self.width, self.height)
                self.elapsed_time = 0
                self.collisions_filter = function(item, other)
                    if other.isGoal then
                        return
                    else
                        return "slide"
                    end
                end
            end,
            update = function(self, dt)
                -- explosión tras tiempo máximo
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 2.345 then
                    self:explode()
                end
            end,
            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.x,
                    self.y,
                    0,
                    self.width / self.state.quads[1].width,
                    self.height / self.state.quads[1].height
                )

            end
        },
        prelaunching = {
            -- Usamos este estado mientras la bomba no ha abandonado nuestro cuerpo
            name = "prelaunching",
            quads = {
                {
                    quad = love.graphics.newQuad(194, 18, 12, 12, atlas:getDimensions()),
                    width = 12,
                    height = 12
                }
            },
            load = function(self)
                self.world:add(self, self.x, self.y, self.width, self.height)
                self.collisions_filter = function(item, other)
                    if other.isGoal then
                        return nil
                    else
                        return "cross"
                    end
                end
            end,
            update = function(self, dt)
                local target_x = self.x + self.vx * dt
                local target_y = self.y + self.vy * dt

                self.x, self.y, cols, len = self.world:move(self, target_x, target_y, self.collisions_filter)
                local inside_player = false -- con esto indicamos si la bomba ha abandonado o no nuestro cuerpo (para que inicialmente no choque con nosotros)
                
                for i = 1, len do
                    if cols[i].other.isPlayer then
                        inside_player = true 
                    else
                        self:explode()
                    end
                end
                if not inside_player then
                    self.change_state(self, self.states.launching)
                end
            end,
            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.x,
                    self.y,
                    0,
                    self.width / self.state.quads[1].width,
                    self.height / self.state.quads[1].height
                )
            end
        },
        launching = {
            name = "launching",
            quads = {
                {
                    quad = love.graphics.newQuad(194, 18, 12, 12, atlas:getDimensions()),
                    width = 12,
                    height = 12
                }
            },
            load = function(self)
                self.elapsed_time = 0
                self.collisions_filter = function(item, other)
                    if other.isBlock  or other.isLimit then
                        self.vx = -0.6 * self.vx
                    elseif other.isGoal then
                        return nil
                    end
                    
                    return "slide"
                end
            end,
            update = function(self, dt)
                local target_x = self.x + self.vx * dt
                local target_y = self.y + self.vy * dt
                self.vy = self.vy + (9.8 * dt) * 50 -- gravedad

                self.x, self.y, cols, len = self.world:move(self, target_x, target_y, self.collisions_filter)
                
                -- la bomba explota si toca cualquier cosa (exceptuando un bloque)
                for i = 1, len do
                    if not cols[i].other.isBlock then
                        self:explode()
                    end
                end

                -- explosión tras tiempo máximo
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 2.345 then
                    self:explode()
                end
            end,
            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.x,
                    self.y,
                    0,
                    self.width / self.state.quads[1].width,
                    self.height / self.state.quads[1].height
                )
            end
        },
        exploding = {
            name = "exploding",
            quads = {
                {
                    quad = love.graphics.newQuad(402, 14, 22, 30, atlas:getDimensions()),
                    width = 22,
                    height = 30
                },
                {
                    quad = love.graphics.newQuad(441, 13, 22, 31, atlas:getDimensions()),
                    width = 22,
                    height = 31
                },
                {
                    quad = love.graphics.newQuad(519, 11, 31, 32, atlas:getDimensions()),
                    width = 31,
                    height = 32
                },
                {
                    quad = love.graphics.newQuad(396, 50, 35, 36, atlas:getDimensions()),
                    width = 35,
                    height = 36
                },
                {
                    quad = love.graphics.newQuad(436, 50, 36, 36, atlas:getDimensions()),
                    width = 36,
                    height = 36
                },
                {
                    quad = love.graphics.newQuad(515, 50, 39, 37, atlas:getDimensions()),
                    width = 39,
                    height = 37
                },
                {
                    quad = love.graphics.newQuad(395, 91, 39, 37, atlas:getDimensions()),
                    width = 39,
                    height = 37
                },
                {
                    quad = love.graphics.newQuad(434, 89, 39, 37, atlas:getDimensions()),
                    width = 39,
                    height = 37
                },
                {
                    quad = love.graphics.newQuad(475, 90, 38, 36, atlas:getDimensions()),
                    width = 38,
                    height = 36
                },
                {
                    quad = love.graphics.newQuad(514, 90, 38, 36, atlas:getDimensions()),
                    width = 38,
                    height = 36
                }
            },
            load = function(self)
                self.elapsed_time = 0
                self.explosion_duration = 0.7
                self.initial_width = 40
                self.initial_height = 40
                self.final_width = 200
                self.final_height = 200
                self.x_scale_factor = 1
                self.y_scale_factor = 1
                self.current_x = self.x
                self.current_y = self.y
                self.current_width = self.initial_width
                self.current_height = self.initial_height
                self.current_frame = 1
                self.collisions_filter = function(item, other)
                    if other.isBlock or other.isLimit then
                        return nil
                    elseif other.isGoal then
                        return nil
                    else
                        return "cross"
                    end
                end
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt

                if self.elapsed_time > self.explosion_duration then
                    self.world:remove(self)
                    self.change_state(self, self.states.afterExplosion)
                else
                    self.current_frame = math.floor(1 + #self.state.quads * self.elapsed_time / self.explosion_duration)

                    self.x_scale_factor =
                        1 + (self.final_width / self.initial_width - 1) * self.elapsed_time / self.explosion_duration
                    self.current_width = self.initial_width * self.x_scale_factor

                    self.y_scale_factor =
                        1 + (self.final_height / self.initial_height - 1) * self.elapsed_time / self.explosion_duration
                    self.current_height = self.initial_height * self.y_scale_factor

                    self.current_x = self.x - (self.current_width - self.initial_width) / 2
                    self.current_y = self.y - (self.current_height - self.initial_height) / 2

                    -- Escalamos, movemos y comprobamos colisiones
                    self.world:update(self, self.current_x, self.current_y, self.current_width, self.current_height)
                    local x, y, cols, len =
                        self.world:check(self, self.current_x, self.current_y, self.collisions_filter)
                    for i = 1, len do
                        if not cols[i].other.isBlock and not cols[i].other.isGoal and not cols[i].other.isLimit then
                            log.debug("La explosión ha alcanzado a: " .. cols[i].other.name)
                            self.game.kill_object(cols[i].other)
                            self.lastExplosionHits = self.lastExplosionHits + 1
                        end
                    end
                end
            end,
            draw = function(self)
                local x_scale =
                    self.x_scale_factor * self.x_scale_factor * self.state.quads[self.current_frame].width /
                    self.current_width
                local y_scale =
                    self.y_scale_factor * self.y_scale_factor * self.state.quads[self.current_frame].height /
                    self.current_height
                love.graphics.draw(
                    atlas,
                    self.state.quads[self.current_frame].quad,
                    self.current_x,
                    self.current_y,
                    0,
                    x_scale,
                    y_scale
                )
                love.graphics.rectangle("line", self.current_x, self.current_y, self.current_width, self.current_height)
            end
        },
        afterExplosion = {
            name = "after explosion",
            load = function(self)
                if self.lastExplosionHits == 0 then
                    self.game.crearSeta(self.x, self.y)
                end
                self.lastExplosionHits = 0
                self.change_state(self, self.states.inactive)
            end
        },
        floor = {
            name = "floor"
        }
    }
}
Bomb.__index = Bomb

function Bomb.new(name, game)
    local bomb = {}
    bomb.game = game
    bomb.name = name
    bomb.state = Bomb.states.inactive
    bomb.world = world
    bomb.current_frame = 1
    bomb.lastExplosionHits = 0
    setmetatable(bomb, Bomb)
    bomb.change_state(bomb, bomb.states.inactive)
    return bomb
end

function Bomb:update(dt)
    self.state.update(self, dt)
end

function Bomb:draw()
    self.state.draw(self)
end

function Bomb:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function Bomb:launch(x, y, initialDirection, playerVx, playerVy)
    if self.state == Bomb.states.inactive then
        self.x = x
        self.y = y
        --log.debug("New bomb launched")
        if initialDirection == "up" then
            self:change_state(Bomb.states.prelaunching)
            self.vx = 0 + playerVx
            self.vy = -350 + playerVy
            if self.vy > -350 then
                self.vy = -350
            end

            if self.vy < -500 then
                self.vy = -500
            end
        elseif initialDirection == "down" then
        self:change_state(Bomb.states.planted)
            self.vx = 0
            self.vy = 0
        else
            log.fatal("initialDirection should be 'up' or 'down'")
        end
    --else
        --log.debug("New bomb not launched because we already have an active bomb")
    end
end

function Bomb:explode()
    if self.state ~= Bomb.states.exploding then
        self.change_state(self, self.states.exploding)
    end
    if self.montado then
        self.montado = false
    end
end

function Bomb:empujar(vector, empujador)
    if vector.x ~= 0 then
        self.x, self.y, cols, len = self.world:move(self, self.x + vector.x, self.y, self.collisions_filter)
    end
    if vector.y ~= 0 then --Si se da en el eje y siempre va a ser hacia arriba
        self.vy = 0
        self.x, self.y, cols, len = self.world:move(self, self.x, self.y + vector.y, self.collisions_filter)
    end
end

return Bomb
