function love.conf(t)
    t.window.title = "Dizzy Balloon" -- The window title (string)
    -- TODO: Añadir t.window.icon = path/hacia/la/imagen/icono
    --t.window.height = 648 -- 216
    --t.window.width = 1152 -- 384
    t.window.fullscreen = false -- Enable or disable fullscreen
    t.version = "11.1" -- The LÖVE version this game was made for (string)
    t.accelerometerjoystick = false -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)

    -- modules
    t.modules.joystick = false -- No necesitamos el módulo joystick
    t.modules.physics = false -- No necesitamos el módulo de físicas
    t.console = true -- Usamos consola para mostrar el logging(Sólo Windows)
end
