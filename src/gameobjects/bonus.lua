local PowerUps = require("misc/powerups")

local BonusClass = {
    name = "Bonus",
    x = 0, y = 0,
    width = 20, height = 20,
    isBonus = true, powerUp = nil,
    queryFilter = function(item)
        if item.isPlayer then return true
        else return false end
    end
}

BonusClass.__index = BonusClass

function BonusClass.new(x, y, powerUp, world, game)
    local bonus = {}
    setmetatable(bonus, BonusClass)
    bonus.x, bonus.y = x, y
    bonus.powerUp, bonus.canApply = powerUp, true
    bonus.time = 0
    bonus.width, bonus.height = BonusClass.width, BonusClass.height
    bonus.world, bonus.game = world, game
    bonus.world:add(bonus, bonus.x, bonus.y, bonus.width, bonus.height)
    return bonus
end

function BonusClass:update(dt)
    self.time = self.time + dt
    if self.time > 3 then
        self.game.remove_bonus(self)
    else
        local items, len = self.world:queryRect(
            self.x,
            self.y,
            self.width / self.powerUp.quad.width,
            self.height / self.powerUp.quad.height,
            self.queryFilter
        )
        if len > 0 then
            self.powerUp:apply(items[1])
            self.canApply = false
            self.game.remove_bonus(self)
        end
    end
end

function BonusClass:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        atlas, self.powerUp.quad.quad,
        self.x,
        self.y,
        0,
        self.width / self.powerUp.quad.width,
        self.height / self.powerUp.quad.height
    )
end

return BonusClass