import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() => runApp(OverlayMaterial(
      title: 'Waya Demo',
      home: Home(),
    ));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      appBar: AppBar(title: Text('Waya Demo'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AreaPicker(),
          Container(height: 100),
          DateTimePicker(),
        ],
      ),
    );
  }
}
