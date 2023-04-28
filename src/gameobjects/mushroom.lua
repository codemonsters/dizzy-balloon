local MushroomClass = {
    x = 0,
    y = 0,
    name = "Seta",
    width = 40,
    height = 40,
    isMushroom = true,
    state = nil,
    states = {
        standing = {
            quads = {
                quads.radish
                --[[
                {
                    quad = love.graphics.newQuad(98, 31, 12, 17, atlas:getDimensions()),
                    width = 12,
                    height = 17
                }
                --]]
            },
            load = function(self)
            end,
            update = function(self, dt)
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

MushroomClass.__index = MushroomClass

function MushroomClass.new(name, world, game, x, y)
    local mushroom = {}
    mushroom.game = game
    mushroom.world = world
    mushroom.name = name
    mushroom.x = x
    mushroom.y = y
    mushroom.dead = false
    world:add(mushroom, mushroom.x, mushroom.y, MushroomClass.width, MushroomClass.height)
    setmetatable(mushroom, MushroomClass)
    mushroom.state = MushroomClass.states.standing
    mushroom.change_state(mushroom, mushroom.states.standing)
    return mushroom
end

function MushroomClass:update(dt)
    if self.dead then
        self.game.remove_mushroom(self)
        return
    end
    self.state.update(self, dt)
end

function MushroomClass:draw()
    if self.dead then
        return
    end
    self.state.draw(self)
end

function MushroomClass:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function MushroomClass:die()
    self.dead = true
end

return MushroomClass
