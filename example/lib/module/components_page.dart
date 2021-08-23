import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ComponentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          isScroll: true,
          appBar: AppBarText('Components Demo'),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          children: <Widget>[
            //// PinBox
            partition('PinBox'),
            const SizedBox(height: 20),
            PinBox(
                maxLength: 5,
                autoFocus: false,
                spaces: const <Widget?>[
                  Icon(Icons.ac_unit, size: 12),
                  Icon(Icons.ac_unit, size: 12),
                  Icon(Icons.ac_unit, size: 12),
                  Icon(Icons.ac_unit, size: 12),
                  Icon(Icons.ac_unit, size: 12),
                  Icon(Icons.ac_unit, size: 12),
                ],
                hasFocusPinDecoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.circular(4)),
                pinDecoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(4)),
                pinTextStyle: const TextStyle(color: Colors.white)),
            partition('WidgetPendant'),
            TextField(
                decoration: InputDecoration(
                    hintText: '11111',
                    icon: const Icon(Icons.call),
                    filled: true,
                    fillColor: Colors.grey,
                    contentPadding: const EdgeInsets.all(6),
                    prefixIcon: Container(
                        color: Colors.red.withOpacity(0.2), width: 20),
                    suffixIcon: Container(
                        color: Colors.red.withOpacity(0.2), width: 20),
                    prefix:
                        Container(color: Colors.green, width: 20, height: 20),
                    isDense: true,
                    suffix:
                        Container(color: Colors.green, width: 20, height: 20),
                    helperText: '33333',
                    errorText: '5555',
                    counterText: '',
                    border: const OutlineInputBorder()),
                textInputAction: TextInputAction.done),
            WidgetPendant(
                borderType: BorderType.underline,
                fillColor: Colors.amberAccent,
                borderColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                extraPrefix: const Text('前缀'),
                extraSuffix: const Text('后缀'),
                prefix: const Text('前缀'),
                suffix: const Text('后缀'),
                header: Row(children: const <Widget>[Text('头部')]),
                footer: Row(children: const <Widget>[Text('底部')]),
                child: CupertinoTextField.borderless(
                    prefixMode: OverlayVisibilityMode.always,
                    prefix:
                        Container(color: Colors.green, width: 20, height: 20),
                    suffixMode: OverlayVisibilityMode.editing,
                    suffix:
                        Container(color: Colors.green, width: 20, height: 20))),
            partition('ExpansionTiles'),
            ExpansionTiles(
                title: BText('title', color: Colors.black),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: BText('item$index', color: Colors.black)))),
            ExpansionTiles(
                title: BText('title', color: Colors.black),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: BText('item$index', color: Colors.black)))),
            partition('Toast'),
            Wrap(
                children: ToastType.values.builder((ToastType type) =>
                    ElevatedText(type.toString(), onTap: () async {
                      await showToast(type.toString(),
                          toastType: type, customIcon: Icons.ac_unit_sharp);
                      showToast('添加await第一个Toast完了之后弹出第二个Toast');
                    }))),

            partition('CounterAnimation'),

            /// CounterAnimation
            CounterAnimation(
                animationType: CountAnimationType.part,
                count: 100,
                onTap: (int c) {
                  showToast(c.toString());
                },
                countBuilder: (int count, String text) =>
                    BText(text, fontSize: 30)).color(Colors.black12),
            const SizedBox(height: 40),
            CounterAnimation(
                animationType: CountAnimationType.all,
                count: 100,
                onTap: (int c) {
                  showToast(c.toString());
                },
                countBuilder: (int count, String text) =>
                    BText(text, fontSize: 30)).color(Colors.black12),
            partition('ToggleRotate'),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ValueBuilder<bool>(
                      initialValue: false,
                      builder: (_, bool? value, ValueCallback<bool> updater) {
                        return ToggleRotate(
                            duration: const Duration(milliseconds: 800),
                            rad: pi / 2,
                            isRotate: value!,
                            onTap: () => updater(!value),
                            child: const Icon(Icons.chevron_left, size: 30));
                      }),
                  ValueBuilder<bool>(
                      initialValue: false,
                      builder: (_, bool? value, ValueCallback<bool> updater) {
                        return ToggleRotate(
                            duration: const Duration(milliseconds: 800),
                            rad: pi,
                            isRotate: value!,
                            onTap: () => updater(!value),
                            child: const Icon(Icons.chevron_left, size: 30));
                      }),
                  ValueBuilder<bool>(
                      initialValue: false,
                      builder: (_, bool? value, ValueCallback<bool> updater) {
                        return ToggleRotate(
                            duration: const Duration(milliseconds: 800),
                            rad: pi * 2,
                            isRotate: value!,
                            onTap: () => updater(!value),
                            child: const Icon(Icons.chevron_left, size: 30));
                      }),
                ]),
            partition('SendSMS'),
            SendSMS(
                duration: const Duration(seconds: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                onTap: (Function sending) async {
                  1.seconds.delayed(() {
                    sending(true);
                  });
                },
                stateBuilder: (SendState state, int i) {
                  switch (state) {
                    case SendState.none:
                      return BText('发送验证码');
                    case SendState.sending:
                      return BText('发送中');
                    case SendState.resend:
                      return BText('重新发送');
                    case SendState.countDown:
                      return BText('等待 $i s');
                  }
                }),

            partition('CountDown'),
            CountDown(
                onChanged: (int i) {},
                duration: const Duration(seconds: 100),
                builder: (int i) {
                  return SimpleButton(
                      text: i.toString(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4)));
                }),

            partition('DottedLine'),
            Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DottedLinePainter(
                        color: Colors.black, strokeWidth: 1, gap: 20)),
                decoration: BoxDecoration(border: DottedLineBorder.all())),
            partition('ValueBuilder'),
            ValueBuilder<int>(
                initialValue: 0,
                builder: (_, int? value, ValueCallback<int> updater) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconBox(
                            icon: Icons.remove_circle_outline,
                            onTap: () {
                              int v = value ?? 0;
                              v -= 1;
                              updater(v);
                            }),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value.toString())),
                        IconBox(
                            icon: Icons.add_circle_outline,
                            onTap: () {
                              int v = value ?? 0;
                              v += 1;
                              updater(v);
                            })
                      ]);
                }),
            partition('ValueListenBuilder'),
            ValueListenBuilder<int>(
                initialValue: 1,
                builder: (_, ValueNotifier<int?> valueListenable) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconBox(
                            icon: Icons.remove_circle_outline,
                            onTap: () {
                              int num = valueListenable.value ?? 0;
                              num -= 1;
                              valueListenable.value = num;
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(valueListenable.value.toString()),
                        ),
                        IconBox(
                            icon: Icons.add_circle_outline,
                            onTap: () {
                              int num = valueListenable.value ?? 0;
                              num += 1;
                              valueListenable.value = num;
                            })
                      ]);
                }),
            partition('CheckBox'),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CheckBox(
                      value: true,
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(6),
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                      useNull: true,
                      stateBuilder: (bool? value) {
                        if (value != null) {
                          return Icon(value
                              ? Icons.check_box
                              : Icons.check_box_outline_blank);
                        }
                        return const Icon(Icons.check_box_outlined);
                      }),
                  CheckBox(
                      value: false,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 20),
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                      stateBuilder: (bool? value) {
                        return Icon(value!
                            ? Icons.check_box
                            : Icons.check_box_outline_blank);
                      }),
                ]),

            const SizedBox(height: 100),
          ]);

  Widget partition(String title) {
    return Universal(
        width: double.infinity,
        color: Colors.grey.withOpacity(0.2),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 25),
        child: BText(title, color: Colors.black));
  }
}
