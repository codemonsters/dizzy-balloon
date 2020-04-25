local widgetClass = {
    cornerRadius = 10,
    defaultFontButtons = font_title,
    alphaNotSelected = 0.6,
    alphaSelected = 0.85

}

-- Crea un botón nuevo. 'font' es opcional, si no se recibe uno se utiliza el font por defecto definido en widgetClass
function widgetClass.newButton(label, x, y, width, height, callback, font)
    local object = { }
    object.label, object.x, object.y, object.width, object.height, object.callback = label, x, y, width, height, callback
    object.font = font or widgetClass.defaultFontButtons
    -- dibujamos el botón en un canvas y guardamos el canvas como imagen. Utilizaremos esta imagen para dibujar el botón tantas veces como se solicite
    local objectCanvas = love.graphics.newCanvas(object.width, object.height)
    love.graphics.setCanvas(objectCanvas)
        love.graphics.setColor(0.753, 0, 0.427, 1)
        --rectángulo más alto
        love.graphics.rectangle("fill", widgetClass.cornerRadius, 0, object.width - 2 * widgetClass.cornerRadius, object.height)
        -- rectángulo más ancho
        love.graphics.rectangle("fill", 0, widgetClass.cornerRadius, object.width, object.height - 2 * widgetClass.cornerRadius)
        -- circulo de la esquina superior izquierda
        love.graphics.circle("fill", widgetClass.cornerRadius, widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- circulo de la esquina superior derecha
        love.graphics.circle("fill", object.width - widgetClass.cornerRadius, widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- circulo de la esquina inferior izquierda
        love.graphics.circle("fill", widgetClass.cornerRadius, object.height - widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- circulo de la esquina inferior derecha
        love.graphics.circle("fill", object.width - widgetClass.cornerRadius, object.height - widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- texto
        --love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setColor(0.753 * 1.4, 0.3, 0.427 * 1.4, 1)
        local textWidth = object.font:getWidth(object.label)
        local textHeight = object.font:getHeight()
        love.graphics.setFont(object.font)
        love.graphics.print(object.label, (object.width - textWidth) / 2, (object.height - textHeight) / 2)
    love.graphics.setCanvas()
    object.image = love.graphics.newImage(objectCanvas:newImageData())
    object.mouseOver = function()
        local mouseX, mouseY = love.mouse.getPosition()
        mouseX = (mouseX - desplazamientoX) / factorEscala
        mouseY = (mouseY - desplazamientoY) / factorEscala
        --menu.widgets:updateMouse((mouseX - desplazamientoX) / factorEscala, (mouseY - desplazamientoY) / factorEscala)
        if mouseX >= object.x and mouseX <= object.x + object.width and mouseY >= object.y and mouseY < object.y + object.height then
            return true
        end
        return false
    end
    object.update = function()
        if object.mouseOver() then
            object.alpha = widgetClass.alphaSelected
            if love.mouse.isDown(1) then
                object.callback()
            end
        else
            object.alpha = widgetClass.alphaNotSelected
        end
    end
    object.draw = function()
        love.graphics.setColor(1, 1, 1, object.alpha)
        love.graphics.draw(object.image, object.x, object.y)
    end
    return object
end

return widgetClass