import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ToastPage extends StatefulWidget {
  @override
  _ToastPageState createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  List<ToastType> toastList;

  @override
  void initState() {
    super.initState();
    toastList = ToastType.values;
    log(toastList);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Toast Demo'), centerTitle: true),
      body: Universal(
          mainAxisAlignment: MainAxisAlignment.center,
          children: toastList
              .map(
                (ToastType e) => FlatButton(
                    onPressed: () => showToast(e.toString(), toastType: e),
                    child: Text(e.toString())),
              )
              .toList()),
    );
  }
}
