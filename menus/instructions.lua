local menu = {
    name = "instructions",
}

function menu.load(menuManager, screen)
    menu.menuManager = menuManager
    menu.screen = screen

    -- creamos los botones del menú
    local strings = require("misc/strings")
    local widgetsClass = require("misc/widgets")
    local lang = config.get("language")
    local nPaginaTutorial = 1

    if lang == "es" then
        Tstrings = {
            "Tu objetivo es ir superando niveles hasta llegar al cielo",
            "Puedes moverte, saltar y lanzar bombas",
            "Puedes matar a los enemigos con bombas, y ellos pueden matarte aplastándote",
            "Si matas a un enemigo, la semilla que había sobre él caerá al suelo",
            "Súbete a una semilla para incubarla y que crezca un globo",
            "Pásalo bien", 
        }
    elseif lang == "en" then
        Tstrings = {
            "Your goal is to beat levels until you reach the sky",
            "You can move, jump and throw bombs",
            "You can kill enemies with bombs, and they can kill you by crushing you",
            "If you kill an enemy, the seed that was over him will fall to the floor",
            "These seeds can be hatched to grow a balloon",
            "Have fun", 
        }
    end

    print(Tstrings[nPaginaTutorial])
    local buttons = {
        {
            --local idioma = config.get("language"),
            label = Tstrings[nPaginaTutorial],
            callback = function()
                print('hola')
            end
        },
        {
            label = getString(strings.previous),
            callback = function()
                if nPaginaTutorial > 1 then
                    nPaginaTutorial = nPaginaTutorial - 1 
                end
            end
        },
        {
            label = getString(strings.next),
            callback = function()
                if nPaginaTutorial < table.getn(Tstrings) then
                    nPaginaTutorial = nPaginaTutorial + 1 
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
    menu.widgets = {}
    for i = 1, #buttons do
        table.insert(menu.widgets, widgetsClass.newButton(buttons[i].label, SCREEN_WIDTH * 0.15, 50 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, buttons[i].callback, font_buttons))
    end
end

function menu.update(dt)
    print(nPaginaTutorial)
    for i = 1, #menu.widgets do
        menu.widgets[i].update()
    end
end

function menu.draw()
    love.graphics.setBlendMode("alpha")
    for i = 1, #menu.widgets do
        menu.widgets[i].draw()
    end
end

return menu