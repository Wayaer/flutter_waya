import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          appBar: AppBarText('Picker Demo'),
          children: <Widget>[
            ElevatedText('showAreaPicker', onTap: () => selectCity()),
            ElevatedText('showChoicePicker', onTap: () => showChoicePicker()),
            ElevatedText('showDateTimePicker', onTap: () => selectTime()),
          ]);

  Future<void> selectTime() async {
    final String? text = await showDateTimePicker<String>(
        startDate: DateTime(2020, 8, 20, 10, 10, 10),
        defaultDate: DateTime(2021, 9, 21, 10, 10, 10),
        endDate: DateTime(2022, 10, 20, 10, 10, 10));
    if (text != null) showToast(text);
  }

  Future<void> selectCity() async {
    final String? data = await showAreaPicker<String>();
    if (data != null) showToast(data.toString());
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
    final int? index = await showMultipleChoicePicker<int>(
        itemBuilder: (_, int index) =>
            Container(alignment: Alignment.center, child: Text(list[index])),
        wheel: PickerWheel(itemHeight: 24, useMagnifier: false),
        itemCount: list.length);
    if (index == null) return;
    showToast(list[index].toString());
  }
}
