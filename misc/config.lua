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
        audio = "on",
        music = "on",
        language = "es"
    }
    love.filesystem.write(config._filename, bitser.dumps(config._fileContents))
end

config.get = function(key)
    return config._fileContents[key]
end

config.set = function(key, value)
    config._fileContents[key] = value
    love.filesystem.write(config._filename, bitser.dumps(config._fileContents))
end

return config