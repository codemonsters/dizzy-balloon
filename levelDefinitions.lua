local PlayerClass = require("gameobjects/player")

local LevelDefinitions = {
    {
        id = 1,
        name = "Nivel 1",
        blocks = {},
        max_enemies = 2,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height}
    },
    {
        id = 2,
        name = "Nivel 2",
        blocks = {
            { name = "Bloque 1", x = 150, y = 620, width = 400, height = 10 },
            { name = "Bloque 2", x = 200, y = 220, width = 300, height = 10 }
        },
        max_enemies = 3,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height}
    },
    {
        id = 3,
        name = "Nivel 3",
        blocks = {
            { name = "Bloque 1", x = 0, y = 250, width = 175, height = 5 },
            { name = "Bloque 2", x = 525, y = 250, width = 175, height = 5},
            { name = "Bloque 3", x = 0, y = 480, width = 250, height = 5},
            { name = "Bloque 4", x = 450, y = 480, width = 250, height = 5},
            { name = "Bloque 5", x = 325, y = 670, width = 50, height = 25},
            { name = "Bloque 6", x = 300, y = 695, width = 100, height = 25}
        },
        max_enemies = 4,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height}
    },
    {
        id = 4,
        name = "Nivel 4",
        blocks = {
            { name = "Bloque 1", x = 150, y = 455, width = 400, height = 30},
            { name = "Bloque 2", x = 335, y = 20, width = 30, height = 435}
        },
        max_enemies = 3,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height}
    },
    {
        id = 5,
        name = "Nivel 5",
        blocks = {
            { name = "Bloque 1", x = 160, y = 20, width = 15, height = 235},
            { name = "Bloque 2", x = 525, y = 20, width = 15, height = 235},
            { name = "Bloque 3", x = 160, y = 485, width = 15, height = 235},
            { name = "Bloque 4", x = 525, y = 485, width = 15, height = 235}
        },
        max_enemies = 6,
        player_initial_respawn_position = {330, WORLD_HEIGHT - PlayerClass.height}
    }
}

return LevelDefinitions