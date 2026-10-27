import 'package:app/main.dart';
import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 进度与加载分类页。
///
/// 覆盖组件：
/// - [FlLinearProgress] 线性进度（纯色 / 渐变 / 静态 / 动画）
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('进度与加载'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const Partition('FlLinearProgress · 纯色 + 动画', marginTop: 0),
        FlLinearProgress(
          width: 300,
          height: 20,
          percent: 0.8,
          // animation 为 true 时会从 0 动画到 percent
          animation: true,
          strokeCap: StrokeCap.round,
          progressColor: Colors.lightGreen,
          backgroundColor: Colors.black12,
          onChanged: (double value) => log('FlLinearProgress percent:$value'),
          builder: (_, double percent) => Stack(
            children: [
              Positioned(
                right: 300 - 300 * percent,
                top: 0,
                bottom: 0,
                child: Text(percent.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        const Partition('FlLinearProgress · 静态进度'),
        FlLinearProgress(
          width: 300,
          height: 10,
          percent: 0.4,
          progressColor: Colors.orange,
          backgroundColor: Colors.black12,
        ),
        const Partition('FlLinearProgress.gradient · isClip:true'),
        FlLinearProgress.gradient(
          width: 300,
          height: 20,
          percent: 1,
          animation: true,
          repeat: true,
          linearGradient: const LinearGradient(colors: Colors.accents),
          strokeCap: StrokeCap.round,
          backgroundColor: Colors.black12,
        ),
        const Partition('FlLinearProgress.gradient · isClip:false'),
        FlLinearProgress.gradient(
          width: 300,
          height: 20,
          percent: 0.9,
          animation: true,
          repeat: true,
          isClip: false,
          duration: const Duration(seconds: 4),
          linearGradient: const LinearGradient(colors: Colors.accents),
          strokeCap: StrokeCap.round,
          backgroundColor: Colors.black12,
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
