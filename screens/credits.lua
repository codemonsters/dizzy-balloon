--[[
    #font:edunline,20
.start
Dizzy Balloon
.end
#font:otrafuente,14
.start
Made with Love <3 by:
.end
.start
__   __                
\ \ / /_ _  __ _  ___  
 \ V / _` |/ _` |/ _ \ 
  | | (_| | (_| | (_) |
  |_|\__,_|\__, |\___/ 
           |___/ 
_______________Yago_F_F_
.end
.start
    _    _           
   / \  | | _____  __
  / _ \ | |/ _ \ \/ /
 / ___ \| |  __/>  < 
/_/   \_\_|\___/_/\_\
     
_________Alejandro_S_P_
.end
.start
____________Marcos_F_P_
.end
.start
#images:una.jpg,dos.jpg,tres.jpg
.end

]]
local screen = {
    name = "Pantalla créditos"
}

local data = {
    --TODO: Crear el "textTitle"
    {
        type = "textTitle",
        text = "DIZZY BALLOON"
    },
    {
        type="space"
    },
    {
        type = "textH1",
        text = "Creado por:"
    },
    {
        type = "text",
        text = {"Braisa", "Kenta", "Marcos", "PabloH"}
    },
    {
        type = "text",
        text = {"Yagueto", "Nerea", "Alejandro"}
    },
    {
        type = "space"
    },
    {
        type = "textH1",
        text = "Fuentes tipográficas usadas:"
    },
    {
        type = "text",
        text = "GBYTftF"
    },
    {
        type = "space"
    },
    {
        type = "textH1",
        text = "Made with Löve"
    },
    {
        type="image",
        image=quads.love.quad,
        width=quads.love.width,
        height=quads.love.height,
        scaleFactorX=0.8,
        scaleFactorY=0.8
    }
}

local onScreenData ={
}

local index = 1

local verticalSpeed = 50

local verticalDistance = 75

-- carga este screen
function screen.load()
    -- música
    --TODO: Deberíamos poner otra música
    --loadAndStartMusic({file = "menu.mp3", volume = 1})
    for k,v in pairs(onScreenData) do
        onScreenData[k] = nil
    end
    print(onScreenData[1])
    index = 1
    table.insert(onScreenData, data[index])
    onScreenData[index].y = -10
    fontH1 = love.graphics.newFont("assets/fonts/unlearne.ttf", 80) -- https://www.1001fonts.com/
    fontH2 = love.graphics.newFont("assets/fonts/unlearne.ttf", 60) -- https://www.dafont.com/es/pixelmania.font
    fontH3 = love.graphics.newFont("assets/fonts/unlearne.ttf", 50)
end

function screen.update(dt)
    for k, v in pairs(onScreenData) do
        v.y = v.y + verticalSpeed * dt
    end

    if onScreenData[index].y > verticalDistance and index ~= #data then
        index = index + 1
        table.insert(onScreenData, data[index])
        data[index].y = -10
    end

end

function screen.draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)
    love.graphics.push()
    love.graphics.setCanvas()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(255, 0, 0, 255)
    for k, v in pairs(onScreenData) do
        if string.match(v.type, "text") then
            local font
            if v.type == "textTitle" then
                font = font_title
                verticalDistance = 2
            elseif v.type == "textH1" then
                font = fontH1
                verticalDistance = 2
            elseif v.type == "textH2" then
                font = fontH2
                verticalDistance = 2
            else
                font = fontH3
                verticalDistance = 2
            end
            verticalDistance = verticalDistance * font:getHeight()
            if type(v.text) == "string" then
                love.graphics.printf(v.text, font, 0, SCREEN_HEIGHT - v.y, SCREEN_WIDTH, "center")
            elseif type(v.text) == "table" then
                local horizontalpos = 0
                local columnsize = SCREEN_WIDTH / (#v.text)
                for key, value in pairs(v.text) do
                    love.graphics.printf(value, font, horizontalpos, SCREEN_HEIGHT - v.y, columnsize, "center")
                    horizontalpos = horizontalpos + columnsize
                end
                verticalDistance = verticalDistance * 0.5
            else
                log.fatal("OH NO! El tipo de dato del texto de créditos es ".. type(v.text))
            end
        elseif v.type == "image" then
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(
                atlas,
                v.image,
                (SCREEN_WIDTH / 2) - v.width * (v.scaleFactorX / 2),
                SCREEN_HEIGHT - v.y,
                0,
                v.scaleFactorX,
                v.scaleFactorY
            )
            verticalDistance = verticalDistance + v.height + 20
        elseif v.type == "space" then
            verticalDistance = 50
        end
    end

    love.graphics.pop()
end

function screen.keypressed(key, scancode, isrepeat)
    changeScreen(require("screens/menu"))
end

function screen.keyreleased(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch, presses)
    changeScreen(require("screens/menu"))
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    changeScreen(require("screens/menu"))
end

return screen
