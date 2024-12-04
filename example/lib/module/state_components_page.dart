import 'dart:async';

import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class StateComponentsPage extends StatelessWidget {
  const StateComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('State Components'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('CheckBox 自定义版', marginTop: 0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CheckBox(
                    value: true,
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.all(6),
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                    tristate: true,
                    builder: (bool? value) {
                      if (value != null) {
                        return Icon(value
                            ? Icons.check_box
                            : Icons.check_box_outline_blank);
                      }
                      return const Icon(Icons.indeterminate_check_box);
                    }),
                CheckBox(
                    value: false,
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.only(right: 20),
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                    builder: (bool? value) {
                      return Icon(value!
                          ? Icons.check_box
                          : Icons.check_box_outline_blank);
                    }),
              ]),
          const Partition('Checkbox 官方附加状态版本'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ChangedBuilder<bool?>(
                value: true,
                onChanged: (bool? value) {},
                builder: (bool? value, onChanged) => Checkbox(
                    tristate: true, value: value, onChanged: onChanged)),
            ChangedBuilder<bool?>(
                value: true,
                onWaitChanged: (bool? value) async {
                  await 1.seconds.delayed();
                  return value;
                },
                builder: (bool? value, onChanged) => Checkbox(
                    shape: const CircleBorder(),
                    tristate: true,
                    value: value,
                    onChanged: onChanged)),
          ]),
          const Partition('XSwitch'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ChangedBuilder<bool>(
                value: true,
                onChanged: (bool value) {},
                builder: (bool value, onChanged) => XSwitch(
                    value: value,
                    activeColor: Colors.deepPurple,
                    size: const Size(40, 21),
                    radius: 12,
                    onChanged: onChanged)),
            ChangedBuilder<bool>(
                value: true,
                onWaitChanged: (bool value) async {
                  await 1.seconds.delayed();
                  return value;
                },
                builder: (bool value, onChanged) => XSwitch(
                    value: value,
                    size: const Size(60, 28),
                    activeColor: Colors.deepPurple,
                    onChanged: onChanged)),
          ]),
          const Partition('Switch 官方附加状态版本'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ChangedBuilder<bool>(
                value: true,
                onChanged: (bool value) {},
                builder: (bool value, onChanged) =>
                    Switch(value: value, onChanged: onChanged)),
            ChangedBuilder<bool>(
                value: true,
                onChanged: (bool value) {},
                builder: (bool value, onChanged) =>
                    CupertinoSwitch(value: value, onChanged: onChanged)),
            ChangedBuilder<bool>(
                value: true,
                onWaitChanged: (bool value) async {
                  await 1.seconds.delayed();
                  return value;
                },
                builder: (bool value, onChanged) =>
                    CupertinoSwitch(value: value, onChanged: onChanged)),
          ]),
          const Partition('SendVerificationCode'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SendVerificationCode(
                gestureBuilder: (onTap, child) =>
                    ElevatedButton(onPressed: onTap, child: child),
                duration: const Duration(seconds: 10),
                onChanged: (SendState value) {
                  showToast(value.toString());
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                onSendTap: () async {
                  await 2.seconds.delayed();
                  return true;
                },
                builder: (SendState state, int i) {
                  switch (state) {
                    case SendState.none:
                      return const Text('发送验证码');
                    case SendState.sending:
                      return const Text('发送中');
                    case SendState.resend:
                      return const Text('重新发送');
                    case SendState.countDown:
                      return Text('等待 $i s');
                  }
                }),
            SendVerificationCode(
                gestureBuilder: (onTap, child) =>
                    ElevatedButton(onPressed: onTap, child: child),
                duration: const Duration(seconds: 10),
                onChanged: (SendState value) {
                  showToast(value.toString());
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                onSendTap: () async {
                  final completer = Completer<bool>();
                  2.seconds.delayed(() {
                    completer.complete(true);
                  });
                  return completer.future;
                },
                builder: (SendState state, int i) {
                  switch (state) {
                    case SendState.none:
                      return const Text('发送验证码');
                    case SendState.sending:
                      return const Text('发送中');
                    case SendState.resend:
                      return const Text('重新发送');
                    case SendState.countDown:
                      return Text('等待 $i s');
                  }
                }),
          ]),

          const SizedBox(height: 100),
        ]);
  }
}
