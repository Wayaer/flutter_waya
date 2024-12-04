import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('Counter'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('AnimationCounter'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            AnimationCounter(
                style: CounterStyle.part,
                translationStyle: CounterTranslationStyle.down,
                text: '103',
                builder: (String text, animate) => Universal(
                    onTap: () {
                      animate('${(text.parseInt) + 1}');
                    },
                    child: BText(text, fontSize: 30))),
            AnimationCounter(
                style: CounterStyle.all,
                translationStyle: CounterTranslationStyle.down,
                text: '101',
                builder: (String text, animate) => Universal(
                    onTap: () {
                      animate('${(text.parseInt) + 1}');
                    },
                    child: BText(text, fontSize: 30))),
            AnimationCounter(
                style: CounterStyle.part,
                translationStyle: CounterTranslationStyle.up,
                text: '110',
                builder: (String text, animate) => Universal(
                    onTap: () {
                      animate('${(text.parseInt) + 1}');
                    },
                    child: BText(text, fontSize: 30))),
            AnimationCounter(
                style: CounterStyle.all,
                translationStyle: CounterTranslationStyle.up,
                text: '120',
                builder: (String text, animate) => Universal(
                    onTap: () {
                      animate('${(text.parseInt) + 1}');
                    },
                    child: BText(text, fontSize: 30)))
          ]),
          const Partition('Counter'),
          Counter.down(
              duration: const Duration(seconds: 30),
              builder: (Duration duration, bool isActive, start, stop) {
                return Row(mainAxisSize: MainAxisSize.min, children: [
                  ElevatedButton(
                      onPressed: isActive ? stop : start,
                      child: Row(children: [
                        BText('Counter.down isActive:$isActive |  ',
                            color: context.theme.colorScheme.primary),
                        AnimationCounter(
                            text: duration.inSeconds.toString(),
                            builder: (String text, animate) => BText(text))
                      ]))
                ]);
              }),
          Counter.down(
              duration: const Duration(seconds: 30),
              builder: (Duration duration, bool isActive, start, stop) =>
                  ElevatedText(
                      'Counter.down isActive:$isActive | ${duration.inSeconds}',
                      onTap: isActive ? stop : start)),
          Counter.up(
              maxDuration: const Duration(seconds: 30),
              builder: (Duration duration, bool isActive, start, stop) =>
                  ElevatedText(
                      'Counter.up max:30 | isActive:$isActive|${duration.inSeconds}',
                      onTap: isActive ? stop : start)),
          Counter.up(
              maxDuration: const Duration(seconds: 30),
              autoStart: false,
              builder: (Duration duration, bool isActive, start, stop) =>
                  ElevatedText(
                      'Counter.up max:30 | autoStart:false | isActive:$isActive|${duration.inSeconds}',
                      onTap: isActive ? stop : start)),
          Counter.up(
              duration: const Duration(seconds: 10),
              builder: (Duration duration, bool isActive, start, stop) =>
                  ElevatedText(
                      'Counter.up start:10 | isActive:$isActive  | ${duration.inSeconds}',
                      onTap: isActive ? stop : start)),
          Counter.up(
              duration: const Duration(seconds: 10),
              maxDuration: const Duration(seconds: 30),
              builder: (Duration duration, bool isActive, start, stop) =>
                  ElevatedText(
                      'Counter.up max:30 | start:10 | isActive:$isActive | ${duration.inSeconds}',
                      onTap: isActive ? stop : start)),
        ]);
  }
}
