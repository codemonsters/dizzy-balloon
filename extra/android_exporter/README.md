# En el branch [``package-generator``](https://github.com/codemonsters/dizzy-balloon/tree/package-generator) hay un script que aún puede que funcione!!
## Instrucciones para crear un APK para Android desde Linux:
1. Comprobar que en la carpeta apktool tenemos la última versión de apktool (https://ibotpeaches.github.io/Apktool/install/)
2. Comprueba que el script (wrapper) apktool es ejecutable (sino: `chmod +x apktool/apktool`)
3. Comprueba que en la carpeta love-embed está descargado el último APK embed de Löve2D (https://github.com/love2d/love/releases/download/11.3/love-11.3-android-embed.apk)
4. Desempaqueta el APK en la carpeta output ejecutando: `apktool/apktool d -s -o output/love_decoded love-embed/love-11.3-android-embed.apk`
5. Crea una carpeta assets dentro de love_decoded: `mkdir output/love_decoded/assets`
6. TODO: Crea un archivo comprimido game.love dentro de output/love_decoded/assets con todos los ficheros del juego: `zip` [TODO: Mover el código del juego a una carpeta "src" para que sea más fácil diferenciar estos archivos]
7. [TODO: Crear iconos en distintas resoluciones] Copia los iconos dentro del directorio donde se ha desempaquetado love: `cp android_icons/* output/love_decoded/res/dra*`
8. Sobreescribe AndroidManifest.xml: `cp AndroidManifest.xml output/love_decoded/`
9. Crea un APK con `apktool/apktool b -o output/dizzy_balloon.apk output/love_decoded`
10. Firma el APK: `java -jar uber-apk-signer/uber-apk-signer-1.3.0.jar --apks output`
