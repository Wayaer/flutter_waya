import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AnchorScrollController extends ScrollController {
  List<GlobalKey> _keyList = [];
  GlobalKey? _lastKey;
  BuildContext? _context;
  double? _scrollTop;
  RenderObject? _ancestor;

  void _setKey(int count, BuildContext context, GlobalKey scrollKey,
      GlobalKey? headerKey) {
    _context = context;
    _keyList = count.generate((index) => GlobalKey());
  }

  Future<void> animateToIndex(int index) async {
    if (_keyList.length >= index && _context != null) {
      if (_scrollTop == null) {
        _ancestor = Navigator.of(_context!).context.findRenderObject();
        final firstOffset = _keyList.first.currentContext
            ?.getWidgetLocalToGlobal(ancestor: _ancestor);
        if (firstOffset != null) {
          _scrollTop = firstOffset.dy;
        }
      }
      if (_keyList[index].currentContext == null) {
        _lastKey =
            _keyList.where((element) => element.currentContext != null).last;
        log('获取到最后一个${_keyList.indexOf(_lastKey!)}');
      } else {
        log('直接跳转最后一个');
        _lastKey = null;
        await _animateTo(_keyList[index].currentContext!);
      }
      if (_lastKey != null && _lastKey!.currentContext != null) {
        await _animateTo(_lastKey!.currentContext!);
        await animateToIndex(index);
      }
    }
  }

  Future<void> _animateTo(BuildContext context) async {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      // _scrollTop = 0;
      log(_scrollTop);
      double dy = rect.top - (_scrollTop ?? 0) + offset;
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      await animateTo(dy,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
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
    addPostFrameCallback((_) {
      final ancestor = Navigator.of(context).context.findRenderObject();
      final headerRect = headerKey.currentContext
          ?.getWidgetRectLocalToGlobal(ancestor: ancestor);
      log(headerRect);
      final scrollRect = scrollKey.currentContext
          ?.getWidgetRectLocalToGlobal(ancestor: ancestor);
      log(scrollRect);
      final firstRect = controller._keyList.first.currentContext
          ?.getWidgetRectLocalToGlobal(ancestor: ancestor);
      log(firstRect);

      final headerOffset =
          headerKey.currentContext?.getWidgetLocalToGlobal(ancestor: ancestor);
      log(headerOffset);
      final scrollOffset =
          scrollKey.currentContext?.getWidgetLocalToGlobal(ancestor: ancestor);
      log(scrollOffset);
      final firstOffset = controller._keyList.first.currentContext
          ?.getWidgetLocalToGlobal(ancestor: ancestor);
      log(firstOffset);
    });
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
