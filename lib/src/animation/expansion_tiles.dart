import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef ExpansionTilesBuilderListTile = Widget Function(BuildContext context,
    GestureTapCallback onTap, bool isExpanded, Widget? rotation);

typedef ExpansionTilesRotationTransitionBuilder = Widget Function(
    bool isExpanded);

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
    this.rotatingBuilder,
  });

  /// 构造器
  final ExpansionTilesBuilderListTile builder;

  /// 展开或关闭监听
  final ValueChanged<bool>? onExpansionChanged;

  /// 子元素，
  final List<Widget> children;

  /// 子元素，
  final Widget? child;

  /// 旋转的图标
  final ExpansionTilesRotationTransitionBuilder? rotatingBuilder;

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
  Animation<double>? iconTurns;
  late Animation<double> heightFactor;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    heightFactor = controller.drive(CurveTween(curve: Curves.easeIn));
    if (widget.rotatingBuilder != null) {
      iconTurns = controller.drive(Tween<double>(begin: 0.0, end: 0.5)
          .chain(CurveTween(curve: Curves.easeIn)));
    }
    isExpanded = widget.initial;
    if (isExpanded) controller.value = 1.0;
  }

  void handleTap() {
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
          final icon = widget.rotatingBuilder?.call(isExpanded);
          final current = Column(mainAxisSize: MainAxisSize.min, children: [
            widget.builder(
                context,
                handleTap,
                isExpanded,
                icon == null || iconTurns == null
                    ? null
                    : RotationTransition(turns: iconTurns!, child: icon)),
            ClipRect(
                child: Align(heightFactor: heightFactor.value, child: child))
          ]);
          if (widget.backgroundColor == null || !isExpanded) return current;
          return ColoredBox(color: widget.backgroundColor!, child: current);
        },
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
