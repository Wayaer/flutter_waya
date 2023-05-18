import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class _Item extends StatelessWidget {
  const _Item(this.index, this.color);

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 80, color: color);
}

class EasyRefreshPage extends StatefulWidget {
  const EasyRefreshPage({super.key});

  @override
  State<EasyRefreshPage> createState() => _EasyRefreshPageState();
}

class _EasyRefreshPageState extends ExtendedState<EasyRefreshPage> {
  List<Color> colors = <Color>[];

  @override
  void initState() {
    super.initState();
    colors.addAll(Colors.accents);
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('EasyRefreshPage'),
        bottomNavigationBar: Universal(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding: EdgeInsets.fromLTRB(
                10, 10, 10, context.bottomNavigationBarHeight + 10),
            children: [
              ElevatedText('Refresh', onTap: () {
                RefreshControllers().current?.callRefresh();
              }),
              ElevatedText('开启新的页面', onTap: () {
                push(const EasyRefreshPage());
              }),
              ElevatedText('Loading', onTap: () {
                RefreshControllers().current?.callLoad();
                colors.addAll(Colors.accents);
                setState(() {});
              }),
            ]),
        body: DefaultTabController(
          length: 3,
          child: TabBarView(
              children: 3.generate((int index) => EasyRefreshed(
                  config: RefreshConfig(onRefresh: () async {
                    2.seconds.delayed(() {
                      RefreshControllers().call(EasyRefreshType.refreshSuccess);
                    });
                  }, onLoading: () async {
                    2.seconds.delayed(() {
                      if (colors.length > 30) {
                        RefreshControllers().call(EasyRefreshType.loadNoMore);
                        return;
                      }
                      colors.addAll(Colors.accents);
                      setState(() {});
                      RefreshControllers().call(EasyRefreshType.loadingSuccess);
                    });
                  }),
                  builder: (_, physics) =>
                      CustomScrollView(physics: physics, slivers: [
                        SliverToBoxAdapter(
                            child: Universal(
                                padding: const EdgeInsets.all(10),
                                children: colors.builderEntry(
                                    (MapEntry<int, Color> entry) =>
                                        _Item(entry.key, entry.value)
                                            .paddingOnly(bottom: 10))))
                      ])))),
        ));
  }
}
