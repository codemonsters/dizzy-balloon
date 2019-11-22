local animLoader = {}

animacionTestJugador = {
    frame1  = {
        setParams = function(jugador)
            jugador.right = true
        end,
        time = 1
    },
    frame2  = {
        setParams = function(jugador) 
            jugador.right = false
        end,
        time = 1
    },
    jump = {
        setParams = function(jugador) 
            jugador.left = true
            jugador:jump()
        end,
        time = 0.5
    },
    pararse = {
        setParams = function(jugador) 
            jugador.left = false

        end,
        time = 0.5
    }
}

local ordered_keys = {}

function animLoader:applyAnim(target, anim)
    self.target = target
    self.anim = anim

    -- Se necesita ordenar la tabla de animacion para iterar en orden por ella
    for k in pairs(self.anim) do
        table.insert(ordered_keys, k)
    end
    
    table.sort(ordered_keys)

    self.counter = 0
    self.currFrame = 1
    self:loadKeyFrame(self.anim, self.currFrame)
    self.currFrame = self.currFrame + 1
end

function animLoader:update(dt)
    if self.anim then
        self.counter = self.counter + dt
        if self.counter >= self.keyFrame.time then
            self:loadKeyFrame(self.anim, self.currFrame)

            self.counter = 0
            self.currFrame = self.currFrame + 1
        end
    end
end

function animLoader:loadKeyFrame(anim, index)
    local k, v = ordered_keys[index], anim[ordered_keys[index]]
    self.keyFrame = anim[k]

    if not self.keyFrame then
        print("Se acabo la animación")
        self.anim = nil
        return
    end

    self.keyFrame.setParams(self.target)
end

return animLoader