#!/usr/bin/env bash
###
# @Description: In User Settings Edit
 # @Author: your name
 # @Date: 2019-08-09 20:38:40
 # @LastEditTime: 2019-08-30 14:06:17
 # @LastEditors: Please set LastEditors
 ###
## 计时
cd ..
app="app"
version="`cat pubspec.yaml | shyaml get-value version`"
echo "${version}"

env=${SET_ENV}
des=${DES}


echo "${des}===ios====${env}"
echo "清理 build"
find . -d -name "build" | xargs rm -rf
flutter clean
mkdir -p app
ipa_path=app/ios-${env}/
if [ ! -d "${ipa_path}" ]; then
  rm -rf ${ipa_path}
  mkdir -p ${ipa_path}
fi
echo "开始获取 packages 插件资源"
flutter packages get

Pods=./ios/Pods
if [ -d "${Pods}" ]; then
  rm -rf ${Pods}
fi

echo "打包的版本${env}"


archive_path=./ipa-${env}/KKing.xcarchive
echo "开始flutter build"

flutter build ios -t lib/main_"${env}".dart  --release --flavor ${env}

case "${env}" in
"prod")

cd ios

echo "开始xcode build"

xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env} -archivePath ${archive_path}

echo "开始导出ipa"

xcodebuild -exportArchive -archivePath ${archive_path} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/

;;
"staging")

cd ios

echo "开始xcode build"

xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env}  -archivePath ${archive_path}

echo "开始导出ipa"

xcodebuild -exportArchive -archivePath ${archive_path} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/

;;
esac
archive_path=./ipa-${env}/KKing.xcarchive
echo "开始flutter build"

flutter build ios -t lib/main_"${env}".dart  --release --flavor ${env}

case "${env}" in
"prod")

cd ios

echo "开始xcode build"

xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env} -archivePath ${archive_path}

echo "开始导出ipa"

xcodebuild -exportArchive -archivePath ${archive_path} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/

;;
"staging")

cd ios

echo "开始xcode build"

xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env}  -archivePath ${archive_path}

echo "开始导出ipa"

xcodebuild -exportArchive -archivePath ${archive_path} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/

;;
esac

cd ..
mv ios/ipa-${env}/${env}.ipa ${ipa_path}v${version}-"${env}".ipa

rm -rf ./ios/ipa-${env}

echo "打包完成😄"

cd ..
mv ios/ipa-${env}/${env}.ipa ${ipa_path}v${version}-"${env}".ipa

rm -rf ./ios/ipa-${env}

echo "打包完成😄"
