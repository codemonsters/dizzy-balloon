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

if mobile then
    leftFinger = PointerClass.new(game, "Izquierdo")
    rightFinger = PointerClass.new(game, "Derecho")
else
    mousepointer = PointerClass.new(game, "Puntero")
end

-- local world = bump.newWorld(50)
local worldCanvas = nil
local bordes = 4
local jugadorpuedesaltar = true
local jugadorquieremoverse = false
--local jugadorquieredisparar = false
local BlockClass = require("gameobjects/block")
local gameFilter
local vidas
local enemigos = {}
local setas = {}
local balloons = {}
local plataformas = {}
local temporizador_respawn_enemigo = 0
local TIEMPO_RESPAWN_ENEMIGO = 3
local TIEMPO_RESPAWN_ENEMIGO = 1
local nivel_actual = 1

local niveles = {
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
    }
}

function pillarEscala()
    if window_height >= window_width then
        return (window_width - bordes * 2) / WORLD_WIDTH
    else
        return (window_height - bordes * 2) / WORLD_HEIGHT
    end
end

local scaleCanvas = pillarEscala()

function game.loadlife()
    jugador.x = nivel_actual.jugador_posicion_inicial[1]
    jugador.y = nivel_actual.jugador_posicion_inicial[2]
end

function game.loadlevel(nivel)
    nivel_actual = niveles[nivel]
    nivel_actual.load(world, game)

    table.insert(plataformas, BlockClass.new("Suelo", 0, WORLD_HEIGHT, WORLD_WIDTH, 10, world))
    table.insert(plataformas, BlockClass.new("Pared Izquierda", -10, 0, 10, WORLD_HEIGHT, world))
    table.insert(plataformas, BlockClass.new("Pared Derecha", WORLD_WIDTH, 0, 10, WORLD_HEIGHT, world))

    game.loadlife()

end

function game.load()
    world = bump.newWorld(50)

    jugador = PlayerClass.new(world, game)

    bomb = BombClass.new("Bomb", game)

    worldCanvas = love.graphics.newCanvas(WORLD_WIDTH, WORLD_HEIGHT)

    nivel_actual = 1

    vidas = 3

    game.loadlevel(nivel_actual)
end

function game.update(dt)
    -- comprobamos si debemos crear un enemigo nuevo
    if nivel_actual.max_enemies > #enemigos then
        temporizador_respawn_enemigo = temporizador_respawn_enemigo + dt
        if temporizador_respawn_enemigo > TIEMPO_RESPAWN_ENEMIGO then
            if math.random() > 0.5 then
                enemigo = EnemyClass.new("enemigoIzq", EnemyClass.width, EnemyClass.height, world, game, math.random() * 360)
            else
                enemigo = EnemyClass.new("enemigoDer", WORLD_WIDTH - EnemyClass.width, EnemyClass.height, world, game, math.random() * 360)
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

    sky:update(dt)

    for i, seta in ipairs(setas) do
        seta:update(dt)
    end

    if fireRequested then
        fireRequested = false
        x,y  = jugador.x,jugador.y
        if bomb.state == bomb.states.inactive then
            if fireInitialDirection == "down" then
                if not jugador.not_supported then
                    jugador.x, jugador.y = world:move(jugador, jugador.x, jugador.y-bomb.height*1.05)
                    bomb:launch(x, y, fireInitialDirection, jugador:vx(), jugador:vy())
                end
            else
                bomb:launch(x, y, fireInitialDirection, jugador:vx(), jugador:vy())
            end
        end
    end
    bomb:update(dt)
end

function game.draw()
    love.graphics.setCanvas(worldCanvas) -- a partir de ahora dibujamos en el canvas
    do
        love.graphics.setBlendMode("alpha")
        
        -- El fondo del mundo
        love.graphics.setColor(20, 00, 200)
        love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)
        
        -- objetos del juego
        jugador:draw()

        for i, enemigo in ipairs(enemigos) do
            enemigo:draw()
        end

        for i, globo in ipairs(balloons) do
            globo:draw()
        end

        sky:draw()

        for i, plataforma in ipairs(plataformas) do
            plataforma:draw()
        end

        bomb:draw()

        for i, seta in ipairs(setas) do
            seta:draw()
        end
    end
    love.graphics.setCanvas() -- volvemos a dibujar en la ventana principal
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(
        worldCanvas,
        (window_width / 2) - (WORLD_WIDTH * scaleCanvas / 2),
        (window_height / 2) - (WORLD_HEIGHT * scaleCanvas / 2),
        0,
        scaleCanvas,
        scaleCanvas
    )
end

function game.keypressed(key, scancode, isrepeat)
    if key == "q" then
        change_screen(require("screens/menu"))
    elseif key == "w" or key == "up" then
        fireRequested = true
        fireInitialDirection = "up"
    elseif key == "a" or key == "left" then
        jugador.left = true
    elseif key == "s" or key == "down" then
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
        jugador.left, jugador.right = false, false
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
    end
    game.loadlife()
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
    for key,seed in pairs(sky.semillas) do --pseudocode
        if math.abs(seed.x-x) < seed.width/2 then
            seed:change_state(seed.states.falling)
        end
    end
end

function game.crearSeta(x, y)
    seta = MushroomClass.new("Seta", world, game, x, y)
    table.insert(setas, seta)
end

return game
