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

### Trabajando con ramas

Con frecuencia cuando comencemos a desarrollar una nueva característica del juego nos interesará crear una nueva rama (branch):

* Para crear una nueva rama y comenzar a utilizarla: ```git checkout -b nombre_rama```
* Podemos hacer tantos commit y push dentro la rama como sea necesario
* Cuando consideremos el trabajo está acabado mezclamos/publicamos los cambios en la rama principal (master): ```git checkout master; git merge nombre_rama```

### Android: Creación y firmado de un AAB para publicar en Google Play

1. Instalar Android Studio y abrirlo para que descargue la última versión del Android SDK. Es necesario instalar también la última versión de CMake desde Android Studio (menú Tools > SDK Manager > pestaña SDKTools > marcar Show Package Details > seleccionar última versión de CMake > Apply y después File > Sync Project with Gradle Files).
2. Clonar el repositorio love-android: ```dizzy-balloon $ git clone --recurse-submodules https://github.com/love2d/love-android```
3. Copia tu juego (main.lua y demás) a love-android/app/src/embed/assets/
4. Modifica el archivo love-android/app/build.gradle de la siguiente manera:
    ```
    android {
        defaultConfig {
            compileSdk 36 // última versión listada en https://developer.android.com/tools/releases/platforms
            targetSdk 36  // Idem
        }
    }
    ```
5. Modifica love-android/gradle.properties:
    ```
    app.name=Dizzy Balloon   # Descomentar esta línea y como nombre poner Dizzy Balloon
    #app.name_byte_array=76,195,150,86,69,32,102,111,114,32,65,110,100,114,111,105,100   # Comentar esta línea, solo la deberíamos usar si los caracteres del nombre de la aplicación no son ingleses

    app.application_id=es.codemonsters.dizzyballoon # Cambiar a es.codemonsters.dizzyballoon
    app.orientation=landscape
    app.version_code=33                             # Cambiar al número siguiente de la última versión publicada
    app.version_name=0.9.0                          # Cambiar a "0.9.0" o lo que corresponda en nuestra aplicación
    ```
6. Sobreescribe los iconos que trae por defecto por los del juego copiando el contenido que hay en 'extra/android_icons' dentro de la carpeta 'love-android/app/src/main/res'
7. Abre el proyecto seleccionando desde Android Studio la carpeta 'dizzy-balloon/love-android'
8. Genera el AAB firmado desde Android Studio:
    1. Cambia la variante de build a embedNoRecordRelease (Build > Select Build Variant).
    2. Ve a Build > Generate Signed App Bundle / APK.
    3. Elige Android App Bundle.
    4. Selecciona tu .jks, introduce alias y contraseñas.
    5. Finaliza y Android Studio lo genera por ti.
    6. El archivo AAB resultante queda en love-android/app/build/outputs/bundle/embedNoRecordRelease/

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
