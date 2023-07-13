import 'package:app/main.dart';
import 'package:app/module/flip_card_page.dart';
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
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedText('FlipCard', onTap: () => push(const FlipCardPage())),
          const Partition('ValueBuilder'),
          ValueBuilder<int>(
              initialValue: 0,
              builder: (_, int? value, ValueCallback<int> updater) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
          const Partition('ValueListenBuilder'),
          ValueListenBuilder<int>(
              initialValue: 1,
              builder: (_, ValueNotifier<int?> valueListenable) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
          const Partition('CheckBox 自定义版'),
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
                    size: const Size(50, 24),
                    radius: 12,
                    onChanged: onChanged)),
            ChangedBuilder<bool>(
                value: true,
                onWaitChanged: (bool value) async {
                  await 1.seconds.delayed();
                  return value;
                },
                builder: (bool value, onChanged) =>
                    XSwitch(value: value, onChanged: onChanged)),
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
          const Partition('SendSMS'),
          SendSMS(
              duration: const Duration(seconds: 10),
              onStateChanged: (SendState value) {
                showToast(value.toString());
              },
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(4)),
              onTap: (Function sending) async {
                1.seconds.delayed(() {
                  sending(true);
                });
              },
              builder: (SendState state, int i) {
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
              builder: (int i) => Universal(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: BText(i.toString()))),
          const SizedBox(height: 100),
        ]);
  }
}
