import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AutoScrollEntry extends StatefulWidget {
  final int initialIndex;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Duration animateDuration;

  /// 回调监听
  final WheelChangedListener onChanged;

  ///以下为滚轮属性
  ///高度
  final double itemHeight;
  final double itemWidth;

  const AutoScrollEntry(
      {Key key,
      int initialIndex,
      this.itemHeight,
      this.itemWidth,
      @required this.children,
      this.onChanged,
      this.margin,
      this.padding,
      this.duration,
      this.animateDuration})
      : this.initialIndex = initialIndex ?? 0,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AutoScrollEntryState();
  }
}

class AutoScrollEntryState extends State<AutoScrollEntry> {
  FixedExtentScrollController controller;
  Timer timer;
  int index = 0;
  double itemHeight = ScreenFit.getHeight(30);

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null &&
        widget.initialIndex < widget.children.length)
      index = widget.initialIndex;
    if (widget.itemHeight != null) itemHeight = widget.itemHeight;
    controller = FixedExtentScrollController(initialItem: widget.initialIndex);
    Tools.addPostFrameCallback((duration) {
      timer = Tools.timerPeriodic(widget.duration ?? Duration(seconds: 3),
          (callback) {
        index += 1;
        if (index > 100) index = 0;
        controller?.animateToItem(index,
            duration: widget.animateDuration ?? Duration(milliseconds: 500),
            curve: Curves.linear);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children == null || widget.children.length < 1)
      return Container();
    return Universal(
        margin: widget.margin,
        padding: widget.padding,
        width: widget.itemWidth,
        height: itemHeight,
        child: ListWheel(
            controller: controller,
            initialIndex: widget.initialIndex,
            itemExtent: itemHeight,
            magnification: 1,
            useMagnifier: false,
            squeeze: 2,
            perspective: 0.00001,
            childDelegateType: ListWheelChildDelegateType.looping,
            children: widget.children,
            physics: NeverScrollableScrollPhysics(),
            onChanged: widget.onChanged ?? (int index) {}));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
