--[[
    Gestor de menús para utilizar en distintas pantallas. Tiene métodos load(), update(dt) y draw() que se pueden incluir dentro del ciclo de vida de Love.

    Es capaz de mostrar varios menús y transiciones (efectos) cuando se cambia de un menú a otro (evita la necesidad de cambiar de screen).
    Tiene métodos load(), update(dt) y draw() para poder ser incluido dentro del ciclo de vida de cualquier screen.

    Parámetros de sus constructor / método new(menus, effects):
    * menus: Lista con los menús que queremos cargar. Cada elemento de la lista será una tabla con dos claves:
        * name: guarda el string con el nombre que queremos darle internamente a este menú.
        * menu: guarda el menú tal y como es devuelto por llamadas como require('menus/EL_MENU_QUE_NOS_INTERESE').

    * transitions: Lista con los efectos a utilizar cuando se realiza la transición de un menú a otro. Cada elemento es una tabla con tres campos:
        * from: nombre del menú origen (el nombre tal y como está definido en la lista menus).
        * to: nombre del menú destino.
        * effect: Por ejemplo cualquier de los definidos dentro de menuManagerClass.screenStates.changingMenu.effects.

    Inicialmente se cargará y mostrará el primer menú definido en la lista menus.
]] --

local MenuManagerClass = {
    name = "MenuManager",
    x,
    y = 0,
    0,
    width,
    height = 0,
    0,
    isBlock = true,
    quad = love.graphics.newQuad(162, 148, 1, 1, atlas:getDimensions())
}

MenuManagerClass.__index = MenuManagerClass

function MenuManagerClass.new(menus, transitions, screen)
    local menuManager = {}
    menuManager.menus = menus
    menuManager.transitions = transitions
    menuManager.screen = screen
    setmetatable(menuManager, MenuManagerClass)
    menuManager.init(menuManager)
    return menuManager
end

function MenuManagerClass:init()
    _, self.startMenu = next(self.menus)
    self.changeMenuTo(self, self.startMenu.menu)
end

-- A partir del valor de self.currentMenu y de self.nextMenu devuelve nil o el efecto de transición a aplicar según lo que esté definido en self.transitions
MenuManagerClass.getDefinedMenuTransitionFor = function(self, fromMenu, toMenu)
    local fromMenuName, toMenuName, iToMenuName, iFromMenuName
    if not fromMenu then
        fromMenuName = "nil"
    else
        fromMenuName = fromMenu.name
    end
    if not toMenu then
        toMenuName = "nil"
    else
        toMenuName = toMenu.name
    end
    for i = 1, #self.transitions do
        local transition = self.transitions[i]
        if transition.from then
            iFromMenuName = transition.from
        else
            iFromMenuName = "nil"
        end
        if transition.to then
            iToMenuName = transition.to
        else
            iToMenuName = "nil"
        end
        if fromMenuName == iFromMenuName and toMenuName == iToMenuName then
            return transition.effect
        end
    end
    return nil
end

MenuManagerClass.screenStates = {
    changingMenu = {
        -- transición de un menú a otro
        name = "chagingMenu",
        load = function(self)
            self.currentTransition = MenuManagerClass.getDefinedMenuTransitionFor(self, self.currentMenu, self.nextMenu)
            if self.currentTransition then
                self.currentTransition.load(self)
            else
                -- No se ha definido ninguna transición, el nuevo menú sustituye instantáneamente al actual (sin utilizar ninguna transición)
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
            end
        end,
        update = function(self, dt)
            self.currentTransition.update(self, dt)
        end,
        draw = function(self)
            self.currentTransition.draw(self)
        end
    },
    showingMenu = {
        -- mostrando un menú
        name = "showingMenu",
        load = function(self)
        end,
        update = function(self, dt)
            if self.currentMenu then
                self.currentMenu.update(self, dt)
            end
            if self.nextMenu then
                self.nextMenu.update(self, dt)
            end
        end,
        draw = function(self)
            if self.currentMenu then
                self.currentMenu.draw()
            end
            if self.nextMenu then
                self.nextMenu.draw()
            end
        end
    }
}

function MenuManagerClass:keypressed(key, scancode, isrepeat)
    if self.screenState == MenuManagerClass.screenStates.showingMenu and self.currentMenu then
        self.currentMenu.keypressed(key, scancode, isrepeat)    end
end

function MenuManagerClass:keyreleased(key, scancode, isrepeat)
    if self.screenState == MenuManagerClass.screenStates.showingMenu and self.currentMenu then
        self.currentMenu.keyreleased(key, scancode, isrepeat)
    end
end
-- Inicia la transición desde el menú actual al menú nextMenu, ejecutando después la función afterTransitionCallback (lo que con frecuencia será una acción que cambie de pantalla). Si delayedExec vale true la acción se ejecutará justo después de update() y de draw()
function MenuManagerClass:changeMenuTo(nextMenu, afterTransitionCallback, delayedExec)
    if delayedExec then
        self.execOnceAfterDraw = function(self)
            if nextMenu then
                -- guardamos el menú en self.nextMenu y llamamos a su método load()
                self.nextMenu = nextMenu
                self.nextMenu.load(self, self.screen) -- al menú le pasamos como argumento el objeto MenuManagerClass para que pueda acceder a él por ejemplo cuando ese menú quiere pedir que se cambie a otro distinto
            else
                self.nextMenu = nil
            end
            self.afterTransitionCallback = afterTransitionCallback
            self.changeScreenState(self, MenuManagerClass.screenStates.changingMenu)
        end
    else
        if nextMenu then
            -- guardamos el menú en self.nextMenu y llamamos a su método load()
            self.nextMenu = nextMenu
            self.nextMenu.load(self, self.screen) -- al menú le pasamos como argumento el objeto MenuManagerClass para que pueda acceder a él por ejemplo cuando ese menú quiere pedir que se cambie a otro distinto
        else
            self.nextMenu = nil
        end
        self.afterTransitionCallback = afterTransitionCallback
        self.changeScreenState(self, MenuManagerClass.screenStates.changingMenu)
    end
end

function MenuManagerClass:getMenu(menuName)
    if not menuName then
        error("MenuManagerClass:getMenu(menuName): función llamada con menuName = nil")
    end
    for i = 1, #self.menus do
        if self.menus[i].name == menuName then
            return self.menus[i].menu
        end
    end
    error("MenuManagerClass:getMenu(menuName): Menú '" .. menuName .. "' no encontrado.")
end

function MenuManagerClass:changeScreenState(screenState)
    if screenState == nil then
        error("menu.changeScreenState() received a nil screenState argument")
    end
    self.screenState = screenState
    self:load()
end

function MenuManagerClass:load()
    self.screenState.load(self)
end

function MenuManagerClass:update(dt)
    self.screenState.update(self, dt)
end

function MenuManagerClass:draw()
    love.graphics.setBlendMode("alpha")
    self.screenState.draw(self)
    if self.delayedAfterDrawAction then
        self.delayedAfterDrawAction()
        self.delayedAfterDrawAction = nil
    end
    if self.execOnceAfterDraw then
        self.execOnceAfterDraw(self)
        self.execOnceAfterDraw = nil
    end
end

MenuManagerClass.effects = {
    moveDown = {
        name = "moveDown",
        load = function(self)
            self.currentMenuShiftX = 0
            self.currentMenuShiftY = 0
            self.nextMenuShiftX = 0
            self.nextMenuShiftY = -SCREEN_HEIGHT
            self.velY = 1500
        end,
        update = function(self, dt)
            self.currentMenuShiftY = self.currentMenuShiftY + dt * self.velY
            self.nextMenuShiftY = self.nextMenuShiftY + dt * self.velY
            if self.nextMenuShiftY > 0 then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                if self.afterTransitionCallback then
                    self.afterTransitionCallback()
                end
            end
            if self.currentMenu then
                self.currentMenu.update(self, dt)
            end
            if self.nextMenu then
                self.nextMenu.update(self, dt)
            end
        end,
        draw = function(self)
            if self.currentMenu then
                love.graphics.push()
                love.graphics.translate(self.currentMenuShiftX, self.currentMenuShiftY)
                self.currentMenu.draw(self)
                love.graphics.pop()
            end
            if self.nextMenu then
                love.graphics.push()
                love.graphics.translate(self.nextMenuShiftX, self.nextMenuShiftY)
                self.nextMenu.draw(self)
                love.graphics.pop()
            end
        end
    },
    moveUp = {
        name = "moveUp",
        load = function(self)
            self.currentMenuShiftX = 0
            self.currentMenuShiftY = 0
            self.nextMenuShiftX = 0
            self.nextMenuShiftY = SCREEN_HEIGHT
            self.velY = -1500
        end,
        update = function(self, dt)
            self.currentMenuShiftY = self.currentMenuShiftY + dt * self.velY
            self.nextMenuShiftY = self.nextMenuShiftY + dt * self.velY
            if self.nextMenuShiftY <= 0 then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                if self.afterTransitionCallback then
                    self.afterTransitionCallback()
                end
            end
            if self.currentMenu then
                self.currentMenu.update(self, dt)
            end
            if self.nextMenu then
                self.nextMenu.update(self, dt)
            end
        end,
        draw = function(self)
            self.effects.moveDown.draw(self)
        end
    },
    moveLeft = {
        name = "moveLeft",
        load = function(self)
            sounds.play(sounds.uiRollOver)
            self.currentMenuShiftX = 0
            self.currentMenuShiftY = 0
            self.nextMenuShiftX = SCREEN_WIDTH
            self.nextMenuShiftY = 0
            self.velX = -2500
        end,
        update = function(self, dt)
            self.currentMenuShiftX = self.currentMenuShiftX + dt * self.velX
            self.nextMenuShiftX = self.nextMenuShiftX + dt * self.velX
            if self.currentMenuShiftX <= -SCREEN_WIDTH then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                if self.afterTransitionCallback then
                    self.afterTransitionCallback()
                end
            end
            if self.currentMenu then
                self.currentMenu.update(self, dt)
            end
            if self.nextMenu then
                self.nextMenu.update(self, dt)
            end
        end,
        draw = function(self)
            self.effects.moveDown.draw(self)
        end
    },
    moveRight = {
        name = "moveRight",
        load = function(self)
            sounds.play(sounds.uiRollOver)
            self.currentMenuShiftX = 0
            self.currentMenuShiftY = 0
            self.nextMenuShiftX = -SCREEN_WIDTH
            self.nextMenuShiftY = 0
            self.velX = 2500
        end,
        update = function(self, dt)
            self.currentMenuShiftX = self.currentMenuShiftX + dt * self.velX
            self.nextMenuShiftX = self.nextMenuShiftX + dt * self.velX
            if self.currentMenuShiftX >= SCREEN_WIDTH then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                if self.afterTransitionCallback then
                    self.afterTransitionCallback()
                end
            end
            if self.currentMenu then
                self.currentMenu.update(self, dt)
            end
            if self.nextMenu then
                self.nextMenu.update(self, dt)
            end
        end,
        draw = function(self)
            self.effects.moveDown.draw(self)
        end
    },
    fadeOut = {
        name = "fadeOut",
        load = function(self)
            self.timer = 0
            self.fadeMaxTimeInSeconds = 1
        end,
        update = function(self, dt)
            self.timer = self.timer + dt
            self.alpha = self.timer / self.fadeMaxTimeInSeconds
            if self.alpha > 1 then
                self.alpha = 1
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                if self.afterTransitionCallback then
                    self.afterTransitionCallback()
                end
            end
            if self.currentMenu then
                self.currentMenu.update(self, dt)
            end
        end,
        draw = function(self)
            self.currentMenu.draw(self)
            love.graphics.setColor(0, 0, 0, self.alpha)
            love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        end
    }
}
return MenuManagerClass
