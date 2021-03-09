import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ScrollViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = <Widget>[
      SliverAutoAppBar(
        pinned: true,
        snap: true,
        floating: true,
        backgroundColor: Colors.transparent,
        flexibleSpaceTitle:
            const Text('title', style: TextStyle(color: Colors.black)),
        background: Container(height: kToolbarHeight * 2, color: Colors.green),
      ),
      SliverAutoAppBar(
          pinned: true,
          snap: true,
          floating: true,
          backgroundColor: Colors.greenAccent,
          flexibleSpaceTitle:
              const Text('第二个Title', style: TextStyle(color: Colors.black)),
          background:
              Container(height: kToolbarHeight, color: Colors.greenAccent)),
      SliverAutoPersistentHeader(
          pinned: true,
          floating: false,
          child: Container(
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: const Text('SliverAutoPersistentHeader'))),
      SliverAutoPersistentHeader(
          pinned: true,
          floating: false,
          child: Container(
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: const Text('SliverAutoPersistentHeader'))),
    ];
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar:
            AppBar(title: const Text('ScrollViewAuto Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customElasticButton('ScrollViewAuto',
              onTap: () => push(_ScrollViewAutoPage(slivers))),
          customElasticButton('ScrollViewAuto.nested',
              onTap: () => push(_ScrollViewAutoNestedPage(slivers))),
        ]);
  }
}

class _ScrollViewAutoNestedPage extends StatelessWidget {
  const _ScrollViewAutoNestedPage(this.slivers, {Key key}) : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => OverlayScaffold(
      body: ScrollViewAuto.nested(
          slivers: slivers,
          body: Universal(
              refreshConfig: RefreshConfig(onRefresh: () async {
                showToast('onRefresh');
              }),
              isScroll: true,
              color: Colors.yellow,
              children: List<Widget>.generate(
                  50, (int index) => Text(index.toString())))));
}

class _ScrollViewAutoPage extends StatelessWidget {
  const _ScrollViewAutoPage(this.slivers, {Key key}) : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => OverlayScaffold(
      body: ScrollViewAuto(
          slivers: slivers,
          body: Universal(
              isScroll: true,
              color: Colors.yellow,
              children: List<Widget>.generate(
                  50, (int index) => Text(index.toString())))));
}
