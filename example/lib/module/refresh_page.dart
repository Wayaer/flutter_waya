import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class RefreshPage extends StatefulWidget {
  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  List<Color> colors = <Color>[];
  final RefreshController controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    // colors.addAll(Colors.accents);
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar:
            AppBar(title: const Text('RefreshPage Demo'), centerTitle: true),
        body: SimpleRefresh(
          controller: controller,
          onRefresh: () {
            3.seconds.delayed(() {
              sendSimpleRefreshType(RefreshType.refreshCompleted);
              showToast('刷新完成');
            });
          },
          onLoading: () {
            3.seconds.delayed(() {
              showToast('加载失败');
              sendSimpleRefreshType(RefreshType.loadFailed);
            });
          },
          child: ScrollList.builder(
              padding: const EdgeInsets.all(10),
              itemBuilder: (_, int index) =>
                  _Item(index, colors[index]).paddingOnly(bottom: 10),
              itemCount: colors.length),
        ));
  }
}

class _Item extends StatelessWidget {
  const _Item(this.index, this.color);

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 80, color: color);
}

class EasyRefreshPage extends StatefulWidget {
  @override
  _EasyRefreshPageState createState() => _EasyRefreshPageState();
}

class _EasyRefreshPageState extends State<EasyRefreshPage> {
  List<Color> colors = <Color>[];
  final RefreshController controller = RefreshController();

  @override
  void initState() {
    super.initState();
    colors.addAll(Colors.accents);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('EasyRefreshPage Demo'), centerTitle: true),
        bottomNavigationBar: Universal(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding: EdgeInsets.fromLTRB(
                10, 10, 10, getBottomNavigationBarHeight + 10),
            children: <Widget>[
              CustomElastic('Refresh', onTap: () {
                sendRefreshType(EasyRefreshType.refresh);
              }),
              CustomElastic('开启新的页面', onTap: () {
                push(EasyRefreshPage());
              }),
              CustomElastic('Loading', onTap: () {
                sendRefreshType(EasyRefreshType.loading);
                colors.addAll(Colors.accents);
                setState(() {});
              }),
            ]),
        body: DefaultTabController(
          length: 3,
          child: TabBarView(
            children: 3.generate(
              (int index) => EasyRefreshed(
                onRefresh: () async {
                  2.seconds.delayed(() {
                    sendRefreshType(EasyRefreshType.refreshSuccess);
                  });
                },
                onLoading: () async {
                  2.seconds.delayed(() {
                    colors.addAll(Colors.accents);
                    setState(() {});
                    sendRefreshType(EasyRefreshType.loadingSuccess);
                  });
                },
                slivers: <Widget>[
                  SliverToBoxAdapter(
                      child: Universal(
                          padding: const EdgeInsets.all(10),
                          children: colors.builderEntry(
                              (MapEntry<int, Color> entry) =>
                                  _Item(entry.key, entry.value)
                                      .paddingOnly(bottom: 10))))
                ],
              ),
            ),
          ),
        ));
  }
}
