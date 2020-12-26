import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  CarouselController controller = CarouselController();
  TransformerController transformerController;

  List<Color> list = [
    Colors.tealAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.redAccent
  ];

  @override
  void initState() {
    super.initState();
    transformerController =
        TransformerController(initialPage: 1, itemCount: list.length);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      isScroll: true,
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('CarouselPage Demo'), centerTitle: true),
      body: Universal(children: <Widget>[
        Universal(
          isStack: true,
          height: 300,
          width: double.infinity,
          children: <Widget>[
            TransformerPageView(
              index: 1,
              loop: false,
              pageController: transformerController,
              // transformer: PageTransformerBuilder(
              //     builder: (Widget child, TransformInfo info) {
              //   return ParallaxColor(
              //     info: info,
              //     colors: list,
              //     child: Container(width: 100, height: 100),
              //   );
              // }),
              itemCount: list.length,
              viewportFraction: 0.8,
              transformer: ScaleAndFadeTransformer(),
              itemBuilder: (BuildContext context, int index) => Container(
                  alignment: Alignment.center,
                  color: list[index],
                  height: 100,
                  width: 100),
            ),
            Align(
              child: Indicator(
                count: list.length,
                layout: IndicatorType.warm,
                controller: transformerController,
              ),
            ),
          ],
        ),
        Container(
          height: 300,
          width: double.infinity,
          child: Carousel(
              pagination: const <CarouselPagination>[
                CarouselPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotCarouselPagination()),
                CarouselPagination(
                    alignment: Alignment.bottomCenter,
                    builder: ArrowPagination()),
                CarouselPagination(
                    alignment: Alignment.center, builder: FractionPagination()),
              ],
              autoPlay: true,
              controller: controller,
              itemWidth: 200,
              itemHeight: double.infinity,
              scale: 0.1,
              itemBuilder: (BuildContext context, int index) =>
                  Container(alignment: Alignment.center, color: list[index]),
              itemCount: list.length),
        ),
        const Divider(),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
