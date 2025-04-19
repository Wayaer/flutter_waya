import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselSliderPage extends StatelessWidget {
  const CarouselSliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselSliderController controller = CarouselSliderController();
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('CarouselSlider'),
        children: [
          const Partition('CarouselSliderController', marginTop: 0),
          Wrap(children: [
            ElevatedText('nextPage', onTap: () {
              controller.nextPage();
            }),
            ElevatedText('previousPage', onTap: () {
              controller.previousPage();
            }),
            ElevatedText('jumpToPage 6', onTap: () {
              controller.jumpToPage(6);
            }),
            ElevatedText('animateToPage 12', onTap: () {
              controller.animateToPage(12);
            }),
            ElevatedText('startAutoPlay', onTap: () {
              controller.startAutoPlay();
            }),
            ElevatedText('stopAutoPlay', onTap: () {
              controller.stopAutoPlay();
            }),
          ]),
          const Partition('CarouselSlider.builder'),
          CarouselSlider.builder(
              controller: controller,
              options: const CarouselSliderOptions(
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  enlargeCenterPage: true,
                  autoPlay: true),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index, int realIndex) =>
                  Container(
                      color: [Colors.red, Colors.amber, Colors.blue][index],
                      alignment: Alignment.center,
                      child: Text('$index'))),
        ]);
  }
}
