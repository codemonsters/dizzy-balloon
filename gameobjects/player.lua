local Player = {
    name = "Player",
    width = 40,
    height = 40,
    states = {
        standing = {
            love.graphics.newImage("assets/player/p.png")
        },
        right = {
            love.graphics.newImage("assets/player/r1.png"),
            love.graphics.newImage("assets/player/r2.png"),
            love.graphics.newImage("assets/player/r3.png")
        },
        left = {
            love.graphics.newImage("assets/player/l1.png"),
            love.graphics.newImage("assets/player/l2.png"),
            love.graphics.newImage("assets/player/l3.png")
        }
    }
}

Player.__index = Player

function Player:load()
    self.width = 40
    self.height = Player.width
    self.x = 1
    self.y = WORLD_HEIGHT - Player.height
    self.velocidad_y = 0
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
    self.velocidad_y = 0
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
    self.x, self.y, cols, len = self.world:move(self, self.x, self.y - self.velocidad_y)
    self.velocidad_y = self.velocidad_y - 9.8 * dt

    if self.jumping then

        if self.velocidad_y < 0 and len > 0 then
            self.velocidad_y = 0
            self.jumping = false
        end

    end

    if self.y > WORLD_HEIGHT - self.height then
        self.velocidad_y = 0
        self.y = WORLD_HEIGHT - self.height
        self.jumping = false
    end
end

function Player:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        self.state[1], -- TODO: Cambiar la imagen del sprite según su estado
        self.x,
        self.y,
        0,
        self.width / self.state[1]:getWidth(),
        self.height/ self.state[1]:getHeight()
    )
end

function Player:jump()
    if not self.jumping then
        self.jumping = true
        self.velocidad_y = 5
    end
end

return Player