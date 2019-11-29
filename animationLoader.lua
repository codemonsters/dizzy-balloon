local animLoader = {}

animacionTestJugador = {
    keyFrames = {
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
    },
    
    orderedKeys = {}, -- claves de los keyframes ordenados

    currFrame = nil, -- el keyframe que se está ejecutando
    frameIndex = 1,
    
    target = nil -- el objeto animado
}

local animList = {}

function animLoader:applyAnim(target, anim)
    anim.target = target
    
    table.insert(animList, anim)
    anim.number = table.getn(animList)

    -- Se necesita ordenar la tabla de animacion para iterar en orden por ella
    for k in pairs(anim.keyFrames) do
        table.insert(anim.orderedKeys, k)
    end
    
    table.sort(anim.orderedKeys)

    self.counter = 0
    self:loadKeyFrame(anim, anim.frameIndex)
end

function animLoader:update(dt)
    for numAnim, anim in pairs(animList) do
        if anim then
            self.counter = self.counter + dt
            if self.counter >= anim.currFrame.time then
                self:loadKeyFrame(anim, anim.frameIndex + 1)
    
                self.counter = 0
            end
        end
    end
end

function animLoader:loadKeyFrame(anim, index)
    anim.frameIndex = index

    local k, v = anim.orderedKeys[index], anim.keyFrames[anim.orderedKeys[index]]
    anim.currFrame = anim.keyFrames[k]

    if not anim.currFrame then
        print("Se acabo la animación")
        table.remove(animList, findIndexInTable(animList, anim))
    else
        anim.currFrame.setParams(anim.target)
    end
end

function findIndexInTable(tabla,valor)
    for index, value in pairs(tabla) do
        if value == valor then
            return index
        end
    end
end

return animLoader