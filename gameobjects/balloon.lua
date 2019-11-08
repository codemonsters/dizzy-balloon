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
            --elseif other.isSeed and other.state ~= other.states.falling then
            --    return "touch"
            return nil
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
                self.expansion_duration = 2
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
                    if self.rider then  
                        self.change_state(self, self.states.flying_with_pilot)
                    else 
                        self.change_state(self, self.states.flying_alone)
                    end 
                else
                    --local incrementoDeArea = 50
                    --local items, len = world:queryRect(self.x - incrementoDeArea/2, self.y - incrementoDeArea/2, self.width + incrementoDeArea, self.height + incrementoDeArea)
                    --colisiones con la zona de arriba del globo
                    --for i = 1, len do
                    --    if items[i].isPlayer then -- le hacemos rebotar para que no se quede atrapado
                    --        items[i]:empujar({x = (items[i].x - self.x), y = (items[i].y - self.y)}, self);
                    --        print(items[i].x - self.x)
                    --        print(items[i].y - self.y)
                    --    end
                    --end
                    self.x_scale_factor =
                        1 + (self.final_width / self.initial_width - 1) * self.elapsed_time / self.expansion_duration
                    self.current_width = self.initial_width * self.x_scale_factor

                    self.y_scale_factor =
                        1 + (self.final_height / self.initial_height - 1) * self.elapsed_time / self.expansion_duration
                    self.current_height = self.initial_height * self.y_scale_factor

                    self.old_y = self.current_y

                    self.current_x = self.x - (self.current_width - self.initial_width) / 2
                    self.current_y = self.y - (self.current_height - self.initial_height)

                    -- Escalamos, movemos y comprobamos colisiones

                    self.world:update(self, self.current_x, self.current_y, self.current_width, self.current_height)
                    local x, y, cols, len =
                        self.world:check(self, self.current_x, self.current_y, self.collisions_filter)
                    for i = 1, len do
                        if cols[i].other.isPlayer then
                            -- desplazamos al jugador
                            local shift_y = self.current_y - self.old_y
                            cols[i].other:translate(0, shift_y * 2)
                        end
                    end
                end
            end,
            draw = function(self)
                self.x_scale =
                    self.x_scale_factor * self.x_scale_factor * self.state.quads[1].width / self.current_width
                self.y_scale =
                    self.y_scale_factor * self.y_scale_factor * self.state.quads[1].height / self.current_height
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
                    if not col.other.isBomb then -- col.other.isBlock or col.other.isSeed or col.other.isEnemy then
                        vecBounce = {x = col.bounce.x - col.touch.x, y = col.bounce.y - col.touch.y}

                        moduloBounce = math.sqrt(math.pow(vecBounce.x, 2) + math.pow(vecBounce.y, 2))
                        vectorUnitario = {x = vecBounce.x / moduloBounce, y = vecBounce.y / moduloBounce}

                        self.velocidad_x = vectorUnitario.x * self.state.moduloVelocidad
                        self.velocidad_y = vectorUnitario.y * self.state.moduloVelocidad
                    elseif col.other.isPlayer then
                        col.other:empujar({x = self.velocidad_x * 2, y = self.velocidad_y * 2}, self)
                    end
                end
            end,
            draw = function(self)
                love.graphics.draw(atlas, self.state.quads[1].quad, self.x, self.y, 0, self.x_scale, self.y_scale)
            end
        },
        flying_with_pilot = {
            moduloVelocidad = math.sqrt(8) * 0.75,
            vx = function(self)
                local vx_factor = 0
                if self.rider.left then
                    vx_factor = -1
                end
                if self.rider.right then
                    vx_factor = 1
                end

                return vx_factor * self.state.moduloVelocidad
            end,
            vy = function(self)
                local vy_factor = 0
                if self.rider.down then
                    vy_factor = 1
                end
                if self.rider.up then
                    vy_factor = -1
                end

                return vy_factor * self.state.moduloVelocidad
            end,
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
                if not self.rider.montado then
                    self:change_state(self.states.flying_alone)
                    return
                end

                --movimento en el eje x e y
                self.x, self.y, cols, len =
                    self.world:move(
                    self,
                    self.x + self.state.vx(self),
                    self.y + self.state.vy(self),
                    self.collisions_filter
                )
                self.rider.x, self.rider.y, cols, len =
                    self.rider.world:move(
                    self.rider,
                    self.rider.x + self.state.vx(self),
                    self.rider.y + self.state.vy(self),
                    self.rider.collisions_filter
                )
            end,
            draw = function(self)
                love.graphics.draw(atlas, self.state.quads[1].quad, self.x, self.y, 0, self.x_scale, self.y_scale)
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
            draw = function(self)
            end
        }
    }
}

BalloonClass.__index = BalloonClass

function BalloonClass.new(seed, world, game)
    --print("SEED = " .. seed.name .. "; world = " .. world.name .. "; game = " .. game)
    local balloon = {}
    balloon.rider = nil
    balloon.x = seed.x
    balloon.y = seed.y
    balloon.game = game
    balloon.name = name
    balloon.dead = false
    balloon.world = world
    balloon.current_frame = 1
    setmetatable(balloon, BalloonClass)
    balloon.world:add(balloon, seed.x, seed.y, seed.width, seed.height)
    balloon.change_state(balloon, BalloonClass.states.growing)
    return balloon
end

function BalloonClass:montado(player)
    self.rider = player
    if self.state == self.states.flying_alone then
        self:change_state(BalloonClass.states.flying_with_pilot)
    end
end

function BalloonClass:update(dt)
    if self.dead then
        self.game.remove_balloon(self)
        return
    end
    self.state.update(self, dt)
end

function BalloonClass:draw()
    if self.dead then
        return
    end
    self.state.draw(self)
end

function BalloonClass:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function BalloonClass:die()
    self.dead = true
end

return BalloonClass
