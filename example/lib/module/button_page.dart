import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

const List<String> _colors = <String>['红色', '黄色', '蓝色'];

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Button Demo'), centerTitle: true),
          children: <Widget>[
            const SizedBox(height: 20),
            CustomElastic('ElasticButton',
                onTap: () => showToast('ElasticButton')),
            const SizedBox(height: 20),
            CustomElastic('BubbleButton',
                onTap: () => push(_BubbleButtonPage())),
            const SizedBox(height: 40),
            const ClothButton.rectangle(
                size: Size(200, 60), backgroundColor: Colors.blue),
            const SizedBox(height: 20),
            const ClothButton.round(
                size: Size(200, 60), backgroundColor: Colors.blue),
            const SizedBox(height: 40),
            const LiquidButton(
                width: 200, height: 60, backgroundColor: Colors.blue),
            const SizedBox(height: 40),
            DropdownMenuButton(
              defaultBuilder: (int index) {
                return Universal(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4)),
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      BasisText(index == null ? '请选择' : _colors[index],
                          color: Colors.white),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ]);
              },
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(4)),
              margin: const EdgeInsets.only(top: 2),
              itemCount: _colors.length,
              onChanged: (int index) {
                showToast('点击了${_colors[index]}');
              },
              itemBuilder: (int index) => Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))),
                  child: BasisText(_colors[index])),
            )
          ]);
}

class _BubbleButtonPage extends StatelessWidget {
  final double size = 40.0;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        appBar: AppBar(title: const Text('Bubble')),
        padding: const EdgeInsets.symmetric(vertical: 40),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          BubbleButton(
              size: size,
              onTap: (bool value) async => !value,
              bubbleBuilder: (bool value) => Universal(
                  isOval: true,
                  alignment: Alignment.center,
                  color: value ? Colors.blue : Colors.grey,
                  child: BasisText('点击', color: Colors.white))),
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
