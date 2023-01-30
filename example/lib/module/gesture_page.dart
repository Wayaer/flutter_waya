import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class GestureZoomPage extends StatelessWidget {
  const GestureZoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('GestureZoom'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureZoom(
              child: Container(width: 100, height: 300, color: Colors.red))
        ]);
  }
}
