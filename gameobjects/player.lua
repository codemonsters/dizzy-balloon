local Player = {
    name = "Player",
    width = 40,
    height = 40,
    velyini = -0.5,
    montado = false,
    montura = nil,
    isPlayer = true,
    states = {
        standing = {
            quads = {
                {
                    quad = love.graphics.newQuad(8, 14, 18, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                }
            },
            load = function(self) self.current_frame = 1 end,
            update = function(self, dt) end
        },
        walking = {
            quads = {
                {
                    quad = love.graphics.newQuad(40, 13, 17, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                },
                {
                    quad = love.graphics.newQuad(72, 14, 18, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                },
                {
                    quad = love.graphics.newQuad(6, 45, 20, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                },
                {
                    quad = love.graphics.newQuad(72, 14, 18, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                }
            },
            load = function(self)
                self.current_frame = 1
                self.elapsed_time = 0
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 0.1 then
                    self.elapsed_time = 0
                    self.current_frame = self.current_frame + 1
                    if self.current_frame > 4 then self.current_frame = 1 end
                end
            end
        },
        jumping = {
            quads = {
                {
                    quad = love.graphics.newQuad(40, 13, 17, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                }
            },
            load = function(self) self.current_frame = 1 end,
            update = function(self, dt) end
        }
    }
}

Player.__index = Player

function Player:new()
    local jugador = {}
    setmetatable(jugador, Player)
    return jugador
end

function Player:load(world, game)
    self.game = game
    self.offset = 0
    self.direccion = 1
    self.world = world
    self.width = 40
    self.height = Player.width
    self.x = 1
    self.y = WORLD_HEIGHT - self.height
    self.velocidad_y = self.velyini --la velocidad y debe ser negativa para que haya diferencia en el movimiento de eje y para saber cuando aplicar aceleración
    self.left, self.right, self.up, self.down, self.jumping = false, false, false, false, false
    -- self.state = Player.states.standing
    self.change_state(self, Player.states.standing)
    self.current_frame = 1
    self.world:add(self, self.x, self.y, self.width, self.height)
end

function Player:update(dt)
    if self.left then
        self.x, self.y, cols, len = self.world:move(self, self.x - 3,self.y)
    end
    if self.right then
        self.x, self.y, cols, len = self.world:move(self, self.x + 3,self.y)
    end
    self.x, ydespues, cols, len = self.world:move(self, self.x, self.y - self.velocidad_y)
    
    if (len > 0) then
        if (cols[1].other.name == "Enemigo" and not self.montado) then
            if (cols[1].other.y - self.y > self.width) then
                self.montado = true
                self.montura = cols[1].other
                self.y = self.montura.y - self.height
                self.montura:montado(self)
            end
        end
    end

    --El jugador aumenta constantemente la velocidad y, pero se resetea cada vez que toca el suelo o un enemigo cayendo
    if ydespues == self.y - self.velocidad_y then --debería caer si se consiguió mover en el eje y
        
        if (self.montado) then
            if (self.montura.x - self.x > self.montura.width or self.montura.x - self.x < - self.montura.width) then        
                self:desmontar()
            end
        else
            self.velocidad_y = self.velocidad_y - 9.8 * dt
            self.jumping = true
        end

    end
    
    if (self.montado == false) then
        self.y = ydespues
    end

    if self.velocidad_y < 0 and len > 0 then --si hay colision al bajar en el eje y
        self.velocidad_y = self.velyini
        self.jumping = false
    end

    -- actualización del estado del jugador
    if self.jumping then
        self.change_state(self, Player.states.jumping)
        if len > 0 and self.velocidad_y > 0 then -- si hay un choque en medio de un salto llendo hacia arriba, te das un cabezazo
            self:cabezazo();
        end
    else
        if self.left or self.right then
            -- self.state = self.states.walking
            self.change_state(self, Player.states.walking)
        else
            -- self.state = self.states.standing
            self.change_state(self, Player.states.standing)
        end
    end
    self.state.update(self, dt)
end

function Player:cabezazo()
    self.x, self.y, cols, len = self.world:move(self, self.x, self.y + 2)
    self.velocidad_y = -4
end

function Player:draw()
    love.graphics.setColor(255, 255, 255, 255)

    -- TODO: eliminar offset y dibujar todos los frames del mismo tamaño
    if self.right then
        self.direccion = 1
        self.offset = 0
    end
    if self.left then
        self.direccion = -1
        self.offset = self.width
    end

    love.graphics.draw(
        atlas,
        self.state.quads[self.current_frame].quad,
        self.x + self.offset,
        self.y,
        0,
        self.width / self.state.quads[self.current_frame].width * self.direccion,
        self.height/ self.state.quads[self.current_frame].height
    )
    --[[
    love.graphics.draw(
        self.state.quads[1], -- TODO: Cambiar la imagen del sprite según su estado
        self.x,
        self.y,
        0
    
        self.width / self.state.quads[1]:getWidth(),
        self.height/ self.state[1]:getHeight()
    )
    --]]
end

function Player:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function Player:jump()
    if not self.jumping then
        self.jumping = true
        self.velocidad_y = 5

        if (self.montado) then
            self:desmontar()
        end
    end
end

function Player:empujar(vector, empujador)
    if vector.x ~= 0 then
        self.x, self.y, cols, len = self.world:move(self, self.x + vector.x, self.y)

        if (len > 0) then --hay una colision con otra cosa al intentar moverlo, debe morir
            xtest, self.y, cols, len = self.world:move(self, self.x - vector.x, self.y)
            if (math.abs(xtest - self.x) <= 0.5) then --si no puede retroceder una distancia, se considera estrujado
                self:morir()
            end
        end
    end
    if vector.y ~= 0 then --Si se da en el eje y siempre va a ser hacia arriba
        self.velocidad_y = 0

        self.x, self.y, cols, len = self.world:move(self, self.x, self.y + vector.y)

        if (len > 0) then --hay una colision con otra cosa al intentar moverlo
            self.x, ytest, cols, len = self.world:move(self, self.x, self.y - vector.y)
            if (math.abs(ytest - self.y) <= 0.5) then --si no puede retroceder una distancia, se considera estrujado
                self:morir()
            end
        end

        self.jumping = false

        self.velocidad_y = self.velyini
    end
end

function Player:desmontar()
    self.montura.jugadorMontado = false
    self.montado = false
end

function Player:morir()
    self.game.vidaperdida()
end

return Player