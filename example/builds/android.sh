#!/usr/bin/env bash

env=release
#jenkins
#env=${SET_ENV}

app="app/android"
version=$(grep 'version:' ../pubspec.yaml)
version=${version#version: }

mkdir -p "$app/$env/"
echo "android===$env====$version"

echo "开始打包apk"
flutter build apk --analyze-size --"$env" --target-platform android-arm -t lib/main.dart #--no-codesign
echo "打包apk已完成"

# shellcheck disable=SC2046
mv ./build/app/outputs/apk/$env/app-$env.apk ./$app/$env/APP-v"${version}".$(date "+%Y%m%d%H%M").apk

echo "Android打包完成😄"
