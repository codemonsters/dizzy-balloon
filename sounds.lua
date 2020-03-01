local SoundsClass = {
    name = "Sounds",
}

SoundsClass.__index = SoundsClass

function SoundsClass.new()
    local sounds = {}
    sounds.bomb_explosion = love.audio.newSource("assets/sounds/bomb_explosion.wav", "static")
    sounds.bomb_explosion:setLooping(false)
    sounds.bomb_launch = love.audio.newSource("assets/sounds/bomb_launch.wav", "static")
    sounds.bomb_launch:setLooping(false)
    sounds.player_jump = love.audio.newSource("assets/sounds/player_jump.wav", "static")
    sounds.player_jump:setLooping(false)
    sounds.player_jump:setVolume(0.1)
    sounds.lostlife = love.audio.newSource("assets/sounds/lostlife.wav", "static")
    sounds.lostlife:setLooping(false)
    sounds.lostlife:setVolume(0.5)
    sounds.level_up = love.audio.newSource("assets/sounds/level_up.wav", "static")
    sounds.level_up:setLooping(false)
    sounds.level_up:setVolume(0.5)
    sounds.ui_click = love.audio.newSource("assets/sounds/ui_click.wav", "static")
    sounds.ui_click:setLooping(false)
    sounds.ui_click:setVolume(1)
    sounds.ui_rollover = love.audio.newSource("assets/sounds/ui_rollover.wav", "static")
    sounds.ui_rollover:setLooping(false)
    sounds.ui_rollover:setVolume(1)
    --sounds.name = name
    setmetatable(sounds, SoundsClass)
    return sounds
end

return SoundsClass