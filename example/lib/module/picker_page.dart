import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          appBar: AppBarText('Picker'),
          padding: const EdgeInsets.all(20),
          isScroll: true,
          children: [
            ElevatedText('show CustomPicker', onTap: customPicker),
            ElevatedText('show AreaPicker', onTap: selectCity),
            ElevatedText('show DateTimePicker', onTap: selectTime),
            ElevatedText('show SingleColumnPicker', onTap: singleColumnPicker),
            const Partition('MultiColumnPicker'),
            ElevatedText('show MultiColumnPicker', onTap: multiColumnPicker),
            ElevatedText('show MultiColumnLinkagePicker',
                onTap: multiColumnLinkagePicker),
            const Partition('SingleListPicker'),
            ElevatedText('show SingleListPicker', onTap: singleListPicker),
            ElevatedText('show SingleListPicker with screen',
                onTap: singleListPickerWithScreen),
            ElevatedText('show SingleListPicker custom',
                onTap: customSingleListPicker),
          ]);

  Future<void> selectTime() async {
    final DateTime? dateTime = await DateTimePicker(
            dual: true,
            options: PickerOptions<DateTime>(confirmTap: (DateTime? dateTime) {
              showToast(dateTime!.format(DateTimeDist.yearSecond));
              return true;
            }, cancelTap: (DateTime? dateTime) {
              showToast(dateTime?.format(DateTimeDist.yearSecond) ?? 'cancel');
              return true;
            }),
            startDate: DateTime(2020, 8, 9, 9, 9, 9),
            defaultDate: DateTime(2021, 9, 21, 8, 8, 8),
            endDate: DateTime(2022, 10, 20, 10, 10, 10))
        .show();
    showToast(dateTime?.format(DateTimeDist.yearSecond) ?? 'null');
  }

  Future<void> customPicker() async {
    final String? data = await CustomPicker<String?>(
            options: PickerOptions<String?>(
                confirmTap: (String? value) {
                  return true;
                },
                cancelTap: (String? value) {
                  return true;
                },
                title: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(6)),
                    child: const BText('Title')),
                backgroundColor: Colors.red),
            content: Container(
                height: 300,
                alignment: Alignment.center,
                color: Colors.blue.withOpacity(0.2),
                child: const BText('showCustomPicker', color: Colors.black)),
            cancelTap: () {
              return 'Cancel';
            })
        .show(
            options:
                BottomSheetOptions(barrierColor: Colors.red.withOpacity(0.3)));
    showToast(data.toString());
  }

  Future<void> selectCity() async {
    final String? data =
        await AreaPicker(defaultProvince: '四川省', defaultCity: '绵阳市')
            .popupBottomSheet<String>();
    showToast(data.toString());
  }

  Future<void> multiColumnPicker() async {
    List<String> listString = ['A', 'B', 'C', 'D', 'E', 'F'];
    final List<PickerEntry> list = <PickerEntry>[
      PickerEntry(
          itemCount: listString.length,
          itemBuilder: (_, int index) => Text(listString[index])),
      PickerEntry(
          itemCount: listString.length,
          itemBuilder: (_, int index) =>
              Text('${listString[index]}${listString[index]}')),
      PickerEntry(
          itemCount: listString.length,
          itemBuilder: (_, int index) =>
              Text('${listString[index]}${listString[index]}')),
      PickerEntry(
          itemCount: listString.length,
          itemBuilder: (_, int index) =>
              Text('${listString[index]}${listString[index]}')),
      PickerEntry(
          itemCount: listString.length,
          itemBuilder: (_, int index) =>
              Text('${listString[index]}${listString[index]}')),
      PickerEntry(
          itemCount: listString.length,
          itemBuilder: (_, int index) =>
              Text('${listString[index]}${listString[index]}')),
    ];
    final List<int>? index =
        await MultiColumnPicker(entry: list, horizontalScroll: true).show();
    if (index != null) {
      String result =
          '${listString[index.first]}-${listString[index.last]}${listString[index.last]}';
      if (result.isNotEmpty) showToast(result);
    }
  }

  Future<void> customSingleListPicker() async {
    final list = 40.generate((index) => index.toString());
    final value = await SingleListPicker(
        itemCount: list.length,
        listBuilder: (int itemCount, IndexedWidgetBuilder itemBuilder) {
          return ScrollList.waterfall(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemBuilder: itemBuilder,
              itemCount: itemCount);
        },
        itemBuilder: (context, index, isSelect, changedFun) {
          return Universal(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isSelect ? Colors.blue : null),
              direction: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              child: BText('第 $index 项'));
        }).show();
    showToast(value.toString());
  }

  Future<void> singleListPicker() async {
    final list = 40.generate((index) => index.toString());
    final value = await SingleListPicker(
        itemCount: list.length,
        singleListPickerOptions: const SingleListPickerOptions(
            isCustomGestureTap: true, allowedMultipleChoice: false),
        itemBuilder: (context, index, isSelect, changedFun) {
          return Universal(
              direction: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BText('第 $index 项'),
                Checkbox(
                    value: isSelect,
                    onChanged: (value) {
                      changedFun.call(index);
                    })
              ]);
        }).show();
    showToast(value.toString());
  }

  Future<void> singleListPickerWithScreen() async {
    final list = 40.generate((index) => index.toString());
    final type = ['筛选1', '筛选2', '筛选3'];
    SelectIndexedChangedFunction? change;
    List<String> screen = [];
    final value = await SingleListPicker(
        itemCount: list.length,
        options: PickerOptions(
            bottom: Universal(
          child: DropdownMenu(
              onTap: (int title, int? value) {
                showToast(
                    '${type[title]}  ${value == null ? '' : list[value]}');
                if (value != null) {
                  screen = [list[value]];
                  change?.call();
                } else {
                  screen.clear();
                }
              },
              title: type,
              value: [list, list, list]),
        )),
        singleListPickerOptions: const SingleListPickerOptions(
            isCustomGestureTap: true, allowedMultipleChoice: false),
        itemBuilder: (context, index, isSelect, changedFun) {
          change = changedFun;
          final entry = Universal(
              direction: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BText('第 $index 项'),
                Checkbox(
                    value: isSelect,
                    onChanged: (value) {
                      changedFun(index);
                    })
              ]);
          if (screen.isNotEmpty) {
            if (list[index] == screen.first) {
              return entry;
            }
            return const SizedBox();
          }
          return entry;
        }).show();
    showToast(value.toString());
  }

  Future<void> multiColumnLinkagePicker() async {
    final List<PickerLinkageEntry> entry = <PickerLinkageEntry>[
      const PickerLinkageEntry(text: Text('A1'), children: [
        PickerLinkageEntry(text: Text('A2')),
      ]),
      const PickerLinkageEntry(text: Text('B1'), children: [
        PickerLinkageEntry(text: Text('B2'), children: [
          PickerLinkageEntry(text: Text('B3')),
          PickerLinkageEntry(text: Text('B3')),
          PickerLinkageEntry(text: Text('B3')),
        ]),
        PickerLinkageEntry(text: Text('B2')),
      ]),
      const PickerLinkageEntry(text: Text('C1'), children: [
        PickerLinkageEntry(text: Text('C2'), children: [
          PickerLinkageEntry(text: Text('C3'), children: [
            PickerLinkageEntry(text: Text('C4'), children: [
              PickerLinkageEntry(text: Text('C5'), children: [
                PickerLinkageEntry(text: Text('C6'), children: [
                  PickerLinkageEntry(text: Text('C7'), children: [
                    PickerLinkageEntry(text: Text('C8')),
                    PickerLinkageEntry(text: Text('C8')),
                    PickerLinkageEntry(text: Text('C8')),
                  ]),
                  PickerLinkageEntry(text: Text('C7')),
                  PickerLinkageEntry(text: Text('C7')),
                ]),
                PickerLinkageEntry(text: Text('C6')),
                PickerLinkageEntry(text: Text('C6')),
              ]),
              PickerLinkageEntry(text: Text('C5')),
              PickerLinkageEntry(text: Text('C5')),
            ]),
            PickerLinkageEntry(text: Text('C4')),
            PickerLinkageEntry(text: Text('C4')),
          ]),
          PickerLinkageEntry(text: Text('C3')),
          PickerLinkageEntry(text: Text('C3')),
        ]),
        PickerLinkageEntry(text: Text('C2')),
        PickerLinkageEntry(text: Text('C2')),
      ]),
      const PickerLinkageEntry(text: Text('D1'), children: [])
    ];
    final List<int>? index =
        await MultiColumnLinkagePicker(entry: entry, horizontalScroll: false)
            .show();
    List<PickerLinkageEntry> resultList = entry;
    String result = '';
    index?.builder((item) {
      result += (resultList[item].text as Text).data!;
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result);
  }

  Future<void> singleColumnPicker() async {
    final list = <String>['一', '二', '三', '四', '五', '六', '七', '八', '十'];
    final int? index = await SingleColumnPicker(
            itemBuilder: (BuildContext context, int index) => Container(
                alignment: Alignment.center,
                child: Text(list[index], style: context.textTheme.bodyText1)),
            itemCount: list.length)
        .show();
    showToast(index == null ? 'null' : list[index].toString());
  }
}
