local animLoader = {}
-- No se puede poner nombres a los frames
animacionTestJugador = {
    keyFrames = {
        {
            setParams = function(jugador)
                jugador.right = true
            end,
            time = 2
        },
        {
            setParams = function(jugador) 
                jugador.right = false
                jugador.left = true
            end,
            time = 0.1
        },
        {
            setParams = function(jugador) 
                jugador.right = true
                jugador.left = false
                jugador:jump()
            end,
            time = 3
        },
    },

    currFrame = nil, -- el keyframe que se está ejecutando
    frameIndex = 1,
    
    target = nil -- el objeto animado
}

animacionTestEnemigo = {
    keyFrames = {
        {
            setParams = function(enemigo)
                enemigo.velocidad_x = math.sqrt(8)
                enemigo.velocidad_y = 0
            end,
            time = 5.1
        },
    },

    currFrame = nil, -- el keyframe que se está ejecutando
    frameIndex = 1,
    
    target = nil -- el objeto animado
}


local animList = {}

function animLoader:applyAnim(target, anim, repetir)
    anim.target = target

    table.insert(animList, anim)
    anim.number = table.getn(animList)

    anim.counter = 0
    anim.frameIndex = 1
    anim.currFrame = nil

    if anim.rep then --se ha repetido al menos una vez antes, devolvemos al objeto a su posición inicial
        target.world:update(
            target,
            target.initPos.x,
            target.initPos.y,
            target.width,
            target.height
        )
        target.x, target.y = target.initPos.x, target.initPos.y
    else
        target.initPos = {x = target.x, y = target.y}
    end
    anim.rep = repetir

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

    anim.currFrame = anim.keyFrames[index]

    if not anim.currFrame then
        table.remove(animList, findIndexInTable(animList, anim))
        if anim.rep then
            animLoader:applyAnim(anim.target, anim, true)
        end
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