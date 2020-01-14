#!/usr/bin/env bash

## 计时
cd ..
env=${SET_ENV}
app="app"
version="`cat pubspec.yaml | shyaml get-value version`"
echo "${version}"
echo "===android====${env}"
echo "清理 build"
find . -d -name "build" | xargs rm -rf
flutter clean
mkdir -p app
apk_path=app/android-${env}
if [ ! -d "${apk_path}" ]; then
  rm -rf ${apk_path}
  mkdir -p ${apk_path}
fi
echo "开始获取 packages 插件资源"
flutter packages get
echo "开始打包apk"
flutter build apk -t lib/main.dart --release --flavor "${env}" #--no-codesign
echo "打包apk已完成"
cp -r build/app/outputs/apk/"${env}"/release/app-"${env}"-release.apk ${apk_path}
mv ${apk_path}/app-"${env}"-release.apk "${apk_path}"/v${version}-"${env}".apk

#cat ./scripts/ver.json | jq ".android"

