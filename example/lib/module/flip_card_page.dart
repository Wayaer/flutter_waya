import 'dart:math';

import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage>
    with SingleTickerProviderStateMixin {
  late FlipCardController controller;

  @override
  void initState() {
    super.initState();
    controller = FlipCardController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('FlipCard'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        isScroll: true,
        children: [
          MouseRegion(
              onEnter: (_) {
                controller.skew(0.2);
              },
              onExit: (_) {
                controller.skew(0);
              },
              child: buildFliCard),
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
          ]),
          12.heightBox,
          MouseRegion(
              onEnter: (_) {
                controller.skew(0.2);
              },
              onExit: (_) {
                controller.skew(0);
              },
              child: buildFliCard),
          24.heightBox,
          FlipCardStateful(
              fit: StackFit.passthrough,
              front: (context, controller) => buildContent(
                  'Front', Colors.amberAccent, controller: controller),
              back: (context, controller) => buildContent(
                  'Back', Colors.lightGreenAccent,
                  controller: controller)),
        ]);
  }

  Widget get buildFliCard => FlipCard(
      controller: controller,
      fit: StackFit.passthrough,
      front: buildContent('Front', Colors.amberAccent),
      back: buildContent('Back', Colors.lightGreenAccent));

  Widget buildContent(String text, Color color,
          {FlipCardController? controller}) =>
      Universal(
          alignment: Alignment.center,
          height: 200,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Universal(
            color: Colors.red,
            padding: EdgeInsets.all(10),
            onTap: (controller ?? this.controller).animateToggle,
            child: Text(text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ));
}
