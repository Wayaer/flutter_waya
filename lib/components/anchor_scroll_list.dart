import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AnchorScrollController extends ScrollController {
  List<GlobalKey> _keyList = [];
  GlobalKey? _lastKey;
  int _lastIndex = 0;
  BuildContext? _context;
  double? _scrollTop;
  RenderObject? _ancestor;

  void _setKey(int count, BuildContext context, GlobalKey scrollKey,
      GlobalKey? headerKey) {
    _context = context;
    _keyList = count.generate((index) => GlobalKey());
  }

  Future<void> jumpToIndex(int index) async {
    if (_keyList.length >= index && _context != null) {
      if (_scrollTop == null) {
        _ancestor = Navigator.of(_context!).context.findRenderObject();
        final firstOffset = _keyList.first.currentContext
            ?.getWidgetLocalToGlobal(ancestor: _ancestor);
        if (firstOffset != null) _scrollTop = firstOffset.dy;
      }
      if (_keyList[index].currentContext == null) {
        if (index < _lastIndex) {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).first;
        } else {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).last;
        }
        _lastIndex = _keyList.indexOf(_lastKey!);
        _jumpTo(_lastKey!.currentContext!);
        await 10.milliseconds.delayed(() => jumpToIndex(index));
      } else {
        _lastIndex = index;
        _lastKey = null;
        _jumpTo(_keyList[index].currentContext!);
      }
    }
  }

  void _jumpTo(BuildContext context) {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      double dy = rect.top - (_scrollTop ?? 0) + offset;
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      jumpTo(dy);
    }
  }

  Future<void> animateToIndex(int index,
      {Duration duration = const Duration(milliseconds: 100),
      Curve curve = Curves.linear}) async {
    if (_keyList.length >= index && _context != null) {
      if (_scrollTop == null) {
        _ancestor = Navigator.of(_context!).context.findRenderObject();
        final firstOffset = _keyList.first.currentContext
            ?.getWidgetLocalToGlobal(ancestor: _ancestor);
        if (firstOffset != null) _scrollTop = firstOffset.dy;
      }
      if (_keyList[index].currentContext == null) {
        if (index < _lastIndex) {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).first;
        } else {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).last;
        }
        _lastIndex = _keyList.indexOf(_lastKey!);
        await _animateTo(_lastKey!.currentContext!,
            duration: duration, curve: curve);
        await animateToIndex(index);
      } else {
        _lastIndex = index;
        _lastKey = null;
        await _animateTo(_keyList[index].currentContext!,
            duration: duration, curve: curve);
      }
    }
  }

  Future<void> _animateTo(BuildContext context,
      {required Duration duration, required Curve curve}) async {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      double dy = rect.top - (_scrollTop ?? 0) + offset;
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      await animateTo(dy, duration: duration, curve: curve);
    }
  }
}

class AnchorScrollList extends StatefulWidget {
  const AnchorScrollList(
      {Key? key,
      required this.itemBuilder,
      required this.itemCount,
      this.controller,
      this.header})
      : super(key: key);
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final AnchorScrollController? controller;
  final Widget? header;

  @override
  State<AnchorScrollList> createState() => _AnchorScrollListState();
}

class _AnchorScrollListState extends State<AnchorScrollList> {
  GlobalKey headerKey = GlobalKey();
  GlobalKey scrollKey = GlobalKey();
  late AnchorScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? AnchorScrollController();
    controller._setKey(widget.itemCount, context, scrollKey,
        widget.header == null ? null : headerKey);
  }

  @override
  void didUpdateWidget(covariant AnchorScrollList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && controller != widget.controller) {
      controller.dispose();
      controller = widget.controller!;
    }
    if (oldWidget.itemCount != widget.itemCount) {
      controller._setKey(widget.itemCount, context, scrollKey,
          widget.header == null ? null : headerKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollList.builder(
        key: scrollKey,
        header: widget.header == null
            ? null
            : SliverToBoxAdapter(
                child: SizedBox(key: headerKey, child: widget.header)),
        controller: controller,
        itemCount: widget.itemCount,
        itemBuilder: (BuildContext context, int index) => SizedBox(
            key: controller._keyList[index],
            child: widget.itemBuilder(context, index)));
  }
}
