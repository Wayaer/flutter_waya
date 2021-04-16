import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

final List<Color> _colors = <Color>[
  ...Colors.accents,
  ...Colors.primaries,
];

class ScrollViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('ScrollView Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomElastic('CustomScrollView',
              onTap: () => push(const _CustomScrollViewPage())),
          CustomElastic('RefreshScrollView',
              onTap: () => push(const _RefreshScrollViewPage())),
          CustomElastic('ScrollViewAuto',
              onTap: () => push(_ScrollViewAutoPage(slivers))),
          CustomElastic('ScrollViewAuto.nested',
              onTap: () => push(_ScrollViewAutoNestedPage(slivers))),
          CustomElastic('DraggableScrollbar',
              onTap: () => push(_DraggableScrollbar(scrollController))),
          CustomElastic('ScrollList',
              onTap: () => push(_ScrollListPage(scrollController))),
          CustomElastic('ScrollList.builder',
              onTap: () => push(_ScrollListBuilderPage(scrollController))),
          CustomElastic('ScrollList.separated',
              onTap: () => push(_ScrollListSeparatedPage(scrollController))),
          CustomElastic('ScrollList.count',
              onTap: () => push(_ScrollListCountPage(scrollController))),
          CustomElastic('ScrollList.placeholder',
              onTap: () => push(_ScrollListPlaceholderPage(scrollController))),
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
  const _ScrollListSeparatedPage(this.scrollController, {Key key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.separated Demo'), centerTitle: true),
        body: ScrollList.separated(
          header: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Header'),
            color: Colors.grey.withOpacity(0.3),
          )),
          footer: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Footer'),
            color: Colors.grey.withOpacity(0.3),
          )),
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
          itemCount: _colors.length,
          itemBuilder: (_, int index) =>
              _Item(index, _colors[index]).paddingSymmetric(vertical: 5),
          separatorBuilder: (_, int index) =>
              const Divider(color: Colors.black, height: 4),
        ));
  }
}

class _ScrollListPlaceholderPage extends StatelessWidget {
  const _ScrollListPlaceholderPage(this.scrollController, {Key key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.builder Demo'), centerTitle: true),
        body: ScrollList.builder(
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Header'),
              color: Colors.grey.withOpacity(0.3),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Footer'),
              color: Colors.grey.withOpacity(0.3),
            )),
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
                        color: _colors.last,
                        padding: const EdgeInsets.symmetric(vertical: 10)),
            itemCount: 0,
            itemBuilder: (_, int index) =>
                _Item(index, _colors[index]).paddingOnly(bottom: 10)));
  }
}

class _ScrollListBuilderPage extends StatelessWidget {
  const _ScrollListBuilderPage(this.scrollController, {Key key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('ScrollList.builder Demo'), centerTitle: true),
        body: Column(children: <Widget>[
          Container(
              height: 100,
              color: Colors.blue,
              alignment: Alignment.center,
              child: BasisText('这里是头部',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          ScrollList.builder(
                  header: SliverToBoxAdapter(
                      child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text('Header'),
                    color: Colors.grey.withOpacity(0.3),
                  )),
                  footer: SliverToBoxAdapter(
                      child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text('Footer'),
                    color: Colors.grey.withOpacity(0.3),
                  )),
                  padding: const EdgeInsets.all(10),
                  refreshConfig: RefreshConfig(
                    onRefresh: () async {
                      showToast('onRefresh');
                      2.seconds.delayed(() {
                        sendRefreshType(EasyRefreshType.refreshSuccess);
                      });
                    },
                    onLoading: () async {
                      showToast('onLoading');
                      2.seconds.delayed(() {
                        sendRefreshType(EasyRefreshType.loadingSuccess);
                      });
                    },
                  ),
                  itemCount: _colors.length,
                  itemBuilder: (_, int index) =>
                      _Item(index, _colors[index]).paddingOnly(bottom: 10))
              .expandedNull,
        ]));
  }
}

class _ScrollListPage extends StatelessWidget {
  const _ScrollListPage(this.scrollController, {Key key}) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('ScrollList Demo'), centerTitle: true),
        body: ScrollList(
          padding: const EdgeInsets.all(10),
          header: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Header'),
            color: Colors.grey.withOpacity(0.3),
          )),
          footer: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Footer'),
            color: Colors.grey.withOpacity(0.3),
          )),
          refreshConfig: RefreshConfig(
            onRefresh: () async {
              showToast('onRefresh');
              2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.refreshSuccess);
              });
            },
            onLoading: () async {
              showToast('onLoading');
              2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.loadingSuccess);
              });
            },
          ),
          sliver: <SliverListGrid>[
            SliverListGrid(
                itemCount: _colors.length,
                itemBuilder: (_, int index) =>
                    _Item(index, _colors[index]).paddingOnly(bottom: 10)),
            SliverListGrid(
                itemCount: _colors.length,
                maxCrossAxisExtent: 100,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (_, int index) =>
                    _Item(index, _colors[index]).paddingOnly(bottom: 10)),
            SliverListGrid(
                itemCount: _colors.length,
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (_, int index) =>
                    _Item(index, _colors[index]).paddingOnly(bottom: 10)),
          ],
        ));
  }
}

class _ScrollListCountPage extends StatelessWidget {
  const _ScrollListCountPage(this.scrollController, {Key key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBar(title: const Text('ScrollList.count Demo'), centerTitle: true),
      body: ScrollList.count(
        header: SliverToBoxAdapter(
            child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 100,
          alignment: Alignment.center,
          child: const Text('Header'),
          color: Colors.grey.withOpacity(0.3),
        )),
        footer: SliverToBoxAdapter(
            child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 100,
          alignment: Alignment.center,
          child: const Text('Footer'),
          color: Colors.grey.withOpacity(0.3),
        )),
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
        children: _colors.builderEntry(
            (MapEntry<int, Color> entry) => _Item(entry.key, entry.value)),
      ),
    );
  }
}

class _RefreshScrollViewPage extends StatelessWidget {
  const _RefreshScrollViewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => OverlayScaffold(
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
            SliverAppBar(
                title: BasisText('RefreshScrollView', color: Colors.white)),
            SliverListGrid(
              itemCount: _colors.length,
              crossAxisFlex: true,
              maxCrossAxisExtent: 30,
              separatorBuilder: (_, int index) {
                return Text('s' + index.toString());
              },
              itemBuilder: (_, int index) {
                return _Item(index, _colors[index]);
              },
            ),
            SliverListGrid(
              crossAxisCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: _colors.builderEntry((MapEntry<int, Color> entry) =>
                  _Item(entry.key, entry.value)),
            ),
          ]));
}

class _CustomScrollViewPage extends StatelessWidget {
  const _CustomScrollViewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => OverlayScaffold(
          body: CustomScrollView(slivers: <Widget>[
        CustomSliverAppBar(title: BasisText('title', color: Colors.white)),
        SliverPinnedToBoxAdapter(
          child: Column(
              children: 4.generate(
                  (int index) => Text('SliverPinnedToBoxAdapter -- $index'))),
        ),
        SliverList(
            delegate: SliverChildListDelegate(_colors.builderEntry(
                (MapEntry<int, Color> entry) => _Item(entry.key, entry.value))))
      ]));
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
  const _DraggableScrollbar(this.scrollController, {Key key}) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final ScrollList list = ScrollList.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        itemCount: _colors.length,
        itemBuilder: (_, int index) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            color: _colors[index],
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
