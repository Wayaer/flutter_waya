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
          ElevatedText('ScrollList.builder with separated',
              onTap: () => push(_ScrollListSeparatedPage(scrollController))),
          ElevatedText('ScrollList.builder with GridStyle.none',
              onTap: () =>
                  push(_ScrollListGridPage(scrollController, GridStyle.none))),
          ElevatedText('ScrollList.builder with GridStyle.masonry',
              onTap: () => push(
                  _ScrollListGridPage(scrollController, GridStyle.masonry))),
          ElevatedText('ScrollList.builder with GridStyle.aligned',
              onTap: () => push(
                  _ScrollListGridPage(scrollController, GridStyle.aligned))),
          ElevatedText('ScrollList.count',
              onTap: () => push(_ScrollListCountPage(scrollController))),
          ElevatedText('ScrollList.builder with placeholder',
              onTap: () => push(_ScrollListPlaceholderPage(scrollController))),
        ]);
  }
}

class _ScrollListGridPage extends StatelessWidget {
  const _ScrollListGridPage(this.scrollController, this.gridStyle);

  final ScrollController scrollController;
  final GridStyle gridStyle;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.builder with GridStyle'),
        child: ScrollList.builder(
          gridStyle: gridStyle,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxCrossAxisExtent: gridStyle == GridStyle.aligned ? null : 100,
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          header: const _Header(),
          footer: const _Footer(),
          padding: const EdgeInsets.all(10),
          refreshConfig: _RefreshConfig(),
          itemCount: [...colors, ...colors, ...colors].length,
          itemBuilder: (_, int index) {
            if (gridStyle == GridStyle.aligned) {
              return ColorEntry(index, [...colors, ...colors, ...colors][index],
                  height: index & 3 == 0 ? 100 : 40);
            }
            return ColorEntry(index, [...colors, ...colors, ...colors][index],
                width: index.isEven ? 40 : 100,
                height: index.isEven ? 100 : 40);
          },
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
        child: ScrollList.builder(
          header: const _Header(),
          footer: const _Footer(),
          padding: const EdgeInsets.all(10),
          refreshConfig: _RefreshConfig(),
          itemCount: colors.length,
          itemBuilder: (_, int index) =>
              ColorEntry(index, colors[index]).paddingSymmetric(vertical: 5),
          separatorBuilder: (_, int index) => const Divider(
              color: Colors.amberAccent, height: 30, thickness: 10),
        ));
  }
}

class _ScrollListPlaceholderPage extends StatelessWidget {
  const _ScrollListPlaceholderPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.builder with placeholder'),
        child: ScrollList.builder(
            header: const _Header(),
            footer: const _Footer(),
            padding: const EdgeInsets.all(10),
            refreshConfig: _RefreshConfig(),
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
        child: ScrollList.builder(
          header: const _Header(),
          footer: const _Footer(),
          padding: const EdgeInsets.all(10),
          refreshConfig: _RefreshConfig(),
          itemBuilder: (_, int index) =>
              ColorEntry(index, index.isEven ? colors.first : colors.last)
                  .paddingOnly(bottom: 10),
        ));
  }
}

class _ScrollListPage extends StatelessWidget {
  const _ScrollListPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList'),
        child: ScrollList(
            padding: const EdgeInsets.all(10),
            header: const _Header(),
            footer: const _Footer(),
            refreshConfig: _RefreshConfig(),
            sliver: [
              const _SliverTitle('SliverListGrid builder'),
              SliverListGrid.builder(
                  itemCount: colors.length,
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index]).paddingOnly(bottom: 10)),
              const _SliverTitle(
                  'SliverListGrid.builder with GridStyle.aligned'),
              SliverListGrid.builder(
                  gridStyle: GridStyle.aligned,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: colors.length,
                  itemBuilder: (_, int index) => ColorEntry(
                      index, colors[index],
                      height: index & 3 == 0 ? 80 : 40)),
              const _SliverTitle('SliverListGrid.count with GridStyle.masonry'),
              SliverListGrid.count(
                  gridStyle: GridStyle.masonry,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: colors.builderEntry((entry) => ColorEntry(
                      entry.key, entry.value,
                      height: entry.key.isEven ? 100 : 70,
                      width: entry.key.isEven ? 50 : 100))),
              const _SliverTitle(
                  'SliverListGrid.builder with GridStyle.masonry'),
              SliverListGrid.builder(
                  gridStyle: GridStyle.masonry,
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: colors.length,
                  itemBuilder: (_, int index) => ColorEntry(
                      index, colors[index],
                      height: index.isEven ? 100 : 70,
                      width: index.isEven ? 50 : 100)),
              const _SliverTitle(
                  'SliverListGrid.builder with maxCrossAxisExtent'),
              SliverListGrid.builder(
                  itemCount: colors.length,
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index]).paddingOnly(bottom: 10)),
              const _SliverTitle('SliverListGrid.builder with crossAxisCount'),
              SliverListGrid.builder(
                  itemCount: colors.length,
                  crossAxisCount: 8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index]).paddingOnly(bottom: 10)),
              const _SliverTitle(
                  'SliverListGrid.builder with separatorBuilder'),
              SliverListGrid.builder(
                  itemCount: colors.length,
                  separatorBuilder: (_, int index) =>
                      Divider(color: colors[index], thickness: 10, height: 20),
                  itemBuilder: (_, int index) =>
                      ColorEntry(index, colors[index])),
            ]));
  }
}

class _SliverTitle extends StatelessWidget {
  const _SliverTitle(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
      child: Container(
          alignment: Alignment.center,
          color: colors[14],
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: BText(title, color: Colors.white)));
}

class _ScrollListCountPage extends StatelessWidget {
  const _ScrollListCountPage(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.count'),
        child: ScrollList.count(
            header: const _Header(),
            footer: const _Footer(),
            padding: const EdgeInsets.all(10),
            refreshConfig: _RefreshConfig(),
            children: colors.builderEntry((MapEntry<int, Color> entry) =>
                ColorEntry(entry.key, entry.value))));
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
          child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 100,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.3),
        child: const Text('Header'),
      ));
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
          child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 100,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.3),
        child: const Text('Footer'),
      ));
}

class _RefreshConfig extends RefreshConfig {
  _RefreshConfig()
      : super(onRefresh: () async {
          await showToast('onRefresh');
          await 2.seconds.delayed(() {
            RefreshControllers().call(EasyRefreshType.refreshSuccess);
          });
        }, onLoading: () async {
          await showToast('onLoading');
          await 2.seconds.delayed(() {
            RefreshControllers().call(EasyRefreshType.loadingSuccess);
          });
        });
}
