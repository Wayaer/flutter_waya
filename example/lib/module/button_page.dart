import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

const List<String> _colors = <String>['红色', '黄色', '蓝色'];

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          backgroundColor: Colors.white,
          isScroll: true,
          appBar: AppBarText('Button Demo'),
          children: <Widget>[
            const DropdownMenu(
              value: <List<String>>[
                <String>['男', '女'],
                <String>['12岁', '13岁', '14岁'],
                <String>['湖北', '四川', '重庆']
              ],
              title: <String>['性别', '年龄', '地区'],
            ),
            const SizedBox(height: 20),
            ElevatedText('ElasticButton',
                onTap: () => showToast('ElasticButton')),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              DropdownMenuButton(
                defaultBuilder: (int index) {
                  return BText(index == null ? '请选择' : _colors[index],
                      color: Colors.black);
                },
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(4)),
                margin: const EdgeInsets.only(top: 2),
                itemCount: _colors.length,
                onChanged: (int index) {
                  showToast('点击了${_colors[index]}');
                },
                toggle:
                    const Icon(Icons.arrow_right_rounded, color: Colors.black),
                itemBuilder: (int index) => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: BText(_colors[index])),
              ),
              const SizedBox(width: 30),
              DropdownButton<String>(
                  value: _colors[0],
                  onChanged: (String value) {},
                  items: _colors.builder((String item) =>
                      DropdownMenuItem<String>(
                          value: item, child: Text(item)))),
              const SizedBox(width: 30),
              DropdownMenuButton.material(
                  itemBuilder: (int index) =>
                      BText(_colors[index], color: Colors.black),
                  itemCount: _colors.length,
                  defaultBuilder: (int index) {
                    return BText(index == null ? '请选择' : _colors[index],
                            color: Colors.black)
                        .paddingSymmetric(vertical: 10);
                  })
            ]),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            SimpleButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                text: 'SimpleButton',
                textStyle: const TextStyle(color: color),
                borderRadius: BorderRadius.circular(4),
                onTap: () {}),
            const SizedBox(height: 20),
            ElevatedText('BubbleButton',
                onTap: () => push(_BubbleButtonPage())),
            const SizedBox(height: 40),
            const ClothButton.rectangle(
                size: Size(200, 60), backgroundColor: color),
            const SizedBox(height: 20),
            const ClothButton.round(
                size: Size(200, 60), backgroundColor: color),
            const SizedBox(height: 40),
            const LiquidButton(width: 200, height: 60, backgroundColor: color),
            const SizedBox(height: 40),
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
        children: <Widget>[
          BubbleButton(
              size: size,
              onTap: (bool value) async => !value,
              bubbleBuilder: (bool value) => Universal(
                  isOval: true,
                  alignment: Alignment.center,
                  color: value ? color : Colors.grey,
                  child: BText('点击', color: Colors.white))),
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
