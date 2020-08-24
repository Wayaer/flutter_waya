import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() => runApp(App());
GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return OverlayMaterial(
      title: 'Waya Demo',
      navigatorKey: _navigatorKey,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      appBarHeight: MediaQueryTools.getStatusBarHeight(),
      appBar: AppBar(title: Text('Waya Demo'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(onPressed: () => showModalPopup(), child: Text('点击弹窗')),
          FlatButton(onPressed: () => showModalToast(), child: Text('点击Toast')),
        ],
      ),
    );
  }

  showModalToast() {
    showDialog(
        context: _navigatorKey.currentContext,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenFit.getWidth(0) / 5, vertical: ScreenFit.getHeight(0) / 4),
            decoration: BoxDecoration(color: getColors(black90), borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(ScreenFit.getWidth(10)),
            child: Text("Toast"),
          );
        });
  }

  showModalPopup() {
    showCupertinoModalPopup(
        context: _navigatorKey.currentContext,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
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
          );
        });
  }
}
