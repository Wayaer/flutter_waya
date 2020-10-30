import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/module/DropdownMenuPage.dart';
import 'package:waya/module/GifImagePage.dart';
import 'package:waya/module/PickerPage.dart';
import 'package:waya/module/PinBoxPage.dart';
import 'package:waya/module/PopupPage.dart';
import 'package:waya/module/ToastPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GlobalMaterial(title: 'Waya Demo', home: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      body: Universal(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customElasticButton('ElasticButton',
              onTap: () => showToast('ElasticButton')),
          customElasticButton('Toast', onTap: () => push(widget: ToastPage())),
          customElasticButton('Picker',
              onTap: () => push(widget: PickerPage())),
          customElasticButton('Popup', onTap: () => push(widget: PopupPage())),
          customElasticButton('PinBox',
              onTap: () => push(widget: PinBoxPage())),
          customElasticButton('GifImage',
              onTap: () => push(widget: GifImagePage())),
          customElasticButton('DropdownMenu',
              onTap: () => push(widget: DropdownMenuPage())),
        ],
      ),
    );
  }

  void showOverlayLoading() => showLoading(gaussian: true);
}

Widget customElasticButton(String text, {GestureTapCallback onTap}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ElasticButton(
      elasticButtonType: ElasticButtonType.onlyScale,
      onTap: onTap,
      child: Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.all(10),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    ),
  );
}
