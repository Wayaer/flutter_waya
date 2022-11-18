# flutter_waya

## [Example Demo](https://wayaer.github.io/flutter_waya/example/app/web/index.html#/) 运行 Example 查看使用

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