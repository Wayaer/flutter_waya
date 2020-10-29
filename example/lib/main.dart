import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/module/DropdownMenuPage.dart';
import 'package:waya/module/GifImagePage.dart';
import 'package:waya/module/PinBoxPage.dart';
import 'package:waya/module/ToastPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // DioTools.getInstance();
  runApp(GlobalMaterial(title: 'Waya Demo', home: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      body: Universal(
        isScroll: true,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: ElasticButton(
              useCache: false,
              elasticButtonType: ElasticButtonType.onlyScale,
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(10),
                child: const Text('ElasticButton'),
              ),
            ),
          ),
          FlatButton(
              onPressed: () => push(widget: ToastPage()),
              child: const Text('Toast')),
          FlatButton(
              onPressed: () => push(widget: PinBoxPage()),
              child: const Text('PinBox')),
          FlatButton(
              onPressed: () => push(widget: GifImagePage()),
              child: const Text('GifImage')),
          FlatButton(
              onPressed: () => push(widget: DropdownMenuPage()),
              child: const Text('DropdownMenu')),
          FlatButton(
              onPressed: () => selectCity(),
              child: const Text('showAreaPicker')),
          FlatButton(
              onPressed: () => selectTime(),
              child: const Text('showDateTimePicker')),
          FlatButton(
              onPressed: () => push(widget: ContentPage()),
              child: const Text('showDialogSureCancel')),
          FlatButton(
              onPressed: () => showBottom(),
              child: const Text('showBottomPopup')),
          FlatButton(
              onPressed: () => showBottomPage(),
              child: const Text('showBottomPagePopup')),
        ],
      ),
    );
  }

  void selectTime() => showDateTimePicker<dynamic>();

  void selectCity() => showAreaPicker<dynamic>();

  void showOverlayLoading() => showLoading(gaussian: true);

  void showBottomPage() {
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

  void showBottom() {
    showBottomPopup<dynamic>(
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

class ContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        appBar: AppBar(title: const Text('Content'), centerTitle: true),
        body: Center(
          child: FlatButton(
              onPressed: () => showDialogSureCancel(),
              child: const Text('showDialogSureCancel')),
        ));
  }

  void showDialogSureCancel() {
    dialogSureCancel<dynamic>(isOverlay: true, children: [
      const Text('内容'),
    ]);
  }
}
