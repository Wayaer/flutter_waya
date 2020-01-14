#!/usr/bin/env bash

## 计时
SECONDS=0

app="app"

version="`cat pubspec.yaml | shyaml get-value version`"

echo "${version}"

#read -n "输入你要打包的环境:release ? profile " env
#read  env

env=staging

echo "===android====${env}"
echo "清理 build"
find . -d -name "build" | xargs rm -rf
flutter clean
rm -rf build
rm -rf app

echo "开始获取 packages 插件资源"
flutter packages get
mkdir app
echo "开始打包apk"

flutter build apk  --target-platform android-arm -t lib/main.dart --release --flavor "${env}" #--no-codesign
echo "打包apk已完成"


if [ ! -d "app/${env}/" ]; then
  mkdir -p "app/${env}/"
fi

cp -r ./build/app/outputs/apk/"${env}"/release/app-"${env}"-release.apk ./builds/app/"${env}"/
mv ./builds/app/"${env}"/app-"${env}"-release.apk ./builds/app/"${env}"/v${version}-"${env}".apk
# > ./builds/ver.json