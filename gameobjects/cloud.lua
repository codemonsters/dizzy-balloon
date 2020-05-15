local CloudClass = {
    name = "Nube",
    x, y = 0,0,
    vx = ,
    width = 100,
    height = 79,
    state = nil,
    states = {
        standing = {
            quads = {
                quads.cloud
            },
            load = function(self)
                self.collisions_filter = function(item, other)
                    return "cross"
                end
            end,
            update = function(self, dt)
                if self.x > WORLD_WIDTH then
                    self.x = 0 - self.width
                end
                print(self.x)
                self.x, self.y, cols, len = self.world:move(self, self.x + self.vx * dt, self.y, self.collisions_filter)
            end,
            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[1].quad,
                    self.x,
                    self.y,
                    0,
                    self.width / self.state.quads[1].width,
                    self.height / self.state.quads[1].height
                )
            end
        
        }
    }
}

CloudClass.__index = CloudClass

function CloudClass.new(name, x, y, world)
    local cloud = {}
    cloud.name = name
    cloud.x, cloud.y = x, y
    cloud.width, cloud.height = width, height
    cloud.world = world
    cloud.state = CloudClass.states.standing
    cloud.world:add(cloud, cloud.x, cloud.y, CloudClass.width, CloudClass.height)
    
    setmetatable(cloud, CloudClass)
    return cloud
end

function CloudClass:draw()
    self.state.draw(self)
end

function CloudClass:update(dt)
    self.state.update(self, dt)
end
return CloudClass