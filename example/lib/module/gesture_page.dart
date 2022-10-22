import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class GesturePage extends StatelessWidget {
  const GesturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('Gesture'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ElevatedText('GestureLock',
              onTap: () => push(const _GestureLockPage())),
          ElevatedText('GestureZoom',
              onTap: () => push(const _GestureZoomPage())),
        ]);
  }
}

class _GestureLockPage extends StatelessWidget {
  const _GestureLockPage();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('GestureLock'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          GestureLock(
              size: 400, showUnSelectRing: true, immediatelyClear: false)
        ]);
  }
}

class _GestureZoomPage extends StatelessWidget {
  const _GestureZoomPage();

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
