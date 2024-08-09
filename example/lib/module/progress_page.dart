import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ProgressBarPage extends StatefulWidget {
  const ProgressBarPage({super.key});

  @override
  State<ProgressBarPage> createState() => _ProgressBarPageState();
}

class _ProgressBarPageState extends State<ProgressBarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(duration: 6.seconds, vsync: this);
    animation.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(appBar: AppBarText('Progress'), children: [
      const Partition('FlLinearProgress', marginTop: 0),
      FlLinearProgress(
          width: 300,
          height: 20,
          percent: 0.8,
          animation: true,
          mainAxisAlignment: MainAxisAlignment.center,
          onChanged: (value) {
            log('FlLinearProgress use animation:$value');
          },
          builder: (_, double percent) => Stack(children: [
                Positioned(
                    right: 300 - 300 * percent,
                    top: 0,
                    bottom: 0,
                    child:
                        BText(percent.toStringAsFixed(1), color: Colors.white))
              ]),
          strokeCap: StrokeCap.round,
          progressColor: Colors.lightGreen,
          backgroundColor: Colors.black12),
      const Partition('FlLinearProgress.gradient'),
      FlLinearProgress.gradient(
          width: 300,
          height: 20,
          percent: 1,
          animation: true,
          repeat: true,
          linearGradient: const LinearGradient(colors: Colors.accents),
          mainAxisAlignment: MainAxisAlignment.center,
          duration: const Duration(seconds: 4),
          builder: (_, double percent) => Stack(children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 300 - 300 * percent,
                    child:
                        BText(percent.toStringAsFixed(1), color: Colors.white)),
              ]),
          strokeCap: StrokeCap.round,
          backgroundColor: Colors.black12),
      const Partition('FlLinearProgress.gradient  isClip:false'),
      FlLinearProgress.gradient(
          width: 300,
          height: 20,
          percent: 0.9,
          animation: true,
          repeat: true,
          isClip: false,
          linearGradient: const LinearGradient(colors: Colors.accents),
          mainAxisAlignment: MainAxisAlignment.center,
          duration: const Duration(seconds: 4),
          builder: (_, double percent) => Stack(children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 300 - 300 * percent,
                    child:
                        BText(percent.toStringAsFixed(1), color: Colors.white)),
              ]),
          strokeCap: StrokeCap.round,
          backgroundColor: Colors.black12),
      const SizedBox(height: 20),
      const Partition('LiquidProgressIndicator'),
      AnimatedBuilder(
          animation: animation,
          builder: (_, __) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LiquidProgressIndicator.circular(
                          borderWidth: 2,
                          borderColor: Colors.greenAccent,
                          value: animation.value)
                      .setSize(const Size(120, 120)),
                  const SizedBox(height: 20),
                  LiquidProgressIndicator.linear(
                          borderWidth: 2,
                          borderColor: Colors.greenAccent,
                          borderRadius: 10,
                          value: animation.value)
                      .setSize(const Size(double.infinity, 30)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LiquidProgressIndicator.custom(
                            value: animation.value,
                            direction: Axis.vertical,
                            shapePath: _buildBoatPath()),
                        LiquidProgressIndicator.custom(
                            value: animation.value,
                            direction: Axis.horizontal,
                            shapePath: _buildSpeechBubblePath()),
                        LiquidProgressIndicator.custom(
                            value: animation.value,
                            direction: Axis.vertical,
                            shapePath: _buildHeartPath()),
                      ]).expanded,
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: FlAnimationWave(
                          value: 0.6,
                          color: context.theme.primaryColor,
                          direction: Axis.vertical))
                ]);
          }).expanded,
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
    animation.dispose();
    super.dispose();
  }
}
