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
        children: toastList.builder(
            (ToastType e) => customElasticButton(e.toString(), onTap: () async {
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
                maxLength: 6,
                autoFocus: false,
                decoration: const BoxDecoration(color: Colors.black26),
                hasFocusPinDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue)),
                pinDecoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                pinTextStyle: const TextStyle(color: Colors.black)),
          ]);
}

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Button Demo'), centerTitle: true),
          children: <Widget>[
            customElasticButton('ElasticButton',
                onTap: () => showToast('ElasticButton')),
            const SizedBox(height: 20),
            const ClothButton.rectangle(
                size: Size(200, 60), backgroundColor: Colors.blue),
            const SizedBox(height: 20),
            const ClothButton.round(
                size: Size(200, 60), backgroundColor: Colors.blue),
            const SizedBox(height: 40),
            const LiquidButton(
                width: 200, height: 60, backgroundColor: Colors.blue),
          ]);
}
