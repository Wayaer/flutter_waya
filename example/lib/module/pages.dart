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
    controller?.dispose();
    super.dispose();
  }
}

class DropdownMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar:
              AppBar(title: const Text('DropdownMenu Demo'), centerTitle: true),
          children: const <Widget>[
            DropdownMenu(
              value: <List<String>>[
                <String>['男', '女'],
                <String>['12岁', '13岁', '14岁'],
                <String>['湖北', '四川', '重庆']
              ],
              title: <String>['性别', '年龄', '地区'],
            ),
          ]);
}

class ToastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const List<ToastType> toastList = ToastType.values;
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Toast Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: toastList
            .map((ToastType e) => customElasticButton(e.toString(),
                onTap: () => showToast(e.toString(), toastType: e)))
            .toList());
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
                maxLength: 6,
                autoFocus: false,
                decoration: const BoxDecoration(color: Colors.black26),
                hasFocusPinDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue)),
                pinDecoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                pinTextStyle: const TextStyle(color: Colors.white)),
          ]);
}
