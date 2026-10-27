import 'dart:async';

import 'package:app/main.dart';
import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 计时与工具分类页。
///
/// 覆盖组件：
/// - [FlCounter] 计时器（倒计时 / 正计时）
/// - [FlSendVerificationCode] 验证码发送
/// - [FlEvent] / [FlEventBus] 事件总线
/// - [FlScreenAdaptation] 屏幕适配
/// - [FlSystemUiOverlayStyleLight] / [FlSystemUiOverlayStyleDark] 状态栏样式
class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final FlEvent<String> _event = FlEvent<String>();
  StreamSubscription<dynamic>? _eventSubscription;
  final List<String> _messages = [];

  static const String _eventBusKey = 'waya_demo';

  @override
  void initState() {
    super.initState();
    // 订阅 FlEvent 广播流
    _eventSubscription = _event.on<String>().listen((dynamic message) {
      if (mounted) setState(() => _messages.insert(0, 'FlEvent：$message'));
    });
    // FlEventBus 是全局单例，使用后需要手动 remove
    FlEventBus().add(_eventBusKey, _onEventBus);
  }

  void _onEventBus(dynamic data) {
    if (mounted) setState(() => _messages.insert(0, 'FlEventBus：$data'));
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _event.close();
    FlEventBus().remove(_eventBusKey, _onEventBus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('计时与工具'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const Partition('FlCounter.down / FlCounter.up · 计时器', marginTop: 0),
        // isActive 为 true 时表示计时器正在运行；start/stop 由组件内部管理
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlCounter.down(
              value: const Duration(seconds: 10),
              builder: (Duration duration, bool isActive, VoidCallback start, VoidCallback stop) => ElevatedButton(
                onPressed: isActive ? stop : start,
                child: FlAnimationCounter.down(value: '${duration.inSeconds}', builder: (String value) => Text(value)),
              ),
            ),
            FlCounter.up(
              max: const Duration(seconds: 60),
              builder: (Duration duration, bool isActive, VoidCallback start, VoidCallback stop) => ElevatedButton(
                onPressed: isActive ? stop : start,
                child: FlAnimationCounter.up(
                  style: FlCounterStyle.all,
                  value: '${duration.inSeconds}',
                  builder: (String value) => Text(value),
                ),
              ),
            ),
          ],
        ),
        const Partition('FlSendVerificationCode · 发送验证码'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlSendVerificationCode(
              value: const Duration(seconds: 10),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              gestureBuilder: (VoidCallback? onTap, Widget child) => ElevatedButton(onPressed: onTap, child: child),
              // 模拟接口：2 秒后返回成功，随后开始倒计时
              onSendTap: () async {
                await 2.seconds.delayed();
                return true;
              },
              builder: (FlSendState state, int seconds) {
                switch (state) {
                  case FlSendState.none:
                    return const Text('发送验证码');
                  case FlSendState.sending:
                    return const Text('发送中');
                  case FlSendState.resend:
                    return const Text('重新发送');
                  case FlSendState.countDown:
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('等待 '),
                        FlAnimationCounter.down(value: '$seconds', builder: (String value) => Text(value)),
                        const Text(' s'),
                      ],
                    );
                }
              },
            ),
          ],
        ),
        const Partition('FlEvent / FlEventBus · 事件总线'),
        // FlEvent<T> 是带类型的广播流；FlEventFactory / flSendEvent / flEventListen / flEventDestroy
        // 是全局单例版本，用法一致，但全局监听没有 remove，示例中改用 FlEventBus
        // 演示可注销监听。
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            ElevatedText('FlEvent.send', onTap: () => _event.send('消息 ${DateTime.now().millisecond}')),
            ElevatedText(
              'FlEventBus.emit',
              onTap: () => FlEventBus().emit(_eventBusKey, '消息 ${DateTime.now().millisecond}'),
            ),
            ElevatedText('清空', onTap: () => setState(_messages.clear)),
          ],
        ),
        8.heightBox,
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _messages.isEmpty
              ? const Text('暂无消息', style: TextStyle(fontSize: 12))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final String message in _messages.take(5))
                      Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(message)),
                  ],
                ),
        ),
        const Partition('SystemUiOverlayStyle · 状态栏样式'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedText(
              'Light',
              onTap: () => SystemChrome.setSystemUIOverlayStyle(const FlSystemUiOverlayStyleLight()),
            ),
            ElevatedText('Dark', onTap: () => SystemChrome.setSystemUIOverlayStyle(const FlSystemUiOverlayStyleDark())),
          ],
        ),
        const Partition('FlScreenAdaptation · 屏幕适配'),
        Center(
          child: ElevatedText(
            '打开 FlScreenAdaptation 示例页',
            onTap: () => push(const _ScreenAdaptationDemoPage()),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

/// [FlScreenAdaptation] 会根据屏幕宽度与 [designWidth] 的比例缩放内容，
/// 适合按设计稿尺寸还原 UI。横屏（宽 >= 高 * 1.1）时默认不缩放。
class _ScreenAdaptationDemoPage extends StatelessWidget {
  const _ScreenAdaptationDemoPage();

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
    appBar: AppBarText('FlScreenAdaptation'),
    child: FlScreenAdaptation(
      designWidth: 375,
      builder: (BuildContext context, bool scaled) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              '当前是否缩放：$scaled\n设计宽度：375',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          16.heightBox,
          // 这里的 375 宽卡片在任意屏幕上都按设计稿比例呈现
          Container(
            width: 375,
            height: 160,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: const Text('width: 375（设计稿尺寸）'),
          ),
        ],
      ),
    ),
  );
}
