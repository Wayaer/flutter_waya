import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef ExpansionTilesBuilderListTile = Widget Function(BuildContext context,
    VoidCallback expand, bool isExpanded, Widget? rotation);

typedef ExpansionTilesRotationIconBuilder = Widget Function(bool isExpanded);

extension ExtensionExpansionTiles on Widget {
  ExpansionTilesRotationIconBuilder get toExpansionTilesRotationIconBuilder =>
      (isExpanded) => this;
}

/// 展开收起
class ExpansionTiles extends StatefulWidget {
  const ExpansionTiles({
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

  /// 初始状态是否展开，
  final bool isExpanded;

  /// 构造器
  final ExpansionTilesBuilderListTile builder;

  /// 旋转的图标
  final ExpansionTilesRotationIconBuilder? icon;

  /// 展开或关闭监听
  final ValueChanged<bool>? onExpansionChanged;

  /// 子元素，
  final List<Widget> children;

  /// 子元素，
  final Widget? child;

  /// 展开时的背景颜色，
  final Color? backgroundColor;

  /// 展开时长
  final Duration duration;

  /// 动画曲线
  final Curve curve;

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
    heightFactor = controller.drive(CurveTween(curve: widget.curve));
    if (widget.icon != null) {
      iconTurns = controller.drive(Tween<double>(begin: 0.0, end: 0.5)
          .chain(CurveTween(curve: widget.curve)));
    }
    isExpanded = widget.isExpanded;
    if (isExpanded) controller.value = 1.0;
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
          final current = Column(mainAxisSize: MainAxisSize.min, children: [
            widget.builder(
                context,
                handleExpanded,
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
    controller.duration = widget.duration;
    if (widget.isExpanded != isExpanded) {
      isExpanded = widget.isExpanded;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
