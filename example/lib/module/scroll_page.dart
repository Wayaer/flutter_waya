import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ScrollViewPage extends StatelessWidget {
  const ScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return ExtendedScaffold(
        appBar: AppBarText('ScrollView'),
        mainAxisAlignment: MainAxisAlignment.center,
        child: DraggableScrollbar(
            controller: scrollController,
            backgroundColor: context.theme.dialogBackgroundColor,
            scrollbarStyle: ScrollbarStyle.semicircle,
            child: RefreshScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                refreshConfig: RefreshConfig(onRefresh: () async {
                  await showToast('onRefresh');
                  RefreshControllers().call(EasyRefreshType.refreshSuccess);
                }, onLoading: () async {
                  await showToast('onLoading');
                  await 2.seconds.delayed(() {
                    RefreshControllers().call(EasyRefreshType.loadingSuccess);
                  });
                }),
                slivers: [
                  SliverListGrid.builder(
                      itemCount: colors.length,
                      maxCrossAxisExtent: 60,
                      separatorBuilder: (_, int index) {
                        return Text('s$index');
                      },
                      itemBuilder: (_, int index) {
                        return ColorEntry(index, colors[index]);
                      }),
                  SliverListGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: colors.builderEntry(
                          (MapEntry<int, Color> entry) =>
                              ColorEntry(entry.key, entry.value))),
                ])));
  }

  List<Widget> get slivers => [
        ExtendedSliverPersistentHeader(
            pinned: true,
            floating: false,
            child: Container(
                height: 60,
                color: colors[9],
                alignment: Alignment.center,
                child: const BText('ExtendedSliverPersistentHeader',
                    color: Colors.black))),
        ExtendedSliverPersistentHeader(
            pinned: true,
            floating: false,
            child: Container(
                height: 60,
                color: colors[13],
                alignment: Alignment.center,
                child: const BText('第二个  ExtendedSliverPersistentHeader',
                    color: Colors.black))),
      ];
}

class ColorEntry extends StatelessWidget {
  const ColorEntry(this.index, this.color,
      {this.height = 80, this.width = 80, super.key});

  final int index;
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) => Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: color,
      child: BText(index.toString(),
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold));
}
