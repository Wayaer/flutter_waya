import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  CarouselController controller = CarouselController();
  TransformerController transformerController = TransformerController();

  List<Color> list = <Color>[
    Colors.tealAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.redAccent
  ];
  List<String> images = <String>[
    'lib/res/banner/1.jpg',
    'lib/res/banner/2.jpg',
    'lib/res/banner/3.jpg',
    'lib/res/banner/4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      isScroll: true,
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Carousel Demo'), centerTitle: true),
      body: Universal(children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          child: Carousel.builder(
              autoPlay: true,
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
              controller: controller,
              itemWidth: 340,
              layout: CarouselLayout.tinder,
              itemHeight: double.infinity,
              itemBuilder: (BuildContext context, int index) =>
                  Container(alignment: Alignment.center, color: list[index]),
              itemCount: list.length),
        ),
        const Divider(),
        Universal(
          width: double.infinity,
          children: <Widget>[
            // Indicator(count: list.length, controller: transformerController),
            Container(
              height: 400,
              child: Carousel.pageView(
                  autoPlay: true,
                  controller: controller,
                  pageController: transformerController,
                  itemCount: images.length,
                  viewportFraction: 0.5,
                  transformer: PageTransformerBuilder(
                      builder: (Widget child, TransformInfo info) {
                    return Universal(
                        padding: const EdgeInsets.all(10),
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ParallaxImage(AssetImage(images[info.index]),
                              height: 280, position: info.position),
                          ParallaxContainer(
                              opacityFactor: 1.0,
                              translationFactor: 400.0,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 6),
                                  color: Colors.orange,
                                  child: Text(info.index.toString())),
                              position: info.position),
                          ParallaxContainer(
                              opacityFactor: 1.0,
                              translationFactor: 300.0,
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 6),
                                  color: Colors.black38,
                                  child: Text(info.index.toString())),
                              position: info.position),
                        ]);
                  })),
            ),
            const Divider(),
            Container(
              height: 100,
              child: Carousel.pageView(
                  autoPlay: true,
                  controller: controller,
                  loop: false,
                  itemCount: list.length,
                  viewportFraction: 0.8,
                  transformer: PageTransformerBuilder(
                      builder: (Widget child, TransformInfo info) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ParallaxColor(
                          colors: list,
                          info: info,
                          child: Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: 100)),
                    );
                  })),
            ),
            const Divider(),
            Container(
              height: 100,
              child: Carousel.pageView(
                  autoPlay: true,
                  controller: controller,
                  itemCount: list.length,
                  viewportFraction: 0.8,
                  transformer: AccordionTransformer(),
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center,
                      color: list[index],
                      height: 100,
                      width: 100)),
            ),
            const Divider(),
            Container(
                height: 100,
                child: Carousel.pageView(
                    autoPlay: true,
                    controller: controller,
                    itemCount: list.length,
                    viewportFraction: 0.8,
                    transformer: ThreeDTransformer(),
                    itemBuilder: (BuildContext context, int index) => Container(
                        alignment: Alignment.center,
                        color: list[index],
                        height: 100,
                        width: 100))),
            const Divider(),
            Container(
              height: 100,
              child: Carousel.pageView(
                  autoPlay: true,
                  controller: controller,
                  itemCount: list.length,
                  viewportFraction: 0.8,
                  transformer: DepthPageTransformer(),
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center,
                      color: list[index],
                      height: 100,
                      width: 100)),
            ),
            const Divider(),
            Container(
              height: 100,
              child: Carousel.pageView(
                  autoPlay: true,
                  controller: controller,
                  itemCount: list.length,
                  viewportFraction: 0.8,
                  transformer: ZoomInPageTransformer(),
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center,
                      color: list[index],
                      height: 100,
                      width: 100)),
            ),
            const Divider(),
            Container(
              height: 100,
              child: Carousel.pageView(
                  autoPlay: true,
                  controller: controller,
                  itemCount: list.length,
                  viewportFraction: 0.8,
                  transformer: ZoomOutPageTransformer(),
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center,
                      color: list[index],
                      height: 100,
                      width: 100)),
            ),
          ],
        ),
        const Divider(),
      ]),
    );
  }
}
