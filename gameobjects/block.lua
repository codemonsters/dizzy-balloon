
local BlockClass = {
    name = "Block",
    x, y = 0, 0,
    width, height = 0, 0,
    quad = love.graphics.newQuad(162, 148, 1, 1, atlas:getDimensions())
}

BlockClass.__index = BlockClass

function BlockClass.new(name, x, y, width, height)
    local block = {}
    block.name = name
    block.x, block.y = x, y
    block.width, block.height = width, height
    setmetatable(block, BlockClass)
    return block
end

function BlockClass:load(world, x, y)
    self.world = world
    self.x, self.y = self.x, self.y
    self.world:add(self, self.x, self.y, self.width, self.height)
end

function BlockClass:draw()
    love.graphics.draw(
        atlas,
        self.quad,
        self.x,
        self.y,
        0,
        self.width,
        self.height
    )
end

return BlockClass
