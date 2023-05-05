#!/bin/sh
rm -rf output; mkdir output
apktool/apktool d -s -o output/love_decoded love-embed/love-11.3-android-embed.apk
mkdir output/love_decoded/assets
pushd .; cd ../../src; /usr/lib/jvm/java-20-openjdk/bin/jar -cfM ../extra/android_exporter/output/love_decoded/assets/game.love *;popd
cp -r android_icons/* output/love_decoded/res/
cp AndroidManifest.xml output/love_decoded/
apktool/apktool b -o output/dizzy_balloon.apk output/love_decoded
java -jar uber-apk-signer/uber-apk-signer-1.3.0.jar --apks output
