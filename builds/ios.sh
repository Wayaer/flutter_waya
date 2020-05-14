#!/usr/bin/env bash

app="app/ios"
env=release
ipa="ipa"

version=$(grep 'version:' pubspec.yaml)
version=${version#version: }

mkdir -p "$app/${env}/"
echo "ios===$env====$version"

echo "清理 build"
flutter clean
rm -rf build

echo "清理 pods"
rm -rf ./ios/Pods
rm -rf ./ios/${ipa}

echo "开始获取 packages 插件资源"
flutter packages get
echo "开始flutter build"
flutter build ios -t lib/main.dart --release --flavor ${env}

# shellcheck disable=SC2164
cd ios

mkdir -p "${ipa}"
archive=${ipa}/ipa-${env}.xcarchive
echo "开始xcode build"
xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env} -archivePath ${archive}
echo "开始导出ipa"
#xcodebuild -exportArchive -archivePath ${archive} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/
xcodebuild -exportArchive -archivePath ${archive} -exportPath $ipa/
# shellcheck disable=SC2103
cd ..
mv ./ios/ipa/${env}.ipa ./${app}v"${version}"-"${env}".ipa

echo "打包完成😄"
