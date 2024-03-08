import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const List<String> _colors = ['红色', '黄色黄色', '蓝色'];

const Map<String, List<String>> _dropdownValue = {
  '性别': ['男', '女'],
  '年龄': ['12岁', '13岁', '14岁'],
  '地区': ['湖北', '四川', '重庆']
};

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          appBar: AppBarText('Button'),
          children: [
            DropdownMenusButton<String, String>(
                shape: const RoundedRectangleBorder(),
                offset: const Offset(0, 10),
                onSelected: (String label, String? value) {
                  showToast('label：$label    item: $value');
                },
                menus: _dropdownValue.builderEntry((item) {
                  return DropdownMenusItem<String, String>(
                      value: item.key,
                      icon: const Icon(Icons.arrow_circle_up_rounded),
                      builder: (String? value, Widget? icon) => Universal(
                              direction: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8)),
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: BText(value ?? item.key,
                                        style: context.textTheme.titleMedium)),
                                if (icon != null) icon,
                              ]),
                      itemBuilder: (_, String? current, updater) =>
                          item.value.builder((item) {
                            final isSelected = current == item;
                            return PopupMenuItem<String>(
                                value: item,
                                child: Center(
                                  child: BText(item,
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                              color: isSelected
                                                  ? Colors.red
                                                  : null)),
                                ));
                          }));
                })),
            const SizedBox(height: 20),
            ElevatedText('ElasticButton', onTap: () {}),
            const SizedBox(height: 20),
            DropdownMenuButton<String>(
                initialValue: _colors.first,
                constraints: const BoxConstraints(minWidth: double.infinity),
                offset: const Offset(0, 15),
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                builder: (String? value, Widget? icon) {
                  final current = BText(value ?? '请选择',
                      style: context.textTheme.labelLarge);
                  return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4)),
                      child: icon == null
                          ? current
                          : Row(children: [
                              const Icon(Icons.ac_unit),
                              10.widthBox,
                              current.expanded,
                              10.widthBox,
                              icon,
                            ]));
                },
                onSelected: (String value) {
                  showToast('点击了$value');
                },
                icon: const Icon(Icons.arrow_right_rounded),
                itemBuilder: (_, String? current, __) => _colors.builder(
                    (item) => PopupMenuItem<String>(
                        value: item,
                        child:
                            BText(item, style: context.textTheme.bodyMedium)))),
            const SizedBox(height: 20),
            ElevatedText('BubbleButton',
                onTap: () => push(_BubbleButtonPage())),
          ]);
}

class _BubbleButtonPage extends StatelessWidget {
  final double size = 40.0;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('Bubble'),
        padding: const EdgeInsets.symmetric(vertical: 40),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BubbleButton(
              size: size,
              onTap: (bool value) async => !value,
              builder: (bool value) => Universal(
                  isOval: true,
                  alignment: Alignment.center,
                  color: value ? context.theme.primaryColor : Colors.grey,
                  child: const BText('点击', color: Colors.white))),
          BubbleButton(
              size: size,
              onTap: (bool isBubbled) async => !isBubbled,
              builder: (bool isBubbled) => Icon(Icons.ac_unit,
                  size: size, color: isBubbled ? Colors.red : Colors.black38)),
          BubbleButton(
            size: size,
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubbleColor: const BubbleColor(
                dotFirstColor: Color(0xff33b5e5),
                dotSecondColor: Color(0xff0099cc)),
            builder: (bool value) => Icon(Icons.error,
                color: value ? Colors.deepPurpleAccent : Colors.grey,
                size: size),
          ),
          BubbleButton(
              size: size,
              circleColor: const CircleColor(
                  start: Color(0xff669900), end: Color(0xff669900)),
              bubbleColor: const BubbleColor(
                  dotFirstColor: Color(0xff669900),
                  dotSecondColor: Color(0xff99cc00)),
              builder: (bool value) => Icon(Icons.add_alert_outlined,
                  color: value ? Colors.green : Colors.grey, size: size)),
        ]);
  }
}
