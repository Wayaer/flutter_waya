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
                colors: [
                  Colors.transparent,
                  Colors.yellow.withValues(alpha: 0.05),
                  Colors.yellow.withValues(alpha: 0.9),
                  Colors.yellow.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                child: Universal(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(9)),
                    child: const Text('Shimmery',
                        style: TextStyle(color: Colors.white)))),
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
                title: const Text('Tile'),
                backgroundColor:
                    context.theme.primaryColor.withValues(alpha: 0.2),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: Text('item$index'))),
              ).expanded,
              ExpansionTiles(
                icon: (bool isExpanded) => Icon(Icons.expand_more,
                    color: isExpanded ? context.theme.primaryColor : null),
                builder: (BuildContext context, GestureTapCallback onTap,
                    bool isExpanded, Widget? rotation) {
                  return ListTile(
                      onTap: onTap,
                      title: const Text('Tile'),
                      trailing: rotation);
                },
                backgroundColor:
                    context.theme.primaryColor.withValues(alpha: 0.2),
                children: 5.generate((int index) => Universal(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: Text('item$index'))),
              ).expanded,
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
