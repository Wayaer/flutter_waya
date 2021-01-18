import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/module/carousel_page.dart';
import 'package:waya/module/json_parse_page.dart';
import 'package:waya/module/pages.dart';
import 'package:waya/module/list_page.dart';
import 'package:waya/module/picker_page.dart';
import 'package:waya/module/popup_page.dart';
import 'package:waya/module/progress_page.dart';
import 'package:waya/module/scroll_view_page.dart';
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
          customElasticButton('Toast', onTap: () => push(ToastPage())),
          customElasticButton('JsonParse', onTap: () => push(JsonParsePage())),
          customElasticButton('Picker', onTap: () => push(PickerPage())),
          customElasticButton('Popup', onTap: () => push(PopupPage())),
          customElasticButton('PinBox', onTap: () => push(PinBoxPage())),
          customElasticButton('Image', onTap: () => push(ImagePage())),
          customElasticButton('Carousel', onTap: () => push(CarouselPage())),
          customElasticButton('SimpleList', onTap: () => push(ListPage())),
          customElasticButton('Progress', onTap: () => push(ProgressPage())),
          customElasticButton('Universal', onTap: () => push(UniversalPage())),
          customElasticButton('ScrollView',
              onTap: () => push(ScrollViewPage())),
          customElasticButton('ElasticButton',
              onTap: () => showToast('ElasticButton')),
          customElasticButton('DropdownMenu',
              onTap: () => push(DropdownMenuPage())),
        ]),
      );

  void showOverlayLoading() => showLoading(gaussian: true);
}

Widget customElasticButton(String text, {GestureTapCallback onTap}) =>
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElasticButton(
          withOpacity: true,
          onTap: onTap,
          child: Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.all(10),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          )),
    );
