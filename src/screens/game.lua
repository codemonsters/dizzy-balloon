local strings = require("misc/strings")

local bump = require "libraries/bump/bump"
local PlayerClass = require("gameobjects/player")
local EnemyClass = require("gameobjects/enemy")
local SkyClass = require("gameobjects/sky")
local PointerClass = require("misc/pointer")
local BombClass = require("gameobjects/bomb")
local BalloonClass = require("gameobjects/balloon")
local MushroomClass = require("gameobjects/mushroom")
local CloudClass = require("gameobjects/cloud")
local GoalClass = require("gameobjects/goal")
local LimitClass = require("gameobjects/limit")
local LevelClass = require("levels/level")
local LevelDefinitions = require("levels/levelDefinitions")
local worldCanvas = nil
local hudCanvas = nil
local jugadorpuedesaltar = true
local jugadorquieremoverse = false
local BlockClass = require("gameobjects/block")
local gameFilter
local enemyRespawnTimer = 0
local ENEMYRESPAWNTIMER = 1
local inicioCambioNivel = 0
local finalCambioNivel = 5
local state
local gamepad = love.graphics.newImage("assets/images/old/gamepad.png")
local circle = love.graphics.newImage("assets/images/old/circle.png")

local game = {
    name = "Juego",
}

local lateral_width = (SCREEN_WIDTH - WORLD_WIDTH) / 2


local dimensionesBotonPausa = device_width * .05

local MenuManagerClass = require("menus/menuManager")

function game.continue()
    game.pause = false
    if config.get("music") == true then music:play() end
end

if mobile then
    leftFinger = PointerClass.new(game, "Izquierdo")
    rightFinger = PointerClass.new(game, "Derecho")
else
    mousepointer = PointerClass.new(game, "Puntero")
end

game.states = {
    fadeIn = {
        name = "FadeIn",
        load = function(self)
            game.timer = 0
            game.fadeMaxTimeInSeconds = 1
            game.states.jugando.load(self)
        end,
        update = function(self, dt)
            game.timer = game.timer + dt
            game.alpha = 1 - game.timer / game.fadeMaxTimeInSeconds
            if game.alpha < 0 then
                game.alpha = 0
                game.execOnceAfterDraw = function()
                    game.state = game.states.jugando
                    game.alpha = 1
                    game.timer = 0
                end
            end
            game.states.jugando.update(self, dt)
        end,
        draw = function(self)
            game.states.jugando.draw(self)
            love.graphics.setColor(0, 0, 0, game.alpha)
            love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        end
    },
    jugando = {
        name = "Jugando",
        load = function(self)
            love.graphics.clear(0, 0, 0)
        end,
        update = function(self, dt)
            -- comprobamos si debemos crear un enemigo nuevo
            game.currentLevel.time = game.currentLevel.time - dt
            if game.currentLevel.time <= 0 then
                game.vidaperdida()
            end
            if game.currentLevel.max_enemies > #game.currentLevel.enemies then
                enemyRespawnTimer = enemyRespawnTimer + dt
                if enemyRespawnTimer > ENEMYRESPAWNTIMER then
                    if math.random() > 0.5 then
                        enemigo =
                            EnemyClass.new(
                            "enemigoIzq",
                            EnemyClass.width,
                            EnemyClass.height,
                            game.currentLevel.world,
                            game,
                            math.random() * 360
                        )
                    else
                        enemigo =
                            EnemyClass.new(
                            "enemigoDer",
                            WORLD_WIDTH - EnemyClass.width,
                            EnemyClass.height,
                            game.currentLevel.world,
                            game,
                            math.random() * 360
                        )
                    end
                    table.insert(game.currentLevel.enemies, enemigo)
                    enemyRespawnTimer = 0
                end
            end
            for i, cloud in ipairs(game.currentLevel.clouds) do
                cloud:update(dt)
            end

            game.currentLevel.player:update(dt)

            for i, enemy in ipairs(game.currentLevel.enemies) do
                enemy:update(dt)
            end

            for i, balloon in ipairs(game.currentLevel.balloons) do
                balloon:update(dt)
            end
            if game.currentLevel.sky ~= nil then
                game.currentLevel.sky:update(dt)
            end

            for i, mushroom in ipairs(game.currentLevel.mushrooms) do
                mushroom:update(dt)
            end

            for i, bonus in ipairs(game.currentLevel.bonuses) do
                bonus:update(dt)
            end

            if fireRequested then
                fireRequested = false
                if
                    game.currentLevel.bomb.state == game.currentLevel.bomb.states.inactive and
                        not (game.currentLevel.player.montado and game.currentLevel.player.montura.isBalloon)
                 then
                    x, y = game.currentLevel.player.x, game.currentLevel.player.y
                    if fireInitialDirection == "down" then
                        if not game.currentLevel.player.not_supported then
                            --comprobamos si hay espacio suficiente para que el juador suba
                            local items, len = game.currentLevel.world:queryRect(game.currentLevel.player.x, game.currentLevel.player.y - game.currentLevel.bomb.height * 1.05 - 1, game.currentLevel.player.width, game.currentLevel.bomb.height * 1.05 + 1)
                            if len == 0 then
                                game.currentLevel.player.x, game.currentLevel.player.y =
                                    game.currentLevel.world:move(
                                    game.currentLevel.player,
                                    game.currentLevel.player.x,
                                    game.currentLevel.player.y - game.currentLevel.bomb.height * 1.05
                                )
                                game.currentLevel.bomb:launch(
                                    x,
                                    y,
                                    fireInitialDirection,
                                    game.currentLevel.player:vx(),
                                    game.currentLevel.player:vy()
                                )
                            end
                        end
                    elseif game.bombasAereas > 0 then
                        game.currentLevel.bomb:launch(
                            x,
                            y,
                            fireInitialDirection,
                            game.currentLevel.player:vx(),
                            game.currentLevel.player:vy()
                        )
                        game.bombasAereas = game.bombasAereas - 1
                    end
                end
            end
            game.currentLevel.bomb:update(dt)
        end,
        draw = function(self)
            love.graphics.setCanvas(game.currentLevel.worldCanvas) -- a partir de ahora dibujamos en el canvas
            do
                love.graphics.setBlendMode("alpha")

                -- El fondo del mundo
                love.graphics.setColor(192, 0, 109)
                love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)

                -- objetos del juego

                for i, cloud in ipairs(game.currentLevel.clouds) do
                    cloud:draw(dt)
                end

                game.currentLevel.player:draw()

                
                for i, enemy in ipairs(game.currentLevel.enemies) do
                    enemy:draw()
                end

                for i, balloon in ipairs(game.currentLevel.balloons) do
                    balloon:draw()
                end
                if game.currentLevel.sky ~= nil then
                    game.currentLevel.sky:draw()
                end

                for i, block in ipairs(game.currentLevel.blocks) do
                    block:draw()
                end

                game.currentLevel.bomb:draw()

                for i, mushroom in ipairs(game.currentLevel.mushrooms) do
                    mushroom:draw()
                end
            
                for i, bonus in ipairs(game.currentLevel.bonuses) do
                    bonus:draw()
                end

                love.graphics.setColor(255, 255, 255)
                game.currentLevel.limit:draw()
                love.graphics.rectangle("line", game.currentLevel.player.x, game.currentLevel.player.y, game.currentLevel.player.width, game.currentLevel.player.height)

            end
            love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal

            --love.graphics.push()
            --love.graphics.translate(desplazamientoX, desplazamientoY)
            --love.graphics.scale(factorEscala, factorEscala)
            love.graphics.setBlendMode("alpha", "premultiplied")
            love.graphics.draw(
                game.currentLevel.worldCanvas,
                (SCREEN_WIDTH - WORLD_WIDTH) / 2,
                (SCREEN_HEIGHT - WORLD_HEIGHT) / 2,
                0,
                1,
                1
            )

            --love.graphics.pop()
        end
    },
    cambiandoDeNivel = {
        load = function(self) -- cargamos el siguiente nivel y dibujamos su primer frame
            sounds.play(sounds.levelUp)
            if LevelDefinitions[(game.currentLevel.id + 1)] == nil then
                game.nextLevel = game.loadlevel(LevelClass.new(LevelDefinitions[1], game))
            else
                game.nextLevel = game.loadlevel(LevelClass.new(LevelDefinitions[(game.currentLevel.id + 1)], game))
            end
            desplazamiento = 0

            love.graphics.setCanvas(game.nextLevel.worldCanvas)
            do
                love.graphics.setColor(192, 0, 109)
                love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)
                -- objetos del juego
                love.graphics.setColor(255, 255, 255)

                if game.nextLevel.sky ~= nil then
                    game.nextLevel.sky:draw()
                end

                for i, block in ipairs(game.nextLevel.blocks) do
                    block:draw()
                end
            end
            love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
            love.graphics.push()
            love.graphics.draw(
                game.currentLevel.worldCanvas,
                (SCREEN_WIDTH - WORLD_WIDTH) / 2,
                (SCREEN_HEIGHT - WORLD_HEIGHT) / 2 + desplazamiento,
                0,
                1,
                1
            )
            love.graphics.pop()
        end,
        update = function(self, dt)
            desplazamiento = desplazamiento + dt * 1000

            if desplazamiento >= WORLD_HEIGHT then
                posX = game.currentLevel.player.x
                game.currentLevel = game.nextLevel
                game.loadlife(posX)
                if game.currentLevel.music ~= nil then
                    loadAndStartMusic(game.currentLevel.music)
                end
                game.change_state(game.states.jugando)
            end
        end,
        draw = function(self)
            love.graphics.translate(desplazamientoX, desplazamientoY)
            love.graphics.scale(factorEscala, factorEscala)
            love.graphics.setBlendMode("alpha", "premultiplied")

            love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
            love.graphics.push()

            love.graphics.draw( -- el primer frame del anterior nivel es dibujado ya que sigue en memoria
                game.currentLevel.worldCanvas,
                (SCREEN_WIDTH - WORLD_WIDTH) / 2,
                (SCREEN_HEIGHT - WORLD_HEIGHT) / 2 + desplazamiento,
                0,
                1,
                1
            )
            love.graphics.draw(
                game.nextLevel.worldCanvas,
                (SCREEN_WIDTH - WORLD_WIDTH) / 2,
                -WORLD_HEIGHT + desplazamiento,
                0,
                1,
                1
            )

            love.graphics.pop()
        end
    },
    muriendo = {
        load = function(self)
            love.graphics.setCanvas(game.currentLevel.worldCanvas) -- a partir de ahora dibujamos en el canvas
            do
                love.graphics.setBlendMode("alpha")

                -- El fondo del mundo
                love.graphics.setColor(192, 0, 109)
                love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)
                love.graphics.setColor(255, 255, 255)

                -- objetos del juego
                for i, cloud in ipairs(game.currentLevel.clouds) do
                    cloud:draw()
                end

                for i, enemy in ipairs(game.currentLevel.enemies) do
                    enemy:draw()
                end

                for i, balloon in ipairs(game.currentLevel.balloons) do
                    balloon:draw()
                end
                if game.currentLevel.sky ~= nil then
                    game.currentLevel.sky:draw()
                end

                for i, block in ipairs(game.currentLevel.blocks) do
                    block:draw()
                end

                game.currentLevel.bomb:draw()

                for i, mushroom in ipairs(game.currentLevel.mushrooms) do
                    mushroom:draw()
                end
            end
            love.graphics.setCanvas()

            playerX, playerY = game.currentLevel.player.x, game.currentLevel.player.y
            velocidadY = -5
        end,
        update = function(self, dt)
            playerY = playerY + velocidadY
            velocidadY = velocidadY + dt * 10
            if playerY >= WORLD_HEIGHT + 100 then
                if game.vidas <= 0 then
                    temporizador_respawn_enemigo = 0
                    returnToMenu()
                else
                    game.currentLevel.player:revive()
                    game.loadlife()
                end
            end
        end,
        draw = function(self)
            love.graphics.translate(desplazamientoX, desplazamientoY)
            love.graphics.scale(factorEscala, factorEscala)
            love.graphics.setBlendMode("alpha", "premultiplied")

            love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal

            love.graphics.push()
            love.graphics.draw( -- el ultimo frame antes de morir es dibujado
                game.currentLevel.worldCanvas,
                (SCREEN_WIDTH - WORLD_WIDTH) / 2,
                (SCREEN_HEIGHT - WORLD_HEIGHT) / 2,
                0,
                1,
                1
            )
            love.graphics.draw(
                atlas,
                PlayerClass.states.standing.quads[1].quad,
                playerX + WORLD_WIDTH / 2 - PlayerClass.width * 2,
                playerY,
                0,
                PlayerClass.width / PlayerClass.states.standing.quads[1].width,
                PlayerClass.height / PlayerClass.states.standing.quads[1].height
            )
            love.graphics.pop()
        end
    }
}

function game.getNewRespawnPos()
    local respawnX, respawnY = game.currentLevel.player.x, game.currentLevel.player.y
    local cols, len =
        game.currentLevel.player.world:queryRect(
        game.currentLevel.player.x,
        game.currentLevel.player.y,
        game.currentLevel.player.width,
        game.currentLevel.player.height
    )
    for i = 1, len do
        if not cols[i].isPlayer then
            if cols[i].x + cols[i].width <= WORLD_WIDTH - game.currentLevel.player.width then
                respawnX = cols[i].x + cols[i].width
            else
                respawnY = cols[i].y - game.currentLevel.player.height
                respawnX = game.currentLevel.player_initial_respawn_position[1]
            end
        end
    end
    return respawnX, respawnY
end

function game.loadlife(posX)
    if posX == nil then
        game.currentLevel.player.x = game.currentLevel.player_initial_respawn_position[1]
    else
        game.currentLevel.player.x = posX
    end
    game.currentLevel.player.y = game.currentLevel.player_initial_respawn_position[2]
    game.currentLevel.player.x, game.currentLevel.player.y = game.getNewRespawnPos()
    game.currentLevel.world:update(
        game.currentLevel.player,
        game.currentLevel.player.x,
        game.currentLevel.player.y,
        game.currentLevel.player.width,
        game.currentLevel.player.height
    )
    game.currentLevel.time = game.currentLevel.levelDefinition.time
    game.change_state(game.states.jugando)
end

function game.loadlevel(level)
    level.player = PlayerClass.new(level.world, 1, WORLD_HEIGHT - PlayerClass.height, game)
    level.player.x = 100
    level.player.y = 100
    level.bomb = BombClass.new("Bomb", level.world, game)
    local totalIntervalos = 4
    math.randomseed(os.time())

    for i=1,totalIntervalos do
        local minIntervalo = (i-1) * (WORLD_HEIGHT/1.2-CloudClass.height)/totalIntervalos
        local maxIntervalo = i * (WORLD_HEIGHT/1.2-CloudClass.height)/totalIntervalos
        game.crearCloud(math.random(0, WORLD_WIDTH), math.random(minIntervalo, maxIntervalo))
    end

    loadAndStartMusic(game.currentLevel.music)
    game.pause = false
    played_ingame_menu_click = false
    local borderWidth = 150
    table.insert(
        level.blocks,
        BlockClass.new(
            "Suelo",
            -borderWidth,
            WORLD_HEIGHT,
            WORLD_WIDTH + 2 * borderWidth,
            borderWidth,
            level.world
        )
    )
    table.insert(
        level.blocks,
        BlockClass.new(
            "Pared Izquierda",
            -borderWidth,
            -borderWidth,
            borderWidth,
            WORLD_HEIGHT + 2 * borderWidth,
            level.world
        )
    )
    table.insert(
        level.blocks,
        BlockClass.new(
            "Pared Derecha",
            WORLD_WIDTH,
            -borderWidth,
            borderWidth,
            WORLD_HEIGHT + 2 * borderWidth,
            level.world
        )
    )
    return level
end

function game.load()
    hudCanvas = love.graphics.newCanvas(lateral_width, SCREEN_HEIGHT)
    gamepadCanvas = love.graphics.newCanvas(lateral_width, SCREEN_HEIGHT)
    game.vidas = 3
    game.bombasAereas = 9
    game.currentLevel = LevelClass.new(LevelDefinitions[1], game)
    game.loadlevel(game.currentLevel)
    game.change_state(game.states.fadeIn)
    loadAndStartMusic(game.currentLevel.music)
    game.pause = false
    played_ingame_menu_click = false

    local strings = require("misc/strings")
    local widgetsClass = require("misc/widgets")
    game.botonPausa = widgetsClass.newButton(
        getString(strings.menu),
        SCREEN_WIDTH - lateral_width + 80,
        SCREEN_HEIGHT * 0.05,
        lateral_width - 80 * 2,
        50,
        function()
            if not game.pause then
                played_ingame_menu_click = false
                game.pause = true
                if music then music:pause() end
            end
        end,
        font_hud)

    game.menuManager = MenuManagerClass.new(
        {
            {
                name = "inGame",
                menu = require("menus/inGame")
            }
        },
        {
            {
                from = nil,
                to = "inGame",
                effect = MenuManagerClass.effects.moveDown
            },
            {
                from = "inGame",
                to = nil,
                effect = MenuManagerClass.effects.moveUp
            }
        },
        game
    )
end

function game.update(dt)
    if game.pause then
        game.menuManager:update(dt)
        if played_ingame_menu_click == false then
            sounds.play(sounds.uiRollOver)
            played_ingame_menu_click = true
        end
    else
        game.state.update(game, dt)
        game.botonPausa.update()
    end
end

function game.draw()
    love.graphics.clear(0, 0, 0) -- borramos la pantalla por completo
    love.graphics.setBlendMode("alpha")

    -- información del lateral izquierdo
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font_hud)
    love.graphics.printf("LVL - " .. game.currentLevel.id, 0, 100, lateral_width, "center")
    love.graphics.printf("x " .. game.vidas, 140, 160, lateral_width, "left")
    love.graphics.printf("x " .. game.bombasAereas, 140, 220, lateral_width, "left")
    love.graphics.draw(atlas, PlayerClass.states.standing.quads[1].quad, 95, 154, 0, 2, 2) -- dibujamos el jugador en el hud
    love.graphics.draw(atlas, BombClass.states.planted.quads[1].quad, 94, 216, 0, 3, 3) -- dibujamos la bomba en el hud

    love.graphics.draw(gamepad, 35, SCREEN_HEIGHT - 280, 0, 1, 1)
    love.graphics.printf(getString(strings.time) .. " " .. math.ceil(game.currentLevel.time), lateral_width + WORLD_WIDTH, 100, lateral_width, "center")

    -- información del lateral derecho
    game.botonPausa.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.draw(circle, lateral_width + 35 + WORLD_WIDTH, SCREEN_HEIGHT - 280, 0, 1, 1) -- botón salto?
    love.graphics.setColor(255, 255, 255)
    
    game.state.draw(game)

    if game.execOnceAfterDraw then
        game.execOnceAfterDraw()
        game.execOnceAfterDraw = nil
    end
    if game.pause then
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.setColor(255, 255, 255)
        game.menuManager:draw()
    end
end

function game.keypressed(key, scancode, isrepeat)
    -- Dado que el juego está en pausa delegamos cómo resolver el evento al menú actual
    if game.pause then
        if game.menuManager.currentMenu then
            game.menuManager.currentMenu.keypressed(key, scancode.isrepeat)
        end
        return
    end
    if key == "escape" then
        --returnToMenu()
        played_ingame_menu_click = false
        game.pause = true
        if music then music:pause() end
    elseif key == "w" or key == "up" then
        game.currentLevel.player.up = true
        fireRequested = true
        fireInitialDirection = "up"
    elseif key == "a" or key == "left" then
        game.currentLevel.player.left = true
    elseif key == "s" or key == "down" then
        game.currentLevel.player.down = true
        fireRequested = true
        fireInitialDirection = "down"
    elseif key == "d" or key == "right" then
        game.currentLevel.player.right = true
    elseif key == "space" and not game.pause then
        game.currentLevel.player:jump()
    elseif key == "v" then
        -- TODO: Eliminar esto en la versión pública
        game.vidas = game.vidas - 1
        log.debug("game.vidas: " .. game.vidas)
    elseif key == "b" then
        -- TODO: Eliminar esto en la versión pública
        game.vidas = game.vidas + 1
        log.debug("game.vidas: " .. game.vidas)
    elseif key == "l" then
        -- TODO: Eliminar esto en la versión pública
        game.change_state(game.states.cambiandoDeNivel)
    elseif key == "j" then
        game.currentLevel.player:die()
        -- TODO: Eliminar esto en la versión pública
    elseif key == "z" then
        print("Posición del jugador (x, y) = " .. game.currentLevel.player.x .. ", " .. game.currentLevel.player.y)
    end
end

function game.keyreleased(key, scancode, isrepeat)
    -- Dado que el juego está en pausa delegamos cómo resolver el evento al menú actual
    if game.pause then
        if game.menuManager.currentMenu then
            game.menuManager.currentMenu.keyreleased(key, scancode.isrepeat)
        end
        return
    end
    if key == "q" then
        returnToMenu()
    elseif key == "w" or key == "up" then
        game.currentLevel.player.up = false
    elseif key == "a" or key == "left" then
        game.currentLevel.player.left = false
    elseif key == "s" or key == "down" then
        game.currentLevel.player.down = false
    elseif key == "d" or key == "right" then
        game.currentLevel.player.right = false
    end
end

function game.cambioDeNivel()
    finalCambioNivel = love.timer.getTime()
    if finalCambioNivel - inicioCambioNivel >= 5 then
        inicioCambioNivel = love.timer.getTime()
        game.change_state(game.states.cambiandoDeNivel)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and not mobile then
        mouseX, mouseY = (x - desplazamientoX) / factorEscala, (y - desplazamientoY) / factorEscala
        print(mouseX .. ",  " .. x)
        jugadorquieremoverse = true
        --jugadorquieredisparar = true
        mousepointer:touchpressed(mouseX, mouseY)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 and not mobile then
        jugadorquieremoverse = false
        --jugadorquieredisparar = false
        mousepointer:touchreleased(dx, dy)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if not mobile then
        mousepointer:touchmoved(dx, dy)
    end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    leftFinger:touchmoved(dx, dy)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    if x > device_width - dimensionesBotonPausa and y < dimensionesBotonPausa then
        played_ingame_menu_click = false
        game.pause = true
        if music then music:pause() end
    end
    if x / factorEscala > SCREEN_WIDTH / 2 then
        rightFinger:touchpressed(x, y)
    else
        jugadorquieremoverse = true
        leftFinger:touchpressed(x, y)
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if x / factorEscala > SCREEN_WIDTH / 2 then
        rightFinger:touchreleased(dx, dy)
    else
        jugadorquieremoverse = false
        leftFinger:touchreleased(dx, dy)
    end
end

function game.pointerpressed(pointer)
    print(pointer.name)
    if pointer.x / factorEscala > SCREEN_WIDTH / 2  and not game.pause then
        game.currentLevel.player:jump()
    end
end

function game.pointerreleased(pointer)
    if pointer.x / factorEscala < SCREEN_WIDTH / 2 then
        game.currentLevel.player.left,
            game.currentLevel.player.right,
            game.currentLevel.player.up,
            game.currentLevel.player.down = false, false, false, false
    else
        jugadorpuedesaltar = true
    end
end

function game.pointermoved(pointer)
    if pointer.x / factorEscala < SCREEN_WIDTH / 2 then
        if jugadorquieremoverse == true then
            if pointer.x + pointer.movementdeadzone < pointer.x + pointer.dx then
                game.currentLevel.player.right = true
            else
                game.currentLevel.player.right = false
            end

            if pointer.x - pointer.movementdeadzone > pointer.x + pointer.dx then
                game.currentLevel.player.left = true
            else
                game.currentLevel.player.left = false
            end

            if pointer.y + pointer.movementdeadzone < pointer.y + pointer.dy then
                game.currentLevel.player.down = true
            else
                game.currentLevel.player.down = false
            end

            if pointer.y - pointer.movementdeadzone > pointer.y + pointer.dy then
                game.currentLevel.player.up = true
            else
                game.currentLevel.player.up = false
            end
        end
        if pointer.y + pointer.shootingdeadzone < pointer.y + pointer.dy then
            fireRequested = true
            fireInitialDirection = "down"
        elseif pointer.y - pointer.shootingdeadzone > pointer.y + pointer.dy then
            fireRequested = true
            fireInitialDirection = "up"
        end
    end
end

function game.vidaperdida()
    game.vidas = game.vidas - 1
    game.change_state(game.states.muriendo)
end

function game.remove_enemy(enemy)
    for i, v in ipairs(game.currentLevel.enemies) do
        if v == enemy then
            game.currentLevel.world:remove(enemy)
            table.remove(game.currentLevel.enemies, i)
            break
        end
    end
end

function game.remove_balloon(balloon)
    for i, v in ipairs(game.currentLevel.balloons) do
        if v == balloon then
            game.currentLevel.world:remove(balloon)
            table.remove(game.currentLevel.balloons, i)
            break
        end
    end
end

function game.create_balloon_from_seed(seed)
    local balloon = BalloonClass.new(seed, game.currentLevel.world, game)
    table.insert(game.currentLevel.balloons, balloon)
    seed:die()
end

function game.remove_mushroom(mushroom)
    for i, v in ipairs(game.currentLevel.mushrooms) do
        if v == mushroom then
            game.currentLevel.world:remove(mushroom)
            table.remove(game.currentLevel.mushrooms, i)
            break
        end
    end
end

function game.remove_bonus(bonus)
    for i, v in ipairs(game.currentLevel.bonuses) do
        if v == bonus then
            game.currentLevel.world:remove(bonus)
            table.remove(game.currentLevel.bonuses, i)
            break
        end
    end
end

function game.kill_object(object)
    log.debug("Matando el objeto " .. object.name)

    if object.isEnemy then
        game.drop_seed(object.x)
    end

    object:die()
end

function game.drop_seed(x)
    for key, seed in pairs(game.currentLevel.sky.semillas) do --pseudocode
        if math.abs(seed.x - x) < seed.width / 2 then
            seed:change_state(seed.states.falling)
        end
    end
end

function game.crearSeta(x, y)
    seta = MushroomClass.new("Seta", game.currentLevel.world, game, x, y)
    table.insert(game.currentLevel.mushrooms, seta)
end

function game.crearCloud(x, y)
    cloud = CloudClass.new("Nube", x, y, game.currentLevel.world)
    table.insert(game.currentLevel.clouds, cloud)
end

function game.change_state(new_state)
    if game.state ~= new_state then
        game.state = new_state
        game.state.load(self)
    end
end

function returnToMenu()
    changeScreen(require("screens/menu"))
end

return game
