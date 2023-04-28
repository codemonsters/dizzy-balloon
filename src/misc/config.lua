--[[
    Módulo para guardar las preferencias o cualquier otra información en un archivo
    Se puede importar desde otro módulo y asignarlo a una variable global, por ejemplo:
        config = require("misc/config")
    A partir de entonces podríamos guardar una pareja clave-valor de la siguiente forma:
    config.set("clave", valor)  -- valor puede ser cualquier tipo de dato (boolean, entero, string...). El dato se guarda en disco inmediatamente
    valor = config.get("clave") -- a la variable valor le estaríamos asignando el valor que tiene la clave indicada

    Se han definido las siguientes claves:
        sound : boolean
        music: boolean
        language: string ("es" o "en")
    Por tanto para saber si la música está actividad en las preferencias podemos hacer:
    if config.get("music") then
        -- la música debería sonar
    end
]]--
local bitser = require("/libraries/bitser/bitser")

local config = {
    _filename = "dizzy.config"
}

if love.filesystem.getInfo(config._filename) then
    log.debug("Leyendo la configuración encontrada en: " .. love.filesystem.getSaveDirectory())
    config._fileContents = love.filesystem.read(config._filename)
    config._fileContents = bitser.loads(config._fileContents)
else
    log.debug("No hay datos de configuración, creando archivo de configuración por defecto")
    config._fileContents = {
        sound = true,
        music = true,
        language = "es"
    }
    love.filesystem.write(config._filename, bitser.dumps(config._fileContents))
end

config.get = function(key)
    -- log.debug("Leyendo dato desde configuración: " .. key .. " = " .. string.format("%s", config._fileContents[key]))
    return config._fileContents[key]
end

config.set = function(key, value)
    -- log.debug("Escribiendo dato en configuración: " .. key .. " = " .. string.format("%s", value))
    config._fileContents[key] = value
    love.filesystem.write(config._filename, bitser.dumps(config._fileContents))
end

return config