import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          appBar: AppBarText('Components'),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Partition('Shimmery', marginTop: 0),
            Shimmery(
                color: Colors.yellow,
                colorOpacity: 0.9,
                child: Universal(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(9)),
                    child: const BText('Shimmery', color: Colors.white))),
            const Partition('Wrapper'),
            const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Wrapper(
                      formEnd: true,
                      elevation: 1,
                      child: Text('this is Wrapper',
                          style: TextStyle(color: Colors.white))),
                  Wrapper(
                      formEnd: true,
                      elevation: 1,
                      style: SpineStyle.right,
                      child: Text('this is Wrapper',
                          style: TextStyle(color: Colors.white))),
                ]),
            const Partition('ExpansionTiles'),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExpansionTile(
                title: const BText('Tile'),
                backgroundColor: context.theme.primaryColor.withOpacity(0.2),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: BText('item$index'))),
              ).expanded,
              ExpansionTiles(
                icon: (bool isExpanded) => Icon(Icons.expand_more,
                    color: isExpanded ? context.theme.primaryColor : null),
                builder: (BuildContext context, GestureTapCallback onTap,
                    bool isExpanded, Widget? rotation) {
                  return ListTile(
                      onTap: onTap,
                      title: const BText('Tile'),
                      trailing: rotation);
                },
                backgroundColor: context.theme.primaryColor.withOpacity(0.2),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: BText('item$index'))),
              ).expanded,
            ]),
            const Partition('CounterAnimation'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CounterAnimation(
                  style: CountAnimationStyle.part,
                  count: 100,
                  onTap: (int c) {},
                  builder: (int count, String text) =>
                      BText(text, fontSize: 30)),
              CounterAnimation(
                  style: CountAnimationStyle.all,
                  count: 100,
                  onTap: (int c) {},
                  builder: (int count, String text) =>
                      BText(text, fontSize: 30))
            ]),
            const Partition('ToggleRotate'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ToggleRotate(
                  duration: const Duration(milliseconds: 500),
                  turns: 0.5,
                  onChanged: (bool value) {
                    log('ToggleRotate 0.5 : $value');
                  },
                  builder: (Widget child, rotate) =>
                      GestureDetector(onTap: rotate, child: child),
                  icon: (bool value) => Icon(
                        Icons.accessibility_sharp,
                        size: 30,
                        color: value ? context.theme.primaryColor : null,
                      )),
              ToggleRotate(
                  duration: const Duration(seconds: 1),
                  turns: 1,
                  onChanged: (bool value) {
                    log('ToggleRotate 1 : $value');
                  },
                  builder: (Widget child, rotate) =>
                      GestureDetector(onTap: rotate, child: child),
                  icon: (bool value) => Icon(
                        Icons.accessibility_sharp,
                        size: 30,
                        color: value ? context.theme.primaryColor : null,
                      )),
              ToggleRotate(
                  duration: const Duration(seconds: 2),
                  turns: 1.5,
                  onChanged: (bool value) {
                    log('ToggleRotate 1.5 : $value');
                  },
                  builder: (Widget child, rotate) =>
                      GestureDetector(onTap: rotate, child: child),
                  icon: (bool value) => Icon(
                        Icons.accessibility_sharp,
                        size: 30,
                        color: value ? context.theme.primaryColor : null,
                      )),
            ]),
            const Partition('DottedLine'),
            Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: DottedLineBorder.all(
                        color: context.theme.dividerColor)),
                child: CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DottedLinePainter(
                        color: context.theme.dividerColor,
                        strokeWidth: 1,
                        gap: 20))),
            const Partition('RatingStars'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              RatingStars(
                  value: 2.2,
                  starSpacing: 4,
                  builder: (bool selected) => Icon(Icons.star,
                      color: selected ? Colors.yellow : Colors.grey)),
              RatingStars(
                  value: 3.3,
                  starSpacing: 4,
                  builder: (bool selected) => Icon(Icons.star,
                      color: selected ? Colors.yellow : Colors.grey)),
            ]),
            const SizedBox(height: 100),
          ]);
}
