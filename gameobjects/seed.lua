--[[
    Possible states of the seed:
        * sky
        * falling
        * touchdown
        * onthefloor
        * rotting
        * evolving
--]]
local SeedClass = {
    x = 0,
    y = 0,
    width = 20,
    height = 20,
    image = love.graphics.newImage("assets/seed.png"),
    name = "Seed",
    states = {
        sky = {
            quads = {
                {
                    quad = love.graphics.newQuad(130, 61, 14, 16, atlas:getDimensions()),
                    width = 14,
                    height = 16
                }
            },
            update = function(self, dt)
                self.x  = self.x + 10 * dt
                if  self.x > WORLD_WIDTH then 
                    self.x = 0 - self.width
                end
            end
        },
        falling = {
            quads = {
                {
                    quad = love.graphics.newQuad(98, 56, 14, 27, atlas:getDimensions()),
                    width = 14,
                    height = 27
                },
                {
                    quad = love.graphics.newQuad(114, 57, 14, 19, atlas:getDimensions()),
                    width = 14,
                    height = 19
                }
            },
            update = function(self, dt)
                self.y = self.y + 30 * dt
                -- TODO: Añadir función change.state
            end
        },
        touchdown = {
            quads = {
                {
                    quad = love.graphics.newQuad(146, 65, 14, 14, atlas:getDimensions()),
                    width = 14,
                    height = 14
                }
            },
        },
        onthefloor = {
            quads = {
                {
                    quad = love.graphics.newQuad(146, 65, 14, 14, atlas:getDimensions()),
                    width = 14,
                    height = 14
                }
            },
        },
        rotting = {
            quads = {
                {
                    quad = love.graphics.newQuad(161, 66, 15, 14, atlas:getDimensions()),
                    width = 15,
                    height = 14
                } 
            },
        },
        evolving = {
            quads = {
                {
                    quad = love.graphics.newQuad(177, 67, 15, 13, atlas:getDimensions()),
                    width = 15,
                    height = 13
                }
            },
        }
    }
}

SeedClass.__index = SeedClass

function SeedClass:new(name)
    local seed = {}
    seed.name = name
    seed.state = SeedClass.states.sky
    seed.currentFrame = 1
    setmetatable(seed, SeedClass) 
    return seed
end

function SeedClass:load(world, x, y)
    self.world = world
    self.x = x
    self.y = y
    self.state = SeedClass.states.sky
    self.currentframe = 1
    self.world:add(self, self.x, self.y, self.width, self.height)
end

function SeedClass:update(dt)
    self.state.update(self, dt)
end

function SeedClass:draw()
    --[[
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.image:getWidth(),
        self.height/ self.image:getHeight())
    --]]
    love.graphics.draw(
        atlas,
        self.state.quads[self.currentFrame].quad,
        self.x,
        self.y,
        0,
        self.width / self.state.quads[self.currentFrame].width,
        self.height/ self.state.quads[self.currentFrame].height
    )
end

return SeedClass