import 'package:flutter/material.dart';

/// Automatically collapse your own src as the scrollview scrolls
/// 随scrollview的滚动自动折叠自己的组件
class AutoCollapsingBuilder extends StatefulWidget {
  const AutoCollapsingBuilder({
    super.key,
    required this.controller,
    required this.child,
    this.minSize = 0,
    this.maxSize = 10,
    this.damping = 1,
    this.direction = Axis.vertical,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 300),
  });

  /// 滚动组件 Controller
  final ScrollController controller;

  /// 最小尺寸
  final double minSize;

  /// 最大尺寸
  final double maxSize;

  /// 阻尼参数
  /// 滚动距离*[damping]=[child]折叠距离
  final double damping;

  /// 横向或垂直
  final Axis direction;

  /// 反转
  final bool reverse;

  /// 子组件
  final Widget child;

  /// 动画时长
  final Duration duration;

  @override
  State<AutoCollapsingBuilder> createState() => _AutoCollapsingBuilderState();
}

class _AutoCollapsingBuilderState extends State<AutoCollapsingBuilder> {
  double _size = 0.0;
  double _previousOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _size = widget.maxSize;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.controller.offset;
    final distance = (offset - _previousOffset).abs();
    final minSize = widget.minSize;
    final maxSize = widget.maxSize;

    if ((!widget.reverse && offset > _previousOffset) ||
        (widget.reverse && offset < _previousOffset)) {
      if (_size > minSize) {
        _size -= distance * widget.damping;
        if (_size < minSize) {
          _size = minSize;
        }
        if (mounted) setState(() {});
      }
    } else if ((!widget.reverse && offset < _previousOffset) ||
        (widget.reverse && offset > _previousOffset)) {
      if (_size < maxSize) {
        _size += distance * widget.damping;
        if (_size > maxSize) {
          _size = maxSize;
        }
        if (mounted) setState(() {});
      }
    }

    _previousOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: widget.duration,
        width: widget.direction == Axis.horizontal ? _size : null,
        height: widget.direction == Axis.vertical ? _size : null,
        child: widget.child);
  }
}
