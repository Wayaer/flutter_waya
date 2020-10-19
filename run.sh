#!/usr/bin/env bash

echo "开始flutter clean"
flutter clean

echo "开始获取 packages 插件资源"
flutter packages get
cd example
sh ./builds/android.sh
#sh ./builds/ios.sh
