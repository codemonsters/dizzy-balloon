local ourTheme = {}
ourTheme = setmetatable({}, {__index = suit.theme})

-- NOTE: you have to replace the whole color table. E.g., replacing only
--       dress.theme.color.normal will also change suit.theme.color.normal!
local labelColor = {normal = {fg = {255, 255, 255}}}

--ourTheme.fontDefaultButtons = love.graphics.newFont("assets/fonts/FutureNow.ttf", 70)
ourTheme.fontDefaultButtons = love.graphics.newFont("assets/fonts/unlearne.ttf", 60) -- https://www.1001fonts.com/unlearned-font.html
ourTheme.fontDefaultLabels = love.graphics.newFont("assets/fonts/edunline.ttf", 80)

local buttonParameters = {
    cornerRadius = 10,
    color = {
        normal = {bg = {0, 0, 0, 0.15}, fg = {0.753, 0, 0.427}},
        hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
        active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
    }
}

-- HELPER
function ourTheme.getColorForState(opt, widget)
    local s = opt.state or "normal"
    if widget == "button" then
        return (buttonParameters.color[s])
    end
end

function ourTheme.Label(text, opt, x, y, w, h)
    y = y + ourTheme.getVerticalOffsetForAlign(opt.valign, opt.font, h)

    love.graphics.setColor(labelColor.normal.fg)
    love.graphics.setFont(ourTheme.fontDefaultLabels)
    love.graphics.printf(text, x + 2, y, w - 4, opt.align or "center")
end

function ourTheme.Button(text, opt, x, y, w, h)
    --if opt.font then
    --    print("TENEMOS OPT.FONT")
    --    love.graphics.setFont(opt.font)
    --else
    love.graphics.setFont(ourTheme.fontDefaultButtons)
    --end

    local c = ourTheme.getColorForState(opt, "button")

    ourTheme.drawBox(x, y, w, h, c, buttonParameters.cornerRadius)
    love.graphics.setColor(buttonParameters.color.normal.fg)

    y = y + ourTheme.getVerticalOffsetForAlign(opt.valign, opt.font, h)
    love.graphics.printf(text, x + 2, y, w - 4, "center")
end

return ourTheme
