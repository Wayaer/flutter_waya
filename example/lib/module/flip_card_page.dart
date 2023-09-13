import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({Key? key}) : super(key: key);

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  FlipCardState? state;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('FlipCard'),
        padding: const EdgeInsets.all(20),
        children: [
          MouseRegion(
                  onEnter: (_) {
                    state?.skew(0.2);
                  },
                  onExit: (_) {
                    state?.skew(0);
                  },
                  child: FlipCard(
                      onFlipCardState: (_) {
                        state = _;
                      },
                      fill: Fill.front,
                      front: buildContent('Front', Colors.amberAccent),
                      back: buildContent('Back', Colors.lightGreenAccent)))
              .expanded,
          12.heightBox,
          Wrap(spacing: 10, runSpacing: 10, children: [
            ElevatedText('toggle', onTap: () {
              state?.toggle();
            }),
            ElevatedText('animateToggle', onTap: () {
              state?.animateToggle();
            }),
            ElevatedText('skew', onTap: () {
              state?.skew(Random().nextDouble());
            }),
            ElevatedText('hint', onTap: () {
              state?.hint();
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
