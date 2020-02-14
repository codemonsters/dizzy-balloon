local PowerUps = {
    speedBoost = {
        color = {0, 0.97, 1},
        apply = function(self, player)
            player.vmultiplier = 2
        end
    },
    extraLife = {
        color = {0, 1, 0.03},
        apply = function(self, player)
            player.game.vidas = player.game.vidas + 1
        end
    },
    jumpBoost = {
        color = {1, 0.97, 0},
        apply = function(self, player)
            player.ymultiplier = 2
        end
    },
    extraBomb = {
        color = {0.1, 0.1, 0.1},
        apply = function(self, player)
            player.game.bombasAereas = player.game.bombasAereas + 1
        end
    }
}

return PowerUps