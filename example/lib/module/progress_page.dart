import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class FlProgressPage extends StatefulWidget {
  const FlProgressPage({super.key});

  @override
  State<FlProgressPage> createState() => _FlProgressPageState();
}

class _FlProgressPageState extends State<FlProgressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  StateSetter? liquidProgressState;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: 10.seconds, vsync: this);
    _animationController.repeat();
    _animationController.addListener(() {
      if (mounted) liquidProgressState?.call(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('FlProgress'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          FlProgress.linear(
              width: 300,
              lineHeight: 20,
              percent: 1,
              animation: true,
              restartAnimation: true,
              animationDuration: const Duration(seconds: 10),
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
          StatefulBuilder(builder: (context, setState) {
            liquidProgressState ??= setState;
            return Column(children: [
              SizedBox.fromSize(
                  size: const Size(150, 30),
                  child: LiquidProgressIndicator.linear(
                      borderColor: Colors.blue,
                      borderWidth: 2,
                      borderRadius: 10,
                      color: Colors.deepPurpleAccent,
                      value: _animationController.value)),
              const SizedBox(height: 20),
              LiquidProgressIndicator.circular(
                      borderColor: Colors.blue,
                      borderWidth: 2,
                      value: _animationController.value,
                      color: Colors.deepPurpleAccent)
                  .setSize(const Size(150, 150)),
              const SizedBox(height: 20),
              LiquidProgressIndicator.custom(
                  value: _animationController.value,
                  color: Colors.deepPurpleAccent,
                  direction: Axis.vertical,
                  shapePath: _buildBoatPath()),
              const SizedBox(height: 20),
              LiquidProgressIndicator.custom(
                  value: _animationController.value,
                  direction: Axis.horizontal,
                  color: Colors.deepPurpleAccent,
                  shapePath: _buildSpeechBubblePath()),
              const SizedBox(height: 20),
              LiquidProgressIndicator.custom(
                  color: Colors.deepPurpleAccent,
                  value: _animationController.value,
                  direction: Axis.vertical,
                  shapePath: _buildHeartPath()),
              const SizedBox(height: 20),
              const SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: FlAnimationWave(
                      value: 0.5,
                      color: Colors.deepPurpleAccent,
                      direction: Axis.vertical))
            ]);
          })
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
