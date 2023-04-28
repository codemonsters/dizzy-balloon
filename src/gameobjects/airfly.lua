local Enemy = require("gameobjects/enemy")
local SeedClass = require("gameobjects/seed")
local PowerUps = require("misc/powerups")

local AirFlyClass = copyTable(Enemy)

--[[
local AirFlyClass.new(name, x, y, world, game, direction)
    local newObject = {
        enemy = Enemy.new(name, x, y, world, game, direction)
    }
    return newObject
end

function AirFlyClass:draw()
    self.enemy.draw()
ed

function AirFlyClass:update(dt)
    self.enemy.update(dt)
end
--]]

function AirFlyClass.newAirfly(name, x, y, world, game, direction)
    local newObject = AirFlyClass.new(name, x, y, world, game, direction)
    setmetatable(newObject, AirFlyClass)
    newObject:change_state(newObject.states.moving)

    --setmetatable(enemy, Enemy)

    return newObject
end

AirFlyClass.flyFilter = function(item, other)
    return "slide"
end

function AirFlyClass:dist(orig, dest)
    return {x = dest.x - orig.x, y = dest.y - orig.y}
end

function AirFlyClass:mod(vec)
    return math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2))
end

function AirFlyClass:getPos(objetivo)
    return {x = self.x, y = self.y}
end

function AirFlyClass:setTarget(objetivo)
    local dist = self:dist({x = self.x, y = self.y}, objetivo)

    self.velocidad_x = dist.x / self:mod(dist) * self.moduloVelocidad
    self.velocidad_y = dist.y / self:mod(dist) * self.moduloVelocidad
end

function AirFlyClass:atacar()
    local huevito =
        SeedClass.new("huevo", self.game.currentLevel.sky, self.world, self.x, self.y + self.height, self.game)
    table.insert(self.game.currentLevel.sky.semillas, huevito)
    huevito.powerUp = PowerUps.flyAttack

    huevito:change_state(huevito.states.falling)
end

AirFlyClass.states.moving = {
    load = function(self)
        self.cargado = true
        self.atacando = false
        self.contadorDescanso = 0
        self.objetivo = {x = math.random(0, WORLD_WIDTH), y = math.random(0, WORLD_HEIGHT / 3)}
        self:setTarget(self.objetivo)
    end,
    update = function(self, dt)
        self.contadorDescanso = self.contadorDescanso + dt
        if self.contadorDescanso > 5 then
            if self.contadorDescanso > 7 then
                self.contadorDescanso = 0
                self.cargado = true
            end
        else
            self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.flyFilter)
            distObj = self:mod(self:dist(self:getPos(), self.objetivo))
            if distObj < 10 or len > 0 then
                if distObj < 10 then
                    if self.atacando then
                        distPlayer =
                            self:mod(
                            self:dist(self:getPos(), {y = self.objetivo.y, x = self.game.currentLevel.player.x})
                        )

                        if distPlayer < 10 then
                            self.atacando = false
                            self.cargado = false
                            self:atacar()
                        end
                    end
                end
                self.objetivo = {x = math.random(0, WORLD_WIDTH), y = math.random(0, WORLD_HEIGHT / 3)}
                if math.random(0, 100) < 20 and self.cargado then
                    self.atacando = true
                end

                if self.atacando then
                    self.objetivo.x = self.game.currentLevel.player.x
                end

                self:setTarget(self.objetivo)
            end
        end
    end
}

function AirFlyClass:draw()
    if self.dead then
        return
    end
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.image:getWidth(),
        self.height / self.image:getHeight()
    )
    love.graphics.setColor(1, 1, 1, 1)
end

return AirFlyClass
