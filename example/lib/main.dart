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
          SearchBox(width: 200),
          FlatButton(onPressed: () => showModalPopup(), child: Text('点击弹窗')),
          FlatButton(onPressed: () => showOverlayLoading(), child: Text('点击Loading')),
          FlatButton(onPressed: () => showOverlayToast(context), child: Text('点击Toast')),
        ],
      ),
    );
  }

  showOverlayLoading() => showLoading(gaussian: true);

  showOverlayToast(BuildContext context) {
    showToast("0");
    showToast("1");
    showToast("2");
    showToast("3");
    showToast("4");
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
