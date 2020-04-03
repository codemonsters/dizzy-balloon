local Player = {
    name = "Player",
    width = 40,
    height = 40,
    isPlayer = true,
    vx = 0,
    dir = function(self)
        local dir = 0
        if self.left then dir = -1
        elseif self.right then dir = 1
        end
        return self.vx * dir
    end,
    vy = 0,
    supported = false,
    montado = false,
    montura = nil,
    collisionsFilter = function(item, other)
        if other.isBomb then return "slide"
        elseif other.isSeed and other.state ~= "falling" then return "touch"
        elseif other.isGoal then return "touch"
        elseif other.isLimit then return nil
        else return "slide" end
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
    player.game, player.world = game, world
    player.x, player.y = 100, 100
    player.vx, player.vy = Player.vx, Player.vy
    player.supported, player.montado, player.montura = false, false, nil
    player.width, player.height = Player.width, Player.height
    player.left, player.right, player.supported = false, false, false, false, false
    player.invencible, player.tVivo, player.tInvencible, player.nBlinks, player.nTramo = false, 0, 4, 8, 0
    player.world:add(player, player.x, player.y, player.width, player.height)
    return player
end

function Player:update(dt)
    self.tVivo = self.tVivo + dt
    if self.invencible and self.tVivo >= self.tInvencible then
        self.invencible = false
    end

    if not self.montado then
        if self.left then
            self.vx = -200
        elseif self.right then
            self.vx = 200
        else
            self.vx = 0
        end
    else
        self.vx = self.montura.vx
        if self.left then
            self.vx = self.vx - 200
        elseif self.right then
            self.vx = self.vx + 200
        end
    end

    local feetItems, feetLen = self.world:queryRect(self.x + 1, self.y + self.height, self.width - 1, 1)
    local headItems, headLen = self.world:queryRect(self.x + 1, self.y - 1, self.width - 1, 1)
    local bodyItems, bodyLen = self.world:queryRect(self.x, self.y, self.width, self.height)

    if feetLen <= 0 then -- El jugador no está apoyado
        self.supported = false
        self.montado = false
    else                 -- El jugador ha tocado suelo y ha de parar de bajar
        self.supported = true
        for i = 1, feetLen do
            if feetItems[i].isEnemy then
                self.montado = true
                self.montura = feetItems[i]
            end
        end
    end

    if not self.supported then
        self.vy = self.vy + 10
    end

    if headLen > 0 and self.vy > 0 then -- El jugador se ha chocado mientras saltaba, ha de rebotar
        self.vy = 4
    end

    self.x, self.y, cols, len = self.world:move(self, self.x + self.vx * dt, self.y + self.vy * dt, self.collisionsFilter)

end

function Player:jump()
    if self.supported then
        self.supported = false
        self.montado = false
        self.montura = nil
        self.vy = -500
    end
end

function Player:draw()

    love.graphics.setColor(255, 255, 255, 255)

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

    love.graphics.draw(atlas, Player.states.standing.quads[1].quad, self.x, self.y)
    
    love.graphics.setColor(255, 255, 255, 255)
end

return Player