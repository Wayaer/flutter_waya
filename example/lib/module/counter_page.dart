import 'dart:async';

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
          const Partition('AnimationCounter.up', marginTop: 0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ValueBuilder(
                initial: 100,
                builder: (_, int? value, updater) => AnimationCounter.up(
                    style: CounterStyle.part,
                    value: value.toString(),
                    builder: (String text) => Universal(
                        onTap: () {
                          updater(value! + 2);
                        },
                        child: BText(text, fontSize: 30)))),
            ValueBuilder(
                initial: 100,
                builder: (_, int? value, updater) => AnimationCounter.up(
                    style: CounterStyle.all,
                    value: value.toString(),
                    builder: (String text) => Universal(
                        onTap: () {
                          updater(value! + 1);
                        },
                        child: BText(text, fontSize: 30)))),
          ]),
          const Partition('AnimationCounter.down'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ValueBuilder(
                initial: 100,
                builder: (_, int? value, updater) => AnimationCounter.down(
                    style: CounterStyle.part,
                    value: value.toString(),
                    builder: (String text) => Universal(
                        onTap: () {
                          updater(value! - 1);
                        },
                        child: BText(text, fontSize: 30)))),
            ValueBuilder(
                initial: 100,
                builder: (_, int? value, updater) => AnimationCounter.down(
                    style: CounterStyle.all,
                    value: value.toString(),
                    builder: (String text) => Universal(
                        onTap: () {
                          updater(value! - 2);
                        },
                        child: BText(text, fontSize: 30)))),
          ]),
          const Partition('Counter.down'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Counter.down(
                onStarts: (Duration duration) {},
                onEnds: (Duration duration) {},
                builder: (Duration duration, bool isActive, start, stop) {
                  return ElevatedButton(
                      onPressed: isActive ? stop : start,
                      child: AnimationCounter.down(
                          value: duration.inSeconds.toString(),
                          builder: (String value) =>
                              BText(value, fontSize: 20)));
                }),
            Counter.down(
                builder: (Duration duration, bool isActive, start, stop) {
              return ElevatedButton(
                  onPressed: isActive ? stop : start,
                  child: AnimationCounter.down(
                      style: CounterStyle.all,
                      value: duration.inSeconds.toString(),
                      builder: (String value) => BText(value, fontSize: 20)));
            }),
          ]),
          const Partition('Counter.up'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Counter.up(
                max: const Duration(seconds: 300),
                builder: (Duration duration, bool isActive, start, stop) {
                  return ElevatedButton(
                      onPressed: isActive ? stop : start,
                      child: AnimationCounter.up(
                          value: duration.inSeconds.toString(),
                          builder: (String value) =>
                              BText(value, fontSize: 20)));
                }),
            Counter.up(
                builder: (Duration duration, bool isActive, start, stop) {
              return ElevatedButton(
                  onPressed: isActive ? stop : start,
                  child: AnimationCounter.up(
                      style: CounterStyle.all,
                      value: duration.inSeconds.toString(),
                      builder: (String value) => BText(value, fontSize: 20)));
            }),
          ]),
          const Partition('SendVerificationCode'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SendVerificationCode(
                gestureBuilder: (onTap, child) =>
                    ElevatedButton(onPressed: onTap, child: child),
                value: const Duration(seconds: 10),
                onChanged: (SendState value) {
                  showToast(value.toString());
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                onSendTap: () async {
                  await 2.seconds.delayed();
                  return true;
                },
                builder: (SendState state, int i) {
                  switch (state) {
                    case SendState.none:
                      return const Text('发送验证码');
                    case SendState.sending:
                      return const Text('发送中');
                    case SendState.resend:
                      return const Text('重新发送');
                    case SendState.countDown:
                      return Row(children: [
                        Text('等待 '),
                        AnimationCounter.down(
                            value: '$i', builder: (value) => Text(value)),
                        Text(' s')
                      ]);
                  }
                }),
            SendVerificationCode(
                gestureBuilder: (onTap, child) =>
                    ElevatedButton(onPressed: onTap, child: child),
                value: const Duration(seconds: 10),
                onChanged: (SendState value) {
                  showToast(value.toString());
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                onSendTap: () async {
                  final completer = Completer<bool>();
                  2.seconds.delayed(() {
                    completer.complete(true);
                  });
                  return completer.future;
                },
                builder: (SendState state, int i) {
                  switch (state) {
                    case SendState.none:
                      return const Text('发送验证码');
                    case SendState.sending:
                      return const Text('发送中');
                    case SendState.resend:
                      return const Text('重新发送');
                    case SendState.countDown:
                      return Row(children: [
                        Text('等待 '),
                        AnimationCounter.down(
                            value: '$i', builder: (value) => Text(value)),
                        Text(' s')
                      ]);
                  }
                }),
          ]),
        ]);
  }
}
