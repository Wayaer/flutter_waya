import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:app/main.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) =>
      ExtendedScaffold(appBar: AppBarText('GifImage Demo'), children: <Widget>[
        GifImage(image: NetworkImage(uri), controller: controller),
      ]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ExtendedFutureBuilderPage extends StatelessWidget {
  const ExtendedFutureBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool? showError = true;
    return ExtendedScaffold(
        padding: const EdgeInsets.all(20),
        appBar: AppBarText('ExtendedFutureBuilder '),
        children: <Widget>[
          ExtendedFutureBuilder<String>(
            initialData: '初始的数据 点击刷新',
            future: () async {
              await 2.seconds.delayed();
              if (showError == null) {
                showError = true;
                return 'null 点击刷新 错误';
              } else if (showError!) {
                showError = false;
                return Future.error('错误 点击刷新正常');
              } else {
                showError = null;
                return '正常 点击刷新为 null';
              }
            },
            onDone: (_, data, reset) {
              return ElevatedText(data, onTap: reset);
            },
            onError: (_, error, reset) {
              return ElevatedText(error.toString(), onTap: reset);
            },
            onNone: (_, reset) {
              return ElevatedText('没有数据点击刷新', onTap: reset);
            },
            onWaiting: (_) {
              return const CircularProgressIndicator();
            },
          ),
        ]);
  }
}
