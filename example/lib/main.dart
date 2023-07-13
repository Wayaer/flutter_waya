import 'package:app/module/anchor_scroll_builder_page.dart';
import 'package:app/module/builder_page.dart';
import 'package:app/module/button_page.dart';
import 'package:app/module/components_page.dart';
import 'package:app/module/decorator_page.dart';
import 'package:app/module/dio_page.dart';
import 'package:app/module/extension_page.dart';
import 'package:app/module/gesture_page.dart';
import 'package:app/module/json_parse_page.dart';
import 'package:app/module/list_wheel_page.dart';
import 'package:app/module/overlay_page.dart';
import 'package:app/module/picker/picker_page.dart';
import 'package:app/module/popup_page.dart';
import 'package:app/module/progress_page.dart';
import 'package:app/module/refresh_page.dart';
import 'package:app/module/scroll_list_page.dart';
import 'package:app/module/scroll_page.dart';
import 'package:app/module/state_components_page.dart';
import 'package:app/module/swiper_page.dart';
import 'package:app/module/text_field_page.dart';
import 'package:app/module/universal_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';

bool isCustomApp = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalOptions globalOptions = GlobalOptions();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 40;

  ExtendedDio().initialize(interceptors: [
    /// 日志打印
    LoggerInterceptor(),

    /// debug 调试工具
    DebuggerInterceptor(),

    /// cooker 管理
    CookiesInterceptor()
  ]);

  globalOptions.setGlobalPushMode(RoutePushStyle.cupertino);

  /// 设置全局Toast配置
  globalOptions.setToastOptions(
      ToastOptions(positioned: Alignment.center, duration: 2.seconds));

  /// 设置全局BottomSheet配置
  globalOptions.setBottomSheetOptions(const BottomSheetOptions(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)))));
  globalOptions
      .setDialogOptions(const DialogOptions(fromStyle: PopupFromStyle.fromTop));

  /// 设置全局Wheel配置
  globalOptions.setWheelOptions(const WheelOptions.cupertino());

  globalOptions.setLogCrossLine(true);

  /// 设置全局Loading配置
  globalOptions.setLoadingOptions(const LoadingOptions(
      custom: BText('全局设置loading', fontSize: 20),
      options: ModalWindowsOptions(onTap: closeLoading)));
  runApp(DevicePreview(
      enabled: isDesktop || isWeb,
      defaultDevice: Devices.ios.iPhone13Mini,
      builder: (context) => isCustomApp ? _CustomApp() : _App()));
}

class _CustomApp extends StatefulWidget {
  @override
  State<_CustomApp> createState() => _CustomAppState();
}

class _CustomAppState extends ExtendedState<_CustomApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalOptions().globalNavigatorKey,
        title: 'Waya UI',
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: _Home());
  }
}

class _App extends StatefulWidget {
  @override
  State<_App> createState() => _AppState();
}

class _AppState extends ExtendedState<_App> {
  @override
  void initState() {
    super.initState();
    addPostFrameCallback((Duration duration) async {
      if (isDebug && isDesktop) {
        await Curiosity().desktop.focusDesktop();
        final bool data =
            await Curiosity().desktop.setDesktopSizeToIPad11(p: 1.3);
        log('桌面端限制宽高:$data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedWidgetsApp(
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        locale: DevicePreview.locale(context),
        title: 'Waya UI',
        home: _Home(),
        builder: (BuildContext context, Widget? child) {
          final widget = ScreenAdaptation(
              designWidth: context.width,
              scaleType: ScreenAdaptationScaleType.auto,
              builder: (_, bool scaled) => child ?? const SizedBox());
          return DevicePreview.appBuilder(context, widget);
        },
        pushStyle: RoutePushStyle.material);
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      onWillPopOverlayClose: true,
      appBar: AppBarText('Flutter Waya Example'),
      padding: const EdgeInsets.all(10),
      isScroll: true,
      body: Universal(
          isWrap: true,
          runSpacing: 10,
          wrapSpacing: 10,
          wrapAlignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            ElevatedText('ExtendedDio',
                onTap: () => push(const ExtendedDioPage())),
            ElevatedText('Components',
                onTap: () => push(const ComponentsPage())),
            ElevatedText('State Components',
                onTap: () => push(const StateComponentsPage())),
            ElevatedText('Button', onTap: () => push(const ButtonPage())),
            ElevatedText('Popup', onTap: () => push(const PopupPage())),
            ElevatedText('Picker', onTap: () => push(const PickerPage())),
            ElevatedText('Overlay', onTap: () => push(const OverlayPage())),
            ElevatedText('FlSwiper', onTap: () => push(const FlSwiperPage())),
            ElevatedText('FlProgress',
                onTap: () => push(const FlProgressPage())),
            ElevatedText('GestureZoom',
                onTap: () => push(const GestureZoomPage())),
            ElevatedText('Universal', onTap: () => push(const UniversalPage())),
            ElevatedText('JsonParse', onTap: () => push(const JsonParsePage())),
            ElevatedText('ScrollView',
                onTap: () => push(const ScrollViewPage())),
            ElevatedText('ScrollList',
                onTap: () => push(const ScrollListPage())),
            ElevatedText('ListWheel', onTap: () => push(const ListWheelPage())),
            ElevatedText('AnchorScroll',
                onTap: () => push(const AnchorScrollBuilderPage())),
            ElevatedText('EasyRefreshed',
                onTap: () => push(const EasyRefreshPage())),
            ElevatedText('Extension', onTap: () => push(const ExtensionPage())),
            ElevatedText('DecoratorBox',
                onTap: () => push(const DecoratorBoxPage())),
            ElevatedText('ExtendedTextField',
                onTap: () => push(const TextFieldPage())),
            ElevatedText('ExtendedBuilder',
                onTap: () => push(const ExtendedBuilderPage())),
          ]),
    );
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
                onTapDown: (_) {
                  elastic();
                },
                onDoubleTap: () {
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    boxShadow: getBoxShadow(color: context.theme.canvasColor),
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: BText(text, color: Colors.white)),
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

const List<Color> colors = <Color>[
  ...Colors.accents,
  ...Colors.primaries,
];
