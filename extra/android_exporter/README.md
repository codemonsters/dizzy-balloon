# En el branch [``package-generator``](https://github.com/codemonsters/dizzy-balloon/tree/package-generator) hay un script que aún puede que funcione!!
## Instrucciones para crear un APK para Android desde Linux:

[Nota: Las instrucciones asumen que el directorio raíz es extra/android_exporter]

1. Comprobar que en la carpeta apktool tenemos la última versión de apktool (https://ibotpeaches.github.io/Apktool/install/)
2. Comprueba que el script (wrapper) apktool es ejecutable (sino: `chmod +x apktool`)
3. Comprueba que en la carpeta love-embed está descargado el último APK embed de Löve2D (https://github.com/love2d/love/releases/download/11.3/love-11.3-android-embed.apk)
4. Crea la carpeta output: `mkdir output`
5. Desempaqueta el APK en la carpeta output ejecutando: `apktool/apktool d -s -o output/love_decoded love-embed/love-11.3-android-embed.apk`
6. Crea una carpeta assets dentro de love_decoded: `mkdir output/love_decoded/assets`
7. Crea un archivo comprimido game.love dentro de output/love_decoded/assets con todos los ficheros del juego: `pushd .; cd ../../src; /usr/lib/jvm/java-20-openjdk/bin/jar -cfM ../extra/android_exporter/output/love_decoded/assets/game.love *;popd`
8. Copia los iconos de la aplicación dentro del directorio donde se ha desempaquetado love: `cp -r android_icons/* output/love_decoded/res/`
9. Sobreescribe AndroidManifest.xml: `cp AndroidManifest.xml output/love_decoded/`
10. Crea un APK con `apktool/apktool b -o output/dizzy_balloon.apk output/love_decoded`
11. Firma el APK: `java -jar uber-apk-signer/uber-apk-signer-1.3.0.jar --apks output`
