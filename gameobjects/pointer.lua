local Pointer = { name = "Pointer" }

function Pointer:new(game, name)
    local puntero = {}
    setmetatable(puntero, Pointer)
    puntero.game = game
    puntero.name = name
    puntero.pressed = false
    puntero.x, self.y = 0, 0
    puntero.dx, self.dy = 0, 0
    return puntero
end

function Pointer:touchpressed(x, y)
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