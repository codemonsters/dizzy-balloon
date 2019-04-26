local Player = {
    name = "Player",
    width = 40,
    height = 40,
    velyini = -0.5,
    montado = false, -- TODO: eliminar montado, usar montura como boolean
    montura = nil,
    isPlayer = true,
    vx = function(self)
        local vx_factor = 0
        if self.left then
            vx_factor = -1
        end
        if self.right then
            vx_factor = 1
        end
        return vx_factor * 180
    end,
    vy = function(self)
        return -self.velocidad_y * 80 -- TODO: Eliminar el campo velocidad_y para que solo se use el método self.vy() y eliminar así código repetido
    end,
    collisions_filter = function(item, other)
        if other.isBomb and not other.directionDown then
            return nil
        else
            return "slide"
        end
    end,
    states = {
        standing = {
            quads = {
                {
                    quad = love.graphics.newQuad(8, 14, 18, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                }
            },
            load = function(self)
                self.current_frame = 1
            end,
            update = function(self, dt)
            end
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
                    if self.current_frame > 4 then
                        self.current_frame = 1
                    end
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
            load = function(self)
                self.current_frame = 1
            end,
            update = function(self, dt)
            end
        }
    }
}

Player.__index = Player

function Player.new(world, game)
    local player = {}
    setmetatable(player, Player)
    player.game = game
    player.world = world
    player.width = 40
    player.height = Player.width
    player.x = 1
    player.y = WORLD_HEIGHT - Player.height
    player.velocidad_y = Player.velyini --la velocidad y debe ser negativa para que haya diferencia en el movimiento de eje y para saber cuando aplicar aceleración
    player.left, player.right, player.up, player.down, player.not_supported = false, false, false, false, false
    player.offset = 0
    player.bitmap_direction = 1
    player.world:add(player, player.x, player.y, player.width, player.height)
    player:change_state(Player.states.standing)
    return player
end

function Player:update(dt)
    --movimento en el eje x
    self.x, self.y, cols, len = self.world:move(self, self.x + self:vx() * dt, self.y, self.collisions_filter)
    -- TODO: juntar estas dos llamadas a world:move en una
    --movimiento en el eje y
    self.x, ydespues, cols, len = self.world:move(self, self.x, self.y + self:vy() * dt, self.collisions_filter)

    --colisiones en el eje y
    if len > 0 then -- checkeamos si nos podemos montar sobre un enemigo
        if cols[1].other.isEnemy and not self.montado then
            if cols[1].other.y - self.y > cols[1].other.height then --cuando el jugador está sobre el enemigo, la y es menor a más altura
                self.montado = true
                self.montura = cols[1].other
                self.y = self.montura.y - self.height
                self.montura:montado(self)
            end
        end
        if self.velocidad_y < 0 then --si hay colision al bajar en el eje y
            self.velocidad_y = self.velyini
            self.not_supported = false
        end
        if self.velocidad_y > 0 then -- si hay un choque en medio de un salto llendo hacia arriba, te das un cabezazo
            self:cabezazo()
        end
    end

    --El jugador aumenta constantemente la velocidad y, pero se resetea cada vez que toca el suelo o un enemigo cayendo
    if ydespues == self.y + self:vy() * dt then --debería caer si se consiguió mover en el eje y
        if self.montado then
            -- si estamos fuera de los limites del enemigo en el eje x
            if self.montura.x - self.x > self.montura.width or self.montura.x - self.x < -self.montura.width then
                self:desmontar()
            end
        else -- el jugador está en el aire, ya sea subiendo o bajando
            self.velocidad_y = self.velocidad_y - 9.8 * dt
            self.not_supported = true
        end
    end

    if self.montado == false then -- si lo hiciesemos cuando está montado caería a través del enemigo
        self.y = ydespues
    end

    -- actualización del estado del jugador
    if self.not_supported then
        self.change_state(self, Player.states.jumping)
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
    self.x, self.y, cols, len = self.world:move(self, self.x, self.y + 2, self.collisions_filter)
    self.velocidad_y = -4
end

function Player:draw()
    love.graphics.setColor(255, 255, 255, 255)

    -- TODO: eliminar offset y dibujar todos los frames del mismo tamaño
    if self.right then
        self.bitmap_direction = 1
        self.offset = 0
    end
    if self.left then
        self.bitmap_direction = -1
        self.offset = self.width
    end

    love.graphics.draw(
        atlas,
        self.state.quads[self.current_frame].quad,
        self.x + self.offset,
        self.y,
        0,
        self.width / self.state.quads[self.current_frame].width * self.bitmap_direction,
        self.height / self.state.quads[self.current_frame].height
    )
end

function Player:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function Player:jump()
    if not self.not_supported then
        self.not_supported = true
        self.velocidad_y = 5

        if self.montado then
            self:desmontar()
        end
    end
end

function Player:empujar(vector, empujador)
    if vector.x ~= 0 then
        self.x, self.y, cols, len = self.world:move(self, self.x + vector.x, self.y, self.collisions_filter)

        if len > 0 then --hay una colision con otra cosa al intentar moverlo, debe morir
            xtest, self.y, cols, len = self.world:move(self, self.x - vector.x, self.y, self.collisions_filter)
            if math.abs(xtest - self.x) <= 0.5 then --si no puede retroceder una distancia, se considera estrujado
                self:die()
            end
        end
    end
    if vector.y ~= 0 then
        self.velocidad_y = 0

        self.x, self.y, cols, len = self.world:move(self, self.x, self.y + vector.y, self.collisions_filter)

        if len > 0 then --hay una colision con otra cosa al intentar moverlo
            self.x, ytest, cols, len = self.world:move(self, self.x, self.y - vector.y, self.collisions_filter)
            if math.abs(ytest - self.y) <= 0.5 then --si no puede retroceder una distancia, se considera estrujado
                self:die()
            end
        end

        self.not_supported = false

        self.velocidad_y = self.velyini
    end
end

function Player:desmontar()
    self.montado = false
end

function Player:die()
    self.game.vidaperdida()
end

return Player
