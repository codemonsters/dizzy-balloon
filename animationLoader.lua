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

local animList = {}
local orderedKeyList = {}
local keyFrameList = {}

function animLoader:applyAnim(target, anim)
    numberAnims = table.getn(animList) + 1
    anim.target = target
    animList[numberAnims] = anim
    self.anim = anim

    local ordered_keys = {}
    -- Se necesita ordenar la tabla de animacion para iterar en orden por ella
    for k in pairs(self.anim) do
        table.insert(ordered_keys, k)
    end
    
    table.sort(ordered_keys)
    orderedKeyList[numberAnims] = ordered_keys

    self.counter = 0
    self.currFrame = 1
    self:loadKeyFrame(self.anim, self.currFrame, numberAnims)
    self.currFrame = self.currFrame + 1
end

function animLoader:update(dt)
    for k, anim in pairs(animList) do
        if anim then
            self.counter = self.counter + dt
            if self.counter >= keyFrameList[k].time then
                self:loadKeyFrame(anim, self.currFrame, k)
    
                self.counter = 0
                self.currFrame = self.currFrame + 1
            end
        end
    end
end

function animLoader:loadKeyFrame(anim, index, numAnim)
    local k, v = orderedKeyList[numAnim][index], anim[orderedKeyList[numAnim][index]]
    keyFrameList[numAnim] = anim[k]

    if not keyFrameList[numAnim] then
        print("Se acabo la animación")
        anim = nil
        return
    end

    keyFrameList[numAnim].setParams(anim.target)
end

return animLoader