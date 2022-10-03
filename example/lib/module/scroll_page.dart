import 'package:app/main.dart';
import 'package:app/module/refresh_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ScrollViewPage extends StatelessWidget {
  const ScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return ExtendedScaffold(
        isScroll: true,
        padding: const EdgeInsets.all(20),
        appBar: AppBarText('ScrollView'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Partition('ExtendedScrollView'),
          ElevatedText('ExtendedScrollView',
              onTap: () => push(_ExtendedScrollViewPage(slivers))),
          ElevatedText('ExtendedScrollView.nested',
              onTap: () => push(_ExtendedNestedScrollViewPage(slivers))),
          ElevatedText('ExtendedScrollView.custom',
              onTap: () => push(_ExtendedCustomScrollViewPage(slivers))),
          const Partition('ScrollView'),
          ElevatedText('CustomScrollView',
              onTap: () => push(const _CustomScrollViewPage())),
          ElevatedText('RefreshScrollView',
              onTap: () => push(const _RefreshScrollViewPage())),
          ElevatedText('DraggableScrollbar',
              onTap: () => push(_DraggableScrollbar(scrollController))),
          const Partition('Refresh'),
          ElevatedText('SimpleRefresh', onTap: () => push(const RefreshPage())),
        ]);
  }

  List<Widget> get slivers => <Widget>[
        ExtendedSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpaceTitle: const Text('ExtendedSliverAppBar',
                style: TextStyle(color: Colors.black)),
            background:
                Container(height: kToolbarHeight * 2, color: colors[0])),
        ExtendedSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: colors[3],
            flexibleSpaceTitle: const Text('第二个 ExtendedSliverAppBar',
                style: TextStyle(color: Colors.black)),
            background: Container(height: kToolbarHeight, color: colors[7])),
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

class _RefreshScrollViewPage extends StatelessWidget {
  const _RefreshScrollViewPage();

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
      appBar: AppBarText('RefreshScrollView'),
      body: RefreshScrollView(
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
          slivers: <Widget>[
            SliverListGrid(
                itemCount: colors.length,
                crossAxisFlex: true,
                maxCrossAxisExtent: 30,
                separatorBuilder: (_, int index) {
                  return Text('s$index');
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
  const _CustomScrollViewPage();

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

class _ExtendedNestedScrollViewPage extends StatelessWidget {
  const _ExtendedNestedScrollViewPage(this.slivers);

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
                    100,
                    (int index) => ColorEntry(
                          index,
                          index.isEven ? Colors.yellow : Colors.blue,
                          width: double.infinity,
                        )))),
      ));
}

class _ExtendedCustomScrollViewPage extends StatelessWidget {
  const _ExtendedCustomScrollViewPage(this.slivers);

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
          child: ExtendedScrollView.custom(slivers: <Widget>[
            ...slivers,
            ...List<Widget>.generate(
                100,
                (int index) => ColorEntry(
                      index,
                      index.isEven ? Colors.yellow : Colors.blue,
                      width: double.infinity,
                    ).toSliverBox)
          ])));
}

class _ExtendedScrollViewPage extends StatelessWidget {
  const _ExtendedScrollViewPage(this.slivers);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: ExtendedScrollView(
              builderScrollView: (BuildContext context, List<Widget> slivers) {
                return RefreshScrollView(
                    slivers: slivers,
                    refreshConfig: RefreshConfig(onRefresh: () async {
                      showToast('onRefresh');
                      2.seconds.delayed(() {
                        RefreshControllers()
                            .call(EasyRefreshType.refreshSuccess);
                      });
                    }, onLoading: () async {
                      showToast('onLoading');
                      2.seconds.delayed(() {
                        RefreshControllers()
                            .call(EasyRefreshType.loadingSuccess);
                      });
                    }));
              },
              slivers: [
            ...slivers,
            ...List<Widget>.generate(
                100,
                (int index) => ColorEntry(
                      index,
                      index.isEven ? Colors.yellow : Colors.blue,
                      width: double.infinity,
                    ).toSliverBox)
          ]));
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

class _DraggableScrollbar extends StatelessWidget {
  const _DraggableScrollbar(this.scrollController);

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
        backgroundColor: context.theme.dialogBackgroundColor,
        scrollbarStyle: ScrollbarStyle.semicircle,
        child: list);
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
