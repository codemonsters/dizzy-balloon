local Pointer = { name = "Pointer" }

function Pointer:new(game, name)
    self.game = game
    self.name = name
    self.pressed = false
    self.x, self.y = 0, 0
    self.dx, self.dy = 0, 0
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
    self.game.pointermoveed(self)
end