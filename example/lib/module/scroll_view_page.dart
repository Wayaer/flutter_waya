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
        // flexibleSpace: Container(
        //   color: Colors.blue,
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //     height: 100,
        //     margin: EdgeInsets.only(bottom: 10),
        //     color: Colors.greenAccent,
        //   ),
        // ),
        // flexibleSpace: FlexibleSpaceBar(
        //   background: const Universal(
        //     color: Colors.greenAccent,
        //     alignment: Alignment.bottomLeft,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     padding: EdgeInsets.only(top: 100),
        //     children: <Widget>[
        //       Text('FlexibleSpaceBar background'),
        //       Text('FlexibleSpaceBar background'),
        //     ],
        //   ),
        //   title: Container(
        //     alignment: Alignment.bottomRight,
        //     child: const Text('年月日', style: TextStyle(fontSize: 12)),
        //   ),
        // ),

        // bottom: Container(color: Colors.red, width: 100, height: 1),
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
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      body: Universal(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customElasticButton('NestedScrollView',
              onTap: () => push(ScrollViewAutoNestedPage(slivers))),
          customElasticButton('CustomScrollViewAutoPage',
              onTap: () => push(ScrollViewAutoPage(slivers))),
        ],
      ),
    );
  }
}

class ScrollViewAutoNestedPage extends StatelessWidget {
  const ScrollViewAutoNestedPage(this.slivers, {Key key}) : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => OverlayScaffold(
      body: ScrollViewAuto.nested(
          slivers: slivers,
          body: Universal(
              isScroll: true,
              color: Colors.yellow,
              children: List<Widget>.generate(
                  50, (int index) => Text(index.toString())))));
}

class ScrollViewAutoPage extends StatelessWidget {
  const ScrollViewAutoPage(this.slivers, {Key key}) : super(key: key);

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
