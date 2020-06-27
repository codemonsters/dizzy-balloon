#!/bin/bash
set -e
BASEDIR=$(dirname "$0")
cd $BASEDIR
pushd .

installapk() {
    echo Proceeding with install
    appPath=$(./ptools-win/adb.exe shell pm list packages es.codemonsters.dizzyballoon)
    if [ -z "$appPath" ]; then
        ./ptools-win/adb.exe install db-android-aligned-debugSigned.apk;
    else 
        ./ptools-win/adb.exe install -r db-android-aligned-debugSigned.apk;
    fi
}

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
echo Checking if device connected with ADB for install
devices=$(./ptools-win/adb.exe devices | grep -w device || true)
if [ -z "$devices" ]; then
    echo Device not connected;
else 
    installapk
fi



echo script end