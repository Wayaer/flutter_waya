import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Color> colors = List<Color>.generate(7, (int index) => Colors.blue);

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('PinBoxPage Demo'), centerTitle: true),
      body: Universal(
          isScroll: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            const Text('SimpleList.custom 单列')
                .padding(const EdgeInsets.only(top: 10)),
            SimpleList.custom(
              physics: const NeverScrollableScrollPhysics(),
              children: colors
                  .map((Color e) => Container(
                      color: e,
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.only(top: 10)))
                  .toList(),
            ),
            const Text('SimpleList.custom 4列')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.custom(
              physics: const NeverScrollableScrollPhysics(),
              maxCrossAxisExtent: 60,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 4,
              children: colors
                  .map((Color e) =>
                      Container(color: e, width: double.infinity, height: 40))
                  .toList(),
            ),
            const Text('SimpleList.custom 列数自适应')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.custom(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisFlex: true,
              maxCrossAxisExtent: 60,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: colors
                  .map((Color e) =>
                      Container(color: e, width: double.infinity, height: 40))
                  .toList(),
            ),
            const Text('SimpleList.custom placeholder')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.custom(
                placeholder:
                    const Text('没有数据', style: TextStyle(color: Colors.white))
                        .container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 10))),
            const Text('SimpleList.builder 单列')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.builder(
                physics: const NeverScrollableScrollPhysics(),
                maxCrossAxisExtent: 60,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2,
                itemCount: colors.length,
                itemBuilder: (_, int index) => Container(
                    color: colors[index],
                    width: double.infinity,
                    height: 40,
                    margin: const EdgeInsets.only(top: 10))),
            const Text('SimpleList.builder 4列')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.builder(
                physics: const NeverScrollableScrollPhysics(),
                maxCrossAxisExtent: 60,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 4,
                itemCount: colors.length,
                itemBuilder: (_, int index) => Container(
                    color: colors[index], width: double.infinity, height: 40)),
            const Text('SimpleList.builder 列数自适应')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.builder(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisFlex: true,
                maxCrossAxisExtent: 60,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: colors.length,
                itemBuilder: (_, int index) => Container(
                    color: colors[index], width: double.infinity, height: 40)),
            const Text('SimpleList.builder placeholder')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.builder(
                itemCount: 0,
                placeholder:
                    const Text('没有数据', style: TextStyle(color: Colors.white))
                        .container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                itemBuilder: (_, int index) => Container()),
            const Text('SimpleList.separated')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: colors.length,
                itemBuilder: (_, int index) => Container(
                    color: colors[index], width: double.infinity, height: 40),
                separatorBuilder: (BuildContext context, int index) =>
                    const DottedLine(
                        margin: EdgeInsets.symmetric(vertical: 6))),
            const Text('SimpleList.separated  placeholder')
                .padding(const EdgeInsets.symmetric(vertical: 10)),
            SimpleList.separated(
                itemCount: 0,
                placeholder:
                    const Text('没有数据', style: TextStyle(color: Colors.white))
                        .container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                itemBuilder: (_, int index) => Container(),
                separatorBuilder: (BuildContext context, int index) =>
                    const Text('separatorBuilder',
                            style: TextStyle(color: Colors.white))
                        .container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 10))),
          ]),
    );
  }
}
