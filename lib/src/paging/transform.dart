import 'package:flutter/material.dart';

/// 切换动画样式：整体缩放 scale、朝向缩放 zoom。
enum FlPageViewTransformStyle { scale, zoom }

/// 轮播项切换动画包装器，配合带 page 的控制器实现缩放效果。
class FlPageViewTransform extends StatelessWidget {
  const FlPageViewTransform({
    super.key,
    required this.child,
    required this.controller,
    required this.index,
    this.scrollDirection = Axis.horizontal,
    this.scaleFactor = 0.3,
    this.style = FlPageViewTransformStyle.scale,
  }) : assert(scaleFactor > 0 && scaleFactor < 1);

  /// 子组件。
  final Widget child;

  /// 当前项的索引。
  final int index;

  /// 页码控制器。
  final PageController controller;

  /// 滚动方向，zoom 样式用于决定缩放对齐边。
  final Axis scrollDirection;

  /// 动画样式，默认 [FlPageViewTransformStyle.scale]。
  final FlPageViewTransformStyle style;

  /// 远离中心时的缩放系数，取值 (0, 1)，默认 0.3。
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (BuildContext context, child) {
        double scale = 1.0;
        double itemOffset = 0;
        double page = controller.initialPage.toDouble();
        if (controller.hasClients) {
          final position = controller.position;
          if (position.hasPixels && position.hasContentDimensions && controller.page != null) {
            page = controller.page!;
            itemOffset = page - index;
          } else {
            final storageContext = controller.position.context.storageContext;
            final Object? savedState = PageStorage.maybeOf(storageContext)?.readState(storageContext);
            final double previousSavedPosition = savedState is double ? savedState : page;
            itemOffset = previousSavedPosition - index.toDouble();
          }
        } else {
          itemOffset = page - index.toDouble();
        }
        final ratio = (1 - (itemOffset.abs() * scaleFactor)).clamp(0.0, 1.0);
        scale = Curves.easeOut.transform(ratio);
        switch (style) {
          case FlPageViewTransformStyle.scale:
            return Transform.scale(scale: scale, child: child);
          case FlPageViewTransformStyle.zoom:
            Alignment alignment;
            final bool horizontal = scrollDirection == Axis.horizontal;
            if (itemOffset > 0) {
              alignment = horizontal ? Alignment.centerRight : Alignment.bottomCenter;
            } else {
              alignment = horizontal ? Alignment.centerLeft : Alignment.topCenter;
            }
            return Transform.scale(scale: scale, alignment: alignment, child: child);
        }
      },
    );
  }
}
