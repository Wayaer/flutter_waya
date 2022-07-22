import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          appBar: AppBarText('Components Demo'),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          children: <Widget>[
            //// PinBox
            const Partition('PinBox'),
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
                textStyle: const TextStyle(color: Colors.white)),
            const Partition('WidgetPendant'),
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
            const Partition('ExpansionTiles'),
            ExpansionTiles(
                title: const BText('title'),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: BText('item$index')))),
            ExpansionTiles(
                title: const BText('title'),
                child: ScrollList.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, int index) => Universal(
                        margin: const EdgeInsets.all(12),
                        alignment: Alignment.centerLeft,
                        child: BText('item$index')),
                    itemCount: 5)),
            const Partition('Toast'),
            Wrap(
                children: ToastStyle.values.builder((ToastStyle style) =>
                    ElevatedText(style.toString(), onTap: () async {
                      await showToast(style.toString(),
                          style: style, customIcon: Icons.ac_unit_sharp);
                      showToast('添加await第一个Toast完了之后弹出第二个Toast');
                    }))),
            Wrap(
                children: [
              Alignment.topCenter,
              Alignment.topLeft,
              Alignment.topRight,
              Alignment.bottomCenter,
              Alignment.bottomLeft,
              Alignment.bottomRight,
              Alignment.center,
              Alignment.centerLeft,
              Alignment.centerRight,
            ].builder((alignment) => ElevatedText(
                        alignment.toString().split('.')[1], onTap: () async {
                      showToast(alignment.toString(),
                          positioned: alignment,
                          customIcon: Icons.ac_unit_sharp,
                          options: ToastOptions(onTap: () {
                            log('点击了Toast');
                          }, modalWindowsOptions: ModalWindowsOptions(
                            onTap: () {
                              log('点击了背景');
                            },
                          )));
                    }))),
            const Partition('CounterAnimation'),

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
            const Partition('ToggleRotate'),
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
            const Partition('SendSMS'),
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
                      return const BText('发送验证码');
                    case SendState.sending:
                      return const BText('发送中');
                    case SendState.resend:
                      return const BText('重新发送');
                    case SendState.countDown:
                      return BText('等待 $i s');
                  }
                }),

            const Partition('CountDown'),
            CountDown(
                onChanged: (int i) {},
                periodic: 1,
                duration: const Duration(seconds: 100),
                builder: (int i) => SimpleButton(
                    text: i.toString(),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4)))),

            const Partition('DottedLine'),
            Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: DottedLineBorder.all(
                        color: context.theme.dividerColor)),
                child: CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DottedLinePainter(
                        color: context.theme.dividerColor,
                        strokeWidth: 1,
                        gap: 20))),
            const SizedBox(height: 100),
          ]);
}
