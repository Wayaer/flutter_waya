import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() =>
    runApp(OverlayMaterial(
      title: 'Waya Demo',
      home: Home(),
    ));

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      appBar: AppBar(title: Text('Waya Demo'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
              opacity: 0.9,
              curve: Curves.easeInCirc,
              duration: Duration(seconds: 5),
              onEnd: () {
                print('动画结束');
              },
              child: CustomButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                background: Colors.greenAccent,
                text: '弹窗', onTap: () {
                showAlert();
              },)
          ),
        ],),);
  }

  showAlert() {
    AlertTools.alertSureCancel(Text('显示几个文职',
      style: TextStyle(color: Colors
          .red)
      ,),
        animatedOpacity: true,
        gaussian: true,
        sureTap:
            () {

        }, cancelTap: () {

        });
  }
}
