import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class UniversalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('PinBox Demo'), centerTitle: true),
          mainAxisAlignment: MainAxisAlignment.center,
          isScroll: true,
          children: <Widget>[
            const Universal(width: 50, height: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Universal(
                width: 50, height: 50, color: Colors.blue, size: Size(60, 60)),
            const SizedBox(height: 10),
            Universal(
                color: Colors.blue.withOpacity(0.2),
                isStack: true,
                size: const Size(100, 100),
                children: const <Widget>[
                  Universal(
                      left: 10,
                      top: 10,
                      color: Colors.blue,
                      size: Size(50, 50)),
                ]),
            const SizedBox(height: 10),
            Universal(
                size: const Size(300, 20),
                direction: Axis.horizontal,
                color: Colors.green.withOpacity(0.2),
                children: const <Widget>[
                  Universal(flex: 1, color: Colors.red),
                  Universal(flex: 2, color: Colors.greenAccent),
                ]),
            const SizedBox(height: 10),
            Universal(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              addInkWell: true,
              radius: 100,
              splashColor: Colors.blue,
              highlightColor: Colors.red,
              hoverColor: Colors.black,
              elevation: 5,
              textStyle: const BasisTextStyle(color: Colors.blue),
              child: BasisText('InkWell', color: Colors.blue),
              onLongPress: () => showToast('InkWell onLongPress'),
              onDoubleTap: () => showToast('InkWell onDoubleTap'),
              onTap: () => showToast('InkWell onTap'),
            ),
            const SizedBox(height: 10),
            Universal(
                size: const Size(200, 50),
                shadowColor: Colors.red,
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.withOpacity(0.3),
                elevation: 5,
                addCard: true,
                onDoubleTap: () => showToast('Card onDoubleTap')),
            const SizedBox(height: 10),
            const Universal(
                decoration: BoxDecoration(color: Colors.red),
                clipBehavior: Clip.antiAlias,
                color: Colors.blue,
                opacity: 0.2,
                size: Size(200, 50)),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
          ]);
}
