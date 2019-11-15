local animLoader = {}

local animacionTest = {
    frame1  = {
        setPlayer = function()
            jugador.right = true
        end,
        time = 1
    },
    frame2  = {
        setPlayer = function() 
            jugador.right = false
        end,
        time = 1
    },
    jump = {
        setPlayer = function() 
            jugador.left = true
            jugador:jump()
        end,
        time = 0.5
    },
    pararse = {
        setPlayer = function() 
            jugador.left = false
        end,
        time = 0.5
    }
}

function animLoader:load(jugador)
    self.jugador = jugador
    self.counter = 0
    self.currFrame = 1
    self:loadKeyFrame(self.currFrame)
    self.currFrame = self.currFrame + 1
end 

function animLoader:update(dt)
    self.counter = self.counter + dt
    if self.counter >= self.keyFrame.time then
        self:loadKeyFrame(self.currFrame)

        self.counter = 0
        self.currFrame = self.currFrame + 1
    end
end

function animLoader:loadKeyFrame(index)
    indice = 0
    for k, keyFrame in pairs(animacionTest) do
        indice = indice + 1
        if indice == index then
            print(k.." "..index.." "..indice)
            self.keyFrame = animacionTest[k]
        end
    end

    self.keyFrame.setPlayer()
end

return animLoader