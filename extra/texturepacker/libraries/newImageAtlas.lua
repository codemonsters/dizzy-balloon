--[[
    newImageAtlas: Simple image atlas maker for SpriteBatch by love2d.org forum's user Azhukar
    https://love2d.org/forums/viewtopic.php?t=83704
]] --

local function sortHelper(a, b)
    return a[1] > b[1]
end

local function rectangleOverlap(aRect, bRect)
    local aX1, aY1, aWidth, aHeight = aRect[1], aRect[2], aRect[3], aRect[4]
    local bX1, bY1, bWidth, bHeight = bRect[1], bRect[2], bRect[3], bRect[4]
    if ((aX1 < bX1 + bWidth) and (aX1 + aWidth > bX1) and (aY1 < bY1 + bHeight) and (aY1 + aHeight > bY1)) then
        return true
    end
end

local function occupied(rect, rectangles, i, occupiedPixels)
    local width, height = rect[3], rect[4]
    local x1, y1, x2, y2 = rect[1], rect[2], rect[1] + width - 1, rect[2] + height - 1

    local maxWidth, maxHeight = occupiedPixels:getDimensions()

    if (x1 < 0) then
        return true
    end --out of bounds
    if (y1 < 0) then
        return true
    end
    if (x2 > maxWidth - 1) then
        return true
    end
    if (y2 > maxHeight - 1) then
        return true
    end

    if (occupiedPixels:getPixel(x1, y1) ~= 0) then
        return true
    end --top left pixel
    if (occupiedPixels:getPixel(x2, y2) ~= 0) then
        return true
    end --bottom right
    if (occupiedPixels:getPixel(x1, y2) ~= 0) then
        return true
    end --bottom right
    if (occupiedPixels:getPixel(x2, y1) ~= 0) then
        return true
    end --top right

    local rectanglesCount = i - 1
    if ((rectanglesCount * 5) > (width * 2 + height * 2)) then --check rectangle side pixels if more efficient to do so
        for x = x1, x2 do
            if (occupiedPixels:getPixel(x, y1) ~= 0) then
                return true
            end --top side pixel
            if (occupiedPixels:getPixel(x, y2) ~= 0) then
                return true
            end --bottom side pixel
        end
        for y = y1, y2 do
            if (occupiedPixels:getPixel(x1, y) ~= 0) then
                return true
            end --left side pixel
            if (occupiedPixels:getPixel(x2, y) ~= 0) then
                return true
            end --right side pixel
        end
    else --check all rectangles otherwise
        for j = 1, rectanglesCount do
            if (rectangleOverlap(rect, rectangles[j])) then
                return true
            end
        end
    end
end

local function newImageAtlas(imageDataTable)
    local maxTextureSize = love.graphics.getSystemLimits().texturesize

    local directionPriority = {
        --order in which rectangles try to settle
        {0, 0, 0, -1}, --top
        {0, 0, -1, 0}, --left
        {1, 0, 0, 0}, --right
        {0, 1, 0, 0} --bottom
    }

    local p = 1 --padding
    local rectangles = {}

    local atlasWidth = 0
    local atlasHeight = 0
    local atlasSurface = 0

    local index = 0
    for key, imageData in pairs(imageDataTable) do
        index = index + 1
        local imageWidth, imageHeight = imageData:getDimensions()
        imageWidth, imageHeight = imageWidth + p * 2, imageHeight + p * 2
        if (atlasWidth < imageWidth) then
            atlasWidth = imageWidth
        end
        if (atlasHeight < imageHeight) then
            atlasHeight = imageHeight
        end
        local imageSurface = imageWidth * imageHeight
        atlasSurface = atlasSurface + imageSurface
        rectangles[index] = {imageSurface, 0, imageWidth, imageHeight, imageData, key}
    end
    table.sort(rectangles, sortHelper) --largest surface area images first

    atlasWidth = math.min(maxTextureSize, math.max(atlasWidth, math.ceil(math.sqrt(atlasSurface) * 1.1)))

    local temp = love.image.newImageData(atlasWidth, atlasHeight) --used to paste color onto occupiedPixels
    for x = 0, atlasWidth - 1 do
        for y = 0, atlasHeight - 1 do
            temp:setPixel(x, y, 255, 255, 255, 255)
        end
    end

    local occupiedPixels = love.image.newImageData(atlasWidth, maxTextureSize)

    for i = 1, #rectangles do
        local rect1 = rectangles[i]
        rect1[1], rect1[2] = 0, 0

        local fits

        for d = 1, #directionPriority do
            local pr = directionPriority[d]
            local dx, dy, bx, by = pr[1], pr[2], pr[3], pr[4]
            if (not fits) then
                for j = 1, i - 1 do
                    local rect2 = rectangles[j]
                    rect1[1], rect1[2] =
                        rect2[1] + rect2[3] * dx + rect1[3] * bx,
                        rect2[2] + rect2[4] * dy + rect1[4] * by --try to settle next to rect2
                    if (not occupied(rect1, rectangles, i, occupiedPixels)) then
                        fits = true
                        break
                    end
                end
            else
                break
            end
        end

        atlasHeight = math.max(atlasHeight, rect1[2] + rect1[4])
        if (atlasHeight > maxTextureSize) then
            error("image atlas breached system max texture size:", maxTextureSize)
        end

        occupiedPixels:paste(temp, rect1[1], rect1[2], 0, 0, rect1[3], rect1[4])
    end

    local atlasImageData = love.image.newImageData(atlasWidth, atlasHeight)
    local quads = {}

    for i = 1, #rectangles do
        local rect = rectangles[i]
        local image_raw, x, y, w, h = rect[5], rect[1] + p, rect[2] + p, rect[3] - p * 2, rect[4] - p * 2
        quads[rect[6]] = love.graphics.newQuad(x, y, w, h, atlasWidth, atlasHeight)

        atlasImageData:paste(image_raw, x, y, 0, 0, w, h) --core

        --sides padding
        atlasImageData:paste(image_raw, x - p, y, 0, 0, p, h) --left
        atlasImageData:paste(image_raw, x + w, y, w - p, 0, p, h) --right
        atlasImageData:paste(image_raw, x, y - p, 0, 0, w, p) --top
        atlasImageData:paste(image_raw, x, y + h, 0, h - p, w, p) --down

        --corners padding
        atlasImageData:paste(image_raw, x - p, y - p, 0, 0, p, p) --top left
        atlasImageData:paste(image_raw, x + w, y - p, w - p, 0, p, p) --top right
        atlasImageData:paste(image_raw, x + w, y + h, w - p, h - p, p, p) --down right
        atlasImageData:paste(image_raw, x - p, y + h, 0, h - p, p, p) --down left
    end
    --atlasImageData:encode("png","imageAtlas.png")
    return quads, love.graphics.newImage(atlasImageData)
end

return newImageAtlas

--azhukar
