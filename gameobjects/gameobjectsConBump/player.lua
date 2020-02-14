local BalloonClass = require("gameobjects/balloon")

local Player = {
    name = "Player",
    width = 40,
    height = 40,
    montado = false,
    montura = {},
    isPlayer = true,
    velyini = -0.5,
    speed = 180,
    extraJumpSpeed = 0,
    vx = function(self)
        local vxFactor = 0
        if self.left then
            vxFactor = -1
        elseif self.right then
            vxFactor = 1
        end
        return self.speed * vxFactor
    end,
    vy = function(self)
        return -self.velocidadY * 80
    end,
    collisionsFilter = function(item, other)
        if     other.isBalloon and other.state == BalloonClass.states.growing then return nil
        elseif other.isBomb and other.state ~= other.states.planted           then return nil
        elseif other.isSeed and other.state ~= other.states.falling           then return "touch"
        elseif other.isGoal                                                   then return "touch"
        elseif other.isLimit                                                  then return nil
        else                                                                       return "slide"
        end   
    end,
    queryFilter = function(item)
        if     item.isBomb and item.state == item.states.prelaunching then return false
        elseif item.isGoal                                            then return false
        elseif item.isLimit                                           then return false
        else                                                               return true
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
                self.currentFrame = 1
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
                self.currentFrame = 1
                self.elapsedTime = 0
            end,
            update = function(self, dt)
                self.elapsedTime = self.elapsedTime + dt
                if self.elapsedTime > 0.1 then
                    self.elapsedTime = 0
                    self.currentFrame = self.currentFrame + 1
                    if self.currentFrame > 4 then
                        self.currentFrame = 1
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
                self.currentFrame = 1
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
    player.width, player.height = Player.width, Player.height
    player.x, player.y = 1, 1
    player.velocidadY = Player.velyini
    player.left, player.right, player.down, player.notSupported = false, false, false, false
    player.speed, player.extraJumpSpeed = Player.speed, Player.extraJumpSpeed
    player.offset = 0
    player.bitmapDirection = 1
    player.invencible = false
    player.tVivo = 0
    player.tInvencible = 4
    player.nBlinks = 8
    player.nTramo = 0
    player.world:add(player, player.x, player.y, player.width, player.height)
    player:changeState(Player.states.standing)
    return player
end

function Player:update(dt)
    self.tVivo = self.tVivo + dt
    if self.invencible and self.tVivo >= self.tInvencible then
        self.invencible = false
    end
    self:movePlayer(dt)
    if self.notSupported then
        self:changeState(Player.states.jumping)
    elseif self.left or self.right then
        if not self.montura.isBalloon then
            self:changeState(Player.states.walking)
        end
    else
        self:changeState(Player.states.standing)
    end
    self.state.update(self, dt)
    self.world:update(self, self.x, self.y)
end

function Player:movePlayer(dt)
    local items, lenColFeet = self:checkFeet(dt)
    if self.velocidadY < 0 then
        for i = 1, lenColFeet do
            if not self.montado and ((items[i].isBallon and items[i].state == BalloonClass.states.flying_alone) or items[i].isEnemy) then
                self.montado = true
                self.montura = items[i]
                self.y = self.montura.y - self.height
                self.notSupported = false
                self.montura:montado(self)
            end
            if self.notSupported then
                self.velocidadY = self.velyini
                self.notSupported = false
            end
        end
    end
    
    local items, lenColHead = self:checkHead(dt)
    if lenColFeet == 0 then
        self.notSupported = true
    end
    for i = 1, lenColHead do
        if items[i].isGoal and self.game then
            self.game.cambioDeNivel()
        end
        if self.velocidadY > 0 then
            self:cabezazo()
        end
    end
    
    if not self.montura.isBalloon then
        self.x, goalY, cols, len = self.world:move(self, self.x + self:vx() * dt, self.y + self:vy() * dt, self.collisionsFilter)
        if self.notSupported then
            self.velocidadY = self.velocidadY - 10 * dt
            self.y = goalY
        end
    end

    if self.montura.isEnemy then
        if self.montura.x - self.x > self.width or self.montura.x - self.x < -self.width then
            self:desmontar()
        end
    end
end

function Player:checkFeet(dt)
    local items, len = self.world:queryRect(self.x, self.y + self.height, self.width, 1, self.queryFilter)
    return items, len
end

function Player:checkHead(dt)
    local items, len = self.world:queryRect(self.x, self.y - 1, self.width, 1, self.queryFilter)
    return items, len
end

function Player:cabezazo(dt)
    self.x, self.y, cols, len = self.world:move(self, self.x, self.y + 2, self.collisionsFilter)
    self.velocidadY = self.velyini
end

function Player:jump()
    if not self.notSupported then
        self.notSupported = true
        self.velocidadY = 5 + self.extraJumpSpeed
        if self.montado then
            self:desmontar()
        end
    end
end

function Player:desmontar()
    self.montado = false
    self.notSupported = true
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
        self.bitmapDirection = 1
        self.offset = 0
    elseif self.left then
        self.bitmapDirection = -1
        self.offset = self.width
    end 

    love.graphics.draw(
        atlas,
        self.state.quads[self.currentFrame].quad,
        self.x + self.offset,
        self.y,
        0,
        self.width / self.state.quads[self.currentFrame].width * self.bitmapDirection,
        self.height / self.state.quads[self.currentFrame].height
    )
end

function Player:changeState(newState)
    if self.state ~= newState then
        self.state = newState
        self.state.load(self)
    end
end

return Player