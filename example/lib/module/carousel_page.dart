import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({Key? key}) : super(key: key);

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  CarouselController controller = CarouselController();

  List<Color> list = <Color>[
    Colors.tealAccent,
    Colors.green,
    Colors.amber,
    Colors.redAccent
  ];

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          backgroundColor: Colors.white,
          appBar: AppBarText('Carousel Demo'),
          children: <Widget>[
            SizedBox(
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
                    itemCount: list.length)),
            Container(
                margin: const EdgeInsets.only(top: 200),
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
                    layout: CarouselLayout.stack,
                    itemHeight: double.infinity,
                    itemBuilder: (BuildContext context, int index) => Container(
                        alignment: Alignment.center, color: list[index]),
                    itemCount: list.length)),
          ]);
}
