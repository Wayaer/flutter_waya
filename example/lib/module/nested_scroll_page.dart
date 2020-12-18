import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class NestedScrollSliverPage extends StatefulWidget {
  @override
  _NestedScrollSliverPageState createState() => _NestedScrollSliverPageState();
}

class _NestedScrollSliverPageState extends State<NestedScrollSliverPage> {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      // appBar: AppBar(title: const Text('标题')),
      body: NestedScrollAuto(
        body: Universal(
            isScroll: true,
            color: Colors.yellow,
            children: List<Widget>.generate(
                50, (int index) => Text(index.toString()))),
        headerMinHeight: 0,
        headerPinned: true,
        headerFloating: false,
        persistentHeader:
            Container(width: 200, height: 100, color: Colors.black),
        sliverAutoAppBar: SliverAutoAppBar(
          pinned: true,
          snap: false,
          floating: false,
          backgroundColor: Colors.transparent,
          background: const Universal(
            color: Colors.greenAccent,
            alignment: Alignment.bottomLeft,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            padding: EdgeInsets.only(top: 20),
            children: <Widget>[
              Text('FlexibleSpaceBar background'),
              Text('FlexibleSpaceBar background'),
            ],
          ),
          flexibleSpaceTitle: Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(top: 100),
            child: const Text('年月日', style: TextStyle(fontSize: 12)),
          ),
          bottom: Container(color: Colors.red, width: 100, height: 1),
        ),
      ),
    );
  }
}
