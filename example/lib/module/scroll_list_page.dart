import 'package:app/main.dart';
import 'package:app/module/scroll_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ScrollListPage extends StatelessWidget {
  const ScrollListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('ScrollList'),
        mainAxisAlignment: MainAxisAlignment.center,
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedText('ScrollList',
              onTap: () => push(_ScrollListPage(scrollController))),
          ElevatedText('ScrollList.builder',
              onTap: () => push(_ScrollListBuilderPage(scrollController))),
          ElevatedText('ScrollList.separated',
              onTap: () => push(_ScrollListSeparatedPage(scrollController))),
          ElevatedText('ScrollList.waterfallFlow',
              onTap: () =>
                  push(_ScrollListWaterfallFlowPage(scrollController))),
          ElevatedText('ScrollList.count',
              onTap: () => push(_ScrollListCountPage(scrollController))),
          ElevatedText('ScrollList.placeholder',
              onTap: () => push(_ScrollListPlaceholderPage(scrollController))),
        ]);
  }
}

class _ScrollListWaterfallFlowPage extends StatelessWidget {
  const _ScrollListWaterfallFlowPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.waterfall'),
        body: ScrollList.waterfall(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxCrossAxisExtent: 100,
          header: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.3),
            child: const Text('Header'),
          )),
          footer: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.3),
            child: const Text('Footer'),
          )),
          padding: const EdgeInsets.all(10),
          refreshConfig: RefreshConfig(onRefresh: () async {
            await showToast('onRefresh');
            await 2.seconds.delayed(() {
              RefreshControllers().call(EasyRefreshType.refreshSuccess);
            });
          }, onLoading: () async {
            await showToast('onLoading');
            await 2.seconds.delayed(() {
              RefreshControllers().call(EasyRefreshType.loadingSuccess);
            });
          }),
          itemCount: [...colors, ...colors, ...colors].length,
          itemBuilder: (_, int index) => ColorEntry(
              index, [...colors, ...colors, ...colors][index],
              height: index.isEven ? 100 : 70, width: index.isEven ? 50 : 100),
        ));
  }
}

class _ScrollListSeparatedPage extends StatelessWidget {
  const _ScrollListSeparatedPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.separated'),
        body: ScrollList.separated(
          header: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.3),
            child: const Text('Header'),
          )),
          footer: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.3),
            child: const Text('Footer'),
          )),
          padding: const EdgeInsets.all(10),
          refreshConfig: RefreshConfig(
            onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.refreshSuccess);
              });
            },
            onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.loadingSuccess);
              });
            },
          ),
          itemCount: colors.length,
          itemBuilder: (_, int index) =>
              ColorEntry(index, colors[index]).paddingSymmetric(vertical: 5),
          separatorBuilder: (_, int index) =>
              const Divider(color: Colors.black, height: 4),
        ));
  }
}

class _ScrollListPlaceholderPage extends StatelessWidget {
  const _ScrollListPlaceholderPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.builder'),
        body: ScrollList.builder(
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: const Text('Header'),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: const Text('Footer'),
            )),
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.refreshSuccess);
              });
            }, onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.loadingSuccess);
              });
            }),
            placeholder: const BText('没有数据', color: Colors.white).container(
                alignment: Alignment.center,
                color: colors[14],
                padding: const EdgeInsets.symmetric(vertical: 10)),
            itemCount: 0,
            itemBuilder: (_, int index) =>
                ColorEntry(index, colors[index]).paddingOnly(bottom: 10)));
  }
}

class _ScrollListBuilderPage extends StatelessWidget {
  const _ScrollListBuilderPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.builder'),
        body: Column(children: [
          ScrollList.builder(
              header: SliverToBoxAdapter(
                  child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 100,
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.3),
                child: const Text('Header'),
              )),
              footer: SliverToBoxAdapter(
                  child: Container(
                margin: const EdgeInsets.only(top: 10),
                height: 100,
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.3),
                child: const Text('Footer'),
              )),
              padding: const EdgeInsets.all(10),
              refreshConfig: RefreshConfig(
                onRefresh: () async {
                  showToast('onRefresh');
                  2.seconds.delayed(() {
                    RefreshControllers().call(EasyRefreshType.refreshSuccess);
                  });
                },
                onLoading: () async {
                  showToast('onLoading');
                  2.seconds.delayed(() {
                    RefreshControllers().call(EasyRefreshType.loadingSuccess);
                  });
                },
              ),
              itemCount: colors.length,
              itemBuilder: (_, int index) => ColorEntry(index, colors[index])
                  .paddingOnly(bottom: 10)).expandedNull,
        ]));
  }
}

class _ScrollListPage extends StatelessWidget {
  const _ScrollListPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList'),
        body: ScrollList(
            padding: const EdgeInsets.all(10),
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: const Text('Header'),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: const Text('Footer'),
            )),
            refreshConfig: RefreshConfig(onRefresh: () async {
              showToast('onRefresh');
              2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.refreshSuccess);
              });
            }, onLoading: () async {
              showToast('onLoading');
              2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.loadingSuccess);
              });
            }),
            sliver: <Widget>[
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverListGrid builder',
                          color: Colors.white))),
              SliverListGrid(
                  itemCount: colors.length,
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index]).paddingOnly(bottom: 10)),
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverWaterfallFlow.aligned',
                          color: Colors.white))),
              SliverWaterfallFlow.aligned(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: colors.length,
                  itemBuilder: (_, int index) => ColorEntry(
                      index, colors[index],
                      height: index & 3 == 0 ? 200 : 40)),
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverListGrid Grid Builder',
                          color: Colors.white))),
              SliverListGrid(
                  itemCount: colors.length,
                  crossAxisFlex: true,
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index]).paddingOnly(bottom: 10)),
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverListGrid Grid Builder',
                          color: Colors.white))),
              SliverListGrid(
                  itemCount: colors.length,
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index]).paddingOnly(bottom: 10)),
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverListGrid separatorBuilder',
                          color: Colors.white))),
              SliverListGrid(
                  itemCount: colors.length,
                  separatorBuilder: (_, int index) =>
                      Divider(color: colors[index]),
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index])),
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverWaterfallFlow Children',
                          color: Colors.white))),
              SliverWaterfallFlow.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: colors.builderEntry((entry) => ColorEntry(
                      entry.key, entry.value,
                      height: entry.key.isEven ? 100 : 70,
                      width: entry.key.isEven ? 50 : 100))),
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      color: colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const BText('SliverWaterfallFlow Builder',
                          color: Colors.white))),
              SliverWaterfallFlow(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: colors.length,
                  itemBuilder: (_, int index) => ColorEntry(
                      index, colors[index],
                      height: index.isEven ? 100 : 70,
                      width: index.isEven ? 50 : 100)),
            ]));
  }
}

class _ScrollListCountPage extends StatelessWidget {
  const _ScrollListCountPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.count'),
        body: ScrollList.count(
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: const Text('Header'),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: const Text('Footer'),
            )),
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.refreshSuccess);
              });
            }, onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                RefreshControllers().call(EasyRefreshType.loadingSuccess);
              });
            }),
            children: colors.builderEntry((MapEntry<int, Color> entry) =>
                ColorEntry(entry.key, entry.value))));
  }
}
