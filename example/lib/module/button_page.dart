import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const List<String> _colors = <String>['红色', '黄色黄色', '蓝色'];

const Map<String, List<String>> _dropdownValue = <String, List<String>>{
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
            DropdownMenus<String, String>(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(10)),
                onChanged: (String label, String? value) {
                  showToast('label：$label    item: $value');
                },
                menus: _dropdownValue.builderEntry((item) {
                  return DropdownMenusKeyItem<String, String>(
                      value: item.key,
                      enabled: item.key != '地区',
                      icon: const Icon(Icons.arrow_circle_up_rounded),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          child: BText(item.key,
                              style: context.textTheme.titleMedium)),
                      items: item.value.builder((valueItem) {
                        return DropdownMenusValueItem<String>(
                            value: valueItem,
                            child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: context.theme.dialogBackgroundColor,
                                    border: const Border(
                                        top:
                                            BorderSide(color: Colors.black12))),
                                child: BText(valueItem,
                                    style: context.textTheme.bodyLarge)));
                      }));
                })),
            const SizedBox(height: 20),
            ElevatedText('ElasticButton', onTap: () {}),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              DropdownMenuButton(
                  builder: (int? index) {
                    return BText(index == null ? '请选择' : _colors[index],
                        style: context.textTheme.labelLarge);
                  },
                  margin: const EdgeInsets.only(top: 2),
                  itemCount: _colors.length,
                  onChanged: (int index) {
                    showToast('点击了${_colors[index]}');
                  },
                  icon: const Icon(Icons.arrow_right_rounded),
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
                  builder: (int? index) {
                    return BText(index == null ? '请选择' : _colors[index],
                            style: context.textTheme.labelLarge)
                        .paddingSymmetric(vertical: 10);
                  })
            ]),
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
