--[[
    Possible states of the seed:
        * sky
        * falling
        * touchdown
        * onthefloor
        * rotting
        * evolving
        * dead
--]]
local BonusClass = require("gameobjects/bonus")
local SeedClass = {
    x = 0,
    y = 0,
    vx = 10,
    vy = 0,
    width = 20,
    height = 20,
    name = "Seed",
    isSeed = true,
    powerUp = nil,
    bonus = nil,
    player_over_timer = 0,
    willExplode = false,
    states = {
        sky = {
            name = "sky",
            quads = {
                quads.egg_00
            },
            load = function(self)
                self.currentframe = 1
                self.collisions_filter = function(item, other)
                    return "cross"
                end
            end,
            update = function(self, dt)
                if self.x > WORLD_WIDTH then
                    self.x = 0 - self.width
                end
                self.x, self.y, cols, len = self.world:move(self, self.x + self.vx * dt, self.y, self.collisions_filter)
            end,
            draw = function(self)
                if self.powerUp ~= nil then
                    love.graphics.setColor(self.powerUp.color)
                end
                love.graphics.draw(
                    atlas,
                    self.states.sky.quads[self.currentFrame].quad,
                    self.x,
                    self.y,
                    0,
                    --self.state.size,
                    --self.state.size
                    self.width / self.states.sky.quads[self.currentFrame].width,
                    self.height / self.states.sky.quads[self.currentFrame].height
                )
            end
        },
        falling = {
            name = "falling",
            quads = {
                quads.egg_00
            },
            load = function(self)
                self.vy = 25
                self.initY = self.y
                self.current_frame = 1
                self.elapsed_time = 0
                self.collisions_filter = function(item, other)
                    if self.state == self.states.falling and other.isPlayer and self.powerUp ~= nil then
                        self.willExplode = true
                        return
                    elseif other.isSeed and other.state == other.states.sky then
                        return "cross"
                    elseif other.isLimit or other.isBonus then
                        return "cross"
                    else
                        return "slide"
                    end
                end
            end,
            update = function(self, dt)
                self.vy = self.vy + 120 * dt
                target_y = self.y + self.vy * dt
                target_x = self.x
                self.y = target_y
                self.x = target_x
                self.x, self.y, cols, len = self.world:move(self, target_x, target_y, self.collisions_filter)
                if self.y - self.initY > self.height * 2 and len > 0 then -- la semilla se activará al contacto tras caer 2 veces su altura
                    self.change_state(self, self.states.touchdown)
                    return
                end
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 0.5 then
                    --self.elapsed_time = self.elapsed_time - 0.5
                    self.elapsed_time = math.fmod(self.elapsed_time, 0.5)
                    self.current_frame = self.current_frame + 1
                    if self.current_frame > 2 then
                        self.current_frame = 1
                    end
                end
                if self.willExplode then
                    self.change_state(self, self.states.explode)
                end
            end,
            draw = function(self)
                self.states.sky.draw(self)
            end
        },
        touchdown = {
            name = "touchdown",
            quads = {
                quads.egg_01,
                quads.egg_02,
                quads.egg_03,
                quads.egg_04,
                quads.egg_03,
                quads.egg_02,
                quads.egg_01,
                quads.egg_00
            },
            load = function(self)
                self.currentframe = 1
                self.elapsed_time = 0
                self.state_max_time = 1
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > self.state_max_time then
                    if self.powerUp ~= nil then
                        self.change_state(self, self.states.explode)
                    else
                        self.change_state(self, self.states.onthefloor)
                    end
                else
                    self.current_frame = math.floor(1 + #self.state.quads * self.elapsed_time / self.state_max_time)
                end
            end,
            draw = function(self)
                love.graphics.draw(
                    atlas,
                    self.state.quads[self.currentFrame].quad,
                    self.x,
                    self.y,
                    0,
                    --self.state.size,
                    --self.state.size
                    self.width / self.state.quads[self.currentFrame].width,
                    self.height / self.state.quads[self.currentFrame].height
                )
            end
        },
        onthefloor = {
            name = "onthefloor",
            quads = {
                quads.egg
            },
            load = function(self)
                print("onthefloor.load")
                self.elapsed_time = 0
                self.currentframe = 1
                self.player_over_timer = 0
            end,
            update = function(self, dt)
                target_y = self.y + 100 * dt
                self.x, self.y, cols, len = self.world:move(self, self.x, target_y, self.collisions_filter)
                -- comprobamos si tenemos encima un jugador
                local player_over = false
                -- local items, len = world:querySegment(self.x, self.y - 1, self.x + self.width, self.y - 1)
                local items, len = self.world:queryRect(self.x, self.y - self.height / 3, self.width, self.height / 3)
                for i = 1, len do
                    if items[i].isPlayer then
                        player_over = true
                        self.player_over_timer = self.player_over_timer + dt
                        break
                    end
                end
                if player_over == false then
                    self.elapsed_time = self.elapsed_time + dt
                end
                if self.player_over_timer > 2 then
                    self.game.create_balloon_from_seed(self)
                    self.change_state(self, self.states.balloon)
                elseif self.elapsed_time > 5 then
                    self.change_state(self, self.states.rotting)
                end
            end,
            draw = function(self)
                self.states.sky.draw(self)
            end
        },
        evolving = {
            name = "evolving",
            quads = {
                quads.balloon
            },
            load = function(self)
                print("evolving.load")
                self.currentframe = 1
                self.elapsed_time = 0
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt

                -- comprobamos si tenemos encima un jugador
                local player_over = true
                -- local items, len = world:querySegment(self.x, self.y - 1, self.x + self.width, self.y - 1)
                local items, len = self.world:queryRect(self.x, self.y - 2, self.x + self.width, self.y - 2)
                for i = 1, len do
                    if items[i].isPlayer then
                        player_over = true
                        break
                    end
                end
                self.player_over_timer = player_over

                if not self.player_over_timer then
                    self.change_state(self, self.states.rotting)
                elseif self.elapsed_time > 1 then
                    self.game.create_balloon_from_seed(self)
                    self.change_state(self, self.states.balloon)
                end
            end,
            draw = function(self)
                self.states.sky.draw(self)
            end
        },
        balloon = {
            name = "balloon",
            quads = {
                quads.balloon
            },
            load = function(self)
                self.currentframe = 1
            end,
            update = function(self, dt)
            end,
            draw = function(self)
                self.states.sky.draw(self)
            end
        },
        rotting = {
            name = "rotting",
            quads = {
                {
                    quad = love.graphics.newQuad(161, 66, 15, 14, atlasOld:getDimensions()),
                    width = 15,
                    height = 14
                }
            },
            load = function(self)
                print("*** ROTTING ***")
                self.elapsed_time = 0
                self.currentframe = 1
            end,
            update = function(self, dt)
                self.elapsed_time = self.elapsed_time + dt
                if self.elapsed_time > 2 then
                    self:die()
                end
            end,
            draw = function(self)
                self.states.sky.draw(self)
            end
        },
        explode = {
            name = "explode",
            size = 200,
            quads = {
                {
                    quad = love.graphics.newQuad(130, 61, 14, 16, atlasOld:getDimensions()),
                    width = 14,
                    height = 16
                }
            },
            load = function(self)
                self.currentFrame = 1
                self.world:remove(self)
                self:die()
                table.insert(self.game.currentLevel.bonuses, BonusClass.new(self.x, self.y, self.powerUp, self.world, self.game)) 
            end,
            update = function(self, dt)
            end,
            draw = function(self)
                self.states.sky.draw(self)
            end
        }
    }
}

SeedClass.__index = SeedClass

function SeedClass.new(name, sky, world, x, y, game)
    local seed = {}
    seed.game = game
    seed.name = name
    seed.sky = sky
    seed.world = world
    seed.x = x
    seed.y = y
    seed.world:add(seed, seed.x, seed.y, SeedClass.width, SeedClass.height)
    setmetatable(seed, SeedClass)
    --seed.state = SeedClass.states.sky
    seed.currentFrame = 1
    seed.change_state(seed, SeedClass.states.sky)
    return seed
end

function SeedClass:update(dt)
    self.state.update(self, dt)
end

function SeedClass:draw()
    self.state.draw(self)
    love.graphics.setColor(255, 255, 255)
    --love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function SeedClass:change_state(new_state)
    if self.state ~= new_state then
        self.state = new_state
        self.state.load(self)
    end
end

function SeedClass:die()
    self.sky:deleteSeed(self)
end

return SeedClass
