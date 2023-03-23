import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ExpansionTiles extends StatefulWidget {
  const ExpansionTiles({
    super.key,
    this.leading,
    required this.title,
    this.children = const [],
    this.child,
    this.initial = false,
    this.subtitle,
    this.backgroundColor,
    this.onExpansionChanged,
    this.trailing,
    this.duration = const Duration(milliseconds: 200),
  });

  /// 标题左侧图标，
  final Widget? leading;

  /// title:闭合时显示的标题，
  final Widget title;

  /// 副标题
  final Widget? subtitle;

  /// 展开或关闭监听
  final ValueChanged<bool>? onExpansionChanged;

  /// 子元素，
  final List<Widget> children;

  /// 自定义子元素
  final Widget? child;

  /// 展开时的背景颜色，
  final Color? backgroundColor;

  /// 右侧的箭头
  final Widget? trailing;

  /// 初始状态是否展开，
  final bool initial;

  /// 展开时长
  final Duration duration;

  @override
  State<ExpansionTiles> createState() => _ExpansionTilesState();
}

class _ExpansionTilesState extends ExtendedState<ExpansionTiles>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));
    _isExpanded = widget.initial;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse().then<void>((void value) {
        setState(() {});
      });
    }
    setState(() {});
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (_, Widget? child) => Universal(
                color: _backgroundColor.value ??
                    widget.backgroundColor ??
                    Colors.transparent,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTileTheme.merge(
                      iconColor: _iconColor.value,
                      textColor: _headerColor.value,
                      child: ListEntry(
                          onTap: _handleTap,
                          leading: widget.leading,
                          title: widget.title,
                          subtitle: widget.subtitle,
                          child: widget.trailing ??
                              RotationTransition(
                                turns: _iconTurns,
                                child: const Icon(Icons.expand_more),
                              ))),
                  ClipRect(
                      child: Align(
                          heightFactor: _heightFactor.value, child: child))
                ]),
        child:
            closed ? null : widget.child ?? Column(children: widget.children));
  }
}
