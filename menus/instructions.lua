local menu = {
    name = "instructions",
    widgets = suit.new(require("menus/ourTheme"))
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    menu.musicOn = false
    
    tutorialStarted = false
    tutorialPage = 1
    tutorialPages = {
        "Comenzar tutorial",
        "Tu objetivo es llegar al cielo sin ser eliminado",
        "Puedes moverte hacia los lados, saltar y lanzar bombas", 
        "Puedes matar a los enemigos con bombas, y ellos pueden matarte a ti de aplastamiento",
        "Si matas a un enemigo, la semilla que tenían encima caerá al suelo",
        "Estas semillas pueden ser incubadas al posarse sobre ellas, y harán crecer un globo",
        "Cuando te subas a estos globos, podrás conducirlos libremente por todo el nivel ", 
        "Tu habilidad de lanzar bombas no estará disponible durante los viajes en globo", 
        "Presta atención a las semillas que causan reacciones especiales al tocar el suelo",
        "Las bombas que no hayan detonado correctamente se convertirán en setas", 
        "Ten cuidado con la zona de explosión de tus propias bombas",  
        "El espacio mínimo que necesitas en el techo para pasar al siguiente nivel es de tres semillas",
        " Algunos niveles tienen plataformas a las que puedes subirte, y contra las que pueden aplastarte", 
        "Pásalo bien",  
        }

end

function menu.update(dt)
    menu.widgets.layout:reset(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.1)
    menu.widgets.layout:padding(SCREEN_HEIGHT * 0.015, SCREEN_WIDTH * 0.015)
    local mouseX, mouseY = love.mouse.getPosition()
    
    menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)


    if menu.widgets:Button(tutorialPages[tutorialPage], menu.widgets.layout:down(SCREEN_WIDTH * .8, SCREEN_HEIGHT * 0.4)).hit then
       if tutorialPage < 14 then
            tutorialPage = tutorialPage + 1
       else
            tutorialPage = 1
       end
    end


    if
        menu.widgets:Button(
            "Volver",
            {
                color = {
                    normal = {bg = {0, 0, 0, 0.15}, fg = {1, 1, 1}},
                    hovered = {fg = {1, 1, 1}, bg = {0.5, 0.5, 0.5, 0.5}},
                    active = {bg = {0, 0, 0, 0.5}, fg = {255, 255, 255}}
                }
            },
            menu.widgets.layout:down(SCREEN_WIDTH * .8, SCREEN_HEIGHT * 0.11)
        ).hit
     then
        if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
            menu.menuManager:changeMenuTo(menu.menuManager:getMenu("main"))
        end
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    menu.widgets:draw()
end

return menu