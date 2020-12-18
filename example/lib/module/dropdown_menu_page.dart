import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DropdownMenuPage extends StatefulWidget {
  @override
  _DropdownMenuPageState createState() => _DropdownMenuPageState();
}

class _DropdownMenuPageState extends State<DropdownMenuPage> {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('DropdownMenu Demo'), centerTitle: true),
      body: const Universal(children: <Widget>[
        DropdownMenu(
          value: <List<String>>[
            <String>['男', '女'],
            <String>['12岁', '13岁', '14岁'],
            <String>['湖北', '四川', '重庆']
          ],
          title: <String>['性别', '年龄', '地区'],
        ),
      ]),
    );
  }
}
