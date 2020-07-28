#!/usr/bin/env bash

env=release
version=$(grep 'version:' pubspec.yaml)
version=${version#version: }

echo "ios===$env====$version"

echo "清理 build"
flutter clean

echo "开始获取 packages 插件资源"
flutter packages get

echo "开始flutter build"
flutter build ios -t lib/main.dart --release

echo "iOS build 完成😄 请去Xcode导出ipa"

#app="app/ios"
#ipa="ipa"
#
#mkdir -p "$app/${env}/"
#
#echo "清理 pods"
#rm -rf ./ios/Pods
#rm -rf ./ios/${ipa}
#
#echo "开始获取 packages 插件资源"
#flutter packages get
#echo "开始flutter build"
#flutter build ios -t lib/main.dart --release
#
## shellcheck disable=SC2164
#archive=${ipa}/ipa-${env}.xcarchive
#echo "开始xcode build"
#xcodebuild archive -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath ${archive}
#echo "开始导出ipa"
#xcodebuild -exportArchive -archivePath ${archive} -exportPath $ipa/
#mv ./ios/ipa/${env}.ipa ./${app}v"${version}"-"${env}".ipa
#
#echo "打包完成😄"
