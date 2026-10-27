import 'package:app/main.dart';
import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 分页与指示器分类页。
///
/// 覆盖组件：
/// - [FlPageView] / [FlPageViewController]：可循环、可自动播放的分页容器
/// - [FlPageViewTransform]：item 缩放 / 缩放对齐
/// - [FlIndicator]：6 种指示器样式
class PageViewPage extends StatefulWidget {
  const PageViewPage({super.key});

  @override
  State<PageViewPage> createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  /// isLoop: true 时内部使用超大 realPage 模拟无限循环
  final FlPageViewController horizontal = FlPageViewController(viewportFraction: 0.8, isLoop: true);

  /// 非循环分页，用于对比
  final FlPageViewController vertical = FlPageViewController(viewportFraction: 0.85);

  final int itemCount = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      horizontal.startAutoPlay();
      vertical.startAutoPlay();
    });
  }

  @override
  void dispose() {
    // FlPageView(disposeController: false) 时由使用方负责释放
    horizontal.dispose();
    vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('分页与指示器'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const Partition('FlPageView · 横向循环 + 自动播放', marginTop: 0),
        buildPageView(horizontal, Axis.horizontal),
        10.heightBox,
        // 通过控制器控制分页
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            ElevatedText('上一页', onTap: () => horizontal.previous()),
            ElevatedText('下一页', onTap: () => horizontal.next()),
            ElevatedText('跳转第 0 页', onTap: () => horizontal.jump(0)),
            ElevatedText('动画到第 3 页', onTap: () => horizontal.animate(3)),
            ElevatedText(
              '当前索引',
              onTap: () async {
                final double? page = horizontal.getPage();
                showToast(
                  'getPage：${page?.toStringAsFixed(2)}  '
                  'getIndex：${horizontal.getIndex(horizontal.page?.round() ?? 0)}',
                );
              },
            ),
            ElevatedText('停止自动播放', onTap: horizontal.stopAutoPlay),
            ElevatedText('开始自动播放', onTap: horizontal.startAutoPlay),
          ],
        ),
        const Partition('FlPageView · 纵向非循环'),
        buildPageView(vertical, Axis.vertical, height: 220),
        const Partition('FlIndicator · 6 种样式'),
        buildIndicators(),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget buildPageView(FlPageViewController controller, Axis direction, {double height = 180}) => FlPageView(
    controller: controller,
    itemCount: itemCount,
    height: height,
    autoPlay: true,
    autoPlayInterval: const Duration(seconds: 3),
    // 外部创建的 controller 由本页负责 dispose
    disposeController: false,
    builder: (FlPageViewController pageController, int? itemCount) => PageView.builder(
      controller: pageController,
      scrollDirection: direction,
      itemCount: itemCount,
      itemBuilder: (_, int index) {
        final ColorScheme scheme = Theme.of(context).colorScheme;
        final Widget child = Container(
          alignment: Alignment.center,
          color: index.isEven ? scheme.primary : scheme.primaryContainer,
          child: Text(
            'index:${pageController.getIndex(index)}\nrealIndex:$index',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        );
        // 同一 item 内并排展示两种 Transform 效果
        return Flex(
          direction: direction == Axis.horizontal ? Axis.vertical : Axis.horizontal,
          children: [
            FlPageViewTransform(
              controller: pageController,
              scrollDirection: direction,
              index: index,
              style: FlPageViewTransformStyle.scale,
              child: child,
            ).expanded,
            const SizedBox(width: 5, height: 5),
            FlPageViewTransform(
              controller: pageController,
              scrollDirection: direction,
              style: FlPageViewTransformStyle.zoom,
              index: index,
              child: child,
            ).expanded,
          ],
        );
      },
    ),
  );

  Widget buildIndicators() => ListenableBuilder(
    listenable: horizontal,
    builder: (_, _) {
      final double position = horizontal.getPage() ?? 0;
      final int index = position.floor();
      return Wrap(
        spacing: 28,
        runSpacing: 12,
        children: FlIndicatorStyle.values
            .map(
              (FlIndicatorStyle style) => FlIndicator(
                count: itemCount,
                index: index,
                position: position,
                style: style,
                size: 10,
                activeSize: 14,
                space: 6,
              ),
            )
            .toList(),
      );
    },
  );
}
