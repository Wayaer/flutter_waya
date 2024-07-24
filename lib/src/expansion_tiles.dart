import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef ExpansionTilesBuilderListTile = Widget Function(
    BuildContext context, GestureTapCallback onTap, Widget rotation);

/// 展开收起
class ExpansionTiles extends StatefulWidget {
  const ExpansionTiles({
    super.key,
    required this.builder,
    this.children = const [],
    this.child,
    this.initial = false,
    this.backgroundColor,
    this.onExpansionChanged,
    this.duration = const Duration(milliseconds: 200),
    this.rotation,
  });

  final ExpansionTilesBuilderListTile builder;

  /// 展开或关闭监听
  final ValueChanged<bool>? onExpansionChanged;

  /// 子元素，
  final List<Widget> children;

  /// 子元素，
  final Widget? child;

  /// 旋转的图标
  final Widget? rotation;

  /// 展开时的背景颜色，
  final Color? backgroundColor;

  /// 初始状态是否展开，
  final bool initial;

  /// 展开时长
  final Duration duration;

  @override
  State<ExpansionTiles> createState() => _ExpansionTilesState();
}

class _ExpansionTilesState extends ExtendedState<ExpansionTiles>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> iconTurns;
  late Animation<double> heightFactor;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    heightFactor = controller.drive(CurveTween(curve: Curves.easeIn));
    iconTurns = controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeIn)));
    isExpanded = widget.initial;
    if (isExpanded) controller.value = 1.0;
  }

  void handleTap() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      controller.forward();
    } else {
      controller.reverse().then<void>((void value) {
        setState(() {});
      });
    }
    setState(() {});
    widget.onExpansionChanged?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !isExpanded && controller.isDismissed;
    return AnimatedBuilder(
        animation: controller.view,
        builder: (_, Widget? child) => ColoredBox(
            color: widget.backgroundColor ?? Colors.transparent,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              widget.builder(context, handleTap,
                  RotationTransition(turns: iconTurns, child: widget.rotation)),
              ClipRect(
                  child: Align(heightFactor: heightFactor.value, child: child))
            ])),
        child:
            closed ? null : widget.child ?? Column(children: widget.children));
  }

  @override
  void didUpdateWidget(covariant ExpansionTiles oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
