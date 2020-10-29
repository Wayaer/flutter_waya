import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class GifImagePage extends StatefulWidget {
  @override
  _GifImagePageState createState() => _GifImagePageState();
}

class _GifImagePageState extends State<GifImagePage>
    with TickerProviderStateMixin {
  GifController controller;

  String uri =
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3681478079,2138136230&fm=26&gp=0.jpg';

  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);
    Tools.addPostFrameCallback((Duration duration) {
      controller.repeat(
          min: 0, max: 74, period: const Duration(milliseconds: 1000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('GifImage Demo'), centerTitle: true),
      body: Universal(children: <Widget>[
        GifImage(image: NetworkImage(uri), controller: controller),
      ]),
    );
  }
}
