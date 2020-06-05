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

-- carga este screen
function screen.load()
    -- música
    --TODO: Deberíamos poner otra música
    loadAndStartMusic({file = "menu.mp3", volume = 1})
    -- animaciones
end

function screen.update(dt)
end

function screen.draw()
    love.graphics.clear(1, 0, 1)
    love.graphics.push()
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)
    --love.graphics.setColor(255, 0, 0, 255)
    -- DEBUG: marcas en los extremos diagonales de la pantalla
    love.graphics.setColor(255, 0, 0)
    love.graphics.line(0, 0, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1)
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
