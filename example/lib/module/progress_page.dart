import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = _animationController.value * 100;
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('Progress Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Progress.linear(
              width: 300,
              lineHeight: 20,
              percent: 1,
              animation: true,
              restartAnimation: true,
              animationDuration: const Duration(seconds: 2),
              linearGradient: LinearGradient(colors: <Color>[
                Colors.red,
                context.theme.progressIndicatorTheme.color ??
                    context.theme.primaryColor
              ]),
              mainAxisAlignment: MainAxisAlignment.center,
              center: const Text('center'),
              widgetIndicator: const BText('0', color: Colors.red),
              progressColor: Colors.lightGreen,
              backgroundColor: Colors.black12),
          const SizedBox(height: 20),
          SizedBox.fromSize(
              size: const Size(150, 30),
              child: const LiquidProgress.linear(value: 0.4, borderWidth: 1.0)),
          const SizedBox(height: 20),
          SizedBox.fromSize(
              size: const Size(150, 30),
              child: LiquidProgress.linear(
                  value: _animationController.value,
                  center: BText('${percentage.toStringAsFixed(0)}%',
                      style: const BTextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)))),
          const SizedBox(height: 20),
          SizedBox.fromSize(
            size: const Size(80, 80),
            child: LiquidProgress.circular(
                value: _animationController.value,
                center: BText('${percentage.toStringAsFixed(0)}%',
                    style: const BTextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 20),
          SizedBox.fromSize(
              size: const Size(150, 150),
              child: LiquidProgress.circular(
                  color: Colors.deepPurpleAccent,
                  value: _animationController.value,
                  center: BText('${percentage.toStringAsFixed(0)}%',
                      style: const BTextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)))),
          const SizedBox(height: 20),
          LiquidProgress.custom(
              color: Colors.deepPurpleAccent,
              direction: Axis.vertical,
              value: 0.2,
              shapePath: _buildBoatPath()),
          const SizedBox(height: 20),
          LiquidProgress.custom(
              direction: Axis.horizontal,
              color: Colors.deepPurpleAccent,
              backgroundColor: Colors.grey[300],
              shapePath: _buildSpeechBubblePath()),
          const SizedBox(height: 20),
          LiquidProgress.custom(
              color: Colors.deepPurpleAccent,
              value: _animationController.value,
              direction: Axis.vertical,
              shapePath: _buildHeartPath(),
              center: BText('${percentage.toStringAsFixed(0)}%',
                  style: const BTextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))),
          const SizedBox(height: 20),
        ]);
  }

  Path _buildBoatPath() {
    return Path()
      ..moveTo(15, 120)
      ..lineTo(0, 85)
      ..lineTo(50, 85)
      ..lineTo(50, 0)
      ..lineTo(105, 80)
      ..lineTo(60, 80)
      ..lineTo(60, 85)
      ..lineTo(120, 85)
      ..lineTo(105, 120)
      ..close();
  }

  Path _buildSpeechBubblePath() {
    return Path()
      ..moveTo(50, 0)
      ..quadraticBezierTo(0, 0, 0, 37.5)
      ..quadraticBezierTo(0, 75, 25, 75)
      ..quadraticBezierTo(25, 95, 5, 95)
      ..quadraticBezierTo(35, 95, 40, 75)
      ..quadraticBezierTo(100, 75, 100, 37.5)
      ..quadraticBezierTo(100, 0, 50, 0)
      ..close();
  }

  Path _buildHeartPath() {
    return Path()
      ..moveTo(55, 15)
      ..cubicTo(55, 12, 50, 0, 30, 0)
      ..cubicTo(0, 0, 0, 37.5, 0, 37.5)
      ..cubicTo(0, 55, 20, 77, 55, 95)
      ..cubicTo(90, 77, 110, 55, 110, 37.5)
      ..cubicTo(110, 37.5, 110, 0, 80, 0)
      ..cubicTo(65, 0, 55, 12, 55, 15)
      ..close();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
