import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselSliderPage extends StatelessWidget {
  const CarouselSliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselSliderController controllerBuilder = CarouselSliderController();
    CarouselSliderController controllerItems = CarouselSliderController();
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('CarouselSlider'),
        children: [
          const Partition('CarouselSliderController', marginTop: 0),
          Wrap(children: [
            ElevatedText('nextPage', onTap: () {
              controllerBuilder.nextPage();
              controllerItems.nextPage();
            }),
            ElevatedText('previousPage', onTap: () {
              controllerBuilder.previousPage();
              controllerItems.previousPage();
            }),
            ElevatedText('jumpToPage 6', onTap: () {
              controllerBuilder.jumpToPage(6);
              controllerItems.jumpToPage(6);
            }),
            ElevatedText('animateToPage 12', onTap: () {
              controllerBuilder.animateToPage(12);
              controllerItems.animateToPage(12);
            }),
            ElevatedText('startAutoPlay', onTap: () {
              controllerBuilder.startAutoPlay();
              controllerItems.startAutoPlay();
            }),
            ElevatedText('stopAutoPlay', onTap: () {
              controllerBuilder.stopAutoPlay();
              controllerItems.stopAutoPlay();
            }),
          ]),
          const Partition('CarouselSlider.builder'),
          CarouselSlider.builder(
              controller: controllerBuilder,
              options: const CarouselSliderOptions(
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  autoPlay: true,
                  enlargeCenterPage: true),
              itemCount: colorList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) =>
                  Container(
                      color: colorList[index],
                      alignment: Alignment.center,
                      child: Text('$index'))),
          const Partition('CarouselSlider.items'),
          CarouselSlider.items(
              controller: controllerItems,
              options: const CarouselSliderOptions(
                  autoPlay: true, enlargeCenterPage: true),
              items: colorList.generate((int index) => Container(
                  color: colorList[index],
                  alignment: Alignment.center,
                  child: Text('$index')))),
        ]);
  }
}
