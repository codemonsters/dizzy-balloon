# dizzy-balloon APK Generator
Contains everything necessary to make an APK of the game.
Tested on Linux and Darwin(macOS), probably doesn't work on Windows.

You need Java and JDK.

## Steps
1. You need to clone only this branch with ```git clone -b package-generator --single-branch https://github.com/codemonsters/dizzy-balloon.git```
2. navigate to ./dizzy-balloon/apk-generator with ```cd ./dizzy-balloon/apk-generator```
3. Clone the master branch so that the generator can make the APK with ```git clone -b master --single-branch https://github.com/codemonsters/dizzy-balloon.git```
4. Edit AndroidManifest.xml to set version number and [others](https://love2d.org/wiki/Game_Distribution/APKTool)
5. Run the corresponding bash script (Example ```./apkgen-linux.sh```)

NOTE: The script with attempt to install the APK to a connected device if possible via ADB.