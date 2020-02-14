local PlayerClass = require("gameobjects/player")

local LevelDefinitions = {
    {
        id = 1,
        name = "Nivel 1",
        blocks = {},
        max_enemies = 2,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height},
        music = {
            file = 'stage1.mp3',
            volume = 0.1
        },
        --music = "pp_fight_or_flight_full_loop.mp3",
        volume = 0.3,
        powerups = {
            speedBoost = 3,
            extraLife = 2,
            jumpBoost = 3,
            extraBomb = 5
        },
        time = 300
    },
    {
        id = 2,
        name = "Nivel 2",
        blocks = {
            {name = "Bloque 1", x = 150, y = 620, width = 420, height = 10},
            {name = "Bloque 2", x = 200, y = 220, width = 320, height = 10}
        },
        max_enemies = 3,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height},
        --music = "pp_silly_goose_full_loop.mp3"
        music = {
            file = 'stage2.mp3',
            volume = 1
        },
        powerups = {
            speedBoost = 2,
            extraLife = 2,
            jumpBoost = 2,
            extraBomb = 4
        },
        time = 240
    },
    {
        id = 3,
        name = "Nivel 3",
        blocks = {
            {name = "Bloque 1", x = 0, y = 250, width = 185, height = 5},
            {name = "Bloque 2", x = 535, y = 250, width = 185, height = 5},
            {name = "Bloque 3", x = 0, y = 480, width = 260, height = 5},
            {name = "Bloque 4", x = 460, y = 480, width = 260, height = 5},
            {name = "Bloque 5", x = 325, y = 670, width = 50, height = 25},
            {name = "Bloque 6", x = 300, y = 695, width = 100, height = 25}
        },
        max_enemies = 4,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height},
        --music = "pp_destiny_full_loop.mp3"
        music = {
            file = 'stage3.mp3',
            volume = 1
        },
        powerups = {
            speedBoost = 2,
            extraLife = 2,
            jumpBoost = 2,
            extraBomb = 3
        },
        time = 180
    },
    {
        id = 4,
        name = "Nivel 4",
        blocks = {
            {name = "Bloque 1", x = 150, y = 455, width = 420, height = 30},
            {name = "Bloque 2", x = 335, y = 20, width = 50, height = 435}
        },
        max_enemies = 3,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height},
        music = {
            file = 'stage4.mp3',
            volume = 0.1
        },
        powerups = {
            speedBoost = 1,
            extraLife = 1,
            jumpBoost = 1,
            extraBomb = 3
        },
        time = 180
    },
    {
        id = 5,
        name = "Nivel 5",
        blocks = {
            {name = "Bloque 1", x = 160, y = 20, width = 15, height = 235},
            {name = "Bloque 2", x = 545, y = 20, width = 15, height = 235},
            {name = "Bloque 3", x = 160, y = 485, width = 15, height = 235},
            {name = "Bloque 4", x = 545, y = 485, width = 15, height = 235}
        },
        max_enemies = 6,
        player_initial_respawn_position = {330, WORLD_HEIGHT - PlayerClass.height},
        --music = "pp_fight_or_flight_heavy_loop.mp3"
        music = {
            file = 'stage5.mp3',
            volume = 1
        },
        powerups = {
            speedBoost = 1,
            extraLife = 1,
            jumpBoost = 1,
            extraBomb = 2
        },
        time = 150
    },
    {
        id = 6,
        name = "Nivel 6",
        blocks = {
            {name = "Bloque 01", x = 180, y = 180, width = 360, height = 10},
            {name = "Bloque 02", x = 180, y = 180, width = 10, height = 140},
            {name = "Bloque 03", x = 180, y = 400, width = 10, height = 140},
            {name = "Bloque 04", x = 180, y = 530, width = 140, height = 10},
            {name = "Bloque 05", x = 400, y = 530, width = 140, height = 10},
            {name = "Bloque 06", x = 530, y = 190, width = 10, height = 140},
            {name = "Bloque 07", x = 530, y = 400, width = 10, height = 140},
            {name = "Bloque 08", x = 330, y = 375, width = 60, height = 10},
            {name = "Bloque 09", x = 85, y = 90, width = 10, height = 90},
            {name = "Bloque 10", x = 85, y = 540, width = 10, height = 90},
            {name = "Bloque 11", x = 625, y = 90, width = 10, height = 90},
            {name = "Bloque 12", x = 625, y = 540, width = 10, height = 90}
        },
        max_enemies = 3,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height},
        powerups = {
            speedBoost = 2,
            extraLife = 1,
            jumpBoost = 1,
            extraBomb = 3
        },
        time = 210
    },
    {
        id = 7,
        name = "Nivel 7",
        blocks = {
            {name = "Bloque 1", x = 250, y = 675, width = 125, height = 15},
            {name = "Bloque 2", x = 425, y = 600, width = 125, height = 15},
            {name = "Bloque 3", x = 600, y = 525, width = 125, height = 15},
            {name = "Bloque 4", x = 375, y = 475, width = 125, height = 15},
            {name = "Bloque 4.5", x = 175, y = 425, width = 125, height = 15},
            {name = "Bloque 5", x = 0, y = 375, width = 100, height = 15},
            {name = "Bloque 6", x = 250, y = 300, width = 125, height = 15},
            {name = "Bloque 7", x = 450, y = 225, width = 125, height = 15},
            {name = "Bloque 8", x = 650, y = 150, width = 125, height = 15}
        },
        max_enemies = 0,
        player_initial_respawn_position = {1, WORLD_HEIGHT - PlayerClass.height},
        --music = "PP_Fight_or_Flight_FULL_Loop.mp3"
        powerups = {
            speedBoost = 0,
            extraLife = 0,
            jumpBoost = 0,
            extraBomb = 0
        },
        time = 600
    }
}

return LevelDefinitions
