rm -rf 'app/web'

echo "开始获取 packages 插件资源"

flutter packages get

echo "开始构建 web"

flutter build web  --base-href '/flutter_waya/example/app/web/'

mv 'build/web' 'app/web'
