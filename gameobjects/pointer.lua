local Pointer = { name = "Pointer" }

Pointer.__index = Pointer

function Pointer.new(game, name)
    local puntero = {}
    setmetatable(puntero, Pointer)
    puntero.game = game
    puntero.name = name
    puntero.pressed = false
    puntero.x, puntero.y = 0, 0
    puntero.dx, puntero.dy = 0, 0
    puntero.movementdeadzone = SCREEN_WIDTH * 0.005
    puntero.shootingdeadzone = SCREEN_HEIGHT * 0.01
    return puntero
end

function Pointer.touchpressed(self, x, y)
    self.pressed = true
    self.x = x
    self.y = y
    self.dx = 0
    self.dy = 0
    self.game.pointerpressed(self)
end

function Pointer:touchreleased(dx, dy)
    self.pressed = false
    self.dx = dx
    self.dy = dy
    self.game.pointerreleased(self)
end

function Pointer:touchmoved(dx, dy)
    self.dx = dx
    self.dy = dy
    self.game.pointermoved(self)
end

return Pointer