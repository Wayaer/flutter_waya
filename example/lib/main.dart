import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() => runApp(OverlayMaterial(
      title: 'Waya Demo',
      home: Home(),
    ));

class Home extends StatelessWidget {
  getJson() async {
//    var data = await rootBundle.loadString('lib/res/area.json');
//    log(data);
  }

  @override
  Widget build(BuildContext context) {
    getJson();
    return OverlayScaffold(
      appBar: AppBar(title: Text('Waya Demo'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AreaPicker(),
        ],
      ),
    );
  }
}
