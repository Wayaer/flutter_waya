import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with TickerProviderStateMixin {
  late GifController controller;

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
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          appBar: AppBarText('GifImage Demo'),
          children: <Widget>[
            GifImage(image: NetworkImage(uri), controller: controller),
          ]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class InputFieldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        backgroundColor: Colors.white,
        appBar: AppBarText('TextField Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
                  hintText: '11111',
                  icon: const Icon(Icons.call),
                  filled: true,
                  fillColor: Colors.grey,
                  contentPadding: const EdgeInsets.all(6),
                  prefixIcon: Container(
                    color: Colors.red.withOpacity(0.2),
                    width: 20,
                  ),
                  suffixIcon:
                      Container(color: Colors.red.withOpacity(0.2), width: 20),
                  prefix: Container(
                    color: Colors.green,
                    width: 20,
                    height: 20,
                  ),
                  isDense: true,
                  suffix: Container(
                    color: Colors.green,
                    width: 20,
                    height: 20,
                  ),
                  // labelText: '22222',
                  helperText: '33333',
                  errorText: '5555',
                  counterText: '',
                  border: const OutlineInputBorder()),
              textInputAction: TextInputAction.done),
          WidgetPendant(
            borderType: BorderType.underline,
            fillColor: Colors.amberAccent,
            borderColor: Colors.greenAccent,
            // borderRadius: BorderRadius.circular(30),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            extraPrefix: const Text('前缀'),
            extraSuffix: const Text('后缀'),
            prefix: const Text('前缀'),
            suffix: const Text('后缀'),
            header: Row(children: const <Widget>[Text('头部')]),
            footer: Row(children: const <Widget>[Text('底部')]),
            child: CupertinoTextField.borderless(
                prefixMode: OverlayVisibilityMode.always,
                prefix: Container(color: Colors.green, width: 20, height: 20),
                suffixMode: OverlayVisibilityMode.editing,
                suffix: Container(
                  color: Colors.green,
                  width: 20,
                  height: 20,
                )),
          ),
        ]);
  }
}

class ToastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const List<ToastType> toastList = ToastType.values;
    return ExtendedScaffold(
        backgroundColor: Colors.white,
        appBar: AppBarText('Toast Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: toastList.builder(
            (ToastType e) => ElevatedText(e.toString(), onTap: () async {
                  await showToast(e.toString(), toastType: e);
                  log('开始弹第二个');
                  showToast('添加await第一个Toast完了之后弹出第二个Toast');
                })));
  }
}

class PinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          appBar: AppBarText('PinBox Demo'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinBox(
                maxLength: 4,
                autoFocus: false,
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
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          appBar: AppBarText('Counter Demo'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CounterAnimation(
                animationType: CountAnimationType.part,
                count: 100,
                onTap: (int c) {
                  showToast(c.toString());
                },
                countBuilder: (int count, String text) =>
                    BText(text, fontSize: 30)).color(Colors.black12),
            const SizedBox(height: 40),
            CounterAnimation(
                animationType: CountAnimationType.all,
                count: 100,
                onTap: (int c) {
                  showToast(c.toString());
                },
                countBuilder: (int count, String text) =>
                    BText(text, fontSize: 30)).color(Colors.black12),
          ]);
}

class ToggleRotatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          appBar: AppBarText('ToggleRotate Demo'),
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
    return ExtendedScaffold(
        backgroundColor: Colors.white,
        appBar: AppBarText('ExpansionTiles Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ExpansionTiles(
              title: BText('title', color: Colors.black),
              children: 5.generate((int index) => Universal(
                  margin: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  child: BText('item$index', color: Colors.black)))),
          ExpansionTiles(
              title: BText('title', color: Colors.black),
              children: 5.generate((int index) => Universal(
                  margin: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  child: BText('item$index', color: Colors.black)))),
        ]);
  }
}

class SimpleBuilderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const int i = 0;
    return ExtendedScaffold(
        backgroundColor: Colors.white,
        appBar: AppBarText('SimpleBuilder Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ValueBuilder<int>(
              initialValue: i,
              builder: (_, int? value, ValueCallback<int> updater) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconBox(
                          icon: Icons.remove_circle_outline,
                          onTap: () {
                            int v = value ?? 0;
                            v -= 1;
                            updater(v);
                          }),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value.toString())),
                      IconBox(
                          icon: Icons.add_circle_outline,
                          onTap: () {
                            int v = value ?? 0;
                            v += 1;
                            updater(v);
                          })
                    ]);
              }),
          const Center(child: SizedBox(height: 30)),
          ValueListenBuilder<int>(
              initialValue: 1,
              builder: (_, ValueNotifier<int?> valueListenable) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconBox(
                          icon: Icons.remove_circle_outline,
                          onTap: () {
                            int num = valueListenable.value ?? 0;
                            num -= 1;
                            valueListenable.value = num;
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(valueListenable.value.toString()),
                      ),
                      IconBox(
                          icon: Icons.add_circle_outline,
                          onTap: () {
                            int num = valueListenable.value ?? 0;
                            num += 1;
                            valueListenable.value = num;
                          })
                    ]);
              }),
        ]);
  }
}
