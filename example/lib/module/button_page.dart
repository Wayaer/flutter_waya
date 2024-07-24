import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

const List<String> _colors = ['红色', '黄色黄色', '蓝色'];
const Map<String, List<String>> _popupMenus = {
  '性别': ['男', '女'],
  '年龄': ['12岁', '13岁', '14岁'],
  '地区': ['湖北', '四川', '重庆']
};

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? selected;
    return ExtendedScaffold(
        isScroll: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        appBar: AppBarText('Button'),
        children: [
          const Partition('MultiPopupMenuButton'),
          MultiPopupMenuButton<String, String>(
              onSelected: (_, String label, String? value) {
            showToast('label：$label    item: $value');
          }, menus: _popupMenus.entriesMapToList((menusItem) {
            return MultiPopupMenuButtonItem<String, String>(
                key: menusItem.key,
                builder: (BuildContext context,
                    String key,
                    String? value,
                    VoidCallback onOpened,
                    VoidCallback onCanceled,
                    PopupMenuItemSelected<String> onSelected) {
                  return Expanded(
                      child: PopupMenuButton<String>(
                          initialValue: value ?? menusItem.value.first,
                          onCanceled: onCanceled,
                          onOpened: onOpened,
                          onSelected: onSelected,
                          position: PopupMenuPosition.under,
                          child: Universal(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              color: Colors.red.withOpacity(0.2),
                              direction: Axis.horizontal,
                              children: [
                                Text(value ?? key).expanded,
                                10.widthBox,
                                const Icon(
                                    Icons.arrow_drop_down_circle_outlined),
                              ]),
                          itemBuilder: (_) => menusItem.value.builder(
                              (item) => buildPopupMenuItem(context, item))));
                });
          })),
          10.heightBox,
          MultiPopupMenuButton<String, String>(
              onSelected: (_, String label, String? value) {
            showToast('label：$label    item: $value');
          }, menus: _popupMenus.entriesMapToList((menusItem) {
            return MultiPopupMenuButtonItem<String, String>(
                key: menusItem.key,
                builder: (BuildContext context,
                    String key,
                    String? value,
                    VoidCallback onOpened,
                    VoidCallback onCanceled,
                    PopupMenuItemSelected<String> onSelected) {
                  return PopupMenuButtonRotateBuilder(
                      turns: 0.5,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      builder:
                          (_, Widget rotateIcon, onRotateOpened, onClosed) {
                        return Expanded(
                            child: PopupMenuButton<String>(
                                initialValue: value,
                                onCanceled: () {
                                  onCanceled();
                                  onClosed();
                                },
                                onOpened: () {
                                  onOpened();
                                  onRotateOpened();
                                },
                                onSelected: (v) {
                                  onSelected(v);
                                  onClosed();
                                },
                                position: PopupMenuPosition.under,
                                child: Universal(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    color: Colors.red.withOpacity(0.2),
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(value ?? key).expanded,
                                      10.widthBox,
                                      rotateIcon
                                    ]),
                                itemBuilder: (_) => menusItem.value.builder(
                                    (item) =>
                                        buildPopupMenuItem(context, item))));
                      });
                });
          })),
          const Partition('PopupMenuButtonRotateBuilder'),
          PopupMenuButtonRotateBuilder(
              turns: 0.25,
              icon: const Icon(Icons.arrow_circle_right_outlined),
              builder: (_, Widget rotate, onOpened, onClosed) {
                return PopupMenuButton(
                    onCanceled: onClosed,
                    onOpened: onOpened,
                    position: PopupMenuPosition.under,
                    onSelected: (value) {
                      selected = value;
                      onClosed();
                    },
                    itemBuilder: (_) => _colors
                        .builder((item) => buildPopupMenuItem(context, item)),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(children: [
                          const Icon(Icons.ac_unit),
                          10.widthBox,
                          Text(selected ?? '请选择',
                                  style: context.textTheme.labelLarge)
                              .expanded,
                          10.widthBox,
                          rotate,
                        ])));
              }),
          const Partition('ElasticButton'),
          ElevatedText('ElasticButton', onTap: () {}),
          const Partition('BubbleButton'),
          ElevatedText('BubbleButton', onTap: () => push(_BubbleButtonPage())),
        ]);
  }

  PopupMenuItem<String> buildPopupMenuItem(BuildContext context, String item) =>
      PopupMenuItem<String>(
          value: item, child: Text(item, style: context.textTheme.bodyMedium));
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
                  size: size)),
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
