import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GlobalMaterial(title: 'Waya Demo', home: Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
        ],
      ),
    );
  }

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
