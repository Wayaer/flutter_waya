import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// Automatically collapse your own src as the scrollview scrolls
/// 随scrollview的滚动自动折叠自己的组件
class FlAutoCollapsingBuilder extends StatefulWidget {
  const FlAutoCollapsingBuilder({
    super.key,
    required this.controller,
    required this.child,
    this.minSize = 0,
    this.maxSize = 10,
    this.damping = 1,
    this.direction = Axis.vertical,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 300),
  }) : assert(minSize <= maxSize, 'minSize 不能大于 maxSize');

  /// 滚动组件 Controller
  final ScrollController controller;

  /// 最小尺寸，默认 0
  final double minSize;

  /// 最大尺寸，默认 10
  final double maxSize;

  /// 阻尼参数，默认 1
  /// 滚动距离*[damping]=[child]折叠距离
  final double damping;

  /// 折叠方向，默认 [Axis.vertical]
  final Axis direction;

  /// 是否反转折叠方向，默认 false
  final bool reverse;

  /// 随滚动折叠的子组件
  final Widget child;

  /// 折叠动画时长，默认 300 毫秒
  final Duration duration;

  @override
  State<FlAutoCollapsingBuilder> createState() => _AutoCollapsingBuilderState();
}

class _AutoCollapsingBuilderState extends FlExtendedState<FlAutoCollapsingBuilder> {
  double _size = 0.0;
  double _previousOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _size = widget.maxSize;
    _previousOffset = widget.controller.hasClients ? widget.controller.offset : 0.0;
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncPreviousOffset();
    });
  }

  void _syncPreviousOffset() {
    _previousOffset = widget.controller.hasClients ? widget.controller.offset : 0.0;
  }

  @override
  void didUpdateWidget(covariant FlAutoCollapsingBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
      _syncPreviousOffset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncPreviousOffset();
      });
    }
    if (oldWidget.maxSize != widget.maxSize || oldWidget.minSize != widget.minSize) {
      _size = _size.clamp(widget.minSize, widget.maxSize).toDouble();
    }
  }

  void _onScroll() {
    final offset = widget.controller.offset;
    final distance = (offset - _previousOffset).abs();
    final minSize = widget.minSize;
    final maxSize = widget.maxSize;

    if ((!widget.reverse && offset > _previousOffset) || (widget.reverse && offset < _previousOffset)) {
      if (_size > minSize) {
        _size -= distance * widget.damping;
        if (_size < minSize) {
          _size = minSize;
        }
        if (mounted) setState(() {});
      }
    } else if ((!widget.reverse && offset < _previousOffset) || (widget.reverse && offset > _previousOffset)) {
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
  Widget build(BuildContext context) => AnimatedContainer(
    duration: widget.duration,
    width: widget.direction == Axis.horizontal ? _size : null,
    height: widget.direction == Axis.vertical ? _size : null,
    child: widget.child,
  );

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }
}
