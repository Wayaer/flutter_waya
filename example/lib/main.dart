import 'package:app/module/button_page.dart';
import 'package:app/module/components_page.dart';
import 'package:app/module/picker/picker_page.dart';
import 'package:app/module/progress_page.dart';
import 'package:app/module/scroll_page.dart';
import 'package:app/module/state_components_page.dart';
import 'package:app/module/swiper_page.dart';
import 'package:app/module/text_field_page.dart';
import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlExtended globalOptions = FlExtended();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 40;

  globalOptions.pushStyle = RoutePushStyle.material;

  /// 设置全局Toast配置
  globalOptions.toastOptions =
      ToastOptions(alignment: Alignment.topCenter, duration: 2.seconds);

  /// 设置全局BottomSheet配置
  globalOptions.bottomSheetOptions = const BottomSheetOptions(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))));
  globalOptions.dialogOptions =
      const DialogOptions(fromStyle: PopupFromStyle.fromTop);

  /// 设置全局Wheel配置
  globalOptions.wheelOptions = const WheelOptions.cupertino();

  globalOptions.logCrossLine = true;

  /// 设置全局Loading配置
  globalOptions.loadingOptions = const LoadingOptions(
      alignment: Alignment.center,
      custom: BText('全局设置loading', fontSize: 20),
      onModalTap: closeLoading);

  runApp(DevicePreview(
      enabled: isDesktop || isWeb,
      defaultDevice: Devices.ios.iPhone13Mini,
      builder: (context) => const _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: FlExtended().navigatorKey,
        scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
        locale: DevicePreview.locale(context),
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        title: 'Waya UI',
        home: ExtendedScaffold(
            enableDoubleClickExit: true,
            appBar: AppBarText('Flutter Waya Example'),
            child: _Home()),
        builder: DevicePreview.appBuilder);
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Universal(
        padding: const EdgeInsets.all(10),
        isWrap: true,
        isScroll: true,
        runSpacing: 10,
        wrapSpacing: 10,
        wrapAlignment: WrapAlignment.center,
        direction: Axis.horizontal,
        scrollDirection: Axis.vertical,
        children: [
          ElevatedText('Components', onTap: () => push(const ComponentsPage())),
          ElevatedText('State Components',
              onTap: () => push(const StateComponentsPage())),
          ElevatedText('Button', onTap: () => push(const ButtonPage())),
          ElevatedText('Picker', onTap: () => push(const PickerPage())),
          ElevatedText('FlSwiper', onTap: () => push(const FlSwiperPage())),
          ElevatedText('FlProgress', onTap: () => push(const FlProgressPage())),
          ElevatedText('ScrollView', onTap: () => push(const ScrollViewPage())),
          ElevatedText('TextField', onTap: () => push(const TextFieldPage())),
        ]);
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {super.key})
      : super(
            elevation: 0,
            title: BText(text, fontSize: 18, fontWeight: FontWeight.bold),
            centerTitle: true);
}

class ElevatedText extends StatelessWidget {
  const ElevatedText(this.text, {super.key, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ElasticBuilder(
      withOpacity: true,
      builder: (_, elasticUp, elastic, elasticDown) => MouseRegion(
            onEnter: (_) {
              elasticUp();
            },
            onExit: (_) {
              elasticDown();
            },
            child: Universal(
                onTap: onTap,
                enabled: onTap != null,
                onTapDown: (_) {
                  elastic();
                },
                onDoubleTap: onTap == null
                    ? null
                    : () {
                        elastic(10.milliseconds);
                      },
                onLongPressDown: (_) {
                  elasticDown();
                },
                onLongPressUp: () {
                  elasticUp();
                },
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20)),
                child: BText(text, color: context.theme.colorScheme.primary)),
          ));
}

class Partition extends StatelessWidget {
  const Partition(this.title, {super.key, this.onTap});

  final String title;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) => Universal(
      onTap: onTap,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: BText(title,
          textAlign: TextAlign.center, fontWeight: FontWeight.bold));
}

const List<Color> colorList = <Color>[
  ...Colors.accents,
  ...Colors.primaries,
];

/// ExtendedScaffold
class ExtendedScaffold extends StatelessWidget {
  const ExtendedScaffold(
      {super.key,
      this.safeLeft = false,
      this.safeTop = false,
      this.safeRight = false,
      this.safeBottom = false,
      this.isStack = false,
      this.isScroll = false,
      this.isCloseOverlay = true,
      this.appBar,
      this.child,
      this.padding,
      this.floatingActionButton,
      this.bottomNavigationBar,

      /// 类似于 Android 中的 android:windowSoftInputMode=”adjustResize”，
      /// 控制界面内容 body 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，
      /// 重新布局避免被键盘盖住内容。默认值为 true。
      this.resizeToAvoidBottomInset,
      this.children,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.refreshConfig,
      this.enableDoubleClickExit = false});

  /// 相当于给[body] 套用 [Column]、[Row]、[Stack]
  final List<Widget>? children;

  /// [children].length > 0 && [isStack]=false 有效;
  final MainAxisAlignment mainAxisAlignment;

  /// [children].length > 0 && [isStack]=false 有效;
  final CrossAxisAlignment crossAxisAlignment;

  /// [children].length > 0有效;
  /// 添加 [Stack]组件
  final bool isStack;

  /// 是否添加滚动组件
  final bool isScroll;

  final EdgeInsetsGeometry? padding;

  /// true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
  /// false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
  final bool isCloseOverlay;

  /// ****** 刷新组件相关 ******  ///
  final RefreshConfig? refreshConfig;

  /// Scaffold相关属性
  final Widget? child;

  final Widget? appBar;
  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  final bool? resizeToAvoidBottomInset;

  /// ****** [SafeArea] ****** ///
  final bool safeLeft;
  final bool safeTop;
  final bool safeRight;
  final bool safeBottom;
  final bool enableDoubleClickExit;

  static DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
        key: key,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        floatingActionButton: floatingActionButton,
        appBar: buildAppBar(context),
        bottomNavigationBar: bottomNavigationBar,
        body: universal);
    return isCloseOverlay
        ? ExtendedPopScope(
            isCloseOverlay: isCloseOverlay,
            onPopInvoked: (bool didPop, bool didCloseOverlay) {
              if (didCloseOverlay || didPop) return;
              if (enableDoubleClickExit) {
                final now = DateTime.now();
                if (_dateTime != null &&
                    now.difference(_dateTime!).inMilliseconds < 2500) {
                  SystemNavigator.pop();
                } else {
                  _dateTime = now;
                  showToast('再次点击返回键退出',
                      options: const ToastOptions(
                          duration: Duration(milliseconds: 1500)));
                }
              } else {
                pop();
              }
            },
            child: scaffold)
        : scaffold;
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (appBar is AppBar) return appBar as AppBar;
    return appBar == null
        ? null
        : PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight - 12),
            child: appBar!);
  }

  Universal get universal => Universal(
      expand: true,
      refreshConfig: refreshConfig,
      padding: padding,
      isScroll: isScroll,
      safeLeft: safeLeft,
      safeTop: safeTop,
      safeRight: safeRight,
      safeBottom: safeBottom,
      isStack: isStack,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      child: child,
      children: children);
}
