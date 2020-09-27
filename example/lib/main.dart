import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // DioTools.getInstance();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GlobalMaterial(title: 'Waya Demo', home: Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  GifController controller;

  String uri = 'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3681478079,2138136230&fm=26&gp=0.jpg';

  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);
    Tools.addPostFrameCallback((Duration duration) {
      controller.repeat(min: 0, max: 74, period: const Duration(milliseconds: 1000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      body: Universal(
        isScroll: true,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const DropdownMenu(
            value: <List<String>>[
              <String>['男', '女'],
              <String>['12岁', '13岁', '14岁'],
              <String>['湖北', '四川', '重庆']
            ],
            title: <String>['性别', '年龄', '地区'],
          ),
          const Divider(height: 20),
          const PinBox(
            maxLength: 6,
            pinBoxWidth: 30,
            pinBoxOuterPadding: EdgeInsets.zero,
            pinBoxBorderWidth: 0.5,
            pinBoxColor: Colors.amber,
            pinBoxHeight: 30,
            pinTextStyle: TextStyle(fontSize: 10),
            highlight: true,
          ),
          // GifImage.cache
          GifImage(image: NetworkImage(uri), controller: controller),
          // Image.network(uri),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElasticButton(
              useCache: false,
              elasticButtonType: ElasticButtonType.onlyScale,
              onTap: () {
                showOverlayToast();
              },
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(10),
                child: const Text('按钮'),
              ),
            ),
          ),
          FlatButton(onPressed: () => showModalPopup(), child: const Text('点击弹窗')),
          FlatButton(onPressed: () => showOverlayToast(), child: const Text('点击Toast')),
          FlatButton(onPressed: () => selectCity(), child: const Text('城市选择器')),
          FlatButton(onPressed: () => selectTime(), child: const Text('时间选择器')),
        ],
      ),
    );
  }

  void selectTime() => showDateTimePicker<dynamic>();

  void selectCity() => showAreaPicker<dynamic>();

  void showOverlayLoading() => showLoading(gaussian: true);

  void showOverlayToast() {
    showToast('0');
  }

  void showModalPopup() {
    showBottomPagePopup<dynamic>(
        widget: CupertinoActionSheet(
      title: const Text('提示'),
      message: const Text('是否要删除当前项？'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text('删除'),
          onPressed: () {},
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: const Text('暂时不删'),
          onPressed: () {},
          isDestructiveAction: true,
        ),
      ],
    ));
  }
}
