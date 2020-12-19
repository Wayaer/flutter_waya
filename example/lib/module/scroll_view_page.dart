import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ScrollViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Waya Demo'), centerTitle: true),
      body: Universal(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customElasticButton('CustomScrollViewAutoPage',
              onTap: () => push(widget: CustomScrollViewAutoPage())),
          customElasticButton('NestedScrollViewPage',
              onTap: () => push(widget: NestedScrollViewPage())),
        ],
      ),
    );
  }
}

class CustomScrollViewAutoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      // appBar: AppBar(title: const Text('标题')),
      body: CustomScrollViewAuto(slivers: <Widget>[
        SliverAutoAppBar(
          pinned: true,
          snap: true,
          floating: true,
          backgroundColor: Colors.transparent,
          flexibleSpaceTitle:
              const Text('title', style: TextStyle(color: Colors.black)),
          background: Container(
            height: kToolbarHeight + 1,
            color: Colors.green,
          ),
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
        SliverAutoPersistentHeader(
          pinned: true,
          floating: false,
          child: Container(
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: const Text('SliverAutoPersistentHeader')),
        ),
      ]),
    );
  }
}

class NestedScrollViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      // appBar: AppBar(title: const Text('标题')),
      body: NestedScrollViewAuto(
          body: Universal(
              isScroll: true,
              color: Colors.yellow,
              children: List<Widget>.generate(
                  50, (int index) => Text(index.toString()))),
          slivers: <Widget>[
            SliverAutoAppBar(
              pinned: true,
              snap: true,
              floating: true,
              backgroundColor: Colors.transparent,
              flexibleSpaceTitle:
                  const Text('title', style: TextStyle(color: Colors.black)),
              background: Container(
                height: kToolbarHeight + 1,
                color: Colors.green,
              ),
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
            SliverAutoPersistentHeader(
              pinned: true,
              floating: false,
              child: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.center,
                  child: const Text('SliverAutoPersistentHeader')),
            ),
          ]),
    );
  }
}
