import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/module/button_page.dart';
import 'package:waya/module/carousel_page.dart';
import 'package:waya/module/json_parse_page.dart';
import 'package:waya/module/pages.dart';
import 'package:waya/module/picker_page.dart';
import 'package:waya/module/popup_page.dart';
import 'package:waya/module/progress_page.dart';
import 'package:waya/module/refresh_page.dart';
import 'package:waya/module/scroll_page.dart';
import 'package:waya/module/universal_page.dart';

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
  final String decoded = des.decodeBase64(str);
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
    addPostFrameCallback((Duration duration) {
      if (isDebug && isDesktop) setDesktopSizeTo5P8();
    });
  }

  @override
  Widget build(BuildContext context) => GlobalWidgetsApp(
      title: 'Waya Demo', home: _Home(), widgetMode: WidgetMode.material);
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      onWillPopOverlayClose: true,
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      body: Wrap(runSpacing: 10, spacing: 10, children: <Widget>[
        CustomElastic('Toast', onTap: () => push(ToastPage())),
        CustomElastic('Button', onTap: () => push(ButtonPage())),
        CustomElastic('ToggleRotate', onTap: () => push(ToggleRotatePage())),
        CustomElastic('Counter', onTap: () => push(CounterPage())),
        CustomElastic('Picker', onTap: () => push(PickerPage())),
        CustomElastic('Popup', onTap: () => push(PopupPage())),
        CustomElastic('PinBox', onTap: () => push(PinBoxPage())),
        CustomElastic('Image', onTap: () => push(ImagePage())),
        CustomElastic('Carousel', onTap: () => push(CarouselPage())),
        CustomElastic('Progress', onTap: () => push(ProgressPage())),
        CustomElastic('Universal', onTap: () => push(UniversalPage())),
        CustomElastic('JsonParse', onTap: () => push(JsonParsePage())),
        CustomElastic('ExpansionTiles',
            onTap: () => push(ExpansionTilesPage())),
        CustomElastic('ScrollView', onTap: () => push(ScrollViewPage())),
        CustomElastic('JsonParse', onTap: () => push(JsonParsePage())),
        CustomElastic('SimpleRefresh', onTap: () => push(RefreshPage())),
        CustomElastic('EasyRefreshed', onTap: () => push(EasyRefreshPage())),
        CustomElastic('SimpleBuilder', onTap: () => push(SimpleBuilderPage())),
        ElevatedButton(
            onPressed: () {
              showSnackBar(SnackBar(content: BasisText('Popup SnackBar')));
            },
            child: BasisText('showSnackBar')),
        ElevatedButton(
            onPressed: () {
              showOverlayLoading();
            },
            child: BasisText('showOverlayLoading')),
      ]),
    );
  }

  void showOverlayLoading() => showLoading(
      gaussian: true,
      onTap: closeOverlay,
      custom: const SpinKitWave(color: Colors.blue));
}

class CustomElastic extends StatelessWidget {
  const CustomElastic(this.text, {Key key, this.onTap}) : super(key: key);

  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => Universal(
        addInkWell: true,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ElasticButton(
            withOpacity: true,
            onTap: onTap,
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(10),
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ).clipRRect(borderRadius: BorderRadius.circular(6))),
      );
}
