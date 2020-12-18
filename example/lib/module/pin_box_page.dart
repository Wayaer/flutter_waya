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
              pinTextStyle: TextStyle(fontSize: 10),
            ),
          ]),
    );
  }
}
