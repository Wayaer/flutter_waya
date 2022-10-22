import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlSwiperPage extends StatefulWidget {
  const FlSwiperPage({super.key});

  @override
  State<FlSwiperPage> createState() => _FlSwiperPageState();
}

class _FlSwiperPageState extends State<FlSwiperPage> {
  FlSwiperController controller = FlSwiperController();
  PageController pageController = PageController();
  ValueNotifier<double> position = ValueNotifier(0);
  List<Color> list = <Color>[
    Colors.tealAccent,
    Colors.green,
    Colors.amber,
    Colors.redAccent
  ];

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      pageController.addListener(listener);
    });
  }

  void listener() {
    position.value = pageController.page!;
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('FlSwiper'),
        children: [
          SizedBox(
              height: 200,
              width: double.infinity,
              child: FlSwiper.builder(
                  autoPlay: true,
                  duration: const Duration(seconds: 3),
                  pagination: const <FlSwiperPagination>[
                    FlSwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotFlSwiperPagination()),
                    FlSwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: ArrowPagination()),
                    FlSwiperPagination(
                        alignment: Alignment.center,
                        builder: FractionPagination()),
                  ],
                  controller: controller,
                  itemWidth: 340,
                  onChanged: (int i) {
                    pageController.animateToPage(i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  layout: FlSwiperLayout.tinder,
                  itemHeight: double.infinity,
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center, color: list[index]),
                  itemCount: list.length)),
          const SizedBox(height: 20),
          SizedBox(
              height: 40,
              width: double.infinity,
              child: PageView.builder(
                  controller: pageController,
                  itemCount: list.length,
                  itemBuilder: (_, int index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 20,
                        color: list[index]);
                  })),
          const SizedBox(height: 20),
          ValueListenableBuilder<double>(
              valueListenable: position,
              builder: (_, double position, __) {
                return Column(children: [
                  Indicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: IndicatorType.slide,
                      position: position),
                  const SizedBox(height: 20),
                  Indicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: IndicatorType.color,
                      position: position),
                  const SizedBox(height: 20),
                  Indicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: IndicatorType.none,
                      position: position),
                  const SizedBox(height: 20),
                  Indicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: IndicatorType.scale,
                      position: position),
                  const SizedBox(height: 20),
                  Indicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: IndicatorType.drop,
                      position: position),
                  const SizedBox(height: 20),
                  Indicator(
                      space: 40,
                      count: list.length,
                      index: position.floor(),
                      layout: IndicatorType.warm,
                      position: position),
                ]);
              }),
          const SizedBox(height: 20),
          SizedBox(
              height: 200,
              width: double.infinity,
              child: FlSwiper.builder(
                  autoPlay: true,
                  duration: const Duration(seconds: 3),
                  pagination: const <FlSwiperPagination>[
                    FlSwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotFlSwiperPagination()),
                    FlSwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: ArrowPagination()),
                    FlSwiperPagination(
                        alignment: Alignment.center,
                        builder: FractionPagination()),
                  ],
                  controller: controller,
                  itemWidth: 340,
                  layout: FlSwiperLayout.stack,
                  itemHeight: double.infinity,
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center, color: list[index]),
                  itemCount: list.length)),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    position.dispose();
    pageController.removeListener(listener);
    pageController.dispose();
  }
}
