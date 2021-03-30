import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with TickerProviderStateMixin {
  GifController controller;

  String uri =
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3681478079,2138136230&fm=26&gp=0.jpg';

  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);
    addPostFrameCallback((Duration duration) {
      controller.repeat(
          min: 0, max: 74, period: const Duration(milliseconds: 1000));
    });
  }

  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('GifImage Demo'), centerTitle: true),
          children: <Widget>[
            GifImage(image: NetworkImage(uri), controller: controller),
          ]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}



class ToastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const List<ToastType> toastList = ToastType.values;
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Toast Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: toastList.builder(
            (ToastType e) => CustomElastic(e.toString(), onTap: () async {
                  await showToast(e.toString(), toastType: e);
                  log('开始弹第二个');
                  showToast('添加await第一个Toast完了之后弹出第二个Toast');
                })));
  }
}

class PinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('PinBox Demo'), centerTitle: true),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinBox(
                maxLength: 4,
                autoFocus: false,
                decoration: const BoxDecoration(color: Colors.transparent),
                boxSpacing: 10,
                hasFocusPinDecoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.circular(4)),
                pinDecoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(4)),
                pinTextStyle: const TextStyle(color: Colors.white)),
          ]);
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Counter Demo'), centerTitle: true),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CounterAnimation(
                animationType: CountAnimationType.part,
                count: 100,
                onTap: (int c) {
                  showToast(c.toString());
                },
                countBuilder: (int count, String text) =>
                    BasisText(text, fontSize: 30)).color(Colors.black12),
            const SizedBox(height: 40),
            CounterAnimation(
                animationType: CountAnimationType.all,
                count: 100,
                onTap: (int c) {
                  showToast(c.toString());
                },
                countBuilder: (int count, String text) =>
                    BasisText(text, fontSize: 30)).color(Colors.black12),
          ]);
}

class ToggleRotatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar:
              AppBar(title: const Text('ToggleRotate Demo'), centerTitle: true),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ToggleRotate(
                duration: Duration(milliseconds: 800),
                rad: pi / 2,
                child: Icon(Icons.chevron_left, size: 30)),
            const SizedBox(height: 40),
            ToggleRotate(
                duration: const Duration(seconds: 2),
                onTap: () {
                  showToast('旋转');
                },
                rad: pi,
                child: const Icon(Icons.chevron_left, size: 30)),
            const SizedBox(height: 40),
            const ToggleRotate(
                duration: Duration(seconds: 3),
                rad: pi * 1.5,
                child: Icon(Icons.chevron_left, size: 30)),
          ]);
}

class ExpansionTilesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar:
            AppBar(title: const Text('ToggleRotate Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ExpansionTiles(
              title: BasisText('title'),
              children: 5.generate((int index) => Universal(
                  margin: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  child: BasisText('item$index', color: Colors.black)))),
          ExpansionTiles(
              title: BasisText('title'),
              children: 5.generate((int index) => Universal(
                  margin: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  child: BasisText('item$index', color: Colors.black)))),
        ]);
  }
}
