local CloudClass = {
    name = "CloudClass",
    x, y = 0,0,
    width = 100, height = 79,
    quad = love.graphics.newQuad(0, 270, 100, 79, atlas:getDimensions()), width = 100, height = 79
}

CloudClass.__index = CloudClass

function CloudClass.new(name, x, y, world)
    local cloud = {}
    cloud.name = name
    cloud.x, cloud.y = x, y
    cloud.width, cloud.height = width, height
    cloud.world = world
    cloud.world:add(cloud, cloud.x, cloud.y, self:width, self:height)
    setmetatable(cloud, CloudClass)
    return cloud
end

function CloudClass:draw()
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
return CloudClass