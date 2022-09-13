import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class StateComponentsPage extends StatelessWidget {
  const StateComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('State Components Demo'),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: <Widget>[
          const Partition('ValueBuilder'),
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
          const Partition('ValueListenBuilder'),
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
          const Partition('CheckBox 自定义版'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
              Widget>[
            CheckBox(
                value: true,
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
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
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                stateBuilder: (bool? value) {
                  return Icon(
                      value! ? Icons.check_box : Icons.check_box_outline_blank);
                }),
          ]),
          const Partition('Checkbox 官方版'),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CheckboxState(
                    value: true, tristate: true, onChanged: (bool? value) {}),
                CheckboxState(
                    value: true,
                    tristate: true,
                    shape: const CircleBorder(),
                    onWaitChanged: (bool? value) async {
                      await 1.seconds.delayed();
                      return value;
                    }),
              ]),
          const Partition('SwitchState 官方附加状态版本'),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SwitchState(value: true, onChanged: (bool? value) {}),
                SwitchState.adaptive(
                    value: true,
                    onWaitChanged: (bool value) async {
                      await 1.seconds.delayed();
                      return value;
                    }),
              ]),
          const Partition('CupertinoSwitchState 官方附加状态版本'),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CupertinoSwitchState(value: true, onChanged: (bool? value) {}),
                CupertinoSwitchState(
                    value: true,
                    onWaitChanged: (bool value) async {
                      await 1.seconds.delayed();
                      return value;
                    }),
              ]),
          const SizedBox(height: 100),
        ]);
  }
}
