# flutter_waya

## [Example](example)

## [extension](./lib/extension)

context 扩展
[context_extension](./lib/extension/context_extension.dart)

基础数据类型 扩展
[object_extension](./lib/extension/object_extension.dart)

  widget 扩展
  [widget_extension](./lib/extension/widget_extension.dart)



## 工具类
## [tools](./lib/tools)
dio 网络请求封装，统一error 返回[ResponseModel]
[dio](./lib/tools/dio.dart)

event bus
[event](./lib/tools/event.dart)

[MediaQueryData]
[screen_fit](./lib/tools/screen_fit.dart)

几个简单的方法
[tools](./lib/tools/tools.dart)

## 多个UI组件
## [widgets](./lib/widgets)

[DropdownMenuButton] 仿官方 [DropdownButton] 不遮挡默认
[LiquidButton] 流体按钮
[ElasticButton] 弹性按钮
[button](./lib/widgets/button)

[indicator] 指示器
[carousel] 轮播图
[carousel](./lib/widgets/carousel)

[LiquidProgress] 流体progress
[Progress] 普通动画progress
[progress](./lib/widgets/progress)

[EasyRefreshed] 封装 flutter_easyrefresh 
[refresh](./lib/widgets/refresh)

根组件使用[GlobalWidgetsApp] 可直接使用 push() pop() 等多个路由方法和[showDialogPopup()],[showBottomPopup()],
[showBottomPagePopup()],[showCupertinoBottomPagePopup()],[dialogSureCancel()],无需传[context],随处可用,
关闭 以上弹窗或页面 必须使用 [closePopup()]或直接[pop()],
[Scaffold] 使用 [OverlayScaffold] 可以任意处使用 [showOverlay()], [showLoading()], [showToast()],
关闭Overlay 必须使用 [closeOverlay()]或关闭全部 [closeAllOverlay()], 

[root](./lib/widgets/root)

多个组件
[widget](./lib/widgets/widget)

实现 picker 功能的滚动组件
[list_wheel](./lib/widgets/list_wheel.dart)

[ScrollViewAuto] 实现 自适应高度的 [SliverAutoPersistentHeader] 和 [SliverAutoAppBar] [FlexibleSpaceAutoBar] 无需设置 expandedHeight
[ScrollList] 合并[ListView] 和 [GridView] 并添加 下拉刷新 和 上拉加载 功能
[scroll_view](./lib/widgets/scroll_view.dart)

中合多个官方组件功能  减少嵌套
[universal](./lib/widgets/universal.dart)

## 快捷打包命令 [builds](builds)

sh android.sh  //即可打包命令 可拷贝builds至自己的项目目录 并修改

运行example 查看 例子