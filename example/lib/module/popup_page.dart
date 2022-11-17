import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

TapDownDetails? _details;

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTapDown: (TapDownDetails details) {
        _details = details;
      },
      child: ExtendedScaffold(
          padding: const EdgeInsets.all(20),
          appBar: AppBarText('Popup'),
          isScroll: true,
          children: [
            ElevatedText('show BottomPopup', onTap: () {
              const _AlertDemo().showBottomPopup<dynamic>(
                  options: const BottomSheetOptions(
                      backgroundColor: Colors.transparent));
            }),
            ElevatedText('show BottomPopup - Full screen', onTap: () {
              Container(color: Colors.red.withOpacity(0.3))
                  .showBottomPopup<dynamic>();
            }),
            ElevatedText('show CupertinoBottomPopup', onTap: () {
              const _AlertDemo().showCupertinoBottomPopup<dynamic>();
            }),
            ElevatedText('show DialogPopup', onTap: () {
              const Center(child: _AlertDemo()).showDialogPopup<dynamic>();
            }),
            ElevatedText('show MenuPopup', onTap: () async {
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
            ElevatedText('show DoubleChooseWindows',
                onTap: () => doubleChooseWindows(context)),
          ]));

  void doubleChooseWindows(BuildContext context) {
    DoubleChooseWindows(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                child: Text('内容', style: context.textTheme.bodyText1)))
        .showBottomPopup(
            options:
                const BottomSheetOptions(backgroundColor: Colors.transparent));
  }
}

class _AlertDemo extends StatelessWidget {
  const _AlertDemo();

  @override
  Widget build(BuildContext context) {
    return const CupertinoActionSheet(
        title: Text('提示'),
        message: Text('是否要删除当前项？'),
        actions: <Widget>[
          CupertinoActionSheetAction(
              onPressed: closePopup, isDefaultAction: true, child: Text('删除')),
          CupertinoActionSheetAction(
              onPressed: closePopup,
              isDestructiveAction: true,
              child: Text('暂时不删')),
        ]);
  }
}
