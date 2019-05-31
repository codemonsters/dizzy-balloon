local BalloonClass = {
    name = "BalloonClass",
    x = 0,
    y = 0,
    vx = 10,
    vy = 0,
    width = 40,
    height = 40,
    isBalloonClass = true,
    
    collisions_filter = function(item, other)
        if other.isBomb and other.state ~= other.states.planted then
            return nil
        elseif other.isSeed and other.state ~= other.states.falling then
            return "touch"
        else
            return "slide"
        end
    end,

    states = {
        growing = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
                self.current_frame = 1
                self.elapsed_time = 0
                print("growing balloon")
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt
            end,
            draw = function(self) end
        },
        flying_alone = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
            
            end,
            update = function(self, dt)
                
            end,
            draw = function(self) end
        },
        flying_with_pilot = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
            
            end,
            update = function(self, dt)
                
            end,
            draw = function(self) end
        },
        dying = {
            quads = {
                {
                    quad = love.graphics.newQuad(125, 78, 16, 16, atlas:getDimensions()),
                    width = 16,
                    height = 16
                }
            },        
            load = function(self)
            
            end,
            update = function(self, dt)
                
            end,
            draw = function(self) end
        }


    }
}

BalloonClass.__index = BalloonClass

function BalloonClass.new(seed, world, game)
    --print("SEED = " .. seed.name .. "; world = " .. world.name .. "; game = " .. game)
    local balloon = {}
    balloon.game = game
    balloon.name = name
    balloon.world = world
    balloon.current_frame = 1
    setmetatable(balloon, BalloonClass)
    balloon.world:add(balloon, seed.x, seed.y, seed.width, seed.height)
    balloon.change_state(balloon, BalloonClass.states.growing)
    return balloon
end
function BalloonClass:update(dt)
    self.state.update(self, dt)
end

function BalloonClass:draw()
    self.state.draw(self)
end

function BalloonClass:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function BalloonClass:die()
end

return BalloonClass
