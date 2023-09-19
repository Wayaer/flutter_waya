rm -rf 'app/web'

echo "开始获取 packages 插件资源"

flutter packages get

echo "开始构建 web"

flutter build web --web-renderer canvaskit

mv 'build/web' 'app/web'
