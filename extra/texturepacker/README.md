# Empaquetador de texturas

Pequeña utilidad para empaquetar las texturas del juego en una única imagen.

## Descripción general

La aplicación busca archivos PNG en la carpeta ./images y a partir de ella crea una imagen única (un atlas / sprite sheet) y un módulo Lua con información sobre los Quads de cada imagen incluida en el atlas.

## Ejecución

Es una aplicación de consola hecha con Love2D. Se puede ejecutar llamando a "love ." desde el directorio actual. El programa imprime en la terminal información sobre el progreso que va haciendo, las rutas y los nombres de los archivos que crea y los posibles mensajes de error.
