local SoundsClass = {
    name = "Sounds",
}

SoundsClass.__index = SoundsClass

function SoundsClass.new()
    local sounds = {}
    sounds.explosion = love.audio.newSource("assets/sounds/explosion.wav", "static")
    sounds.explosion:setLooping(false)
    sounds.whoosh = love.audio.newSource("assets/sounds/whoosh.wav", "static")
    sounds.whoosh:setLooping(false)
    sounds.jump = love.audio.newSource("assets/sounds/jump.wav", "static")
    sounds.jump:setLooping(false)
    sounds.lostlife = love.audio.newSource("assets/sounds/lostlife.wav", "static")
    sounds.lostlife:setLooping(false)
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
        name = "explosion"
        --src = "assets/sounds/explosion.wav"
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

