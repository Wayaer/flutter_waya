import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          appBar: AppBarText('Components Demo'),
          padding: const EdgeInsets.all(20),
          children: <Widget>[
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
            const Partition('RText'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              const BText('BText'),
              const BText.rich(
                  style: BTextStyle(color: Color(0xFF42A5F5)),
                  texts: [
                    'BText',
                    ' . ',
                    'rich',
                  ],
                  styles: [
                    BTextStyle(color: Color(0xFFD32F2F)),
                    BTextStyle(color: Colors.white),
                    BTextStyle(color: Color(0xFFFFC400)),
                  ]),
              RText(
                  style: const BTextStyle(color: Color(0xFF42A5F5)),
                  texts: const [
                    'RText',
                    ' = ',
                    'RichText 魔改版',
                  ],
                  styles: const [
                    BTextStyle(color: Color(0xFFD32F2F)),
                    BTextStyle(color: Colors.white),
                    // BTextStyle(color: Color(0xFFFFC400)),
                  ])
            ]),

            const SizedBox(height: 100),
          ]);
}
