import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const List<String> _colors = <String>['红色', '黄色黄色', '蓝色'];

const Map<String, List<String>> _dropdownValue = <String, List<String>>{
  '性别': <String>['男', '女'],
  '年龄': <String>['12岁', '13岁', '14岁'],
  '地区': <String>['湖北', '四川', '重庆']
};

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          padding: const EdgeInsets.all(20),
          appBar: AppBarText('Button'),
          children: [
            DropdownMenus(
                isModal: true,
                onTap: (int title, int? value) {
                  if (value == null) {
                    showToast(
                        '点击了title：${_dropdownValue.keys.elementAt(title)}');
                  } else {
                    showToast(
                        '点击了title：${_dropdownValue.keys.elementAt(title)} value: ${_dropdownValue.values.elementAt(title)[value]}');
                  }
                },
                decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(10)),
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                value:
                    _dropdownValue.values.builder((List<String> item) => item),
                title: _dropdownValue.keys.toList()),
            DropdownMenus.custom(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(10)),
                titleCount: _dropdownValue.keys.length,
                titleBuilder: (_, int index, bool visible) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: BText(_dropdownValue.keys.elementAt(index),
                          style: context.textTheme.titleMedium));
                },
                valueCount: _dropdownValue.values
                    .builder((List<String> item) => item.length),
                label: (bool visible) =>
                    const Icon(Icons.arrow_circle_up, size: 16),
                valueBuilder: (_, int titleIndex, int valueIndex) {
                  return Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                          color: context.theme.dialogBackgroundColor,
                          border: const Border(
                              top: BorderSide(color: Colors.black12))),
                      child: BText(
                          _dropdownValue.values
                              .elementAt(titleIndex)[valueIndex],
                          style: context.textTheme.bodyLarge));
                }),
            const SizedBox(height: 20),
            ElevatedText('ElasticButton',
                onTap: () => showToast('ElasticButton')),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              DropdownMenuButton(
                  defaultBuilder: (int? index) {
                    return BText(index == null ? '请选择' : _colors[index],
                        style: context.textTheme.labelLarge);
                  },
                  margin: const EdgeInsets.only(top: 2),
                  itemCount: _colors.length,
                  onChanged: (int index) {
                    showToast('点击了${_colors[index]}');
                  },
                  toggle: const Icon(Icons.arrow_right_rounded),
                  itemBuilder: (int index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: BText(_colors[index],
                          fontSize: 14, style: context.textTheme.bodyMedium))),
              DropdownButton<String>(
                  value: _colors[0],
                  onChanged: (String? value) {},
                  items: _colors.builder((String item) =>
                      DropdownMenuItem<String>(
                          value: item, child: Text(item)))),
              DropdownMenuButton.material(
                  itemBuilder: (int index) => BText(_colors[index],
                      style: context.textTheme.bodyMedium),
                  itemCount: _colors.length,
                  defaultBuilder: (int? index) {
                    return BText(index == null ? '请选择' : _colors[index],
                            style: context.textTheme.labelLarge)
                        .paddingSymmetric(vertical: 10);
                  })
            ]),
            const SizedBox(height: 40),
            SimpleButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                text: 'SimpleButton',
                textStyle: const BTextStyle(),
                borderRadius: BorderRadius.circular(4),
                onTap: () {}),
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
              bubbleBuilder: (bool value) => Universal(
                  isOval: true,
                  alignment: Alignment.center,
                  color: value ? context.theme.primaryColor : Colors.grey,
                  child: const BText('点击', color: Colors.white))),
          BubbleButton(
              size: size,
              onTap: (bool isBubbled) async => !isBubbled,
              bubbleBuilder: (bool isBubbled) => Icon(Icons.ac_unit,
                  size: size, color: isBubbled ? Colors.red : Colors.black38)),
          BubbleButton(
            size: size,
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubbleColor: const BubbleColor(
                dotFirstColor: Color(0xff33b5e5),
                dotSecondColor: Color(0xff0099cc)),
            bubbleBuilder: (bool value) => Icon(Icons.error,
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
              bubbleBuilder: (bool value) => Icon(Icons.add_alert_outlined,
                  color: value ? Colors.green : Colors.grey, size: size)),
        ]);
  }
}
