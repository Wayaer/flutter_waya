import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Picker Demo'), centerTitle: true),
      body: Universal(children: <Widget>[
        customElasticButton('showAreaPicker', onTap: () => selectCity()),
        customElasticButton('showChoicePicker',
            onTap: () => showChoicePicker()),
        customElasticButton('showDateTimePicker', onTap: () => selectTime()),
      ]),
    );
  }

  Future<void> selectTime() async {
    final String data = await showDateTimePicker<String>();
    showToast(data.toString());
  }

  Future<void> selectCity() async {
    final String data = await showAreaPicker<String>();
    showToast(data.toString());
  }

  Future<void> showChoicePicker() async {
    final List<String> list = <String>[
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '十'
    ];
    final int index = await showMultipleChoicePicker<int>(
        itemBuilder: (_, int index) => Text(list[index]),
        itemCount: list.length);
    if (index == null) return;
    showToast(list[index].toString());
  }
}
