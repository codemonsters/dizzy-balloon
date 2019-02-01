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
            name = "sky",
            quads = {
                {
                    quad = love.graphics.newQuad(130, 61, 14, 16, atlas:getDimensions()),
                    width = 14,
                    height = 16
                }
            },
            load = function(self) end,
            update = function(self, dt)
                self.x  = self.x + 10 * dt
                if  self.x > WORLD_WIDTH then 
                    self.x = 0 - self.width
                end
            end,
        },
        falling = {
            name = "falling",
            quads = {
                {
                    quad = love.graphics.newQuad(98, 56, 14, 21, atlas:getDimensions()),
                    width = 14,
                    height = 21
                },
                {
                    quad = love.graphics.newQuad(114, 57, 14, 19, atlas:getDimensions()),
                    width = 14,
                    height = 19
                }
            },
            load = function(self) 
                print("EMPIEZA A CAER")
                self.current_frame = 1
                self.elapsed_time = 0
            end,
            update = function(self, dt)
                self.y = self.y + 100 * dt
                if self.y + self.height >= WORLD_HEIGHT then
                    self.change_state(self, self.states.touchdown)
                    self.elapsed_time = self.elapsed_time + dt
                    return
                end
                if self.elapsed_time > 0.5 then
                    self.elapsed_time = 0
                    self.current_frame = self.current_frame + 1
                    if self.current_frame > 2 then self.current_frame = 1 end
                end
            end
        },
        touchdown = {
            name = "touchdown",
            quads = {
                {
                    quad = love.graphics.newQuad(146, 65, 14, 14, atlas:getDimensions()),
                    width = 14,
                    height = 14
                }
            },
            update = function(self, dt) end,
            load = function(self) end
        },
        onthefloor = {
            name = "onthefloor",
            quads = {
                {
                    quad = love.graphics.newQuad(146, 65, 14, 14, atlas:getDimensions()),
                    width = 14,
                    height = 14
                }
            },
            update = function(self, dt) end,
            load = function(self) end
        },
        rotting = {
            name = "rotting",
            quads = {
                {
                    quad = love.graphics.newQuad(161, 66, 15, 14, atlas:getDimensions()),
                    width = 15,
                    height = 14
                } 
            },
            update = function(self, dt) end,
            load = function(self) end
        },
        evolving = {
            name ="evolving",
            quads = {
                {
                    quad = love.graphics.newQuad(177, 67, 15, 13, atlas:getDimensions()),
                    width = 15,
                    height = 13
                }
            },
            update = function(self, dt) end,
            load = function(self) end
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
    if self.state.name ~= SeedClass.states.sky.name then
        log.debug(self.state.name)
    end
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

function SeedClass:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

return SeedClass