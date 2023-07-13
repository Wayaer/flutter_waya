import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          appBar: AppBarText('Components'),
          padding: const EdgeInsets.all(20),
          children: [
            const Partition('ExpansionTiles'),
            ExpansionTiles(
                backgroundColor: context.theme.primaryColor,
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
                style: CountAnimationStyle.part,
                count: 100,
                onTap: (int c) {},
                builder: (int count, String text) =>
                    BText(text, fontSize: 30)).color(Colors.black12),
            const SizedBox(height: 40),
            CounterAnimation(
                style: CountAnimationStyle.all,
                count: 100,
                onTap: (int c) {},
                builder: (int count, String text) =>
                    BText(text, fontSize: 30)).color(Colors.black12),
            const Partition('ToggleRotate'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                    'RichText魔改版',
                  ],
                  styles: const [
                    BTextStyle(color: Color(0xFFD32F2F)),
                    BTextStyle(color: Colors.white),
                    // BTextStyle(color: Color(0xFFFFC400)),
                  ])
            ]),
            const Partition('RatingStars'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              RatingStars(
                  value: 2.2,
                  starSpacing: 4,
                  builder: (bool selected) => Icon(Icons.star,
                      color: selected ? Colors.yellow : Colors.grey)),
              RatingStars(
                  value: 3.3,
                  starSpacing: 4,
                  builder: (bool selected) => Icon(Icons.star,
                      color: selected ? Colors.yellow : Colors.grey)),
            ]),
            const SizedBox(height: 100),
          ]);
}
