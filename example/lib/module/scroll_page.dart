import 'package:app/main.dart';
import 'package:app/module/refresh_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ScrollViewPage extends StatelessWidget {
  const ScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('ScrollView'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          ElevatedText('ExtendedScrollView',
              onTap: () => push(_ExtendedScrollViewPage(slivers))),
          ElevatedText('ExtendedScrollView.nested',
              onTap: () => push(_ExtendedScrollViewNestedPage(slivers))),
          const SizedBox(height: 40),
          ElevatedText('CustomScrollView',
              onTap: () => push(const _CustomScrollViewPage())),
          ElevatedText('RefreshScrollView',
              onTap: () => push(const _RefreshScrollViewPage())),
          ElevatedText('DraggableScrollbar',
              onTap: () => push(_DraggableScrollbar(scrollController))),
          const SizedBox(height: 40),
          ElevatedText('SimpleRefresh', onTap: () => push(const RefreshPage())),
        ]);
  }

  List<Widget> get slivers => <Widget>[
        ExtendedSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpaceTitle:
                const Text('title', style: TextStyle(color: Colors.black)),
            background:
                Container(height: kToolbarHeight * 2, color: colors[0])),
        ExtendedSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: colors[3],
            flexibleSpaceTitle:
                const Text('第二个Title', style: TextStyle(color: Colors.black)),
            background: Container(height: kToolbarHeight, color: colors[7])),
        ExtendedSliverPersistentHeader(
            pinned: true,
            floating: false,
            child: Container(
                color: colors[9],
                alignment: Alignment.center,
                child: const Text('ExtendedSliverPersistentHeader'))),
        ExtendedSliverPersistentHeader(
            pinned: true,
            floating: false,
            child: Container(
                color: colors[13],
                alignment: Alignment.center,
                child: const Text('ExtendedSliverPersistentHeader'))),
      ];
}

class _RefreshScrollViewPage extends StatelessWidget {
  const _RefreshScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: RefreshScrollView(
              padding: const EdgeInsets.all(10),
              refreshConfig: RefreshConfig(onRefresh: () async {
                await showToast('onRefresh');
                sendRefreshType(EasyRefreshType.refreshSuccess);
              }, onLoading: () async {
                await showToast('onLoading');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.loadingSuccess);
                });
              }),
              slivers: <Widget>[
            const SliverAppBar(
                title: BText('RefreshScrollView', color: Colors.white)),
            SliverListGrid(
                itemCount: colors.length,
                crossAxisFlex: true,
                maxCrossAxisExtent: 30,
                separatorBuilder: (_, int index) {
                  return Text('s' + index.toString());
                },
                itemBuilder: (_, int index) {
                  return ColorEntry(index, colors[index]);
                }),
            SliverListGrid.count(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: colors.builderEntry((MapEntry<int, Color> entry) =>
                    ColorEntry(entry.key, entry.value))),
          ]));
}

class _CustomScrollViewPage extends StatelessWidget {
  const _CustomScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: CustomScrollView(slivers: <Widget>[
        const CustomSliverAppBar(
            title: BText('CustomScrollViewPage', color: Colors.white)),
        SliverPinnedToBoxAdapter(
            child: Column(
                children: 4.generate((int index) =>
                    Text('SliverPinnedToBoxAdapter -- $index')))),
        SliverList(
            delegate: SliverChildListDelegate(colors.builderEntry(
                (MapEntry<int, Color> entry) =>
                    ColorEntry(entry.key, entry.value))))
      ]));
}

class _ExtendedScrollViewNestedPage extends StatelessWidget {
  const _ExtendedScrollViewNestedPage(this.slivers, {Key? key})
      : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: RefreshIndicator(
        notificationPredicate: (ScrollNotification notification) {
          /// 返回true即可
          return true;
        },
        onRefresh: () async {
          /// 模拟网络请求
          await Future<dynamic>.delayed(const Duration(seconds: 4));

          /// 结束刷新
          return Future<dynamic>.value(true);
        },
        child: ExtendedScrollView.nested(
            slivers: slivers,
            body: Universal(
                isScroll: true,
                color: Colors.yellow,
                children: List<Widget>.generate(
                    100, (int index) => Text(index.toString())))),
      ));
}

class _ExtendedScrollViewPage extends StatelessWidget {
  const _ExtendedScrollViewPage(this.slivers, {Key? key}) : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: ExtendedScrollView(slivers: <Widget>[
        ...slivers,
        SliverToBoxAdapter(
            child: Universal(
                color: Colors.yellow,
                children: List<Widget>.generate(
                    100, (int index) => Text(index.toString()))))
      ]));
}

class ColorEntry extends StatelessWidget {
  const ColorEntry(this.index, this.color,
      {this.height = 80, this.width = 80, Key? key})
      : super(key: key);

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

class _DraggableScrollbar extends StatelessWidget {
  const _DraggableScrollbar(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final ScrollList list = ScrollList.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        itemCount: colors.length,
        itemBuilder: (_, int index) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            color: colors[index],
            width: double.infinity,
            height: 40));

    Widget scrollbar = DraggableScrollbar(
        controller: scrollController,
        child: list,
        backgroundColor: context.theme.dialogBackgroundColor,
        scrollbarStyle: ScrollbarStyle.semicircle);
    // scrollbar = DraggableScrollbar(
    //     controller: scrollController,
    //     child: list,
    //     backgroundColor: context.theme.dialogBackgroundColor,
    //     scrollbarStyle: ScrollbarStyle.rect);
    // scrollbar = DraggableScrollbar(
    //     controller: scrollController,
    //     child: list,
    //     backgroundColor: context.theme.dialogBackgroundColor,
    //     scrollbarStyle: ScrollbarStyle.arrows);

    return ExtendedScaffold(
        appBar: AppBarText('DraggableScrollbar'), body: scrollbar);
  }
}
