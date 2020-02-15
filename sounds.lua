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

--[[
function BlockClass:draw()
    love.graphics.draw(
        atlas,
        self.quad,
        self.x,
        self.y,
        0,
        self.width,
        self.height
    )
end
--]]
return SoundsClass

--[[
local soundTable = {
    {
        name = "bomb_explosion"
        --src = "assets/sounds/bomb_explosion.wav"
        looping = false
        volume = 1
        type = "static"
    },
    {
        name = "bombLaunch"
        --src = "assets/sounds/bombLaunch.wav"
        looping = false
        volume = 1
        type = "static"
    }
}

return soundTable
--]]

