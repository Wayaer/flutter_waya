# flutter_waya

# Flutter 项目开发 基类库

### 若需要原生工具可以使用 [flutter_curiosity](https://github.com/Wayaer/flutter_curiosity)

## 1.二次封装组件 [custom](lib/src/widget/custom)

### 1、全局弹窗 全局无Context路由跳转 根组件使用 [OverlayCupertino](lib/src/widget/overlay/widget/OverlayCupertino.dart) 或 [OverlayMaterial](lib/src/widget/overlay/widget/OverlayMaterial.dart) 

### 2、[A-Z 侧边栏](lib/src/widget/a-z)

### 3、[自定义广告滚动](lib/src/widget/autoscroll)

## 2.多个工具类 [utils](lib/src/tools)

### 1、[弹窗工具](lib/src/widget/overlay/alert/AlertTools.dart)

### 2、[全局无Context路由跳转](lib/src/tools/NavigatorTools.dart)

### 3、[部分基础工具类](lib/src/tools/Tools.dart)

### 4、[长日志打印](lib/src/tools/LogTools.dart)

### 5、[屏幕相关参数](lib/src/tools/MediaQueryTools.dart)

### 6、[全局消息发送监听](lib/src/tools/Event.dart)

### 7、[本地持久化存储](lib/src/tools/StorageTools.dart)

## 3.多个组件 [widget](./lib/src/widget)

### 1、[AlertBase 弹窗底层组件](lib/src/widget/overlay/alert/AlertBase.dart)

### 2、[点击跳过](./lib/src/widget/CountDownSkip.dart)

### 3、[验证码发送](./lib/src/widget/SendSMS.dart)

### 4、[二次封装刷新组件](./lib/src/widget/Refresher.dart)

### 5、[二次封装Loading组件](lib/src/widget/overlay/alert/Loading.dart)

## 4.快捷打包命令 [builds](./builds)

###sh android.sh  //即可打包命令 可拷贝builds至自己的项目目录 并修改



