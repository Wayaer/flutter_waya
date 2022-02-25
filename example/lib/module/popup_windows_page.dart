import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

TapDownDetails? _details;

class PopupWindowsPage extends StatelessWidget {
  const PopupWindowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (TapDownDetails details) {
          _details = details;
        },
        child: ExtendedScaffold(
            appBar: AppBarText('PopupWindows Demo'),
            isScroll: true,
            children: <Widget>[
              const Partition('Picker'),
              ElevatedText('showCustomPicker', onTap: _showCustomPicker),
              ElevatedText('showAreaPicker', onTap: selectCity),
              ElevatedText('showMultipleChoicePicker', onTap: showChoicePicker),
              ElevatedText('showMultiColumnChoicePicker',
                  onTap: showMultiColumnChoicePicker),
              ElevatedText('showDateTimePicker', onTap: selectTime),
              const Partition('Popup'),
              ElevatedText('showBottomPopup', onTap: () {
                showBottomPopup<dynamic>(
                    widget: const _AlertDemo(),
                    options: const BottomSheetOptions(
                        backgroundColor: Colors.transparent));
              }),
              ElevatedText('showBottomPopup - Full screen', onTap: () {
                showBottomPopup<dynamic>(
                    widget: Container(color: Colors.red.withOpacity(0.3)));
              }),
              ElevatedText('showCupertinoBottomPopup', onTap: () {
                showCupertinoBottomPopup<dynamic>(widget: const _AlertDemo());
              }),
              ElevatedText('showDialogPopup', onTap: () {
                showDialogPopup<dynamic>(
                    widget: const Center(child: _AlertDemo()));
              }),
              ElevatedText('showMenuPopup', onTap: () async {
                final String? data = await showMenuPopup<String>(
                    position: RelativeRect.fromLTRB(
                        _details?.globalPosition.dx ?? 10,
                        _details?.globalPosition.dy ?? 10,
                        deviceWidth - (_details?.globalPosition.dx ?? 10),
                        deviceHeight - (_details?.globalPosition.dy ?? 10)),
                    items: const <PopupMenuEntry<String>>[
                      CheckedPopupMenuItem<String>(
                          value: '111', child: Text('111')),
                      PopupMenuDivider(),
                      CheckedPopupMenuItem<String>(
                          value: '222', child: Text('222')),
                    ]);
                showToast(data.toString());
              }),
              const Partition('Other'),
              ElevatedText('showDoubleChooseWindows',
                  onTap: () => showDoubleChoose(context)),
              ElevatedText('showSnackBar', onTap: () {
                showSnackBar(const SnackBar(content: BText('Popup SnackBar')));
              }),
              ElevatedText('showOverlayLoading', onTap: () {
                showOverlayLoading();
              }),
            ]),
      );

  void showOverlayLoading() => showLoading(
        options: const ModalWindowsOptions(gaussian: true, onTap: closeOverlay),
        custom: const SpinKitThreeBounce(color: Colors.red),
      );

  void showDoubleChoose(BuildContext context) {
    const bool isOverlay = false;
    showDoubleChooseWindows<dynamic>(
        isOverlay: isOverlay,
        right: SimpleButton(
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            child: Text('确定', style: context.textTheme.subtitle1),
            onTap: () {
              ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
              showToast('确定');
            }),
        left: SimpleButton(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('取消', style: context.textTheme.subtitle1),
            onTap: () {
              ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
              showToast('取消');
            }),
        content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text('内容', style: context.textTheme.bodyText1)));
  }

  Future<void> selectTime() async {
    final DateTime? dateTime = await showDateTimePicker<DateTime?>(
        dual: true,
        options: PickerOptions<DateTime>(sureTap: (DateTime? dateTime) {
          showToast(dateTime!.format(DateTimeDist.yearSecond));
          return true;
        }, cancelTap: (DateTime? dateTime) {
          showToast(dateTime?.format(DateTimeDist.yearSecond) ?? 'cancel');
          return true;
        }),
        unit: const DateTimePickerUnit(second: null),
        startDate: DateTime(2020, 8, 9, 9, 9, 9),
        defaultDate: DateTime(2021, 9, 21, 8, 8, 8),
        endDate: DateTime(2022, 10, 20, 10, 10, 10));
    showToast(dateTime?.format(DateTimeDist.yearSecond) ?? 'null');
  }

  Future<void> _showCustomPicker() async {
    final String? data = await showCustomPicker<String?>(
      bottomSheetOptions:
          BottomSheetOptions(barrierColor: Colors.red.withOpacity(0.3)),
      options: PickerOptions<String?>(
          sureTap: (String? value) {
            return true;
          },
          cancelTap: (String? value) {
            return true;
          },
          title: Container(
              child: const BText('Title'),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(6))),
          backgroundColor: Colors.red),
      content: Container(
          height: 300,
          alignment: Alignment.center,
          color: Colors.blue.withOpacity(0.2),
          child: const BText('showCustomPicker', color: Colors.black)),
      cancelTap: () {
        return 'Cancel';
      },
      // sureTap: () {
      //   return 'CustomPicker';
      // },
    );
    showToast(data.toString());
  }

  Future<void> selectCity() async {
    final String? data = await showAreaPicker<String>();
    showToast(data.toString());
  }

  Future<void> showMultiColumnChoicePicker() async {
    final List<PickerEntry> list = <PickerEntry>[
      const PickerEntry(text: Text('A1'), children: [
        PickerEntry(text: Text('A2')),
      ]),
      const PickerEntry(text: Text('B1'), children: [
        PickerEntry(text: Text('B2'), children: [
          PickerEntry(text: Text('B3')),
          PickerEntry(text: Text('B3')),
          PickerEntry(text: Text('B3')),
        ]),
        PickerEntry(text: Text('B2')),
      ]),
      const PickerEntry(text: Text('C1'), children: [
        PickerEntry(text: Text('C2'), children: [
          PickerEntry(text: Text('C3'), children: [
            PickerEntry(text: Text('C4'), children: [
              PickerEntry(text: Text('C5'), children: [
                PickerEntry(text: Text('C6'), children: [
                  PickerEntry(text: Text('C7'), children: [
                    PickerEntry(text: Text('C8')),
                    PickerEntry(text: Text('C8')),
                    PickerEntry(text: Text('C8')),
                  ]),
                  PickerEntry(text: Text('C7')),
                  PickerEntry(text: Text('C7')),
                ]),
                PickerEntry(text: Text('C6')),
                PickerEntry(text: Text('C6')),
              ]),
              PickerEntry(text: Text('C5')),
              PickerEntry(text: Text('C5')),
            ]),
            PickerEntry(text: Text('C4')),
            PickerEntry(text: Text('C4')),
          ]),
          PickerEntry(text: Text('C3')),
          PickerEntry(text: Text('C3')),
        ]),
        PickerEntry(text: Text('C2')),
        PickerEntry(text: Text('C2')),
      ]),
      const PickerEntry(text: Text('D1'), children: [
        PickerEntry(text: Text('D2'), children: [
          PickerEntry(text: Text('D3')),
          PickerEntry(text: Text('D3')),
          PickerEntry(text: Text('D3')),
        ]),
        PickerEntry(text: Text('D2')),
        PickerEntry(text: Text('D2')),
        PickerEntry(text: Text('D2')),
      ])
    ];
    final List<int>? index = await showBottomPopup(
        widget: MultiColumnChoicePicker(entry: list, horizontalScroll: true));
    List<PickerEntry> resultList = list;
    String result = '';
    index?.builder((item) {
      result += (resultList[item].text as Text).data!;
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result);
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
        itemBuilder: (BuildContext context, int index) => Container(
            alignment: Alignment.center,
            child: Text(list[index], style: context.textTheme.bodyText1)),
        itemCount: list.length);
    showToast(index == null ? 'null' : list[index].toString());
  }
}

class _AlertDemo extends StatelessWidget {
  const _AlertDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoActionSheet(
        title: Text('提示'),
        message: Text('是否要删除当前项？'),
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: Text('删除'), onPressed: closePopup, isDefaultAction: true),
          CupertinoActionSheetAction(
              child: Text('暂时不删'),
              onPressed: closePopup,
              isDestructiveAction: true),
        ]);
  }
}
