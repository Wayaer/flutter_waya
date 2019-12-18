#!/usr/bin/env bash
###
# @Description: In User Settings Edit
 # @Author: your name
 # @Date: 2019-08-09 20:38:40
 # @LastEditTime: 2019-08-14 15:02:37
 # @LastEditors: Please set LastEditors
 ###
## 计时
SECONDS=0

app="app"

version="`cat pubspec.yaml | shyaml get-value version`"

echo "${version}"

#read -n "输入你要打包的环境:staging ? prod " env
#read  env
#read -n "输入你的更新内容: " des
#read  des
env=staging
des=test
echo "${des}===android====${env}"
echo "清理 build"
find . -d -name "build" | xargs rm -rf
flutter clean
rm -rf build
rm -rf app

echo "开始获取 packages 插件资源"
flutter packages get

mkdir app

echo "开始打包apk"
say "开始打包apk"
flutter build apk  --target-platform android-arm -t lib/main_"${env}".dart --release --flavor "${env}" #--no-codesign
echo "打包apk已完成"
say "打包apk已完成"

if [ ! -d "app/${env}/" ]; then
  mkdir -p "app/${env}/"
fi

cp -r ./build/app/outputs/apk/"${env}"/release/app-"${env}"-release.apk ./builds/app/"${env}"/
mv ./builds/app/"${env}"/app-"${env}"-release.apk ./builds/app/"${env}"/v${version}-"${env}".apk
 > ./builds/ver.json