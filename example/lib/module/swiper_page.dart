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

  List<FlSwiperPlugin> pagination = [
    const FlSwiperPagination(
        alignment: Alignment.bottomCenter, builder: FlSwiperDotPagination()),
    const FlSwiperArrowPagination(),
    const FlSwiperPagination(
        alignment: Alignment.topCenter, builder: FlSwiperFractionPagination()),
  ];

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('FlSwiper'),
        children: [
          const Partition('FlSwiper FlSwiperLayout.tinder'),
          FlSwiper(
                  autoPlay: true,
                  duration: const Duration(seconds: 3),
                  pagination: pagination,
                  controller: controller,
                  itemWidth: 330,
                  onChanged: (int i) {
                    pageController.animateToPage(i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  layout: FlSwiperLayout.tinder,
                  itemHeight: double.infinity,
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center, color: list[index]),
                  itemCount: list.length)
              .setHeight(150),
          const Partition('FlSwiper FlSwiperLayout.stack'),
          FlSwiper(
                  autoPlay: true,
                  duration: const Duration(seconds: 3),
                  pagination: pagination,
                  controller: controller,
                  itemWidth: 280,
                  layout: FlSwiperLayout.stack,
                  itemHeight: double.infinity,
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center, color: list[index]),
                  itemCount: list.length)
              .setHeight(150),
          const Partition('PageView.builder'),
          PageView.builder(
              controller: pageController,
              itemCount: list.length,
              itemBuilder: (_, int index) {
                return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 20,
                    color: list[index]);
              }).setHeight(60),
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
    controller.dispose();
    pageController.removeListener(listener);
    pageController.dispose();
  }
}
