import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  FlipCardController controller = FlipCardController();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('FlipCard'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          MouseRegion(
                  onEnter: (_) {
                    controller.skew(0.2);
                  },
                  onExit: (_) {
                    controller.skew(0);
                  },
                  child: FlipCard(
                      controller: controller,
                      onFlip: (FlipCardState value) {
                        log(value);
                      },
                      onFlipDone: (FlipCardState value) {
                        log(value);
                      },
                      front: buildContent('Front', Colors.amberAccent),
                      back: buildContent('Back', Colors.lightGreenAccent)))
              .expanded,
          12.heightBox,
          Wrap(spacing: 10, runSpacing: 10, children: [
            ElevatedText('toggle', onTap: () {
              controller.toggle();
            }),
            ElevatedText('animateToggle', onTap: () {
              controller.animateToggle();
              // setState(() {});
            }),
            ElevatedText('skew', onTap: () {
              controller.skew(Random().nextDouble());
            }),
            ElevatedText('hint', onTap: () {
              controller.hint();
            }),
          ])
        ]);
  }

  Widget buildContent(String text, Color color) => Container(
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: BText(text, fontSize: 20, fontWeight: FontWeight.bold));
}
