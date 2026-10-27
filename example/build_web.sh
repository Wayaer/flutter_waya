cd "$(dirname "$0")" || exit 1

rm -rf 'app/web'
mkdir -p 'app'

echo "开始获取 packages 插件资源"

flutter pub get

echo "开始构建 web"

flutter build web --base-href '/flutter_waya/example/app/web/'

mv 'build/web' 'app/web'
