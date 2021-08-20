import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ComponentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          isScroll: true,
          appBar: AppBarText('PinBox Demo'),
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            //// PinBox
            BText('PinBox', color: Colors.black),
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
            const SizedBox(height: 20),
            BText('CounterAnimation', color: Colors.black),
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),
            BText('ToggleRotate', color: Colors.black),
            const SizedBox(height: 20),

            /// ToggleRotate
            const ToggleRotate(
                duration: Duration(milliseconds: 800),
                rad: pi / 2,
                child: Icon(Icons.chevron_left, size: 30)),
            const SizedBox(height: 40),
            ToggleRotate(
                duration: const Duration(seconds: 2),
                onTap: () {
                  showToast('旋转');
                },
                rad: pi,
                child: const Icon(Icons.chevron_left, size: 30)),
            const SizedBox(height: 40),
            const ToggleRotate(
                duration: Duration(seconds: 3),
                rad: pi * 1.5,
                child: Icon(Icons.chevron_left, size: 30)),
            const SizedBox(height: 20),
            BText('SendSMS', color: Colors.black),
            const SizedBox(height: 20),
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
                  log(state.toString() + i.toString());
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

            const SizedBox(height: 20),
            BText('ToggleRotate', color: Colors.black),
            const SizedBox(height: 20),
            CountDownSkip(
                onChanged: (int i) {
                  showToast(i.toString());
                },
                duration: const Duration(seconds: 5),
                builder: (int i) {
                  return SimpleButton(
                    text: i.toString(),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4)),
                  );
                }),
          ]);
}
