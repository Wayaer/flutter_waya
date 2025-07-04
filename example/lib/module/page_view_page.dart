import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlPageViewPage extends StatefulWidget {
  const FlPageViewPage({super.key});

  @override
  State<FlPageViewPage> createState() => _FlPageViewPageState();
}

class _FlPageViewPageState extends State<FlPageViewPage> {
  FlPageViewController controllerHorizontal =
      FlPageViewController(viewportFraction: 0.8);
  FlPageViewController controllerVertical =
      FlPageViewController(viewportFraction: 0.8, isLoop: true);

  int itemCount = 10;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      controllerHorizontal.startAutoPlay();
      controllerVertical.startAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('FlPageView'),
        children: [
          const Partition('FlPageView vertical', marginTop: 0),
          buildPageView(controllerVertical, Axis.vertical),
          const Partition('FlPageView horizontal'),
          buildPageView(controllerHorizontal, Axis.horizontal),
          const Partition('FlIndicator'),
          buildIndicator(controllerHorizontal),
          20.heightBox,
        ]);
  }

  Widget buildPageView(FlPageViewController controller, Axis direction) =>
      FlPageView(
        controller: controller,
        itemCount: itemCount,
        autoPlay: true,
        builder: (FlPageViewController pageController, int? itemCount) =>
            PageView.builder(
                controller: pageController,
                scrollDirection: direction,
                itemCount: itemCount,
                itemBuilder: (_, int index) {
                  final colorScheme = Theme.of(context).colorScheme;
                  final child = Container(
                      alignment: Alignment.center,
                      color: index.isEven
                          ? colorScheme.primary
                          : colorScheme.primaryContainer,
                      child: Text(
                          'index:${pageController.getIndex(index)}\nrealIndex: $index'));
                  return Flex(
                      direction: direction == Axis.horizontal
                          ? Axis.vertical
                          : Axis.horizontal,
                      children: [
                        FlPageViewTransform(
                                controller: pageController,
                                scrollDirection: direction,
                                index: index,
                                style: FlPageViewTransformStyle.scale,
                                child: child)
                            .expanded,
                        SizedBox(width: 5, height: 5),
                        FlPageViewTransform(
                                controller: pageController,
                                scrollDirection: direction,
                                style: FlPageViewTransformStyle.zoom,
                                index: index,
                                child: child)
                            .expanded,
                      ]);
                }),
      );

  Widget buildIndicator(FlPageViewController controller) => ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        final position = controller.getPage() ?? 0;
        return Column(children: [
          FlIndicator(
              space: 20,
              count: itemCount,
              index: position.floor(),
              style: FlIndicatorStyle.slide,
              position: position),
          const SizedBox(height: 10),
          FlIndicator(
              space: 20,
              count: itemCount,
              index: position.floor(),
              style: FlIndicatorStyle.color,
              position: position),
          const SizedBox(height: 10),
          FlIndicator(
              space: 20,
              count: itemCount,
              index: position.floor(),
              style: FlIndicatorStyle.none,
              position: position),
          const SizedBox(height: 10),
          FlIndicator(
              space: 20,
              count: itemCount,
              index: position.floor(),
              style: FlIndicatorStyle.scale,
              position: position),
          const SizedBox(height: 10),
          FlIndicator(
              space: 20,
              count: itemCount,
              index: position.floor(),
              style: FlIndicatorStyle.drop,
              position: position),
          const SizedBox(height: 10),
          FlIndicator(
              space: 20,
              count: itemCount,
              index: position.floor(),
              style: FlIndicatorStyle.warm,
              position: position),
        ]);
      });
}
