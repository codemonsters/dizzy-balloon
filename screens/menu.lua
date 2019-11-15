local PlayerClass = require("gameobjects/player")
local bump = require "libraries/bump/bump"
local BlockClass = require("gameobjects/block")
local animLoader = require("animationLoader")

local menu = { name = "Menú principal" }
local negro = {1, 1, 1, 1}

function menu.load()
    world = bump.newWorld(50)
    jugador = PlayerClass.new(world, nil)
    local borderWidth = 50
    BlockClass.new("Suelo", 0, WORLD_HEIGHT, WORLD_WIDTH, borderWidth, world)
    animLoader:load(jugador)
end
function menu.update(dt)
    jugador:update(dt)
    animLoader:update(dt)

end

function menu.draw()
    love.graphics.clear(255, 255, 255)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf(
        "DIZZY BALLOON\n\n=PRESS FIRE TO START=",
        font_menu,
        0,
        math.floor((SCREEN_HEIGHT - font_menu:getHeight() * 2) / 2),
        SCREEN_WIDTH,
        "center"
    )
    jugador:draw()
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        game_screen = require("screens/game")
        change_screen(game_screen)
    end
end

function menu.keyreleased(key, scancode, isrepeat)

end

function love.mousepressed(id, x, y, dx, dy, pressure)
    game_screen = require("screens/game")
    change_screen(game_screen)
end

return menu
