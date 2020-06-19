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
    {
     type = "textTitle",
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
        type = "textTitle",
        text = "Fuentes tipográficas usadas:"
    },
    {
        type = "text",
        text = "Made with Löve"
    },
    {
        type="image",
        image=quads.love.quad,
        width=quads.love.width,
        height=quads.love.height,
        scaleFactorX=1,
        scaleFactorY=1
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
    table.insert(onScreenData, data[index])
    onScreenData[index].y = 0
end

function screen.update(dt)
    for k, v in pairs(onScreenData) do
        v.y = v.y + verticalSpeed * dt
    end

    if onScreenData[index].y > verticalDistance and index ~= #data then
        index = index + 1
        table.insert(onScreenData, data[index])
        data[index].y = 0
    end

end

function screen.draw()
    love.graphics.clear(1, 0, 1)
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)
    love.graphics.push()
    love.graphics.setCanvas()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(255, 0, 0, 255)
    for k, v in pairs(onScreenData) do
        if v.type == "text" then
            if type(v.text) == "string" then
                love.graphics.printf(v.text, font_buttons, 0, SCREEN_HEIGHT - v.y, SCREEN_WIDTH, "center")
            elseif type(v.text) == "table" then
                --TODO: Coger ancho pantalla y dividir en columnas las tablas
            else
                log.fatal("OH NO! El tipo de dato del texto de créditos es ".. type(v.text))
            end
            verticalDistance = 75

        elseif v.type == "image" then
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
