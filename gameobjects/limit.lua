local LimitClass = {
    name = "Limit",
    x,
    y = 0,
    0,
    width,
    height = 0,
    0,
    isLimit = true,
    --quad = quads.limit.quad
    quad = love.graphics.newQuad(162, 148, 1, 1, atlasOld:getDimensions())
}

LimitClass.__index = LimitClass

function LimitClass.new(name, x, y, width, height, world)
    local limit = {}
    limit.name = name
    limit.x, limit.y = x, y
    limit.width, limit.height = width, height
    limit.world = world
    limit.world:add(limit, limit.x, limit.y, limit.width, limit.height)
    setmetatable(limit, LimitClass)
    return limit
end

function LimitClass:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return LimitClass
