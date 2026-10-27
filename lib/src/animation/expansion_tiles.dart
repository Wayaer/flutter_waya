import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 头部构建器，参数为展开方法、当前是否展开以及旋转图标（未配置图标时为 null）
typedef FlExpansionTilesBuilderListTile = Widget Function(
  BuildContext context,
  VoidCallback expand,
  bool isExpanded,
  Widget? rotation,
);

/// 旋转图标构建器，参数为当前是否展开
typedef FlExpansionTilesRotationIconBuilder = Widget Function(bool isExpanded);

/// 将任意 Widget 转换为旋转图标构建器
extension FlExpansionTilesExtension on Widget {
  FlExpansionTilesRotationIconBuilder get toExpansionTilesRotationIconBuilder =>
      (isExpanded) => this;
}

/// 可展开收起的列表项，展开时以高度动画展示子内容
class FlExpansionTiles extends StatefulWidget {
  const FlExpansionTiles({
    super.key,
    required this.builder,
    this.children = const [],
    this.child,
    this.isExpanded = false,
    this.backgroundColor,
    this.onExpansionChanged,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
    this.icon,
  });

  /// 初始是否展开，默认 false
  final bool isExpanded;

  /// 头部构建器
  final FlExpansionTilesBuilderListTile builder;

  /// 旋转图标构建器，展开时旋转 0.5 圈
  final FlExpansionTilesRotationIconBuilder? icon;

  /// 展开或收起状态变化回调
  final ValueChanged<bool>? onExpansionChanged;

  /// 展开区域包含的多个子组件
  final List<Widget> children;

  /// 展开区域的自定义子组件，优先级高于 [children]
  final Widget? child;

  /// 展开时的背景颜色
  final Color? backgroundColor;

  /// 展开动画时长，默认 200 毫秒
  final Duration duration;

  /// 展开动画曲线，默认 [Curves.fastOutSlowIn]
  final Curve curve;

  @override
  State<FlExpansionTiles> createState() => _ExpansionTilesState();
}

class _ExpansionTilesState extends FlExtendedState<FlExpansionTiles> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<double>? iconTurns;
  late Animation<double> heightFactor;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    initTween();
    isExpanded = widget.isExpanded;
    if (isExpanded) controller.value = 1.0;
  }

  void initTween() {
    heightFactor = controller.drive(CurveTween(curve: widget.curve));
    if (widget.icon != null) {
      iconTurns = controller.drive(Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: widget.curve)));
    }
  }

  void handleExpanded() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      controller.forward();
      setState(() {});
    } else {
      controller.reverse().then<void>((void value) {
        setState(() {});
      });
    }
    widget.onExpansionChanged?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !isExpanded && controller.isDismissed;
    return AnimatedBuilder(
      animation: controller.view,
      builder: (_, Widget? child) {
        final icon = widget.icon?.call(isExpanded);
        final current = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.builder(
              context,
              handleExpanded,
              isExpanded,
              icon == null || iconTurns == null ? null : RotationTransition(turns: iconTurns!, child: icon),
            ),
            ClipRect(
              child: Align(heightFactor: heightFactor.value, child: child),
            ),
          ],
        );
        if (widget.backgroundColor == null || !isExpanded) return current;

        // 透明 Material 作为最近祖先，避免 ColoredBox 遮挡 ListTile 背景与 ink
        return ColoredBox(
          color: widget.backgroundColor!,
          child: Material(type: MaterialType.transparency, child: current),
        );
      },
      child: closed ? null : widget.child ?? Column(children: widget.children),
    );
  }

  @override
  void didUpdateWidget(covariant FlExpansionTiles oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
    initTween();
    if (oldWidget.isExpanded != widget.isExpanded && widget.isExpanded != isExpanded) {
      isExpanded = widget.isExpanded;
      if (isExpanded) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
