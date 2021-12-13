import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:app/main.dart';

class GestureLockPage extends StatelessWidget {
  const GestureLockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('GestureLock Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          GestureLock(
              size: 400, showUnSelectRing: true, immediatelyClear: false)
        ]);
  }
}

class GestureZoomPage extends StatelessWidget {
  const GestureZoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('GestureZoom Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureZoom(
              child: Container(width: 100, height: 300, color: Colors.red))
        ]);
  }
}
