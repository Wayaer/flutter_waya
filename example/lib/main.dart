import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/module/button_page.dart';
import 'package:waya/module/carousel_page.dart';
import 'package:waya/module/json_parse_page.dart';
import 'package:waya/module/pages.dart';
import 'package:waya/module/picker_page.dart';
import 'package:waya/module/popup_page.dart';
import 'package:waya/module/progress_page.dart';
import 'package:waya/module/scroll_page.dart';
import 'package:waya/module/universal_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setGlobalPushMode(WidgetMode.ripple);
  runApp(GlobalWidgetsApp(title: 'Waya Demo', home: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
        backgroundColor: Colors.white,
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
          ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
        ]),
      );

  void showOverlayLoading() => showLoading(gaussian: true);
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
