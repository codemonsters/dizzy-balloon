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
]]--

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

function MenuManagerClass.new(menus, transitions)
    local menuManager = {}
    menuManager.menus = menus
    menuManager.transitions = transitions
    setmetatable(menuManager, MenuManagerClass)
    -- estado inicial de los menús
    --NIL INNECESARIO: menuManager.currentMenu = nil -- forzamos currentMenu a nil para que changeMenuTo sepa que el menú que va a cargar es el primero de esta pantalla
    --NIL INNECESARIO: menuManager.currentTransition = nil
    _, menuManager.startMenu = next(menuManager.menus)
    menuManager.changeMenuTo(menuManager, menuManager.startMenu.menu)
    return menuManager
end

-- A partir del valor de self.currentMenu y de self.nextMenu devuelve nil o el efecto de transición a aplicar según lo que esté definido en self.transitions
MenuManagerClass.getDefinedMenuTransitionFor = function(self, fromMenu, toMenu)
    local fromMenuName, toMenuName, iToMenuName, iFromMenuName
    if not fromMenu then
        fromMenuName = 'nil'
    else
        fromMenuName = fromMenu.name
    end
    if not toMenu then
        toMenuName = 'nil'
    else
        toMenuName = toMenu.name
    end
    for i = 1, #self.transitions do
        local transition = self.transitions[i]
        if not transition.from then
            iFromMenuName = 'nil'
        else
            iFromMenuName = transition.from
        end
        if not transition.to then
            iToMenuName = 'nil'
        else
            iToMenuName = transition.to
        end
        if fromMenuName == iFromMenuName and toMenuName == iToMenuName then
            return transition.effect
        end
    end
    return nil
end

MenuManagerClass.screenStates = {
    -- TODO: ¿Añadir efecto para utilizar mientras abandonamos esta pantalla?
    changingMenu = {
        -- transición de un menú a otro
        name = "chagingMenu",
        load = function(self)
            self.currentTransition = MenuManagerClass.getDefinedMenuTransitionFor(self, self.currentMenu, self.nextMenu)
            if self.currentTransition then
                self.currentTransition.load(self)
            else
                -- el nuevo menú sustituye instantáneamente al actual (sin utilizar ninguna transición)
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
            end
        end,
        update = function(self, dt)
            --self.screenStates.changingMenu.effect:update(dt)
            self.currentTransition.update(self, dt)
        end,
        draw = function(self)
            if self.currentMenu then
                love.graphics.push()
                love.graphics.translate(
                    self.currentMenuShiftX,
                    self.currentMenuShiftY
                )
                self.currentMenu.draw(self)
                love.graphics.pop()
            end

            love.graphics.push()
            love.graphics.translate(
                self.nextMenuShiftX,
                self.nextMenuShiftY
            )
            self.nextMenu.draw(self)
            love.graphics.pop()
        end
    },
    showingMenu = {
        -- mostrando un menú
        name = "showingMenu",
        load = function(self)
        end,
        update = function(self, dt)
            self.currentMenu.update(self, dt)
        end,
        draw = function(self)
            self.currentMenu.draw()
        end
    }
}

function MenuManagerClass:changeMenuTo(nextMenu)
    print("MENU --> " .. nextMenu.name)
    -- guardamos el menú en self.nextMenu y llamamos a su método load()
    self.nextMenu = nextMenu
    self.nextMenu.load(self) -- al menú le pasamos como argumento el objeto MenuManagerClass para que pueda acceder a él por ejemplo cuando ese menú quiere pedir que se cambie a otro distinto
    -- transición de un menú a otro
    self.changeScreenState(self, MenuManagerClass.screenStates.changingMenu)
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
    self.screenState.draw(self)
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
            self.nextMenuShiftY = self.nextMenuShiftY + dt * self.velY
            if self.nextMenuShiftY > 0 then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                self.currentMenu.update(self, dt)
            else
                self.nextMenu.update(self, dt)
            end
        end
    },
    moveLeft = {
        name = "moveLeft",
        load = function(self)
            sounds.ui_rollover:play()
            self.currentMenuShiftX = 0
            self.nextMenuShiftX = SCREEN_WIDTH
            self.velX = -2500
        end,
        update = function(self, dt)
            self.currentMenuShiftX = self.currentMenuShiftX + dt * self.velX
            self.nextMenuShiftX = self.nextMenuShiftX + dt * self.velX
            if self.currentMenuShiftX <= -SCREEN_WIDTH then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                self.currentMenu.update(self, dt)
            else
                self.currentMenu.update(self, dt)
                self.nextMenu.update(self, dt)
            end
        end
    },
    moveRight = {
        name = "moveRight",
        load = function(self)
            sounds.ui_rollover:play()
            self.currentMenuShiftX = 0
            self.nextMenuShiftX = -SCREEN_WIDTH
            self.velX = 2500
        end,
        update = function(self, dt)
            self.currentMenuShiftX = self.currentMenuShiftX + dt * self.velX
            self.nextMenuShiftX = self.nextMenuShiftX + dt * self.velX
            if self.currentMenuShiftX >= SCREEN_WIDTH then
                self.currentMenu = self.nextMenu
                self.nextMenu = nil
                self.changeScreenState(self, MenuManagerClass.screenStates.showingMenu)
                self.currentMenu.update(self, dt)
            else
                self.currentMenu.update(self, dt)
                self.nextMenu.update(self, dt)
            end
        end
    }
}
return MenuManagerClass
