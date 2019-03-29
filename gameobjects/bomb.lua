local Bomb = {
    name = "Bomb",
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
    width = 40,
    height = 40,
    isBomb = true,
    states = {
        inactive = {
            name = "inactive",
            load = function(self) end,
            update = function(self, dt) end,
            draw = function(self) end
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
                print("PRELAUNCHING LOADED: X = " .. self.x ..", Y = " .. self.y)
                self.world:add(self, self.x, self.y, self.width, self.height)
                self.collisions_filter = function(item, other)
                    return 'cross'
                end
            end,
            update = function(self, dt)
                local target_x  = self.x + self.vx * dt
                local target_y = self.y + self.vy * dt

                self.vy = self.vy + 300 * dt    -- gravedad
                print("BOMB: X = " .. self.x ..", Y = ".. self.y)
                self.x, self.y, cols, len = self.world:move(self, target_x, target_y, self.collisions_filter)
                local inside_player = false   -- con esto indicamos si la bomba ha abandonado o no nuestro cuerpo (para que inicialmente no choque con nosotros)
                for i = 1, len do
                    if cols[i].other.isPlayer then    
                        print("ESTAMOS DENTRO DE PLAYER")
                        inside_player = true
                    else
                        self.change_state(self, self.states.exploding)
                    end
                end
                if not inside_player then
                    print("SALIMOS!")
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
                    self.height/ self.state.quads[1].height
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
                print("LAUNCHING LOADED: X = " .. self.x ..", Y = " .. self.y)
                self.elapsed_time = 0
                self.collisions_filter = function(item, other)
                    return 'bounce'
                end
            end,
            update = function(self, dt)
                local target_x  = self.x + self.vx * dt
                local target_y = self.y + self.vy * dt
                self.vy = self.vy + 300 * dt    -- gravedad

                self.x, self.y, cols, len = self.world:move(self, target_x, target_y, self.collisions_filter)

                -- la bomba explota si toca cualquier cosa (exceptuando un bloque)
                for i = 1, len do
                    if not cols[i].other.isBlock then
                        self.change_state(self, self.states.exploding)
                    end
                end

                -- explosión tras tiempo máximo
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 2.345 then
                    print("COMIENZA A EXPLOTAR")
                    self.change_state(self, self.states.exploding)
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
                    self.height/ self.state.quads[1].height
                )
            end
        },
        exploding = {
            name = "exploding",
            quads = {
                {
                    quad = love.graphics.newQuad(194, 35, 12, 12, atlas:getDimensions()),
                    width = 12,
                    height = 12
                }
            },
            load = function(self) self.elapsed_time = 0 end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 0.5 then
                    self.world:remove(self)
                    self.change_state(self, self.states.inactive)  -- TODO: Provisional
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
                        self.height/ self.state.quads[1].height
                    )
            end
        },
        floor = {
            name = "floor"
        }
    }
}
Bomb.__index = Bomb

function Bomb.new(name)
    local bomb = {}
    bomb.name = name
    bomb.state = Bomb.states.inactive   -- FIXME: Esto deberíamos hacerlo en el método load y no en new
    setmetatable(bomb, Bomb) 
    return bomb
end

function Bomb:load(world)
    self.world = world
    -- TODO: ¿Preferimos que la bomba esté siempre inactiva tras ejecutar load o bien conservamos su estado anterior? De momento hemos comentado:
    -- self.change_state(self, self.states.inactive)
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

function Bomb:launch(x, y, initialDirection)
    if self.state == Bomb.states.inactive then
        self.x = x
        self.y = y
        self:change_state(Bomb.states.prelaunching)
        log.debug("New bomb launched")
        if initialDirection == "up" then
            self.vx  = 0
            self.vy = -350
        elseif initialDirection == "down" then
            self.vx = 0
            self.vy = 350
        else
            log.fatal("initialDirection should be 'up' or 'down'")
        end
    else
        log.debug("New bomb not launched because we already have an active bomb")
    end
end

return Bomb