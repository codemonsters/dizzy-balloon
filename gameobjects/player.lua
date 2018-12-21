local Player = {
    name = "Player",
    width = 40,
    height = 40,
    states = {
        standing = {
            quads = {
                {
                    quad = love.graphics.newQuad(8, 14, 18, 18, atlas:getDimensions()),
                    width = 18,
                    height = 18
                }
            }
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
            }
        }
    }
}

Player.__index = Player

function Player:load()
    self.width = 40
    self.height = Player.width
    self.x = 1
    self.y = WORLD_HEIGHT - Player.height
    self.velocidad_y = -0.1
    self.left = false
    self.right = false
    self.up = false
    self.down = false
    self.jumping = false
    self.state = states.standing
end

function Player:new()
    local jugador = {}
    setmetatable(jugador, Player)
    return jugador
end

function Player:load(world)
    self.world = world
    self.x = 1
    self.y = WORLD_HEIGHT - self.height
    self.velocidad_y = -0.1 --la velocidad y debe ser negativa para que haya diferencia en el movimiento de eje y para saber cuando aplicar aceleración
    self.left, self.right, self.up, self.down = false
    self.jumping = falses
    self.state = Player.states.standing
    
    self.world:add(self, self.x, self.y, self.width, self.height)
end

function Player:update(dt)
    if self.left and self.x > 0 then
        self.x, self.y, cols, len = self.world:move(self, self.x - 3,self.y)
    end
    if self.right and self.x < WORLD_WIDTH - self.width then
        self.x, self.y, cols, len = self.world:move(self, self.x + 3,self.y)
    end
    --El jugador aumenta constantemente la velocidad y, pero se resetea cada vez que toca el suelo o un enemigo cayendo
    self.x, ydespues, cols, len = self.world:move(self, self.x, self.y - self.velocidad_y)

    if ydespues - self.y ~= 0 then --si es diferente a 0 no tenemos superficie debajo, aplicamos la aceleración
        self.velocidad_y = self.velocidad_y - 9.8 * dt
    end

    self.y = ydespues

    if self.velocidad_y < 0 and len > 0 then --si hay colision al bajar en el eje y
        self.velocidad_y = -0.1
        self.jumping = false
    end

    if self.y > WORLD_HEIGHT - self.height then --molaría meter los bordes del mundo
        self.velocidad_y = -0.1
        self.y = WORLD_HEIGHT - self.height
        self.jumping = false
    end

    -- actualización del estado del jugador
    if self.jumping then
    else
        if self.left or self.right then
            self.state = self.states.walking
        else
            self.state = self.states.standing
        end
    end
end

function Player:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        atlas,
        self.state.quads[1].quad,
        self.x,
        self.y,
        0,
        self.width / self.state.quads[1].width,
        self.height/ self.state.quads[1].height
    ) -- TODO: Cambiar la imagen del sprite según su estado
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

function Player:jump()
    if not self.jumping then
        self.jumping = true
        self.velocidad_y = 5
    end
end

return Player