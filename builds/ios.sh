#!/usr/bin/env bash
app="app"
version="`cat pubspec.yaml | shyaml get-value version`"
echo "${version}"

read -n "输入你要打包的环境: release ?  profile" env
read  env

echo "===ios====${env}"
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
flutter build ios -t lib/main.dart  --release --flavor ${env}
case "${env}" in
"profile")
cd ios
echo "开始xcode build"
xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env} -archivePath ${archive_path}
echo "开始导出ipa"
#xcodebuild -exportArchive -archivePath ${archive_path} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/
xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ipa-${env}/
;;
"release")
cd ios
echo "开始xcode build"
xcodebuild archive -workspace Runner.xcworkspace -scheme ${env} -configuration Release-${env}  -archivePath ${archive_path}
echo "开始导出ipa"
#xcodebuild -exportArchive -archivePath ${archive_path} -exportOptionsPlist ./iosExportOptions.plist -exportPath ipa-${env}/
xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ipa-${env}/
;;
esac
cd ..
mv ios/ipa-${env}/${env}.ipa ${ipa_path}v${version}-"${env}".ipa
#rm -rf ./ios/ipa-${env}
echo "打包完成😄"
