import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AnchorScrollController extends ScrollController {
  List<GlobalKey> _keyList = [];
  GlobalKey? _scrollKey;
  RenderObject? _ancestor;
  bool _reverse = false;
  Axis _scrollDirection = Axis.vertical;

  void _setConfig(
      int count, GlobalKey scrollKey, bool reverse, Axis scrollDirection) {
    _scrollKey = scrollKey;
    _reverse = reverse;
    _scrollDirection = scrollDirection;
    _keyList = count.generate((index) => GlobalKey());
  }

  /// 上次跳转的 index
  int lastIndex = 0;

  /// 最近一次跳转次数
  int jumpTimes = 0;

  /// 跳转至指定 index
  Future<void> jumpToIndex(int index,
      {Duration duration = const Duration(milliseconds: 20),
      bool useAnimateTo = false,
      double ruleOutSpacing = 0,
      Curve curve = Curves.linear}) async {
    if (index >= _keyList.length) index = _keyList.length - 1;
    if (index < 1) index = 1;
    if (_ancestor == null) jumpTimes = 0;
    _ancestor ??= _scrollKey!.currentContext!.findRenderObject();
    final targetKey = _keyList[index];
    GlobalKey? jumpKey;
    if (targetKey.currentContext == null) {
      if (index < lastIndex) {
        jumpKey = _keyList.where((e) => e.currentContext != null).first;
      } else {
        jumpKey = _keyList.where((e) => e.currentContext != null).last;
      }
      final jumpIndex = _keyList.indexOf(jumpKey);
      final value = useAnimateTo
          ? await _animateTo(jumpKey.currentContext!,
              duration: duration, curve: curve, ruleOutSpacing: ruleOutSpacing)
          : _jumpTo(jumpKey.currentContext!, ruleOutSpacing: ruleOutSpacing);
      if (value) {
        lastIndex = jumpIndex;
        await duration.delayed(() async => await jumpToIndex(index));
      }
    } else {
      lastIndex = index;
      useAnimateTo
          ? await _animateTo(targetKey.currentContext!,
              duration: duration,
              curve: curve,
              isEnd: true,
              ruleOutSpacing: ruleOutSpacing)
          : _jumpTo(targetKey.currentContext!,
              isEnd: true, ruleOutSpacing: ruleOutSpacing);
      jumpTimes = 0;
    }
  }

  bool _jumpTo(BuildContext context,
      {bool isEnd = false, double ruleOutSpacing = 0}) {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      double dy = offset + _rectToOffset(rect, ruleOutSpacing: ruleOutSpacing);
      if (dy == offset && !isEnd) {
        dy = offset +
            _rectToOffset(rect, useEnd: true, ruleOutSpacing: ruleOutSpacing);
      }
      if (dy == offset) return false;
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      if (dy < 0) dy = 0;
      jumpTo(dy);
      jumpTimes += 1;
      return true;
    }
    return false;
  }

  double _rectToOffset(Rect rect,
      {bool useEnd = false, double ruleOutSpacing = 0}) {
    switch (_scrollDirection) {
      case Axis.horizontal:
        double left = rect.left + ruleOutSpacing;
        if (useEnd) left += rect.width;
        return _reverse ? -left : left;
      case Axis.vertical:
        double top = rect.top + ruleOutSpacing;
        if (useEnd) top += rect.height;
        return _reverse ? -top : top;
    }
  }

  Future<bool> _animateTo(BuildContext context,
      {required Duration duration,
      required Curve curve,
      bool isEnd = false,
      double ruleOutSpacing = 0}) async {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      double dy = offset + _rectToOffset(rect, ruleOutSpacing: ruleOutSpacing);
      if (dy == offset && !isEnd) {
        dy = offset +
            _rectToOffset(rect, useEnd: true, ruleOutSpacing: ruleOutSpacing);
      }
      if (dy == offset) return false;
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      if (dy < 0) dy = 0;
      await animateTo(dy, duration: duration, curve: curve);
      return true;
    }
    return false;
  }
}

typedef AnchorBuilder = Widget Function(
    BuildContext context,

    /// 务必把 [scrollKey] 赋值给 滚动组件[key]
    GlobalKey scrollKey,

    /// 务必把 [scrollController] 回传给 builder 里的滚动组件
    ScrollController scrollController,

    /// 如果使用 [reverse] 务必把 [reverse] 回传给 builder 里的滚动组件 默认为 false
    bool reverse,

    /// 如果使用 [scrollDirection] 务必把 [scrollDirection] 回传给 builder 里的滚动组件 默认为 Axis.vertical
    Axis scrollDirection,

    /// 务必将 entryKeys[index] 赋值给 子元素[key]
    List<GlobalKey> entryKeys);

/// 滚动至指定index子元素
class AnchorScrollBuilder extends StatefulWidget {
  const AnchorScrollBuilder({
    super.key,
    required this.controller,
    required this.count,
    required this.builder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.disposeController = true,
  });

  /// 必须把 [controller] 回传给 builder 里的滚动组件
  final AnchorScrollController controller;

  /// 必须把 [scrollDirection]] 回传给 builder 里的滚动组件
  final Axis scrollDirection;

  /// 必须把 [reverse] 回传给 builder 里的滚动组件
  final bool reverse;

  /// 子组件数量
  final int count;

  /// 默认为[true] 组件 dispose 时 自动调用 controller.dispose()
  final bool disposeController;

  /// 滚动组件构造器
  final AnchorBuilder builder;

  @override
  State<AnchorScrollBuilder> createState() => _AnchorScrollBuilderState();
}

class _AnchorScrollBuilderState extends ExtendedState<AnchorScrollBuilder> {
  GlobalKey scrollKey = GlobalKey();
  late AnchorScrollController controller;

  @override
  void initState() {
    controller = widget.controller;
    controller._setConfig(
        widget.count, scrollKey, widget.reverse, widget.scrollDirection);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnchorScrollBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller != widget.controller) {
      controller.dispose();
      controller = widget.controller;
    }
    if (oldWidget.count != widget.count ||
        oldWidget.reverse != widget.reverse ||
        oldWidget.scrollDirection != widget.scrollDirection) {
      controller._setConfig(
          widget.count, scrollKey, widget.reverse, widget.scrollDirection);
    }
    controller.lastIndex = 0;
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, scrollKey,
      controller, widget.reverse, widget.scrollDirection, controller._keyList);

  @override
  void dispose() {
    super.dispose();
    if (widget.disposeController) controller.dispose();
  }
}
