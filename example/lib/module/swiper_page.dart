import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlSwiperPage extends StatefulWidget {
  const FlSwiperPage({super.key});

  @override
  State<FlSwiperPage> createState() => _FlSwiperPageState();
}

class _FlSwiperPageState extends State<FlSwiperPage> {
  ValueNotifier<double> position = ValueNotifier(0);
  List<Color> list = <Color>[
    Colors.tealAccent,
    Colors.green,
    Colors.amber,
    Colors.redAccent
  ];

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('FlSwiper'),
        children: [
          const SizedBox(height: 20),
          const Partition('FlIndicator'),
          ValueListenableBuilder<double>(
              valueListenable: position,
              builder: (_, double position, __) {
                return Column(children: [
                  FlIndicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: FlIndicatorType.slide,
                      position: position),
                  const SizedBox(height: 20),
                  FlIndicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: FlIndicatorType.color,
                      position: position),
                  const SizedBox(height: 20),
                  FlIndicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: FlIndicatorType.none,
                      position: position),
                  const SizedBox(height: 20),
                  FlIndicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: FlIndicatorType.scale,
                      position: position),
                  const SizedBox(height: 20),
                  FlIndicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: FlIndicatorType.drop,
                      position: position),
                  const SizedBox(height: 20),
                  FlIndicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: FlIndicatorType.warm,
                      position: position),
                ]);
              }),
          const SizedBox(height: 20),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    position.dispose();
  }
}
