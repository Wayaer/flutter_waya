import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return GlobalMaterial(title: 'Waya Demo', home: Home());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      appBar: AppBar(title: Text('Waya Demo'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PinBox(
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
            margin: EdgeInsets.all(10),
            child: ElasticButton(
              useCache: false,
              elasticButtonType: ElasticButtonType.onlyScale,
              onTap: () {
                showOverlayToast();
              },
              child: Container(
                color: Colors.green,
                padding: EdgeInsets.all(10),
                child: Text('按钮'),
              ),
            ),
          ),
          FlatButton(onPressed: () => showModalPopup(), child: Text('点击弹窗')),
          FlatButton(onPressed: () => showOverlayToast(), child: Text('点击Toast')),
          FlatButton(onPressed: () => selectCity(), child: Text('城市选择器')),
        ],
      ),
    );
  }

  selectCity() => showAreaPicker();

  showOverlayLoading() => showLoading(gaussian: true);

  showOverlayToast() {
    showToast("0");
  }

  showModalPopup() {
    showBottomPagePopup(
        widget: CupertinoActionSheet(
      title: Text('提示'),
      message: Text('是否要删除当前项？'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('删除'),
          onPressed: () {},
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text('暂时不删'),
          onPressed: () {},
          isDestructiveAction: true,
        ),
      ],
    ));
  }
}
