# flutter_waya

## [Example](example) 运行 Example 查看使用

### 初始化 navigatorKey 两种方式

```dart
/// 设置你自己的 navigatorKey
void setGlobalNavigatorKey() {
  GlobalOptions().setGlobalNavigatorKey(navigatorKey);
}

/// 使用自己的 MaterialApp
class _CustomAppState extends State<_App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalOptions().globalNavigatorKey,
        title: 'Waya UI',
        home: _Home());
  }
}

/// 根组件使用  ExtendedWidgetsApp , 默认 移出 banner
class _AppState extends State<_App> {
  @override
  Widget build(BuildContext context) {
    return ExtendedWidgetsApp(
        title: 'Waya UI', home: _Home(), pushStyle: RoutePushStyle.material);
  }
}

```

- Scaffold 使用 `ExtendedScaffold` 可自动管理 android 物理返回键 关闭 toast loading 等各种弹窗，以及多种功能

### extension 扩展方法

- [extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension)
    - [context_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/context_extension.dart)
      context 扩展

    - [object_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/object_extension.dart)
      基础数据类型 扩展

    - [widget_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/widget_extension.dart)
      widget 扩展

    - [num_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/num_extension.dart)
      num 扩展

    - [string_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/string_extension.dart)
      string 扩展

### utils 工具类

- [utils](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils)

    - [dio](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils/src/dio.dart) dio 网络请求封装，统一error 返回[ResponseModel]
    - [event](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils/src/event.dart) event bus
    - [media_query](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils/src/media_query.dart)
      MediaQueryData

### UI组件

- [button](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/button)

    - `DropdownMenuButton()` 仿官方 `DropdownButton` 不遮挡默认
    - `LiquidButton()` 流体按钮
    - `ElasticButton()` 弹性按钮

- [swiper](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/swiper)
    - `Indicator()` 指示器
    - `FlSwiper()` 轮播图

- [progress](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/progress)
    - `LiquidProgress()` 流体progress
    - `Progress()` 普通动画progress

- `ExtendedWidgetsApp()` 根组件使用 `ExtendedWidgetsApp()`可直接使用`push()` `pop()`
  等多个路由方法和`showDialogPopup()`,`showBottomPopup()`,`showCupertinoBottomPopup()`
  ,`showDoubleChooseWindows()`,`showOverlay()`,`showLoading()`,`showToast()`,无需传 context ,随处打开,关闭 以上弹窗或页面 必须使用 `closePopup()`或直接 `pop()`,

- `ExtendedScaffold()`
  添加 `onWillPop()` `RefreshConfig` `padding` `margin` `decoration` `isStack` `isScroll` `children`
  等多个参数

- `ListWheel()` 实现 picker 功能的滚动组件

- `ExtendedScrollView()` 实现 自适应高度的 `ExtendedSliverPersistentHeader()`
  和 `ExtendedSliverAppBar()` `ExtendedFlexibleSpaceBar()` 无需设置 expandedHeight

- `ScrollList()` 合并 `ListView()` 和 `GridView()` 并添加 下拉刷新 和 上拉加载 功能

- `Universal()`中合多个官方组件功能 减少嵌套

## 更新指南

- [1.20.0 更新](https://github.com/Wayaer/flutter_waya/blob/main/CHANGELOG.md) 添加跳转至滚动组件指定下标 无论是`ListView`或`GridView`，无论使用`SliverChildBuilderDelegate()`
  代理，或是`SliverChildListDelegate()` 都可以使用
- [1.16.2 修改指南](https://github.com/Wayaer/flutter_waya/blob/main/CHANGELOG.md)