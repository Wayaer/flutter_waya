import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/module/alert_page.dart';
import 'package:waya/module/button_page.dart';
import 'package:waya/module/carousel_page.dart';
import 'package:waya/module/extension_page.dart';
import 'package:waya/module/json_parse_page.dart';
import 'package:waya/module/pages.dart';
import 'package:waya/module/progress_page.dart';
import 'package:waya/module/refresh_page.dart';
import 'package:waya/module/scroll_page.dart';
import 'package:waya/module/universal_page.dart';

import 'module/components_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setGlobalPushMode(WidgetMode.ripple);
  _des();
  runApp(_App());
}

void _des() {
  const String str = 'CfAmqOiIYz6NkH0Te32Uz6obXELPspz1pDj+oOUNNbsmptHP0Jwvdg==';
  const String key = 'a51d3484ad8445df9d9e7aa5e8';
  log('des解密==>\n key = $key \n String = $str');
  final DES des = DES(DESEngine(), 'a51d3484ad8445df9d9e7aa5e8');
  final String? decoded = des.decodeBase64(str);
  log('des解密完成==> $decoded');
}

class _App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  void initState() {
    super.initState();
    addPostFrameCallback((Duration duration) async {
      if (isDebug && isDesktop) {
        final bool data =
            await Curiosity.instance.desktop.setDesktopSizeToIPad9P7(p: 1.5);
        log('桌面端限制宽高:$data');
      }
    });
  }

  @override
  Widget build(BuildContext context) => ExtendedWidgetsApp(
      title: 'Waya Demo', home: _Home(), widgetMode: WidgetMode.material);
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      backgroundColor: Colors.white,
      onWillPopOverlayClose: true,
      appBar: AppBarText('Flutter Waya Example'),
      padding: const EdgeInsets.all(10),
      body: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: <Widget>[
            ElevatedText('Components', onTap: () => push(ComponentsPage())),
            ElevatedText('Button', onTap: () => push(ButtonPage())),
            ElevatedText('Alert', onTap: () => push(AlertPage())),
            ElevatedText('Image', onTap: () => push(ImagePage())),
            ElevatedText('Carousel', onTap: () => push(CarouselPage())),
            ElevatedText('Progress', onTap: () => push(ProgressPage())),
            ElevatedText('Universal', onTap: () => push(UniversalPage())),
            ElevatedText('JsonParse', onTap: () => push(JsonParsePage())),
            ElevatedText('ScrollView', onTap: () => push(ScrollViewPage())),
            // ElevatedText('SimpleRefresh', onTap: () => push(RefreshPage())),
            ElevatedText('EasyRefreshed', onTap: () => push(EasyRefreshPage())),
            ElevatedText('Extension', onTap: () => push(const ExtensionPage())),
          ]),
    );
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {Key? key})
      : super(
            key: key,
            elevation: 0,
            iconTheme: const IconThemeData.fallback(),
            title: BText(text,
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            centerTitle: true,
            backgroundColor: color);
}

const Color color = Colors.amber;

class ElevatedText extends StatelessWidget {
  const ElevatedText(this.text, {Key? key, this.onTap}) : super(key: key);

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SimpleButton(
        isElastic: true,
        onTap: onTap,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(boxShadow: const <BoxShadow>[
          BoxShadow(
              color: color,
              offset: Offset(0, 0),
              blurRadius: 1.0,
              spreadRadius: 1.0)
        ], color: color, borderRadius: BorderRadius.circular(4)),
        child: BText(text, color: Colors.black),
      );
}
