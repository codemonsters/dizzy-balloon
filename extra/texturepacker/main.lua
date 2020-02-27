--[[
Este script crea un atlas que contiene todas las imágenes PNG que encuentra en una carpeta.
Crea además un módulo / archivo ".lua" con información sobre el quad / rectángulo que localiza
cada imagen dentro del atlas. Este módulo puede ser importado mediante una instrucción require.
--]]
local binpack = require("libraries/binpack") -- MaxRects bin packer, found here: https://www.love2d.org/forums/viewtopic.php?t=84957
local path = require("libraries/path") -- path source code taken from LuaPower distribution

-- searchs for PNG files in the folder sourcePath and returns a list with a dictionary for each PNG. Every dictionary has these keys: key, filename, w and h
function getImagesDataFromPath(sourcePath)
    local results = {}
    local filenames = love.filesystem.getDirectoryItems(sourcePath)
    local ending = ".png"
    for k, filename in ipairs(filenames) do
        local filename_lower = string.lower(filename)
        if filename_lower:sub(-(#ending)) == ending then
            imageData = {}
            imageData.key = string.sub(filename, 1, #filename - 4)
            imageData.filename = path.combine(sourcePath, filename)
            local img = love.graphics.newImage(imageData.filename)
            imageData.w = img:getWidth()
            imageData.h = img:getHeight()
            table.insert(results, imageData)
        end
    end
    return results
end

-- sort images by height (tallest first)
function sortImages(data)
    -- bubble sort with no changes detection
    for i = 1, #data do
        local changes = false
        for j = i + 1, #data do
            if data[i].h < data[j].h then
                local tmp = data[i]
                data[i] = data[j]
                data[j] = tmp
                changes = true
                break
            end
        end
        if not changes then
            break
        end
    end
    return data
end

function putImageRectanglesInPacker(data, binPacker)
    for _, imageData in pairs(data) do
        local rectangle = binPacker:insert(imageData.w, imageData.h)
        if rectangle then
            imageData.x = rectangle.x
            imageData.y = rectangle.y
        else
            error("Error trying to insert image '" .. imageData.filename .. "' in the packer")
        end
    end
end

function getMinimumAtlasDimensions(data)
    local minWidth, minHeight = 0, 0
    for _, imageData in pairs(data) do
        if imageData.x + imageData.w > minWidth then
            minWidth = imageData.x + imageData.w
        end
        if imageData.y + imageData.h > minHeight then
            minHeight = imageData.y + imageData.h
        end
    end
    return minWidth, minHeight
end

function createAtlasImage(data, outputPNGFilename, outputImageWidth, outputImageHeight)
    canvas = love.graphics.newCanvas(outputImageWidth, outputImageHeight)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    for _, imageData in pairs(data) do
        local img = love.graphics.newImage(imageData.filename)
        love.graphics.draw(img, imageData.x, imageData.y)
        --print(imageData.x .. ", " .. imageData.y)
    end
    love.graphics.setCanvas()
    outputData = canvas:newImageData()
    success, message = love.filesystem.write(outputPNGFilename, outputData:encode("png"))
    if success then
        print("File '" .. outputPNGFilename .. "' created in " .. love.filesystem.getSaveDirectory())
    else
        error("Error creating output PNG: " .. message)
    end
end

function createAtlasQuadsModule(data, outputQuadsModuleFilename)
    outputData = "local quads = {\n"
    for _, imageData in pairs(data) do
        outputData =
            outputData ..
            "\t" ..
                imageData.key ..
                    " = {quad = love.graphics.newQuad(" ..
                        imageData.x ..
                            ", " ..
                                imageData.y ..
                                    ", " ..
                                        imageData.w ..
                                            ", " ..
                                                imageData.h ..
                                                    " ), width = " ..
                                                        imageData.w .. ", height = " .. imageData.h .. "},\n"
    end
    outputData = outputData .. "}\n\n"
    outputData = outputData .. "return quads\n"

    success, message = love.filesystem.write(outputQuadsModuleFilename, outputData)
    if success then
        print("File '" .. outputQuadsModuleFilename .. "' created in " .. love.filesystem.getSaveDirectory())
    else
        error("Error creating file for the atlas quads module: " .. message)
    end
end

function love.load()
    love.filesystem.setIdentity("dizzy-balloon-packer")
    local sourcePath = "images"
    local limits = love.graphics.getSystemLimits()
    local binPacker = binpack(limits.texturesize, limits.texturesize)
    print("Searching for PNG images in path and getting images data from folder '" .. sourcePath .. "'...")
    local data = getImagesDataFromPath(sourcePath)
    if #data == 0 then
        print("Nothing to do: No PNG files found in source folder ('" .. sourceFolder .. "')")
    else
        print(#data .. " PNG files found")
        print("Sorting image data by descending height...")
        data = sortImages(data)
        print("Inserting images in the packer...")
        putImageRectanglesInPacker(data, binPacker)
        atlasWidth, atlasHeight = getMinimumAtlasDimensions(data)
        print("Minimum size for the packed image: " .. atlasWidth .. " x " .. atlasHeight .. " px (width x height)")
        print("Creating resulting atlas image...")
        createAtlasImage(data, "atlas.png", atlasWidth, atlasHeight)
        print("Creating resulting atlas quads module...")
        createAtlasQuadsModule(data, "atlas.lua")
        print("Done")
    end

    love.event.quit()
end
