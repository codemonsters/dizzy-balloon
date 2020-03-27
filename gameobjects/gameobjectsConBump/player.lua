local Player = {
    name = "Player",
    width = 40,
    height = 40,
    isPlayer = true,
    vx = 180,
    dir = function(self)
        local dir = 0
        if self.left then dir = -1
        elseif self.right then dir = 1
        end
        return self.vx * dir
    end,
    vy = 80,
    supported = false,
    collisions_filter = function(item, other)
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
    player.supported = false
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

    local feetItems, feetLen = self.world:queryRect(self.x + 1, self.y + self.height, self.width - 1, 1)
    local headItems, headLen = self.world:queryRect(self.x + 1, self.y - 1, self.width - 1, 1)
    local bodyItems, bodyLen = self.world:queryRect(self.x, self.y, self.width, self.height)

    if feetLen == 0 then -- El jugador tiene que ser afectado por la gravedad
        self.supported = false
        self.vy = self.vy - (9.81 * dt)
    else                 -- El jugador ha tocado suelo y ha de parar de bajar
        self.supported = true
        self.vy = 0
    end

    if headLen > 0 and self.vy > 0 then -- El jugador se ha chocado mientras saltaba, ha de rebotar
        self.vy = -4
    end

    -- Las colisiones contra el cuerpo del jugador pienso que han de ser manejadas por el otro cuerpo,
    -- por ejemplo, si un enemigo empuja al jugador, es el jugador quien debe ser empujado y no ha de
    -- empujarse a sí mismo. Si una bomba mata a un jugador, el jugador no ha de suicidarse, si no que
    -- la bomba ha de ser la que lo mate. Y así con el resto de colisiones, como los bloques.

end

function Player:jump()
    self.vy = 5
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

    love.graphics.draw(atlas, Player.states.standing.quads[1].quad, self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(255, 255, 255, 255)
end

return Player