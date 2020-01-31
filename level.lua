local BlockClass = require("gameobjects/block")
local SkyClass = require("gameobjects/sky")
local GoalClass = require("gameobjects/goal")
local LimitClass = require("gameobjects/limit")
local bump = require "libraries/bump/bump"

local LevelClass = {
    name = "Level"
}

LevelClass.__index = LevelClass

function LevelClass.new(levelDefinition, game)
    local level = {}
    setmetatable(level, LevelClass)
    level.id = levelDefinition.id
    level.world = bump.newWorld(50)
    level.game = game
    level.levelDefinition = levelDefinition
    level.max_enemies = level.levelDefinition.max_enemies
    level.music = level.levelDefinition.music
    level.blocks = {}
    for _, block in ipairs(level.levelDefinition.blocks) do
        table.insert(level.blocks, BlockClass.new(block.name, block.x, block.y, block.width, block.height, level.world))
    end
    level.enemies = {}
    level.mushrooms = {}
    level.balloons = {}
    level.sky = SkyClass.new(level.world, level.game, level)
    level.goal = GoalClass.new("Salida", 0, -1, WORLD_WIDTH, 1, level.world)
    level.limit = LimitClass.new("Techo", 0, 0, WORLD_WIDTH, 20, level.world) -- El limite es necesario para bloquear el escape de enemigos y otros objetos excepto las semillas y el jugador
    level.player_initial_respawn_position = level.levelDefinition.player_initial_respawn_position
    level.worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)
    return level
end

return LevelClass