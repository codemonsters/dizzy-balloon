local BalloonClass = {
    name = "BalloonClass",
    x = 0,
    y = 0,
    vx = 10,
    vy = 0,
    width = 40,
    height = 40,
    isBalloon = true,
    
    collisions_filter = function(item, other)
        if other.isBomb and other.state ~= other.states.planted then
            return nil
        --elseif other.isSeed and other.state ~= other.states.falling then
        --    return "touch"
        else
            return "bounce"
        end
    end,

    states = {
        growing = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
                self.elapsed_time = 0
                self.expansion_duration = 0.1
                self.initial_width = 16
                self.initial_height = 16
                self.final_width = 40
                self.final_height = 40
                self.x_scale_factor = 1
                self.y_scale_factor = 1
                self.current_x = self.x
                self.current_y = self.y
                self.current_width = self.initial_width
                self.current_height = self.initial_height
                self.current_frame = 1
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt

                if self.elapsed_time > self.expansion_duration then
                    self.x = self.current_x
                    self.y = self.current_y
                    self.width = self.final_width
                    self.height = self.final_height
                    self.change_state(self, self.states.flying_alone)
                else
                    self.x_scale_factor =
                        1 + (self.final_width / self.initial_width - 1) * self.elapsed_time / self.expansion_duration
                    self.current_width = self.initial_width * self.x_scale_factor

                    self.y_scale_factor =
                        1 + (self.final_height / self.initial_height - 1) * self.elapsed_time / self.expansion_duration
                    self.current_height = self.initial_height * self.y_scale_factor

                    self.current_x = self.x - (self.current_width - self.initial_width) / 2
                    self.current_y = self.y - (self.current_height - self.initial_height)

                    -- Escalamos, movemos y comprobamos colisiones
                    self.world:update(self, self.current_x, self.current_y, self.current_width, self.current_height)
                end
            end,
            draw = function(self)
                self.x_scale =
                    self.x_scale_factor * self.x_scale_factor * self.state.quads[1].width /
                    self.current_width
                self.y_scale =
                    self.y_scale_factor * self.y_scale_factor * self.state.quads[1].height /
                    self.current_height
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.current_x,
                    self.current_y,
                    0,
                    self.x_scale,
                    self.y_scale
                )
            end
        },
        flying_alone = {
            moduloVelocidad = math.sqrt(8), -- 2 unidades en el eje x y 2 en el y a 45º
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
                self.velocidad_x = math.cos(90) * self.state.moduloVelocidad
                self.velocidad_y = math.sin(90) * self.state.moduloVelocidad
            end,
            update = function(self, dt)
                self.movSigx = self.x + self.velocidad_x
                self.movSigy = self.y + self.velocidad_y
                self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.collisions_filter)

                if len > 0 then
                    local col = cols[1]
                    if col.other.isBlock or col.other.isSeed or col.other.isEnemy then --calculo de velocidad tras el choque TODO: hacerlo mejor
                        vecBounce = {x = col.bounce.x - col.touch.x, y = col.bounce.y - col.touch.y}
                        
                        moduloBounce = math.sqrt(math.pow(vecBounce.x, 2) + math.pow(vecBounce.y, 2))
                        vectorUnitario = {x = vecBounce.x / moduloBounce, y = vecBounce.y / moduloBounce}
            
                        self.velocidad_x = vectorUnitario.x * self.state.moduloVelocidad
                        self.velocidad_y = vectorUnitario.y * self.state.moduloVelocidad
                        
                        seno = self.velocidad_y/self.state.moduloVelocidad -- calculo del ángulo con relación a la vertical tras el choque
                        anguloEnGradosConVertical = math.asin(seno) * 360/(2*math.pi)

                        if math.abs(anguloEnGradosConVertical) <= 15 then
                            self:change_state(self.states.swiping)
                        end
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.velocidad_x*2, y = self.velocidad_y*2}, self);
                    end
                end
            end,
            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.x,
                    self.y,
                    0,
                    self.x_scale,
                    self.y_scale
                )
            end
        },
        flying_with_pilot = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
            
            end,
            update = function(self, dt)
                
            end,

            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.x,
                    self.y,
                    0,
                    self.x_scale,
                    self.y_scale
                )
            end
        },
        dying = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
            
            end,
            update = function(self, dt)
                
            end,
            draw = function(self) end
        }


    }
}

BalloonClass.__index = BalloonClass

function BalloonClass.new(seed, world, game)
    --print("SEED = " .. seed.name .. "; world = " .. world.name .. "; game = " .. game)
    local balloon = {}
    balloon.x = seed.x
    balloon.y = seed.y
    balloon.game = game
    balloon.name = name
    balloon.world = world
    balloon.current_frame = 1
    setmetatable(balloon, BalloonClass)
    balloon.world:add(balloon, seed.x, seed.y, seed.width, seed.height)
    balloon.change_state(balloon, BalloonClass.states.growing)
    return balloon
end

function BalloonClass:montado(player)
    self.change_state(self, BalloonClass.states.flying_with_pilot)
end

function BalloonClass:update(dt)
    self.state.update(self, dt)
end

function BalloonClass:draw()
    self.state.draw(self)
end

function BalloonClass:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function BalloonClass:die()
end

return BalloonClass
