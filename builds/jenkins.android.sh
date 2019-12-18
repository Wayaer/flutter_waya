#!/usr/bin/env bash
###
# @Description: In User Settings Edit
 # @Author: your name
 # @Date: 2019-08-09 20:38:40
 # @LastEditTime: 2019-08-14 15:02:37
 # @LastEditors: Please set LastEditors
 ###
## 计时
cd ..

env=${SET_ENV}
des=${DES}

app="app"
version="`cat pubspec.yaml | shyaml get-value version`"

echo "${version}"

echo "${des}===android====${env}"
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
say "开始打包apk"
flutter build apk -t lib/main_"${env}".dart --release --flavor "${env}" #--no-codesign
echo "打包apk已完成"
say "打包apk已完成"

cp -r build/app/outputs/apk/"${env}"/release/app-"${env}"-release.apk ${apk_path}
mv ${apk_path}/app-"${env}"-release.apk "${apk_path}"/v${version}-"${env}".apk

cat ./scripts/ver.json | jq ".android"
echo "打包完成😄"
