local binser = require("/libraries/binser/binser")

local config = {
    _filename = "dizzy.config"
}

if love.filesystem.exists(config._filename) then
    log.debug("Leyendo la configuración encontrada en: " .. love.filesystem.getSaveDirectory() .. "/" .. config._filename)
    --config._fileContents = binser.deserialize(love.filesystem.read(config._filename))
    config._fileContents = binser.readFile(config._filename)
    for key,value in pairs(config._fileContents) do print(key,value) end
    --config._fileContents = binser.deserialize(config._fileContents)
else
    log.debug("No hay datos de configuración, creando archivo de configuración por defecto")
    config._fileContents = {
        audio = "on",
        music = "on",
        language = "es"
    }
    --love.filesystem.write(config._filename, binser.serialize(config._fileContents))
    binser.writeFile(config._filename, config._fileContents)
end

config.get = function(key)
    return config._fileContents[key]
end

config.set = function(key, value)
    config._fileContents[key] = value
    love.filesystem.write(config._filename, binser.serialize(config._fileContents))
end

log.debug("config.audio = " .. config.get("audio") .. "; config.music = ".. config.get("music") .. "; config.language = " .. config.get("language"))
config.set("music", "off")
log.debug("config.audio = " .. config.get("audio") .. "; config.music = ".. config.get("music") .. "; config.language = " .. config.get("language"))

return config