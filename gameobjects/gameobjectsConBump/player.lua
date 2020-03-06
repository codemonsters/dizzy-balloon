local BalloonClass = require("gameobjects/balloon")

local Player = {
    name = "Player",
    width = 40,
    height = 40,
    isPlayer = true,
    vx = 0,
    vy = 0,
    extraJumpSpeed = 0,
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
    player.x, player.y = 200, 200
    player.up, player.down = false, false
    player.movingLeft, player.movingRight = false, false
    player.vx, player.vy, player.extraJumpSpeed, player.vy = Player.vx, Player.vy, Player.extraJumpSpeed, 0
    player.canJump, player.onEnemy = false, false
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

function Player:left(value)
    self.movingLeft = value
end

function Player:right(value)
    self.movingRight = value
end


function Player:update(dt)
    self.tVivo = self.tVivo + dt
    if self.invencible and self.tVivo >= self.tInvencible then
        self.invencible = false
    end
    if self.movingLeft then
        self.vx = -180
        self:changeState(self.states.walking)
    elseif self.movingRight then
        self.vx = 180
        self:changeState(self.states.walking)
    else
        self.vx = 0
        self:changeState(self.states.standing)
    end
    self:movePlayer(dt)
    self.state.update(self, dt)
    self.world:update(self, self.x, self.y)
end

function Player:movePlayer(dt)
    self.x, self.y, cols, len = self.world:move(self, self.x + self.vx * dt, self.y + self.vy * dt, self.collisionsFilter)
    local items, lenColFeet = self:checkFeet(dt)
    if lenColFeet == 0 then
        self.vy = self.vy + 800 * dt
        self.canJump = false
        self:changeState(self.states.jumping)
    else
        for i = 1, lenColFeet do
            if items[i].isEnemy then
                self.vx = items[i].vx * dt
                self.vy = items[i].vy * dt
            else
                self.vx = 0
                self.vy = 0
            end
        end
        self.canJump = true
        self:changeState(self.states.standing)
    end
    
    local items, lenColHead = self:checkHead(dt)
    for i = 1, lenColHead do
        if items[i].isGoal and self.game then
            self.game.cambioDeNivel()
        else
            self:cabezazo(dt)
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
    self.vy = self.velyini
end

function Player:jump()
    if self.canJump then
        self.vy = -400 - self.extraJumpSpeed
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
    if self.movingRight then
        self.bitmapDirection = 1
        self.offset = 0
    elseif self.movingLeft6 then
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

function Player:empujar(vector, empujador, dt)
    if vector.x ~= 0 then
        initialX = self.x
        self.x, self.y, cols, len = self.world:move(self, self.x + vector.x, self.y, self.collisions_filter)

        if len > 0 then --hay una colision con otra cosa al intentar moverlo, debe morir
            if math.abs(initialX - self.x) <= 0.5 then --si no puede retroceder una distancia, se considera estrujado
                testX, self.y, cols, len = self.world:check(self, self.x - vector.x, self.y, self.collisions_filter)
                if math.abs(initialX - testX) <= 0.5 then
                    self:die()
                end
            end
        end
    end
    if vector.y ~= 0 then
        initialY = self.y
        self.x, self.y, cols, len = self.world:move(self, self.x, self.y + vector.y, self.collisions_filter)

        if len > 0 then --hay una colision con otra cosa al intentar moverlo
            if math.abs(initialY - self.y) <= 0.5 then --si no puede retroceder una distancia, se considera estrujado
                self.x, testY, cols, len = self.world:check(self, self.x, self.y - vector.y, self.collisions_filter)
                if math.abs(initialY - testY) <= 0.5 then
                    self:die()
                end
            end
        end
    end
end

function Player:die()
    if self.invencible == false and self.game then
        self.game.vidaperdida()
    end
end

function Player:revive()
    self.invencible = true
    self.tVivo = 0
end

function Player:translate(x, y)
    self.x, self.y, cols, len = self.world:move(self, self.x + x, self.y + y, self.collisions_filter)
end

return Player