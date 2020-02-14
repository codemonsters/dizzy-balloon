local Enemy = require("gameobjects/enemy")

local AirFlyClass = {}
AirFlyClass.__index = Enemy

function AirFlyClass.new(name, x, y, world, game, direction)
    local newObject = Enemy.new(name, x, y, world, game, direction)
    
    --setmetatable(enemy, Enemy)
    
    return newObject
end

AirFlyClass.flyFilter = function(item, other)
    return "slide"
end

function AirFlyClass:dist(self, orig, dest)
    return {x = dest.x - orig.x, y = dest.y - orig.y}
end

function AirFlyClass:mod(self, vec)
    return math.sqrt(math.pow(vec.x,2)+math.pow(vec.y,2))
end

AirFlyClass.states.moving = {
    
    load = function(self)
        self.objetivo = {x = WORLD_WIDTH/2, y = math.random(0, self.height * 10)}
        dist = self:dist({x = self.x, y = self.y}, self.objetivo)
        self.direction = math.asin(dist.y/self:mod(dist))
        self.velocidad_x = math.cos(self.direction) * self.moduloVelocidad
        self.velocidad_y = math.sin(self.direction) * self.moduloVelocidad
    end,
    update = function(self, dt)

        self.x, self.y, cols, len = self.world:move(self, self.movSigx, self.movSigy, self.flyFilter)

        if len > 0 then
            local col = cols[1]
            if col.other.isBlock or col.other.isSeed or col.other.isEnemy or col.other.isMushroom then -- si se pone "if not other.col.isBomb" then da un error cuando el enemigo choca con algo, puede ser problema de la bomba no teniendo un collision_filter o algo por el estilo 
                -- TODO: calculo de velocidad tras el choque
                vecBounce = {x = col.bounce.x - col.touch.x, y = col.bounce.y - col.touch.y}
                
                moduloBounce = math.sqrt(math.pow(vecBounce.x, 2) + math.pow(vecBounce.y, 2))
                vectorUnitario = {x = vecBounce.x / moduloBounce, y = vecBounce.y / moduloBounce}
    
                self.velocidad_x = vectorUnitario.x * self.moduloVelocidad
                self.velocidad_y = vectorUnitario.y * self.moduloVelocidad
                
                seno = self.velocidad_y/self.moduloVelocidad -- calculo del ángulo con relación a la vertical tras el choque
                anguloEnGradosConVertical = math.asin(seno) * 360/(2*math.pi)

                if math.abs(anguloEnGradosConVertical) <= 15 then
                    self:change_state(self.states.swiping)
                end
            elseif col.other.isPlayer then
                col.other:empujar({x = self.velocidad_x*2, y = self.velocidad_y*2}, self);
            end
        end
    end,
    draw = function(self, dt)
    end
}

return AirFlyClass