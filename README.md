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
       * No siempre vendrá bien configurado el path de Love en la extensión Love2D Support (por defecto pixelbyte.love2d.path vale: C:\Program Files\Love\love.exe). Para cambiar esto vamos a File / Preferences / Settings / Extensions / Love2D config. Si suamos un ordenador Mac tendremos que poner una ruta similar a: /Applications/love.app/Contents/MacOS/love
       * Con un ordenador Mac para que tras pulsar [cmd + L] se inicie Love con nuestro juego tendremos que añadir VSCode a la lista de programas que pueden controlar el ordenador. Podemos hacer esto desde: System Preferences / Security & Privacy / Accessibility

### Cómo trabajar con el repositorio

Inicialmente necesitaremos clonar el repositorio Git en nuestro equipo:

1. Configuramos Git:
    * Para identificar nuestras contribuciones más fácilmente:
        * ```git config --global user.email "NUESTRA@DIRECCION.MAIL"```
        * ```git config --global user.name "NOMBREDEUSUARIO"```
    * Para que no vuelva a pedir nuestra contraseña durante los siguientes 90 minutos (5400 segundos):
        * ```git config --global credential.helper cache```
        * ```git config --global credential.helper 'cache --timeout=5400'```
    * Utilizar colores en la terminal:
        * ```git config color.ui true```
    * Para mostrar la información de cada commit en una única línea:
        * ```git config format.pretty oneline```
2. Clonamos el repositorio dentro de una carpeta local:
    * Si es desde la terminal ejecutamos: ```git clone https://NOMBREDEUSUARIO@github.com/codemonsters/dizzy-balloon.git```
    * O bien usamos un programa con interfaz gráfica (SmartSVN, GitKraken...)
3. Abrimos la *carpeta* en Visual Studio Code

### Trabajando con branches (frecuentemente una branch implica una nueva característica):

* Para crear una nueva rama y comenzar a utilizarla: ```git checkout -b nombre_rama```
* Hacemos tantos commit y push dentro la rama como sea necesario
* Cuando consideremos el trabajo acabado mezclamos/publicamos los cambios en la rama principal (master): ```git checkout master; git merge nombre_rama```

### Problemas con el usuario

* Para actualizar el url de origin con un nuevo nombre de usuario
   Entrar en el archivo ```.gitconfig``` y eliminas user.

   ### En Windows:
   ```Step 1: Open Control panel. ```

   ```Step 2: Click on Credential Manager.```

   ```Step 3: Click on Windows Credentials under Manage your credentials page.```

   ```Step 4: Under Generic Credentials click on github.```

   ```Step 5: Click on Remove and then confirm by clicking Yes button.```

   ### En Linux:
   ```git config --global --unset-all```


### Android: Creación de un APK

Requisitos:
* love-android-sdl2 (aquí se explica como descargarla y prepararla: https://love2d.org/wiki/Game_Distribution#Android )
* android-ndk-r14b  (descargas la versión 14b de la página oficial)

### Discord: Trabajo a distancia
Invitación al servidor de Discord para la actividad de Laboratorio: https://discord.gg/ZQaNtRF

## Documentación

* [Learn Lua In 15 Minutes](http://tylerneylon.com/a/learn-lua/)
* [Metatables](https://www.lua.org/pil/13.html) y [Programación Orientada a Objetos con Lua](https://www.tutorialspoint.com/lua/lua_object_oriented.htm)
* [Love2D Wiki](https://love2d.org/wiki/Main_Page)
* [Love2D API](https://love2d-community.github.io/love-api/)
* [SUIT](https://suit.readthedocs.io/en/latest/): Documentación para la librería de widgets
* [awesome-love2d](https://github.com/love2d-community/awesome-love2d): A curated list of amazingly awesome LÖVE libraries, resources and shiny things
* [git - the simple guide](http://rogerdudler.github.io/git-guide/)
* [Mastering Markdown](https://guides.github.com/features/mastering-markdown/): Útil para editar este y otros ficheros
* [How to write a Git commit message properly with examples](https://www.theserverside.com/video/Follow-these-git-commit-message-guidelines)

## Otros

* Paleta de Colores: [http://paletton.com/#uid=75a0u0kw0u7kiBppJw+z8nUERiF](http://paletton.com/#uid=75a0u0kw0u7kiBppJw+z8nUERiF)
* Compresión de un archivo wav a mp3 192kbps (ejemplo para música): '''ffmpeg -i Stage5.wav -acodec mp3 -ab 192k stage5.mp3'''
* Creación de sfx:
http://drpetter.se/project_sfxr.html (el original),  https://www.bfxr.net/ (el mejorado)
* Iconos:
https://fontawesome.com/icons?d=gallery
