import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_waya/flutter_waya.dart';

// import 'package:flutter_waya/flutter_waya.dart' hide showToast;
// import 'package:oktoast/oktoast.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return GlobalMaterial(
      title: 'Waya Demo',
      home: Home(),
    );
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

  showOverlayToast(BuildContext context) => showToast("message");

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
