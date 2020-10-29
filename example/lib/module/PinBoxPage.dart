import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('PinBoxPage Demo'), centerTitle: true),
      body: const Universal(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinBox(
              maxLength: 6,
              pinBoxWidth: 30,
              pinBoxOuterPadding: EdgeInsets.zero,
              pinBoxBorderWidth: 0.5,
              pinBoxColor: Colors.amber,
              pinBoxHeight: 30,
              pinTextStyle: TextStyle(fontSize: 10),
              highlight: true,
            ),
          ]),
    );
  }
}
