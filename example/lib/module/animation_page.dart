import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlAnimationPage extends StatefulWidget {
  const FlAnimationPage({super.key});

  @override
  State<FlAnimationPage> createState() => _FlAnimationPageState();
}

class _FlAnimationPageState extends State<FlAnimationPage> {
  Map<String, Function> animation = {};

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        padding: const EdgeInsets.all(20),
        appBar: AppBarText('FlAnimation'),
        children: [
          FlAnimation(
              delayDuration: 2.seconds,
              style: AnimationStyle.fade,
              onAnimate: (running) {
                animation.addAll({'fade': running});
              },
              child: buildText('fade')),
          FlAnimation(
              delayDuration: 2.seconds,
              style: AnimationStyle.horizontalHunting,
              onAnimate: (running) {
                animation.addAll({'horizontalHunting': running});
              },
              child: buildText('horizontalHunting')),
          FlAnimation(
              delayDuration: 2.seconds,
              style: AnimationStyle.verticalHunting,
              onAnimate: (running) {
                animation.addAll({'verticalHunting': running});
              },
              child: buildText('verticalHunting')),
        ]);
  }

  Widget buildText(String text) {
    return Universal(
        width: 300,
        height: 50,
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
        onTap: () {
          animation[text]?.call();
        },
        child: BText(text, color: Colors.white));
  }
}
