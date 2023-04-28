local SoundsClass = {
    name = "Sounds",
}

SoundsClass.__index = SoundsClass

function SoundsClass.new()
    local sounds = {
        bombExplosion = {
            audioSource = love.audio.newSource("assets/sounds/bomb_explosion.wav", "static"),
            volume = 1
        },
        bombLaunch = {
            audioSource = love.audio.newSource("assets/sounds/bomb_launch.wav", "static"),
            volume = 1
        },
        gameOver = {
            audioSource = love.audio.newSource("assets/sounds/gameover.wav", "static"),
            volume = 0.3
        },
        levelUp = {
            audioSource = love.audio.newSource("assets/sounds/level_up.wav", "static"),
            volume = 0.5
        },
        lostLife = {
            audioSource = love.audio.newSource("assets/sounds/lostlife.wav", "static"),
            volume = 0.3
        },
        playerJump = {
            audioSource = love.audio.newSource("assets/sounds/player_jump.wav", "static"),
            volume = 0.1
        },    
        uiClick = {
            audioSource = love.audio.newSource("assets/sounds/ui_click.wav", "static"),
            volume = 1
        },
        uiRollOver = {
            audioSource = love.audio.newSource("assets/sounds/ui_rollover.wav", "static"),
            volume = 1
        }
    }
    setmetatable(sounds, SoundsClass)
    return sounds
end

function SoundsClass.play(soundTable)
    soundTable.audioSource:setVolume(soundTable.volume)
    if config.get("sound") == true then
        soundTable.audioSource:play()
    end
end

return SoundsClass