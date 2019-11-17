local bump = require "libraries/bump/bump"
local game = {name = "Juego"}
local PlayerClass = require("gameobjects/player")
-- local jugador = PlayerClass.new()
local EnemyClass = require("gameobjects/enemy")
local SkyClass = require("gameobjects/sky")
-- local sky = SkyClass.new(world, game)
local PointerClass = require("pointer")
-- local bomb = BombClass.new()
local BombClass = require("gameobjects/bomb")
-- local balloon = BalloonClass.new()
local BalloonClass = require("gameobjects/balloon")
local MushroomClass = require("gameobjects/mushroom")
local GoalClass = require("gameobjects/goal")
local LimitClass = require("gameobjects/limit")

if mobile then
    leftFinger = PointerClass.new(game, "Izquierdo")
    rightFinger = PointerClass.new(game, "Derecho")
else
    mousepointer = PointerClass.new(game, "Puntero")
end

-- local world = bump.newWorld(50)
local worldCanvas = nil
local hudCanvas = nil
local jugadorpuedesaltar = true
local jugadorquieremoverse = false
--local jugadorquieredisparar = false
local BlockClass = require("gameobjects/block")
local gameFilter
local vidas
local bombasAereas
local enemigos = {}
local setas = {}
local balloons = {}
local plataformas = {}
local temporizador_respawn_enemigo = 0
local TIEMPO_RESPAWN_ENEMIGO = 1
local nivel_actual = 1
local numero_nivel_actual = 0
inicioCambioNivel = 0
finalCambioNivel = 5
local state

local hud_width = (SCREEN_WIDTH - WORLD_WIDTH) / 2
local hud_height = SCREEN_HEIGHT

game.states = {
    jugando = {
        name = "Jugando",
        load = function(self)
        end,
        update = function(self, dt)
            -- comprobamos si debemos crear un enemigo nuevo
            if game.niveles[numero_nivel_actual].max_enemies > #enemigos then
                temporizador_respawn_enemigo = temporizador_respawn_enemigo + dt
                if temporizador_respawn_enemigo > TIEMPO_RESPAWN_ENEMIGO then
                    if math.random() > 0.5 then
                        enemigo =
                            EnemyClass.new(
                            "enemigoIzq",
                            EnemyClass.width,
                            EnemyClass.height,
                            world,
                            game,
                            math.random() * 360
                        )
                    else
                        enemigo =
                            EnemyClass.new(
                            "enemigoDer",
                            WORLD_WIDTH - EnemyClass.width,
                            EnemyClass.height,
                            world,
                            game,
                            math.random() * 360
                        )
                    end
                    table.insert(enemigos, enemigo)
                    temporizador_respawn_enemigo = 0
                end
            end

            jugador:update(dt)

            for i, enemigo in ipairs(enemigos) do
                enemigo:update(dt)
            end

            for i, globo in ipairs(balloons) do
                globo:update(dt)
            end
            if sky ~= nil then
                sky:update(dt)
            end

            for i, seta in ipairs(setas) do
                seta:update(dt)
            end

            if fireRequested then
                fireRequested = false
                if bomb.state == bomb.states.inactive and not (jugador.montado and jugador.montura.isBalloon) then
                    x, y = jugador.x, jugador.y
                    if fireInitialDirection == "down" then
                        if not jugador.not_supported then
                            jugador.x, jugador.y = world:move(jugador, jugador.x, jugador.y - bomb.height * 1.05)
                            bomb:launch(x, y, fireInitialDirection, jugador:vx(), jugador:vy())
                        end
                    elseif bombasAereas > 0 then
                        bomb:launch(x, y, fireInitialDirection, jugador:vx(), jugador:vy())
                        bombasAereas = bombasAereas - 1
                    end
                end
            end
            bomb:update(dt)
        end,
        draw = function(self)
            love.graphics.setCanvas(worldCanvas) -- a partir de ahora dibujamos en el canvas
            do
                love.graphics.setBlendMode("alpha")

                -- El fondo del mundo
                love.graphics.setColor(20, 00, 200)
                love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH - 1, WORLD_HEIGHT - 1)

                -- objetos del juego

                jugador:draw()

                for i, enemigo in ipairs(enemigos) do
                    enemigo:draw()
                end

                for i, globo in ipairs(balloons) do
                    globo:draw()
                end
                if sky ~= nil then
                    sky:draw()
                end

                for i, plataforma in ipairs(plataformas) do
                    plataforma:draw()
                end

                bomb:draw()

                for i, seta in ipairs(setas) do
                    seta:draw()
                end

                -- DEBUG: marcas en los extremos diagonales del canvas
                love.graphics.setColor(100, 100, 255)
                love.graphics.circle("line", 5, 5, 5)
                love.graphics.circle("line", WORLD_WIDTH - 6, WORLD_HEIGHT - 6, 5)
            end
            love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal

            love.graphics.push()
            love.graphics.translate(desplazamientoX, desplazamientoY)
            love.graphics.scale(factorEscala, factorEscala)
            love.graphics.setBlendMode("alpha", "premultiplied")
            love.graphics.draw(
                worldCanvas,
                (SCREEN_WIDTH - WORLD_WIDTH) / 2,
                (SCREEN_HEIGHT - WORLD_HEIGHT) / 2,
                0,
                1,
                1
            )
            love.graphics.pop()
        end
    },
    cambiandoDeNivel = {
        load = function(self)
        end,
        update = function(self, dt)
            print("game.states.cambiandoDeNivel, update")
            numero_nivel_actual = numero_nivel_actual + 1
            plataformas = {}
            game.loadlevel(numero_nivel_actual)
            print(game)
            game.change_state(game.states.jugando)
        end,
        draw = function(self)
        end
    }
}

game.niveles = {
    -- en los load se crean todos los gameobjects menos los jugadores y los tres bloques que delimitan el mundo
    {
        name = "Nivel 1",
        max_enemies = 2,
        jugador_posicion_inicial = {1, WORLD_HEIGHT - PlayerClass.height},
        load = function(world, game)
            sky = SkyClass.new(world, game)
        end
    },
    {
        name = "Nivel 2",
        max_enemies = 3,
        jugador_posicion_inicial = {1, WORLD_HEIGHT - PlayerClass.height},
        load = function(world, game)
            sky = SkyClass.new(world, game)
            table.insert(plataformas, BlockClass.new("Bloque 1", 150, 600, 400, 10, world))
            table.insert(plataformas, BlockClass.new("Bloque 2", 200, 200, 300, 10, world))
        end
    },
    {
        name = "Nivel 3",
        max_enemies = 4,
        jugador_posicion_inicial = {1, WORLD_HEIGHT - PlayerClass.height},
        load = function(world, game)
            sky = SkyClass.new(world, game)
            table.insert(plataformas, BlockClass.new("Bloque 1", 0, 230, 175, 5, world))
            table.insert(plataformas, BlockClass.new("Bloque 2", 525, 230, 175, 5, world))
            table.insert(plataformas, BlockClass.new("Bloque 3", 0, 460, 250, 5, world))
            table.insert(plataformas, BlockClass.new("Bloque 4", 450, 460, 250, 5, world))
            table.insert(plataformas, BlockClass.new("Bloque 5", 325, 650, 50, 25, world))
            table.insert(plataformas, BlockClass.new("Bloque 6", 300, 675, 100, 25, world))
        end
    },
    {
        name = "Nivel 4",
        max_enemies = 3,
        jugador_posicion_inicial = {1, WORLD_HEIGHT - PlayerClass.height},
        load = function(world, game)
            sky = SkyClass.new(world, game)
            table.insert(plataformas, BlockClass.new("Bloque 1", 150, 435, 400, 30, world))
            table.insert(plataformas, BlockClass.new("Bloque 2", 335, 20, 30, 415, world))
        end
    },
    {
        name = "Nivel 5",
        max_enemies = 6,
        jugador_posicion_inicial = {330, WORLD_HEIGHT - PlayerClass.height},
        load = function(world, game)
            sky = SkyClass.new(world, game)
            table.insert(plataformas, BlockClass.new("Bloque 1", 160, 20, 15, 235, world))
            table.insert(plataformas, BlockClass.new("Bloque 2", 525, 20, 15, 235, world))
            table.insert(plataformas, BlockClass.new("Bloque 3", 160, 465, 15, 235, world))
            table.insert(plataformas, BlockClass.new("Bloque 4", 525, 465, 15, 235, world))
        end
    }
}

function game.loadlife()
    jugador.x = nivel_actual.jugador_posicion_inicial[1]
    jugador.y = nivel_actual.jugador_posicion_inicial[2]
    world:update(jugador, jugador.x, jugador.y, jugador.width, jugador.height)
    print("loadlife. pos jugador ahora = (" .. jugador.x .. ", " .. jugador.y .. ")")
end

function game.loadlevel(nivel)
    world = bump.newWorld(50)
    jugador = PlayerClass.new(world, game)
    bomb = BombClass.new("Bomb", game)
    salida = GoalClass.new("Salida", 0, -1, WORLD_WIDTH, 1, world)
    numero_nivel_actual = nivel
    print("numero_nivel_actual = " .. numero_nivel_actual)
    nivel_actual = game.niveles[numero_nivel_actual]
    nivel_actual.load(world, game)

    enemigos = {}
    setas = {}
    balloons = {}
    local borderWidth = 50

    table.insert(plataformas, BlockClass.new("Suelo", 0, WORLD_HEIGHT, WORLD_WIDTH, borderWidth, world))
    table.insert(plataformas, BlockClass.new("Pared Izquierda", -borderWidth, 0, borderWidth, WORLD_HEIGHT, world))
    table.insert(plataformas, BlockClass.new("Pared Derecha", WORLD_WIDTH, 0, borderWidth, WORLD_HEIGHT, world))
    table.insert(plataformas, LimitClass.new("Techo", 0, 0, WORLD_WIDTH, 20, world)) -- El limite es necesario para bloquear el escape de enemigos y otros objetos excepto las semillas y el jugador

    game.loadlife()
end

function game.load()
    worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)
    hudCanvas = love.graphics.newCanvas(hud_width, hud_height)
    numero_nivel_actual = 0
    vidas = 3
    bombasAereas = 9
    game.state = game.states.cambiandoDeNivel
    game.change_state(game.state)
    --game.loadlevel(numero_nivel_actual)
end

function game.update(dt)
    game.state.update(game, dt)
end

function game.draw()
    love.graphics.clear(255, 255, 255) -- borramos la pantalla por completo

    love.graphics.setCanvas(hudCanvas) -- canvas del HUD
    do
        love.graphics.setBlendMode("alpha")

        -- El fondo del canvas
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, hud_width, SCREEN_HEIGHT)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("LVL - " .. numero_nivel_actual, font_hud, 0, 100, hud_width, "center")
        love.graphics.printf("x " .. vidas, font_hud, 140, 160, hud_width, "left")
        love.graphics.printf("x " .. bombasAereas, font_hud, 140, 220, hud_width, "left")

        ------------
        love.graphics.draw(atlas, PlayerClass.states.standing.quads[1].quad, 95, 154, 0, 2, 2) -- dibujamos el jugador en el hud

        love.graphics.draw(atlas, BombClass.states.planted.quads[1].quad, 94, 216, 0, 3, 3) -- dibujamos la bomba en el hud

        -- DEBUG: marcas en los extremos diagonales del canvas
        love.graphics.setColor(100, 100, 255)
        love.graphics.circle("line", 5, 5, 5)
        love.graphics.circle("line", hud_width - 6, hud_height - 6, 5)
    end

    love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal

    love.graphics.push()
    love.graphics.translate(desplazamientoX, desplazamientoY)
    love.graphics.scale(factorEscala, factorEscala)

    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(hudCanvas, SCREEN_WIDTH - hud_width, 0, 0, 1, 1)
    love.graphics.pop()

    game.state.draw(game)
end

function game.keypressed(key, scancode, isrepeat)
    if key == "q" then
        change_screen(require("screens/menu"))
    elseif key == "w" or key == "up" then
        jugador.up = true
        fireRequested = true
        fireInitialDirection = "up"
    elseif key == "a" or key == "left" then
        jugador.left = true
    elseif key == "s" or key == "down" then
        jugador.down = true
        fireRequested = true
        fireInitialDirection = "down"
    elseif key == "d" or key == "right" then
        jugador.right = true
    elseif key == "space" then
        jugador:jump()
    elseif key == "v" then
        vidas = vidas - 1
        log.debug("vidas: " .. vidas)
    elseif key == "b" then
        vidas = vidas + 1
        log.debug("vidas: " .. vidas)
    elseif key == "l" then
        numero_nivel_actual = numero_nivel_actual + 1
        plataformas = {}
        game.loadlevel(numero_nivel_actual)
    elseif key == "z" then
        print("Posición del jugador (x, y) = " .. jugador.x .. ", " .. jugador.y)
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "q" then
        change_screen(require("screens/menu"))
    elseif key == "w" or key == "up" then
        jugador.up = false
    elseif key == "a" or key == "left" then
        jugador.left = false
    elseif key == "s" or key == "down" then
        jugador.down = false
    elseif key == "d" or key == "right" then
        jugador.right = false
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
        jugadorquieremoverse = true
        --jugadorquieredisparar = true
        mousepointer:touchpressed(x, y)
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
    if x > SCREEN_WIDTH / 2 then
        rightFinger:touchpressed(x, y)
    else
        jugadorquieremoverse = true
        --jugadorquieredisparar = true
        leftFinger:touchpressed(x, y)
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if x > SCREEN_WIDTH / 2 then
        rightFinger:touchreleased(dx, dy)
    else
        jugadorquieremoverse = false
        --jugadorquieredisparar = false
        leftFinger:touchreleased(dx, dy)
    end
end

function game.pointerpressed(pointer)
    if pointer.x > SCREEN_WIDTH / 2 then
        jugador:jump()
    end
end

function game.pointerreleased(pointer)
    if pointer.x < SCREEN_WIDTH / 2 then
        jugador.left, jugador.right, jugador.up, jugador.down = false, false, false, false
    else
        jugadorpuedesaltar = true
    end
end

function game.pointermoved(pointer)
    if pointer.x < SCREEN_WIDTH / 2 then
        if jugadorquieremoverse == true then
            if pointer.x + pointer.movementdeadzone < pointer.x + pointer.dx then
                jugador.right = true
            else
                jugador.right = false
            end

            if pointer.x - pointer.movementdeadzone > pointer.x + pointer.dx then
                jugador.left = true
            else
                jugador.left = false
            end

            if pointer.y + pointer.movementdeadzone < pointer.y + pointer.dy then
                jugador.down = true
            else
                jugador.down = false
            end

            if pointer.y - pointer.movementdeadzone > pointer.y + pointer.dy then
                jugador.up = true
            else
                jugador.up = false
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
    vidas = vidas - 1
    if vidas <= 0 then
        world = nil
        temporizador_respawn_enemigo = 0
        enemigos = {}
        plataformas = {}
        change_screen(require("screens/menu"))
    else
        jugador:revive()
        game.loadlife()
    end
end

function game.remove_enemy(enemy)
    for i, v in ipairs(enemigos) do
        if v == enemy then
            world:remove(enemy)
            table.remove(enemigos, i)
            break
        end
    end
end

function game.remove_balloon(balloon)
    for i, v in ipairs(balloons) do
        if v == balloon then
            world:remove(balloon)
            table.remove(balloons, i)
            break
        end
    end
end

function game.create_balloon_from_seed(seed)
    --print("CREAR BALON!!!")
    local balloon = BalloonClass.new(seed, world, game)
    table.insert(balloons, balloon)
    seed:die()
end

function game.remove_mushroom(mushroom)
    for i, v in ipairs(setas) do
        if v == mushroom then
            world:remove(mushroom)
            table.remove(setas, i)
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
    for key, seed in pairs(sky.semillas) do --pseudocode
        if math.abs(seed.x - x) < seed.width / 2 then
            seed:change_state(seed.states.falling)
        end
    end
end

function game.crearSeta(x, y)
    seta = MushroomClass.new("Seta", world, game, x, y)
    table.insert(setas, seta)
end

function game.change_state(new_state)
    if game.state ~= new_state then
        game.state = new_state
        game.state.load(self)
    end
end

return game
