import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('PinBox Demo'), centerTitle: true),
      body: Universal(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinBox(
                maxLength: 6,
                autoFocus: false,
                decoration: const BoxDecoration(color: Colors.black26),
                hasFocusPinDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue)),
                pinDecoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                pinTextStyle: const TextStyle(color: Colors.white)),
          ]),
    );
  }
}
