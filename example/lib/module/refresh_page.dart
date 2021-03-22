import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/widgets/refresh/simple_refresh.dart';

class RefreshPage extends StatefulWidget {
  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  final List<Color> colors = <Color>[];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    colors.addAll(Colors.accents);
    colors.addAll(Colors.accents);
    colors.addAll(Colors.accents);
    colors.addAll(Colors.accents);
    colors.addAll(Colors.accents);
    colors.addAll(Colors.accents);
    // colors.addAll(Colors.accents.sublist(0, 6));
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar:
            AppBar(title: const Text('RefreshPage Demo'), centerTitle: true),
        body: SimpleRefresh(
            onRefresh: () {



            },
            child: ScrollList.builder(
                padding: const EdgeInsets.all(10),
                itemBuilder: (_, int index) =>
                    _Item(index, colors[index]).paddingOnly(bottom: 10),
                itemCount: colors.length)));
  }
}

class _Item extends StatelessWidget {
  const _Item(this.index, this.color);

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 80, color: color);
}
