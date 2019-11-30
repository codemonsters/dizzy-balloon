local animLoader = {}

animacionTestJugador = {
    keyFrames = {
        derecha1  = {
            setParams = function(jugador)
                jugador.right = true
            end,
            time = 2
        },
        izquierda1  = {
            setParams = function(jugador) 
                jugador.right = false
                jugador.left = true
            end,
            time = 1
        },
        pararse = {
            setParams = function(jugador)
                jugador.right = false 
                jugador.left = false
            end,
            time = 0.5
        },
        derecha2 = {
            setParams = function(jugador) 
                jugador.left = false
                jugador.right = true
            end,
            time = 0.5
        },

        jump = {
            setParams = function(jugador) 
                jugador.right = false
                jugador:jump()
            end,
            time = 0.5
        },

    },
    
    orderedKeys = {}, -- claves de los keyframes ordenados

    currFrame = nil, -- el keyframe que se está ejecutando
    frameIndex = 1,
    
    target = nil -- el objeto animado
}

animacionTestEnemigo = {
    keyFrames = {
        e_frame1  = {
            setParams = function(enemigo)
                enemigo.velocidad_x = math.sqrt(8)
                enemigo.velocidad_y = -math.sqrt(8)
            end,
            time = 3.5
        },

        e_frame2  = {
            setParams = function(enemigo)
                enemigo.velocidad_x = -math.sqrt(8)
            end,
            time = 2.2
        },
       e_frame3  = {
            setParams = function(enemigo)
                enemigo.velocidad_y = -math.sqrt(8)
            end,
            time = 1
        },
        
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

    anim.counter = 0
    self:loadKeyFrame(anim, anim.frameIndex)
end

function animLoader:update(dt)
    for numAnim, anim in pairs(animList) do
        if anim then
            anim.counter = anim.counter + dt
            if anim.counter >= anim.currFrame.time then
                self:loadKeyFrame(anim, anim.frameIndex + 1)
    
                anim.counter = 0
            end
        end
    end
end

function animLoader:loadKeyFrame(anim, index)
    anim.frameIndex = index

    local k, v = anim.orderedKeys[index], anim.keyFrames[anim.orderedKeys[index]]
    anim.currFrame = anim.keyFrames[k]
    --print(k)
    if not anim.currFrame then
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