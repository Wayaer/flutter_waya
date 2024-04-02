import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

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

class AutoCollapsingPage extends StatefulWidget {
  const AutoCollapsingPage({super.key, this.direction = Axis.vertical});

  final Axis direction;

  @override
  State<AutoCollapsingPage> createState() => _AutoCollapsingPageState();
}

class _AutoCollapsingPageState extends State<AutoCollapsingPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isStack: true,
        appBar: AppBarText('AutoCollapsing'),
        mainAxisAlignment: MainAxisAlignment.center,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          ListView.builder(
              controller: controller,
              itemCount: colorList.length,
              itemBuilder: (BuildContext context, int index) => ColorEntry(
                  index, colorList[index],
                  height: index & 3 == 0 ? 80 : 40)).expand,
          Padding(
              padding: const EdgeInsets.all(20),
              child: AutoCollapsingBuilder(
                  controller: controller,
                  minSize: 20,
                  direction: widget.direction,
                  maxSize: 300,
                  child: Container(
                    height: widget.direction == Axis.horizontal ? 300 : null,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  )))
        ]);
  }
}
