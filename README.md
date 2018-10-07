# dizzy_balloon

## Preparación del entorno de desarrollo

### Software necesario

Instalamos lo siguiente:
* Un cliente Git:
    * [SmartSVN](http://www.smartsvn.com/)
    * [GitKraken](http://www.gitkraken.com/) 
* [Love2D](http://love2d.org/)
* [Visual Studio Code](http://code.visualstudio.com/):
* Extensiones para Visual Studio:
    * Love2D Support (pixelbyte-studios.pixelbyte-love2d)
    * Lua Debug (actboy168.lua-debug)
    * vscode-lua (trixnz.vscode-lua)
* Configuración de Visual Studio Code:
    * No siempre vendrá bien configurado el path de Love en la extensión Love2D Support (por defecto pixelbyte.love2d.path vale: C:\Program Files\Love\love.exe). Para cambiar esto vamos a File / Preferences / Settings / Extensions / Love2D config.

### Cómo trabajar con el repositorio

Inicialmente necesitaremos clonar el repositorio Git en nuestro equipo:

1. Configuramos Git:
    * git config --global user.email "NUESTRA@DIRECCION.MAIL"
    * git config --global user.name "NOMBREDEUSUARIO"
1. Creamos una carpeta vacía para alojar el proyecto
2. Clonamos el repositorio dentro de esa carpeta:
    * Si es desde la terminal ejecutamos: git checkout https://NOMBREDEUSUARIO@github.com/codemonsters/dizzy_balloon.git
    * O bien usamos un programa con interfaz gráfica (SmartSVN, GitKraken...)
4. Abrimos la *carpeta* en Visual Studio Code


## Documentación:

* [Learn Lua In 15 Minutes](http://tylerneylon.com/a/learn-lua/)
* [Love2D Wiki](https://love2d.org/wiki/Main_Page)
* [awesome-love2d](https://github.com/love2d-community/awesome-love2d): A curated list of amazingly awesome LÖVE libraries, resources and shiny things
* [git - the simpe guide](http://rogerdudler.github.io/git-guide/)
* [Mastering Markdown](https://guides.github.com/features/mastering-markdown/): Útil para editar este y otros ficheros
