import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListWheelPage extends StatefulWidget {
  const ListWheelPage({Key? key}) : super(key: key);

  @override
  State<ListWheelPage> createState() => _ListWheelPageState();
}

class _ListWheelPageState extends ExtendedState<ListWheelPage> {
  final numberList = ['一', '二', '三', '四', '五', '六', '七', '八', '十'];

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ListWheel'),
        isScroll: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('ListWheel.builder'),
          addBackboard(ListWheel.builder(
              onSelectedItemChanged: (_) {
                'ListWheel.builder : $_'.log();
              },
              itemBuilder: (_, int index) => BText(numberList[index]),
              itemCount: numberList.length)),
          const Partition('ListWheel.count'),
          addBackboard(ListWheel.count(
              options: const WheelOptions(),
              onSelectedItemChanged: (_) {
                'ListWheel.count : $_'.log();
              },
              children: numberList.builder((item) => BText(item)))),
          const Partition('ListWheelState.builder'),
          addBackboard(ListWheelState(
              count: numberList.length,
              initialItem: 5,
              builder: (_) => ListWheel.builder(
                  controller: _,
                  onSelectedItemChanged: (_) {
                    'ListWheelState.builder : $_'.log();
                  },
                  itemBuilder: (_, int index) => BText(numberList[index]),
                  itemCount: numberList.length))),
          const Partition('ListWheelState.builder'),
          addBackboard(ListWheelState(
              initialItem: 5,
              count: numberList.length,
              builder: (_) => ListWheel.count(
                  controller: _,
                  options: const WheelOptions(),
                  onSelectedItemChanged: (_) {
                    'ListWheelState.builder : $_'.log();
                  },
                  children: numberList.builder((item) => BText(item))))),
        ]);
  }

  Widget addBackboard(Widget child) => Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      height: 150,
      width: 230,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: getBoxShadow(), borderRadius: BorderRadius.circular(12)),
      child: child);
}
