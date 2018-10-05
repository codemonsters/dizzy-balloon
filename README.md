# dizzy_balloon

## Preparación del entorno de desarrollo

### Software necesario

Instalamos lo siguiente:
* Un cliente Git:
    * [SmartSVN](http://www.smartsvn.com/)
    * [GitKraken](http://www.gitkraken.com/) 
* [Love2D](http://love2d.org/)
* [Visual Studio Code](http://code.visualstudio.com/):
* Extensiones para Visual Studio
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
    * Si es desde la terminal ejecutar: git clone https://NOMBREDEUSUARIO@github.com/codemonsters/dizzy_balloon.git
    * Otra opción es utilizar un programa con interfaz gráfica (SmartSVN, GitKraken...) a partir del mismo URL
3. Abrimos la *carpeta* en Visual Studio Code

## Documentación:

* [Mastering Markdown](https://guides.github.com/features/mastering-markdown/): Útil para editar este y otros ficheros
* Documentación sobre Git: [https://try.github.io/](https://try.github.io/)
