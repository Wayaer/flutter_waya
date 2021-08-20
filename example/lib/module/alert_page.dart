import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class AlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          appBar: AppBarText('Alert Demo'),
          children: <Widget>[
            ElevatedText('showAreaPicker', onTap: () => selectCity()),
            ElevatedText('showChoicePicker', onTap: () => showChoicePicker()),
            ElevatedText('showDateTimePicker', onTap: () => selectTime()),
            ElevatedText('showBottomPopup', onTap: () => showBottom()),
            ElevatedText('showDialogSureCancel', onTap: sureCancel),
            ElevatedText('showBottomPagePopup', onTap: () => showBottomPage()),
            ElevatedText('showSnackBar', onTap: () {
              showSnackBar(SnackBar(content: BText('Popup SnackBar')));
            }),
            ElevatedText('showOverlayLoading', onTap: () {
              showOverlayLoading();
            }),
          ]);

  void showOverlayLoading() => showLoading(
      gaussian: true,
      onTap: closeOverlay,
      custom: const SpinKitWave(color: color));

  void showBottomPage() {
    showBottomPagePopup<dynamic>(
        widget: const CupertinoActionSheet(
            title: Text('提示'),
            message: Text('是否要删除当前项？'),
            actions: <Widget>[
          CupertinoActionSheetAction(
              child: Text('删除'), onPressed: closePopup, isDefaultAction: true),
          CupertinoActionSheetAction(
              child: Text('暂时不删'),
              onPressed: closePopup,
              isDestructiveAction: true),
        ]));
  }

  void showBottom() {
    showBottomPopup<dynamic>(
        widget: const CupertinoActionSheet(
            title: Text('提示'),
            message: Text('是否要删除当前项？'),
            actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('删除'),
            onPressed: closePopup,
            isDefaultAction: true,
          ),
          CupertinoActionSheetAction(
              child: Text('暂时不删'),
              onPressed: closePopup,
              isDestructiveAction: true),
        ]));
  }

  void sureCancel() {
    const bool isOverlay = true;
    showDialogSureCancel<dynamic>(
        isOverlay: isOverlay,
        sure: SimpleButton(
          alignment: Alignment.center,
          child: Text('确定', style: _textStyle()),
          onTap: () {
            if (isOverlay) {
              closeOverlay();
            }
            // else {
            //   closePopup();
            // }

            ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
            showToast('确定');
          },
        ),
        cancel: SimpleButton(
          alignment: Alignment.center,
          child: Text('取消', style: _textStyle()),
          onTap: () {
            if (isOverlay) {
              closeOverlay();
            }
            // else {
            //   closePopup();
            // }

            ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
            showToast('取消');
          },
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            '内容',
            style: _textStyle(),
          ),
        ));
  }

  TextStyle _textStyle() => const TextStyle(
        color: Colors.blueAccent,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );

  Future<void> selectTime() async {
    final String? text = await showDateTimePicker<String>(
        dual: false,
        startDate: DateTime(2020, 8, 9, 9, 9, 9),
        defaultDate: DateTime(2021, 9, 21, 8, 8, 8),
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
