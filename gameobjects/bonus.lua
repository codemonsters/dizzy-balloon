local PowerUps = require("misc/powerups")

local BonusClass = {
    name = "Bonus",
    x = 0, y = 0,
    width = 20, height = 20,
    isBonus = true
}

BonusClass.__index = BonusClass

function BonusClass.new(x, y, quad, world, game)
    local bonus = {}
    setmetatable(bonus, BonusClass)
    bonus.x, bonus.y = x, y
    bonus.quad = quad
    bonus.width, bonus.height = BonusClass.width, BonusClass.height
    bonus.world, bonus.game = world, game
    bonus.world:add(bonus, bonus.x, bonus.y, bonus.width, bonus.height)
    return bonus
end

function BonusClass:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        atlas, self.quad.quad,
        self.x - (self.width / self.quad.width / 2),
        self.y - (self.height / self.quad.height / 2),
        0,
        self.width / self.quad.width,
        self.height / self.quad.height
    )
end

return BonusClass