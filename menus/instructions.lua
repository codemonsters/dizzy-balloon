local menu = {
    name = "instructions",
    widgets = suit.new(require("menus/ourTheme"))
}
local PlayerClass = require("gameobjects/player")

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen
    paginaTutorial = 1
    paginasTutorial = {
        "Presiona siguiente para comenzar el tutorial",
        "Tu objetivo es llegar al cielo sin ser eliminado",
        "Puedes moverte hacia los lados, saltar y lanzar bombas",
        "Puedes matar a los enemigos con bombas, y ellos pueden matarte aplastándote",
        "Si matas a un enemigo, la semilla que había sobre él caerá al suelo",
        "Estas semillas pueden ser incubadas posándose en ellas para hacer crecer un globo",
        "Cuando te subas a uno de estos globos, podrás conducirlos libremente", 
        "Tu habilidad de lanzar bombas no estará disponible mientras montes en globo", 
        "Presta atención a las semillas que causan reacciones especiales al tocar el suelo",
        "Las bombas que no hayan detonado exitosamente se convertirán en setas", 
        "Ten cuidado con tus propias bombas",  
        "El espacio mínimo que necesitas en el techo para pasar al siguiente nivel es de tres semillas",
        "Algunos niveles tienen plataformas a las que puedes subirte", 
        "Pásalo bien",  
    }

    jugador = PlayerClass.new(world, nil)
    posX = 500
    posY = 500
    
    -- creamos los botones del menú
    local strings = require("misc/strings")
    local widgetsClass = require("misc/widgets")
    local buttons = {
    widgetsClass = require("misc/widgets")

        {
            label = paginasTutorial[paginaTutorial],
            callback = function()
            end
        },
        {
            label = "Anterior",
            callback = function()
                if paginaTutorial > 1 then
                    paginaTutorial = paginaTutorial - 1
                end
            end
        },
        {
            label = "Siguiente",
            callback = function()
                if paginaTutorial < 15 then
                    paginaTutorial = paginaTutorial + 1
                    print(paginaTutorial)
                end
            end
        },
        {
            label = getString(strings.goBack),
            callback = function()
                if menu.menuManager.screenState == menu.menuManager.screenStates.showingMenu then
                    menu.menuManager:changeMenuTo(menu.menuManager:getMenu("main"))
                end
            end
        }
    }
end

function menu.update(dt)
    buttons[1].label = paginasTutorial[paginaTutorial]
    jugador.x = posX
    jugador.y = posY
    for i = 1, #menu.widgets do
        menu.widgets[i].update()
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    jugador:draw()
    for i = 1, #menu.widgets do
        menu.widgets[i].draw()
    end
end
return menu