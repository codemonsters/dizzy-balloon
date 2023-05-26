local BalloonClass = require("gameobjects/balloon")

local Player = {
    name = "Player",
    vmultiplier = 1,
    ymultiplier = 1,
    width = 40,
    height = 40,
    velyini = -0.5,
    montado = false, -- TODO: eliminar montado, usar montura como boolean
    montura = nil,
    isPlayer = true,
    vx = function(self)
        local vx_factor = 0
        local airSlow = 1
        if self.left then
            if self.jumpRight then
                airSlow = 0.5
            end
            vx_factor = -1
        end
        if self.right then
            if self.jumpLeft then
                airSlow = 0.5
            end
            vx_factor = 1
        end

        return vx_factor * 180 * self.vmultiplier * airSlow
    end,
    vy = function(self)
        vel_y = -self.velocidad_y * 80
        if vel_y < 0 then
            vel_y = vel_y * self.ymultiplier
        end
        return vel_y -- TODO: Eliminar el campo velocidad_y para que solo se use el método self.vy() y eliminar así código repetido
    end,
    collisions_filter = function(item, other)
        if other.isBalloon and other.state == BalloonClass.states.growing then
            return nil -- TODO: Revisar si deberiamos resolver esta colisión también desde aquí y no solo desde balloon
        elseif other.isBomb and other.state ~= other.states.planted then
            return nil
        elseif other.isSeed and other.state ~= other.states.falling then
            return "touch"
        elseif other.isGoal then
            return "touch"
        elseif other.isBonus then
            return "cross"
        elseif other.isLimit then
            return nil
        else
            return "slide"
        end
    end,
    invincible_collisions_filter = function(item, other)
        if other.isBalloon and other.state == BalloonClass.states.growing then
            return nil -- TODO: Revisar si deberiamos resolver esta colisión también desde aquí y no solo desde balloon
        elseif other.isBomb and other.state ~= other.states.planted then
            return nil
        elseif other.isSeed and other.state ~= other.states.falling then
            return "touch"
        elseif other.isGoal then
            return "touch"
        elseif other.isLimit then
            return nil
        elseif other.isEnemy or other.isBonus then
            return "cross"
        else
            return "slide"
        end
    end,
    states = {
        standing = {
            quads = {
                quads.player_standing
            },
            load = function(self)
                self.current_frame = 1
            end,
            update = function(self, dt)
            end
        },
        walking = {
            quads = {
                quads.player_walking_01,
                quads.player_walking_02,
                quads.player_walking_03,
                quads.player_walking_02
                --[[
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
                --]]
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
                quads.player_jumping
            },
            load = function(self)
                self.current_frame = 1
                sounds.play(sounds.playerJump)
            end,
            update = function(self, dt)
            end
        }
    }
}

Player.__index = Player

function Player.new(world, spawnX, spawnY, game)
    local player = {}
    setmetatable(player, Player)
    player.game = game
    player.world = world
    player.width = 40
    player.height = Player.width
    player.x = spawnX
    player.y = spawnY
    player.velocidad_y = Player.velyini --la velocidad y debe ser negativa para que haya diferencia en el movimiento de eje y para saber cuando aplicar aceleración
    player.left, player.right, player.up, player.down, player.not_supported = false, false, false, false, false
    player.jumpLeft, player.jumpRight = false, false
    player.offset = 0
    player.bitmap_direction = 1
    player.invencible = false
    player.tVivo = 0
    player.tInvencible = 4
    player.nBlinks = 8
    player.nTramo = 0
    player.collisions_filter = Player.collisions_filter
    player.world:add(player, player.x, player.y, player.width, player.height)
    player:change_state(Player.states.standing)
    return player
end

function Player:update(dt)
    self.tVivo = self.tVivo + dt

    if self.invencible and self.tVivo >= self.tInvencible then
        self.invencible = false
        self.collisions_filter = Player.collisions_filter
    end

    local feetHeight = 1
    local items, lenColFeet = self.world:queryRect(self.x, self.y + self.height + 1, self.width, feetHeight) --detector de los pies del jugador

    --colisiones con los pies del jugador SOLO al bajar
    if self.velocidad_y < 0 then
        for i = 1, lenColFeet do
            if
                not self.montado and not self.invencible and
                    ((items[i].isBalloon and items[i].state == BalloonClass.states.flying_alone) or items[i].isEnemy)
             then
                self.montado = true
                self.montura = items[i]
                self.y = self.montura.y - self.height
                self.not_supported = false
                self.montura:montado(self)
            end
            if self.not_supported == true then --si hay colision al bajar en el eje y
                self.velocidad_y = self.velyini
                self.not_supported = false
            end
        end
    end

    if lenColFeet == 0 then -- si no hubo choques con los pies, está en caída libre
        self.not_supported = true
    end

    local headHeight = 10
    local items, len = self.world:queryRect(self.x, self.y - headHeight, self.width, headHeight) --detector de la cabeza del jugador

    --colisiones con la cabeza del jugador
    for i = 1, len do
        if self.velocidad_y > 0 and not items[i].isLimit then
            self:cabezazo()
        end
        if items[i].isGoal and self.game then -- comprobamos si hemos tocado la meta
            self.game.cambioDeNivel()
        end
    end

    if not (self.montado and self.montura.isBalloon) then -- cuando estemos montados en el globo no nos podremos mover
        self.x, ydespues, cols, len =
            self.world:move(self, self.x + self:vx() * dt, self.y + self:vy() * dt, self.collisions_filter)
    end

    if self.not_supported then -- el jugador está en el aire, ya sea subiendo o bajando
        self.velocidad_y = self.velocidad_y - 20 * dt
        self.y = ydespues
    end

    if self.montado then
        -- si estamos fuera de los limites del enemigo en el eje x
        if self.montura.x - self.x > self.montura.width or self.montura.x - self.x < -self.montura.width then
            self:desmontar()
        end
    end

    -- actualización del estado del jugador
    if self.not_supported then
        self.change_state(self, Player.states.jumping)
    else
        if self.left or self.right then
            -- self.state = self.states.walking
            if not (self.montado and self.montura.isBalloon) then
                self.change_state(self, Player.states.walking)
            end
        else
            -- self.state = self.states.standing
            self.change_state(self, Player.states.standing)
        end
        self.jumpLeft, self.jumpRight = false, false
    end

    self.state.update(self, dt)
end

function Player:cabezazo()
    self.x, self.y, cols, len = self.world:move(self, self.x, self.y + 2, self.collisions_filter)
    self.velocidad_y = -4
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.invencible then
        self.nTramo = (self.tVivo / self.tInvencible) * (self.nBlinks * 2) + 1
        if (self.nTramo % 2 < 1) then --no dibujar
            love.graphics.setColor(0, 0, 0, 0)
        end
    end

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

    love.graphics.setColor(1, 1, 1, 1)
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
        self.velocidad_y = 8
        if self.left then self.jumpLeft = true
        elseif self.right then self.jumpRight = true
        end

        if self.montado then
            self:desmontar()
        end
    end
end

function Player:empujar(vector, empujador)
    self.x, self.y, cols, len = self.world:move(self, self.x + vector.x, self.y + vector.y, self.collisions_filter)
    
    local feetItems, feetLen = self.world:queryRect(self.x + 1, self.y + self.height, self.width - 1, 1)
    local headItems, headLen = self.world:queryRect(self.x + 1, self.y - 1, self.width - 1, 1)
    local leftItems, leftLen = self.world:queryRect(self.x - 1, self.y, 1, self.height)
    local rightItems, rightLen = self.world:queryRect(self.x + self.width, self.y, 1, self.height)
    
    if feetLen > 0 and headLen > 0 then
        self:die()
    end

    if leftLen > 0 and rightLen > 0 then
        self:die()
    end
end

function Player:desmontar()
    self.montado = false
    self.not_supported = true
end

function Player:die()
    if self.invencible == false and self.game then
        self.game.vidaperdida()
        self.vmultiplier, self.ymultiplier = 1, 1
        if self.game.vidas <= 0 then
            sounds.play(sounds.gameOver)
        else
            sounds.play(sounds.lostLife)
        end
    end
end

function Player:revive()
    self.invencible = true
    self.collisions_filter = Player.invincible_collisions_filter
    self.tVivo = 0
end

function Player:translate(x, y)
    self.x, self.y, cols, len = self.world:move(self, self.x + x, self.y + y, self.collisions_filter)
end

return Player
