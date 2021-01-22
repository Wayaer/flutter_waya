import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double percent = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((Duration duration) {
      timer = const Duration(seconds: 1).timerPeriodic((Timer timer) {
        percent += 0.1;
        setState(() {});
        if (percent >= 1) {
          percent = 1;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => OverlayScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('PinBox Demo'), centerTitle: true),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Progress.linear(
                width: 300,
                lineHeight: 20,
                percent: 0.5,
                animation: true,
                isRTL: true,
                animationDuration: const Duration(seconds: 5),
                linearGradient: const LinearGradient(
                    colors: <Color>[Colors.red, Colors.blue]),
                mainAxisAlignment: MainAxisAlignment.center,
                trailing: const Text('LinearProgress',
                    style: TextStyle(color: Colors.white)),
                progressColor: Colors.lightGreen,
                backgroundColor: Colors.black12,
                widgetIndicator:
                    Container(width: 20, height: 20, color: Colors.amber)),
            const SizedBox(height: 20),
            const Progress.circular(
                radius: 120,
                lineWidth: 15,
                animation: true,
                percent: 0.7,
                arcType: ArcType.full,
                arcBackgroundColor: Colors.cyan,
                center: Text('70.0%',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                footer: Text('CircularProgress',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                circularStrokeCap: CircularStrokeCap.round,
                linearGradient:
                    LinearGradient(colors: <Color>[Colors.red, Colors.blue]))
          ]);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
