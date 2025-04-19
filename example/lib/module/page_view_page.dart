import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PageViewPage extends StatefulWidget {
  const PageViewPage({super.key});

  @override
  State<PageViewPage> createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  PageAutoPlayController controllerHorizontal =
      PageAutoPlayController(viewportFraction: 0.8);
  PageAutoPlayController controllerVertical =
      PageAutoPlayController(viewportFraction: 0.8);

  int itemCount = 3;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      controllerHorizontal.startAutoPlay();
      controllerVertical.startAutoPlay(reverse: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerHorizontal.dispose();
    controllerVertical.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('PageView'),
        children: [
          const Partition('FlPageViewItemTransform vertical', marginTop: 0),
          SizedBox(
              height: 100,
              child: buildPageView(controllerVertical, Axis.vertical)),
          const Partition('FlPageViewItemTransform horizontal'),
          SizedBox(
              height: 200,
              child: buildPageView(controllerHorizontal, Axis.horizontal)),
          const Partition('FlIndicator'),
          buildIndicator(controllerHorizontal),
          20.heightBox,
        ]);
  }

  Widget buildPageView(PageController controller, Axis direction) =>
      PageView.builder(
          controller: controller,
          scrollDirection: direction,
          itemCount: itemCount,
          itemBuilder: (_, int index) {
            final colorScheme = Theme.of(context).colorScheme;
            final child = Container(
                alignment: Alignment.center,
                color: index.isEven
                    ? colorScheme.primary
                    : colorScheme.primaryContainer,
                child: Text('page $index'));
            return Flex(
                direction: direction == Axis.horizontal
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  FlPageViewItemTransform(
                          controller: controller,
                          scrollDirection: direction,
                          index: index,
                          style: FlPageViewItemBuilderStyle.scale,
                          child: child)
                      .expanded,
                  SizedBox(width: 5, height: 5),
                  FlPageViewItemTransform(
                          controller: controller,
                          scrollDirection: direction,
                          style: FlPageViewItemBuilderStyle.zoom,
                          index: index,
                          child: child)
                      .expanded,
                ]);
          });

  Widget buildIndicator(PageController controller) => ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        final position = controller.page ?? 0;
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
