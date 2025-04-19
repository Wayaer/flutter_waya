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
          const SizedBox(height: 100),
        ]);
  }
}
