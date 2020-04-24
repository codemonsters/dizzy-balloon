local widgetClass = {
    cornerRadius = 10,
    fontButtons = font_title
}

function widgetClass.newButton(label, x, y, width, height)
    local object = {}
    object.label, object.x, object.y, object.width, object.height = label, x, y, width, height
    object.draw = function()
        love.graphics.setColor(0.753, 0, 0.427)
        --rectángulo más alto
        love.graphics.rectangle("fill", object.x + widgetClass.cornerRadius, object.y, object.width - 2 * widgetClass.cornerRadius, object.height)
        -- rectángulo más ancho
        love.graphics.rectangle("fill", object.x, object.y + widgetClass.cornerRadius, object.width, object.height - 2 * widgetClass.cornerRadius)
        -- circulo de la esquina superior izquierda
        love.graphics.circle("fill", object.x + widgetClass.cornerRadius, object.y + widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- circulo de la esquina superior derecha
        love.graphics.circle("fill", object.x + object.width - widgetClass.cornerRadius, object.y + widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- circulo de la esquina inferior izquierda
        love.graphics.circle("fill", object.x + widgetClass.cornerRadius, object.y + object.height - widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- circulo de la esquina inferior derecha
        love.graphics.circle("fill", object.x + object.width - widgetClass.cornerRadius, object.y + object.height - widgetClass.cornerRadius, widgetClass.cornerRadius)
        -- texto
        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(object.label, widgetClass.fontButtons, object.x, object.y, object.width, "center")
    end
    return object
end

return widgetClass