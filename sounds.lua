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
    sounds.player_jump:setVolume(0.05)
    sounds.lostlife = love.audio.newSource("assets/sounds/lostlife.wav", "static")
    sounds.lostlife:setLooping(false)
    sounds.lostlife:setVolume(0.5)
    --sounds.name = name
    setmetatable(sounds, SoundsClass)
    return sounds
end

return SoundsClass