--[[
menuWidgets.theme.color = {
    normal   = {bg = {188,188,188}, fg = { 66, 66, 66}},
    hovered  = {bg = {255,255,255}, fg = { 50,153,187}},
    active   = {bg = {255,255,255}, fg = {225,153,  0}}
}

--]]
local ourTheme = {}
ourTheme.theme = setmetatable({}, {__index = suit.theme})

-- NOTE: you have to replace the whole color table. E.g., replacing only
--       dress.theme.color.normal will also change suit.theme.color.normal!
ourTheme.theme.color = {
    normal   = {bg = {188,188,188}, fg = { 66, 66, 66}},
    hovered  = {bg = {255,255,255}, fg = { 50,153,187}},
    active   = {bg = {255,255,255}, fg = {225,153,  0}}
}

function ourTheme.theme.Label(text, opt, x,y,w,h)
    -- draw the label in a fancier way
end

return ourTheme
