import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  CarouselController controller = CarouselController();
  TransformerController transformerController;

  List<Color> list = <Color>[
    Colors.tealAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.redAccent
  ];

  @override
  void initState() {
    super.initState();
    transformerController = TransformerController(initialPage: 0, loop: false);
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
              index: 0,
              controller: controller,
              // pageController: transformerController,
              itemCount: list.length,
              viewportFraction: 0.8,
              transformer: ZoomInPageTransformer(),
              itemBuilder: (BuildContext context, int index) => Container(
                  alignment: Alignment.center,
                  color: list[index],
                  height: 100,
                  width: 100),
            ),
            // Align(
            //   child: Indicator(
            //       count: list.length,
            //       layout: IndicatorType.warm,
            //       controller: transformerController),
            // ),
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
              autoPlay: false,
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
    log(controller == null);
    controller?.dispose();
    transformerController?.dispose();
    super.dispose();
  }
}
