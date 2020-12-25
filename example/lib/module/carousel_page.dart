import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  final PageController _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('CarouselPage Demo'), centerTitle: true),
      body: Universal(children: <Widget>[
        Universal(
          isStack: true,
          height: 100,
          width: double.infinity,
          children: [
            PageView(
              controller: _pageController,
              children: List<Widget>.generate(
                  5,
                  (int index) => const Universal(
                        color: Colors.blue,
                        width: double.infinity,
                        height: double.infinity,
                      )),
            ),
            Align(
              child: Indicator(
                count: 5,
                layout: IndicatorType.warm,
                controller: _pageController,
              ),
            ),
          ],
        ),




      ]),
    );
  }
}
