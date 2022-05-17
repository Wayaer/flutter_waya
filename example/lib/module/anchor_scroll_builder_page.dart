import 'package:app/main.dart';
import 'package:app/module/scroll_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const _colors = [
  ...colors,
  ...colors,
  ...colors,
  ...colors,
  ...colors,
  ...colors,
  ...colors
];

double _random(int index) {
  return index.isEven ? 500 : 1000;
  // const min = 500;
  // const max = 1000;
  // final _random = Random();
  // return (min + _random.nextInt(max - min)).toDouble();
}

class AnchorScrollBuilderPage extends StatelessWidget {
  const AnchorScrollBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('ScrollList'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          ElevatedText('AnchorScrollBuilder builder vertical',
              onTap: () => push(_AnchorScrollBuilderPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder builder vertical reverse',
              onTap: () => push(_AnchorScrollBuilderPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder builder horizontal ',
              onTap: () => push(_AnchorScrollBuilderPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.horizontal))),
          ElevatedText('AnchorScrollBuilder builder horizontal reverse',
              onTap: () => push(_AnchorScrollBuilderPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.horizontal))),
          const SizedBox(height: 20),
          ElevatedText('AnchorScrollBuilder grid vertical',
              onTap: () => push(_AnchorScrollGridPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder grid vertical reverse',
              onTap: () => push(_AnchorScrollGridPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder grid horizontal ',
              onTap: () => push(_AnchorScrollGridPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.horizontal))),
          ElevatedText('AnchorScrollBuilder grid horizontal reverse',
              onTap: () => push(_AnchorScrollGridPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.horizontal))),
          const SizedBox(height: 20),
          ElevatedText('AnchorScrollBuilder count vertical',
              onTap: () => push(_AnchorScrollCountPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder count vertical reverse',
              onTap: () => push(_AnchorScrollCountPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder count horizontal ',
              onTap: () => push(_AnchorScrollCountPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.horizontal))),
          ElevatedText('AnchorScrollBuilder count horizontal reverse',
              onTap: () => push(_AnchorScrollCountPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.horizontal))),
          const SizedBox(height: 20),
          ElevatedText('AnchorScrollBuilder waterfall vertical',
              onTap: () => push(_AnchorScrollBuilderWaterfallPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder waterfall vertical reverse',
              onTap: () => push(_AnchorScrollBuilderWaterfallPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.vertical))),
          ElevatedText('AnchorScrollBuilder waterfall horizontal ',
              onTap: () => push(_AnchorScrollBuilderWaterfallPage(
                  controller: AnchorScrollController(),
                  reverse: false,
                  scrollDirection: Axis.horizontal))),
          ElevatedText('AnchorScrollBuilder waterfall horizontal reverse',
              onTap: () => push(_AnchorScrollBuilderWaterfallPage(
                  controller: AnchorScrollController(),
                  reverse: true,
                  scrollDirection: Axis.horizontal))),
        ]);
  }
}

class _AnchorScrollBuilderPage extends StatelessWidget {
  const _AnchorScrollBuilderPage(
      {Key? key,
      required this.reverse,
      required this.scrollDirection,
      required this.controller})
      : super(key: key);

  final AnchorScrollController controller;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AnchorScrollBuilder builder'),
        floatingActionButton: _FloatingActionButton(controller),
        bottomNavigationBar: _BottomNavigationBar(controller),
        children: [
          const _TopWidget(),
          AnchorScrollBuilder(
              count: _colors.length,
              controller: controller,
              reverse: reverse,
              scrollDirection: scrollDirection,
              builder: (BuildContext context,
                  GlobalKey<State<StatefulWidget>> scrollKey,
                  ScrollController scrollController,
                  bool reverse,
                  Axis scrollDirection,
                  List<GlobalKey<State<StatefulWidget>>> entryKey) {
                return ScrollList.builder(
                    key: scrollKey,
                    controller: scrollController,
                    itemCount: _colors.length,
                    reverse: reverse,
                    header: const _Header().sliverToBoxAdapter(),
                    footer: const _Footer().sliverToBoxAdapter(),
                    scrollDirection: scrollDirection,
                    itemBuilder: (_, int index) => ColorEntry(
                        index, _colors[index],
                        key: entryKey[index],
                        height: scrollDirection == Axis.horizontal
                            ? double.infinity
                            : _random(index),
                        width: scrollDirection == Axis.vertical
                            ? double.infinity
                            : _random(index)));
              }).expandedNull
        ]);
  }
}

class _AnchorScrollGridPage extends StatelessWidget {
  const _AnchorScrollGridPage(
      {Key? key,
      required this.reverse,
      required this.scrollDirection,
      required this.controller})
      : super(key: key);

  final AnchorScrollController controller;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AnchorScrollBuilder builder'),
        floatingActionButton: _FloatingActionButton(controller),
        bottomNavigationBar: _BottomNavigationBar(controller),
        children: [
          const _TopWidget(),
          AnchorScrollBuilder(
              count: _colors.length,
              controller: controller,
              reverse: reverse,
              scrollDirection: scrollDirection,
              builder: (BuildContext context,
                  GlobalKey<State<StatefulWidget>> scrollKey,
                  ScrollController scrollController,
                  bool reverse,
                  Axis scrollDirection,
                  List<GlobalKey<State<StatefulWidget>>> entryKey) {
                return ScrollList.builder(
                    key: scrollKey,
                    controller: scrollController,
                    itemCount: _colors.length,
                    crossAxisCount: 3,
                    reverse: reverse,
                    header: const _Header().sliverToBoxAdapter(),
                    footer: const _Footer().sliverToBoxAdapter(),
                    scrollDirection: scrollDirection,
                    itemBuilder: (_, int index) => ColorEntry(
                        index, _colors[index],
                        key: entryKey[index],
                        height: scrollDirection == Axis.horizontal
                            ? double.infinity
                            : _random(index),
                        width: scrollDirection == Axis.vertical
                            ? double.infinity
                            : _random(index)));
              }).expandedNull
        ]);
  }
}

class _AnchorScrollBuilderWaterfallPage extends StatelessWidget {
  const _AnchorScrollBuilderWaterfallPage(
      {Key? key,
      required this.reverse,
      required this.scrollDirection,
      required this.controller})
      : super(key: key);

  final AnchorScrollController controller;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AnchorScrollBuilder waterfall'),
        floatingActionButton: _FloatingActionButton(controller),
        bottomNavigationBar: _BottomNavigationBar(controller),
        children: [
          const _TopWidget(),
          AnchorScrollBuilder(
              count: _colors.length,
              controller: controller,
              reverse: reverse,
              scrollDirection: scrollDirection,
              builder: (BuildContext context,
                  GlobalKey<State<StatefulWidget>> scrollKey,
                  ScrollController scrollController,
                  bool reverse,
                  Axis scrollDirection,
                  List<GlobalKey<State<StatefulWidget>>> entryKey) {
                return ScrollList.waterfall(
                    key: scrollKey,
                    controller: scrollController,
                    itemCount: _colors.length,
                    reverse: reverse,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    header: const _Header().sliverToBoxAdapter(),
                    footer: const _Footer().sliverToBoxAdapter(),
                    scrollDirection: scrollDirection,
                    itemBuilder: (_, int index) => ColorEntry(
                        index, _colors[index],
                        key: entryKey[index],
                        height: scrollDirection == Axis.horizontal
                            ? double.infinity
                            : _random(index),
                        width: scrollDirection == Axis.vertical
                            ? double.infinity
                            : _random(index)));
              }).expandedNull
        ]);
  }
}

class _AnchorScrollCountPage extends StatelessWidget {
  const _AnchorScrollCountPage(
      {Key? key,
      required this.reverse,
      required this.scrollDirection,
      required this.controller})
      : super(key: key);

  final AnchorScrollController controller;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AnchorScrollBuilder count'),
        floatingActionButton: _FloatingActionButton(controller),
        bottomNavigationBar: _BottomNavigationBar(controller),
        children: [
          const _TopWidget(),
          AnchorScrollBuilder(
              count: _colors.length,
              controller: controller,
              reverse: reverse,
              scrollDirection: scrollDirection,
              builder: (BuildContext context,
                  GlobalKey scrollKey,
                  ScrollController scrollController,
                  bool reverse,
                  Axis scrollDirection,
                  List<GlobalKey> entryKey) {
                return ScrollList.count(
                    key: scrollKey,
                    controller: scrollController,
                    reverse: reverse,
                    header: const _Header().sliverToBoxAdapter(),
                    footer: const _Footer().sliverToBoxAdapter(),
                    scrollDirection: scrollDirection,
                    children: _colors.builderEntry((entry) => ColorEntry(
                        entry.key, _colors[entry.key],
                        key: entryKey[entry.key],
                        height: scrollDirection == Axis.horizontal
                            ? double.infinity
                            : _random(entry.key),
                        width: scrollDirection == Axis.vertical
                            ? double.infinity
                            : _random(entry.key))));
              }).expandedNull
        ]);
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton(this.controller, {Key? key}) : super(key: key);
  final AnchorScrollController controller;

  @override
  Widget build(BuildContext context) => Universal(
      margin: const EdgeInsets.only(right: 10),
      onTap: () {
        controller.jumpTo(0);
      },
      child: const Icon(Icons.arrow_circle_up, size: 50));
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      height: 100,
      width: 100,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const BText('footer'));
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      height: 100,
      width: 100,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const BText('header'));
}

class _TopWidget extends StatelessWidget {
  const _TopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      height: 100,
      alignment: Alignment.center,
      child: const BText('Top Widget'));
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar(this.controller, {Key? key}) : super(key: key);
  final AnchorScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Universal(
        mainAxisSize: MainAxisSize.min,
        safeBottom: true,
        children: [
          const BText('animateToIndex').marginOnly(top: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedText('0', onTap: () {
              controller.jumpToIndex(0, useAnimateTo: true);
            }),
            ElevatedText('50', onTap: () {
              controller.jumpToIndex(50, useAnimateTo: true);
            }),
            ElevatedText('100', onTap: () {
              controller.jumpToIndex(100, useAnimateTo: true);
            }),
            ElevatedText('150', onTap: () {
              controller.jumpToIndex(150, useAnimateTo: true);
            }),
            ElevatedText('200', onTap: () {
              controller.jumpToIndex(200, useAnimateTo: true);
            }),
            ElevatedText('237', onTap: () {
              controller.jumpToIndex(237, useAnimateTo: true);
            }),
          ]),
          const BText('jumpToIndex').marginOnly(top: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedText('0', onTap: () {
              controller.jumpToIndex(0);
            }),
            ElevatedText('50', onTap: () {
              controller.jumpToIndex(50);
            }),
            ElevatedText('100', onTap: () {
              controller.jumpToIndex(100);
            }),
            ElevatedText('150', onTap: () {
              controller.jumpToIndex(150);
            }),
            ElevatedText('200', onTap: () {
              controller.jumpToIndex(200);
            }),
            ElevatedText('237', onTap: () {
              controller.jumpToIndex(237);
            }),
          ])
        ]);
  }
}
