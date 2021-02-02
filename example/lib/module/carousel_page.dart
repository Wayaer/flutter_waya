import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  CarouselController controller = CarouselController();

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
  Widget build(BuildContext context) => OverlayScaffold(
          isScroll: true,
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Carousel Demo'), centerTitle: true),
          children: <Widget>[
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
                        alignment: Alignment.center,
                        builder: FractionPagination()),
                  ],
                  controller: controller,
                  itemWidth: 340,
                  layout: CarouselLayout.tinder,
                  itemHeight: double.infinity,
                  itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment.center, color: list[index]),
                  itemCount: list.length),
            ),
          ]);
}
