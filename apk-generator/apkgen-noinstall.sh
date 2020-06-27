#!/bin/bash
set -e
BASEDIR=$(dirname "$0")
cd $BASEDIR
pushd .
echo
echo Generating game.love
#jar -cfM ./love_decoded/assets/game.love dizzy-balloon
#cd dizzy-balloon; zip -r ../love_decoded/assets/game.love *
cd dizzy-balloon; jar -cfM ../love_decoded/assets/game.love *
popd
echo
echo Rebuilding APK from love_decoded
echo
java -jar apktool.jar b -o db-android.apk love_decoded
echo
echo Signing generated APK
echo
java -jar uber-apk-signer.jar --apks db-android.apk
echo
echo Removing unsigned APK
rm db-android.apk
echo
echo script end