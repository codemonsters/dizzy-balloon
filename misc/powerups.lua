local PowerUps = {
    speedBoost = {
        color = {0, 0.97, 1},
        apply = function(self, player)
            player.vmultiplier = 2
        end,
        quad = quads.skate
    },
    extraLife = {
        color = {0, 1, 0.03},
        apply = function(self, player)
            player.game.vidas = player.game.vidas + 1
        end,
        quad = quads.heart
    },
    jumpBoost = {
        color = {1, 0.97, 0},
        apply = function(self, player)
            player.ymultiplier = 2
        end,
        quad = quads.spring
    },
    extraBomb = {
        color = {0.1, 0.1, 0.1},
        apply = function(self, player)
            player.game.bombasAereas = player.game.bombasAereas + 1
        end,
        quad = quads.bomb
    },
    flyAttack = {
        color = {1, 0.1, 0.1},
        apply = function(self, player)
            player:die()
        end
    }
}

return PowerUps