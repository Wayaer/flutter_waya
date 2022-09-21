import 'package:app/module/anchor_scroll_builder_page.dart';
import 'package:app/module/button_page.dart';
import 'package:app/module/components_page.dart';
import 'package:app/module/dio_page.dart';
import 'package:app/module/extension_page.dart';
import 'package:app/module/gesture_page.dart';
import 'package:app/module/json_parse_page.dart';
import 'package:app/module/overlay_page.dart';
import 'package:app/module/pages.dart';
import 'package:app/module/picker_page.dart';
import 'package:app/module/popup_page.dart';
import 'package:app/module/progress_page.dart';
import 'package:app/module/refresh_page.dart';
import 'package:app/module/scroll_list_page.dart';
import 'package:app/module/scroll_page.dart';
import 'package:app/module/state_components_page.dart';
import 'package:app/module/swiper_page.dart';
import 'package:app/module/universal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';

bool isCustomApp = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalOptions globalOptions = GlobalOptions();

  void des() {
    const String str =
        'CfAmqOiIYz6NkH0Te32Uz6obXELPspz1pDj+oOUNNbsmptHP0Jwvdg==';
    const String key = 'a51d3484ad8445df9d9e7aa5e8';
    log('des解密==>\nkey = $key \nString = $str');
    final DES des = DES(DESEngine(), 'a51d3484ad8445df9d9e7aa5e8');
    final String? decoded = des.decodeBase64(str);
    log('des解密完成==> $decoded');
  }

  ExtendedDio().initialize(
      options:
          ExtendedDioOptions(interceptors: [LoggerInterceptor()], logTs: true));

  globalOptions.setGlobalPushMode(RoutePushStyle.cupertino);
  globalOptions.setToastOptions(
      ToastOptions(positioned: Alignment.center, duration: 2.seconds));
  globalOptions.setBottomSheetOptions(const BottomSheetOptions());
  globalOptions.setGeneralDialogOptions(
      const GeneralDialogOptions(fromStyle: PopupFromStyle.fromTop));
  globalOptions.setWheelOptions(
      const WheelOptions(useMagnifier: true, magnification: 1.5));
  globalOptions.setPickerWheelOptions(
      const PickerWheelOptions(useMagnifier: true, magnification: 1.5));
  globalOptions.setLogDottedLine(false);
  globalOptions.setLoadingOptions(const LoadingOptions(
      custom: BText('全局设置loading', fontSize: 20),
      style: LoadingStyle.custom,
      options: ModalWindowsOptions(onTap: closeLoading)));
  des();
  runApp(isCustomApp ? _CustomApp() : _App());
}

class _CustomApp extends StatefulWidget {
  @override
  State<_CustomApp> createState() => _CustomAppState();
}

class _CustomAppState extends State<_CustomApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalOptions().globalNavigatorKey,
        title: 'Waya UI',
        theme: ThemeData.light(),
        home: _Home());
  }
}

class _App extends StatefulWidget {
  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  void initState() {
    super.initState();
    addPostFrameCallback((Duration duration) async {
      if (isDebug && isDesktop) {
        await Curiosity().desktop.focusDesktop();
        final bool data =
            await Curiosity().desktop.setDesktopSizeToIPad9P7(p: 1.5);
        log('桌面端限制宽高:$data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedWidgetsApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        title: 'Waya UI',
        home: _Home(),
        builder: (_, Widget? child) {
          if (isWeb) {
            child = ExtendedScaffold(
                body: Align(
                    alignment: Alignment.center,
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: child)));
          }
          return ScreenAdaptation(
              designWidth: 600,
              scaleType: ScreenAdaptationScaleType.auto,
              builder: (_, bool scaled) => child ?? const SizedBox());
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
        body: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10,
            spacing: 10,
            children: <Widget>[
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
              ElevatedText('Progress', onTap: () => push(const ProgressPage())),
              ElevatedText('Gesture', onTap: () => push(const GesturePage())),
              ElevatedText('Universal',
                  onTap: () => push(const UniversalPage())),
              ElevatedText('JsonParse',
                  onTap: () => push(const JsonParsePage())),
              ElevatedText('ScrollView',
                  onTap: () => push(const ScrollViewPage())),
              ElevatedText('ScrollList',
                  onTap: () => push(const ScrollListPage())),
              ElevatedText('AnchorScroll',
                  onTap: () => push(const AnchorScrollBuilderPage())),
              ElevatedText('EasyRefreshed',
                  onTap: () => push(const EasyRefreshPage())),
              ElevatedText('Extension',
                  onTap: () => push(const ExtensionPage())),
              ElevatedText('ExtendedFutureBuilder',
                  onTap: () => push(const ExtendedFutureBuilderPage())),
            ]));
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {super.key})
      : super(
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyleLight(),
            title: BText(text, fontSize: 18, fontWeight: FontWeight.bold),
            centerTitle: true);
}

class ElevatedText extends StatelessWidget {
  const ElevatedText(this.text, {super.key, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SimpleButton(
      isElastic: true,
      onTap: onTap,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          boxShadow: getBoxShadow(color: context.theme.canvasColor),
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(4)),
      child: BText(text, color: Colors.white));
}

class Partition extends StatelessWidget {
  const Partition(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Universal(
        width: double.infinity,
        color: Colors.grey.withOpacity(0.2),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 25),
        child: BText(title));
  }
}

const List<Color> colors = <Color>[
  ...Colors.accents,
  ...Colors.primaries,
];
