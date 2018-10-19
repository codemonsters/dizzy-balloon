# Dizzy Balloon

Remake no oficial y con licencia GPL de Dizzy Balloon, juego desarrollado originalmente por Pony Canyon para ordenadores MSX y publicado en el año 1984. Más información sobre el juego original [aquí](https://www.generation-msx.nl/software/pony-canyon/dizzy-balloon/release/559/).

## Preparación del entorno de desarrollo

### Software necesario

Instalamos lo siguiente:
* Un cliente Git:
    * [git](https://git-scm.com/downloads): Cliente Git oficial (CLI / intefaz de línea de comandos)
    * [SmartSVN](http://www.smartsvn.com/): Cliente con interfaz gráfica
    * [GitKraken](http://www.gitkraken.com/): Otro cliente con interfaz gráfica
* [Love2D](http://love2d.org/)
* [Visual Studio Code](http://code.visualstudio.com/):
* Extensiones para Visual Studio Code:
    * [Love2D Support](https://marketplace.visualstudio.com/items?itemName=pixelbyte-studios.pixelbyte-love2d):  pixelbyte-studios.pixelbyte-love2d
    * [vscode-lua](https://marketplace.visualstudio.com/items?itemName=actboy168.lua-debug) (trixnz.vscode-lua)
* Configuración de Visual Studio Code:
    * No siempre vendrá bien configurado el path de Love en la extensión Love2D Support (por defecto pixelbyte.love2d.path vale: C:\Program Files\Love\love.exe). Para cambiar esto vamos a File / Preferences / Settings / Extensions / Love2D config.

### Cómo trabajar con el repositorio

Inicialmente necesitaremos clonar el repositorio Git en nuestro equipo:

1. Configuramos Git:
    * git config --global user.email "NUESTRA@DIRECCION.MAIL"
    * git config --global user.name "NOMBREDEUSUARIO"
1. Creamos una carpeta vacía para alojar el proyecto
2. Clonamos el repositorio dentro de esa carpeta:
    * Si es desde la terminal ejecutamos: git clone https://NOMBREDEUSUARIO@github.com/codemonsters/dizzy_balloon.git
    * O bien usamos un programa con interfaz gráfica (SmartSVN, GitKraken...)
4. Abrimos la *carpeta* en Visual Studio Code


## Documentación

* [Learn Lua In 15 Minutes](http://tylerneylon.com/a/learn-lua/)
* [Metatables](https://www.lua.org/pil/13.html) y [Programación Orientada a Objetos con Lua](https://www.tutorialspoint.com/lua/lua_object_oriented.htm)
* [Love2D Wiki](https://love2d.org/wiki/Main_Page)
* [awesome-love2d](https://github.com/love2d-community/awesome-love2d): A curated list of amazingly awesome LÖVE libraries, resources and shiny things
* [git - the simple guide](http://rogerdudler.github.io/git-guide/)
* [Mastering Markdown](https://guides.github.com/features/mastering-markdown/): Útil para editar este y otros ficheros
