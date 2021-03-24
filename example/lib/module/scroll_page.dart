import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ScrollViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Color> colors = <Color>[];
    final ScrollController scrollController = ScrollController();
    colors.addAll(Colors.accents);
    colors.addAll(Colors.primaries);

    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('ScrollView Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomElastic('ScrollViewAuto',
              onTap: () => push(_ScrollViewAutoPage(slivers))),
          CustomElastic('ScrollViewAuto.nested',
              onTap: () => push(_ScrollViewAutoNestedPage(slivers))),
          CustomElastic('DraggableScrollbar',
              onTap: () => push(_DraggableScrollbar(colors, scrollController))),
          CustomElastic('ScrollList',
              onTap: () => push(_ScrollListPage(colors, scrollController))),
          CustomElastic('ScrollList.custom',
              onTap: () =>
                  push(_ScrollListCustomPage(colors, scrollController))),
          CustomElastic('ScrollList.builder',
              onTap: () =>
                  push(_ScrollListBuilderPage(colors, scrollController))),
          CustomElastic('ScrollList.builder-grid',
              onTap: () =>
                  push(_ScrollListBuilderGridPage(colors, scrollController))),
          CustomElastic('ScrollList.separated',
              onTap: () =>
                  push(_ScrollListSeparatedPage(colors, scrollController))),
          CustomElastic('ScrollList.placeholder',
              onTap: () =>
                  push(_ScrollListPlaceholderPage(colors, scrollController))),
        ]);
  }

  List<Widget> get slivers => <Widget>[
        SliverAutoAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpaceTitle:
                const Text('title', style: TextStyle(color: Colors.black)),
            background:
                Container(height: kToolbarHeight * 2, color: Colors.green)),
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
}

class _ScrollListSeparatedPage extends StatelessWidget {
  const _ScrollListSeparatedPage(this.colors, this.scrollController, {Key key})
      : super(key: key);

  final List<Color> colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.separated Demo'), centerTitle: true),
        body: ScrollList.separated(
          padding: const EdgeInsets.all(10),
          refreshConfig: RefreshConfig(
            onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.refreshSuccess);
              });
            },
            onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.loadingSuccess);
              });
            },
          ),
          itemCount: colors.length,
          itemBuilder: (_, int index) =>
              _Item(index, colors[index]).paddingSymmetric(vertical: 5),
          separatorBuilder: (_, int index) =>
              const Divider(color: Colors.black, height: 4),
        ));
  }
}

class _ScrollListPlaceholderPage extends StatelessWidget {
  const _ScrollListPlaceholderPage(this.colors, this.scrollController,
      {Key key})
      : super(key: key);

  final List<Color> colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.builder Demo'), centerTitle: true),
        body: ScrollList.builder(
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.refreshSuccess);
              });
            }, onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.loadingSuccess);
              });
            }),
            placeholder:
                BasisText('没有数据', style: const TextStyle(color: Colors.white))
                    .container(
                        alignment: Alignment.center,
                        color: colors.last,
                        padding: const EdgeInsets.symmetric(vertical: 10)),
            itemCount: 0,
            itemBuilder: (_, int index) =>
                _Item(index, colors[index]).paddingOnly(bottom: 10)));
  }
}

class _ScrollListBuilderGridPage extends StatelessWidget {
  const _ScrollListBuilderGridPage(this.colors, this.scrollController,
      {Key key})
      : super(key: key);

  final List<Color> colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.builder-Grid Demo'),
            centerTitle: true),
        body: ScrollList.builder(
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(
              onRefresh: () async {
                await showToast('onRefresh');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.refreshSuccess);
                });
              },
              onLoading: () async {
                await showToast('onLoading');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.loadingSuccess);
                });
              },
            ),
            itemCount: colors.length,
            crossAxisFlex: true,
            mainAxisExtent: 100,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            itemBuilder: (_, int index) => _Item(index, colors[index])));
  }
}

class _ScrollListBuilderPage extends StatelessWidget {
  const _ScrollListBuilderPage(this.colors, this.scrollController, {Key key})
      : super(key: key);

  final List<Color> colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.builder Demo'), centerTitle: true),
        body: ScrollList.builder(
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(
              onRefresh: () async {
                await showToast('onRefresh');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.refreshSuccess);
                });
              },
              onLoading: () async {
                await showToast('onLoading');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.loadingSuccess);
                });
              },
            ),
            itemCount: colors.length,
            itemBuilder: (_, int index) =>
                _Item(index, colors[index]).paddingOnly(bottom: 10)));
  }
}

class _ScrollListPage extends StatelessWidget {
  const _ScrollListPage(this.colors, this.scrollController, {Key key})
      : super(key: key);

  final List<Color> colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('ScrollList Demo'), centerTitle: true),
        body: ScrollList(
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(
              onRefresh: () async {
                await showToast('onRefresh');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.refreshSuccess);
                });
              },
              onLoading: () async {
                await showToast('onLoading');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.loadingSuccess);
                });
              },
            ),
            gridDelegates: const <SliverGridDelegate>[
              null,
              SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              null,
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 10),
            ],
            delegates: <SliverChildDelegate>[
              SliverChildBuilderDelegate(
                  (_, int index) =>
                      _Item(index, colors[index]).paddingOnly(bottom: 10),
                  childCount: colors.length),
              SliverChildListDelegate(colors.builderEntry(
                  (MapEntry<int, Color> entry) =>
                      _Item(entry.key, entry.value))),
              SliverChildBuilderDelegate(
                  (_, int index) =>
                      _Item(index, colors[index]).paddingOnly(bottom: 10),
                  childCount: colors.length),
              SliverChildListDelegate(colors.builderEntry(
                  (MapEntry<int, Color> entry) =>
                      _Item(entry.key, entry.value))),
            ]));
  }
}

class _ScrollListCustomPage extends StatelessWidget {
  const _ScrollListCustomPage(this.colors, this.scrollController, {Key key})
      : super(key: key);

  final List<Color> colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('ScrollList.custom Demo'), centerTitle: true),
      body: ScrollList.custom(
          padding: const EdgeInsets.all(10),
          refreshConfig: RefreshConfig(onRefresh: () async {
            await showToast('onRefresh');
            await 2.seconds.delayed(() {
              sendRefreshType(EasyRefreshType.refreshSuccess);
            });
          }, onLoading: () async {
            await showToast('onLoading');
            await 2.seconds.delayed(() {
              sendRefreshType(EasyRefreshType.loadingSuccess);
            });
          }),
          delegate: SliverChildBuilderDelegate(
              (_, int index) =>
                  _Item(index, colors[index]).paddingOnly(bottom: 10),
              childCount: colors.length)),
    );
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
                await showToast('onRefresh');
                sendRefreshType(EasyRefreshType.refreshSuccess);
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

class _Item extends StatelessWidget {
  const _Item(this.index, this.color);

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 80, color: color);
}

class _DraggableScrollbar extends StatelessWidget {
  const _DraggableScrollbar(this.colors, this.scrollController, {Key key})
      : super(key: key);

  final List<Color> colors;
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

    final DraggableScrollbar scrollbar =
        DraggableScrollbar(controller: scrollController, child: list);

    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('DraggableScrollbar Demo'), centerTitle: true),
        body: scrollbar);
  }
}
