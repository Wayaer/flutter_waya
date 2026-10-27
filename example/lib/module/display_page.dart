import 'dart:async';

import 'package:app/main.dart';
import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 展示与布局分类页。
///
/// 覆盖组件：
/// - [FlWrapper] 带尖角的容器
/// - [FlDottedLinePainter] / [FlDottedLineBorder] 虚线
/// - [FlRatingStars] 评分
/// - [FlShimmery] 微光骨架
/// - [FlSwitch] 开关
/// - [FlFlipCard] / [FlFlipCardStateful] 翻转卡片
/// - [FlAutomaticKeepAliveClientWrapper] 保持页面状态
///   （自定义 State 可直接继承 `FlAutomaticKeepAliveClientMixinState`）
class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> with SingleTickerProviderStateMixin {
  late final FlFlipCardController flipController = FlFlipCardController(vsync: this);

  @override
  void dispose() {
    flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> shimmerColors = <Color>[
      Colors.transparent,
      Colors.yellow.withValues(alpha: 0.05),
      Colors.yellow.withValues(alpha: 0.9),
      Colors.yellow.withValues(alpha: 0.05),
      Colors.transparent,
    ];
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('展示与布局'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const Partition('FlWrapper · 4 个方向的尖角容器', marginTop: 0),
        // style 控制方向；formEnd 反向定位；spineRadius 控制尖端与连接处圆角
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final FlSpineStyle style in FlSpineStyle.values)
              FlWrapper(
                style: style,
                formEnd: true,
                elevation: 1,
                spineRadius: 3,
                color: Theme.of(context).colorScheme.primary,
                child: const Text('FlWrapper', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
        const Partition('FlWrapper · spineRadius 圆角半径'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final double value in <double>[0, 2, 4, 6])
              FlWrapper(
                style: FlSpineStyle.left,
                spineRadius: value,
                color: Theme.of(context).colorScheme.secondary,
                child: Text('spineRadius $value', style: const TextStyle(color: Colors.white)),
              ),
          ],
        ),
        const Partition('FlDottedLine · 虚线边框'),
        // BoxDecoration 的 borderRadius 会让虚线沿圆角路径绘制
        Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: FlDottedLineBorder.all(color: Theme.of(context).dividerColor, length: 6, space: 4),
          ),
          child: const Text('FlDottedLineBorder + borderRadius'),
        ),
        10.heightBox,
        // 独立画家同样支持圆角、独立线段长度与圆头端点
        SizedBox(
          width: double.infinity,
          height: 44,
          child: CustomPaint(
            painter: FlDottedLinePainter(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 1.5,
              gap: 4,
              length: 6,
              radius: 12,
              strokeCap: StrokeCap.round,
            ),
            child: const Center(child: Text('FlDottedLinePainter · radius + round cap')),
          ),
        ),
        10.heightBox,
        // symmetric 可以为水平 / 垂直边分别指定颜色和宽度
        Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: FlDottedLineBorder.symmetric(
              vertical: BorderSide(color: Theme.of(context).colorScheme.primary),
              horizontal: BorderSide(color: Theme.of(context).colorScheme.secondary),
              length: 6,
              space: 4,
            ),
          ),
          child: const Text('FlDottedLineBorder.symmetric'),
        ),
        const Partition('FlRatingStars · 评分'),
        // ValueBuilder 负责保存当前值；FlRatingStars 支持半星、实时回调
        ValueBuilder<double>(
          initial: 3,
          builder: (_, double? value, Function updater) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlRatingStars(
                value: value ?? 0,
                step: 0.5,
                followChanged: true,
                starSize: const Size(30, 30),
                starSpacing: 4,
                onChanged: (double realStars, double selectedStars) => updater(realStars),
                builder: (bool selected) =>
                    Icon(Icons.star, size: 30, color: selected ? Colors.amber : Colors.grey.shade400),
              ),
              16.widthBox,
              Text('${(value ?? 0).toStringAsFixed(1)} / 5'),
            ],
          ),
        ),
        const Partition('FlShimmery · 微光骨架'),
        // direction 支持 6 个方向；默认 FlShimmerDirection.fromLTRB()
        // 每个盒子各自包一层 FlShimmery，拥有独立的微光动画
        Row(
          children: [
            Expanded(
              child: FlShimmery(
                colors: shimmerColors,
                child: Universal(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            10.widthBox,
            Expanded(
              child: FlShimmery(
                colors: shimmerColors,
                child: Universal(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
        10.heightBox,
        FlShimmery(
          direction: const FlShimmerDirection.fromRightToLeft(),
          colors: [
            Colors.transparent,
            Colors.pink.withValues(alpha: 0.05),
            Colors.pink.withValues(alpha: 0.9),
            Colors.pink.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          child: Universal(
            height: 20,
            decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const Partition('FlSwitch · 开关'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ValueBuilder<bool>(
              initial: true,
              builder: (_, bool? value, Function updater) => FlSwitch(
                value: value ?? false,
                activeColor: Colors.deepPurple,
                size: const Size(44, 24),
                radius: 12,
                onChanged: (bool newValue) => updater(newValue),
              ),
            ),
            ValueBuilder<bool>(
              initial: false,
              builder: (_, bool? value, Function updater) => FlSwitch(
                value: value ?? false,
                thumbColor: Colors.amber,
                activeColor: Colors.green,
                trackColor: Colors.grey.shade300,
                size: const Size(60, 28),
                radius: 14,
                onChanged: (bool newValue) => updater(newValue),
              ),
            ),
          ],
        ),
        const Partition('FlFlipCard · 翻转卡片'),
        FlFlipCard(
          controller: flipController,
          fit: StackFit.passthrough,
          front: buildCard('Front', Colors.amberAccent),
          back: buildCard('Back', Colors.lightGreenAccent),
        ),
        12.heightBox,
        // FlFlipCardController 提供 toggle / animateToggle / skew / hint
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            ElevatedText('toggle', onTap: flipController.toggle),
            ElevatedText('animateToggle', onTap: () => flipController.animateToggle()),
            ElevatedText('skew(0.2)', onTap: () => flipController.skew(0.2)),
            ElevatedText('skew(0)', onTap: () => flipController.skew(0)),
            ElevatedText('hint', onTap: () => flipController.hint()),
          ],
        ),
        12.heightBox,
        // FlFlipCardStateful 内置点击翻转与开始/结束回调
        FlFlipCardStateful(
          fit: StackFit.passthrough,
          onFlipStart: (FlFlipCardState state) => log('onFlipStart:$state'),
          onFlipEnd: (FlFlipCardState state) => log('onFlipEnd:$state'),
          front: (_, _) => buildCard('Stateful Front', Colors.lightBlueAccent),
          back: (_, _) => buildCard('Stateful Back', Colors.pinkAccent),
        ),
        const Partition('FlAutomaticKeepAliveClientWrapper · 保持页面状态'),
        // 滚动到其它页再回来，计时器状态不会丢失
        SizedBox(
          height: 160,
          child: PageView.builder(
            itemCount: 3,
            itemBuilder: (_, int index) {
              if (index == 0) return const FlAutomaticKeepAliveClientWrapper(child: _KeepAliveCounter());
              return Center(child: Text('page $index'));
            },
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget buildCard(String text, Color color) => Universal(
    alignment: Alignment.center,
    height: 160,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
    child: Universal(
      color: Colors.black26,
      padding: const EdgeInsets.all(10),
      onTap: flipController.animateToggle,
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ),
  );
}

/// 每 500ms 自增一次，用于验证 KeepAlive 是否生效。
class _KeepAliveCounter extends StatefulWidget {
  const _KeepAliveCounter();

  @override
  State<_KeepAliveCounter> createState() => _KeepAliveCounterState();
}

class _KeepAliveCounterState extends State<_KeepAliveCounter> {
  int count = 0;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => count++);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('已运行 ${(count / 2).toStringAsFixed(1)} 秒'),
        const Text('滚动到其它页再回来，计数不会重置', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
