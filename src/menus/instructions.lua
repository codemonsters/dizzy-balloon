local instr = {
    name = "instructions",
}

function instr.load(menuManager, screen)
    instr.menuManager = menuManager
    instr.screen = screen

    -- creamos los botones del menú
    local strings = require("misc/strings")
    local widgetsClass = require("misc/widgets")
    local lang = config.get("language")
    local nPaginaTutorial = 1

    if lang == "es" then
        Tstrings = {
            "Tu objetivo es ir superando niveles hasta llegar al cielo",
            "Puedes moverte, saltar y lanzar bombas",
            "Puedes matar a los enemigos con bombas,\ny ellos pueden matarte aplastándote",
            "Si matas a un enemigo, la semilla\nque había sobre él caerá al suelo",
            "Súbete a una semilla para que sea\nincubada y que crezca un globo",
            "Pásalo bien", 
        }
    elseif lang == "en" then
        Tstrings = {
            "Your goal is to beat levels until you reach the sky",
            "You can move, jump and throw bombs",
            "You can kill enemies with bombs, and\nthey can kill you by crushing you",
            "If you kill an enemy, the seed that\nwas over him will fall to the floor",
            "These seeds can be hatched to grow a balloon",
            "Have fun", 
        }
    end

    buttons = {
        {
            --local idioma = config.get("language"),
            label = Tstrings[nPaginaTutorial],
            callback = function()
                print(Tstrings[nPaginaTutorial])
            end
        },
        {
            label = getString(strings.next),
            callback = function()
                if nPaginaTutorial < table.getn(Tstrings) then
                    nPaginaTutorial = nPaginaTutorial + 1
                    instr.widgets[1].setLabel(Tstrings[nPaginaTutorial])
                else
                    instr.menuManager:changeMenuTo(instr.menuManager:getMenu("main"))
                end
            end
        },
    }
    instr.widgets = {}
    for i = 1, #buttons do
        if i == 1 then
            table.insert(instr.widgets, widgetsClass.newButton(buttons[i].label, SCREEN_WIDTH * 0.15, 150 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.13, buttons[i].callback, font_tutorial, 0.6))
        else
            table.insert(instr.widgets, widgetsClass.newButton(buttons[i].label, 285 + SCREEN_WIDTH * 0.15, 150 + i * SCREEN_HEIGHT * 0.16, SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.13, buttons[i].callback, font_buttons))
        end
    end
end

function instr.update(dt)
    for i = 1, #instr.widgets do
        instr.widgets[i].update()
    end
end

function instr.draw()
    love.graphics.setBlendMode("alpha")
    for i = 1, #instr.widgets do
        instr.widgets[i].draw()
    end
end

return instr