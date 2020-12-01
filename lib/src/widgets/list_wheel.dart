import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListWheel extends StatefulWidget {
  ListWheel({
    Key key,
    double itemExtent,
    double diameterRatio,
    double offAxisFraction,
    double perspective,
    int initialIndex,
    double magnification,
    bool useMagnifier,
    double squeeze,
    ScrollPhysics physics,
    this.itemBuilder,
    this.itemCount,
    this.childDelegateType,
    this.controller,
    this.onChanged,
    this.onScrollEnd,
    this.children,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
  })  : diameterRatio = diameterRatio ?? 1,
        offAxisFraction = offAxisFraction ?? 0,
        initialIndex = initialIndex ?? 0,
        perspective = perspective ?? 0.01,
        magnification = magnification ?? ConstConstant.listWheelMagnification,
        useMagnifier = useMagnifier ?? true,
        squeeze = squeeze ?? 1,
        itemExtent = itemExtent ?? ConstConstant.pickerItemHeight,
        physics = physics ?? const FixedExtentScrollPhysics(),
        super(key: key) {
    if (childDelegateType == ListWheelChildDelegateType.list ||
        childDelegateType == ListWheelChildDelegateType.looping) {
      assert(children != null);
    }
    if (childDelegateType == null ||
        childDelegateType == ListWheelChildDelegateType.builder) {
      assert(itemCount != null && itemBuilder != null,
          'childDelegateType default is "ListWheelChildDelegateType.builder", The necessary conditions must be passed');
    }
  }

  ///  每个Item的高度,固定的
  final double itemExtent;

  ///  条目构造器
  final IndexedWidgetBuilder itemBuilder;

  ///  条目数量
  final int itemCount;

  ///  半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  ///  选中item偏移
  final double offAxisFraction;

  ///  表示车轮水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  ///  初始选中的Item
  final int initialIndex;

  ///  回调监听
  final ValueChanged<int> onChanged;

  ///  放大倍率
  final double magnification;

  ///  是否启用放大镜
  final bool useMagnifier;

  ///  1或者2
  final double squeeze;

  ///
  final ScrollPhysics physics;

  final ListWheelChildDelegateType childDelegateType;
  final FixedExtentScrollController controller;
  final List<Widget> children;

  ///  滚动监听 添加此方法  [onScrollStart],[onScrollUpdate],[onScrollEnd] 无效
  final NotificationListenerCallback<dynamic> onNotification;

  ///  动开始回调
  final ValueChanged<int> onScrollStart;

  ///  滚动中回调
  final ValueChanged<int> onScrollUpdate;

  ///  动结束回调
  final ValueChanged<int> onScrollEnd;

  @override
  _ListWheelState createState() => _ListWheelState();
}

class _ListWheelState extends State<ListWheel> {
  FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    ListWheelChildDelegate childDelegate;
    switch (widget?.childDelegateType) {
      case ListWheelChildDelegateType.builder:
        childDelegate = ListWheelChildBuilderDelegate(
            builder: widget.itemBuilder, childCount: widget.itemCount);
        break;
      case ListWheelChildDelegateType.list:
        childDelegate = ListWheelChildListDelegate(children: widget.children);
        break;
      case ListWheelChildDelegateType.looping:
        childDelegate =
            ListWheelChildLoopingListDelegate(children: widget.children);
        break;
      default:
        childDelegate = ListWheelChildBuilderDelegate(
            builder: widget.itemBuilder, childCount: widget.itemCount);
        break;
    }

    Widget wheel = ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: widget.itemExtent,
        physics: widget.physics,
        diameterRatio: widget.diameterRatio,
        onSelectedItemChanged: (int index) {
          if (widget?.onChanged != null) widget.onChanged(index);
        },
        offAxisFraction: widget.offAxisFraction,
        perspective: widget.perspective,
        useMagnifier: widget.useMagnifier,
        squeeze: widget.squeeze,
        magnification: widget.magnification,
        childDelegate: childDelegate);
    if (widget.onScrollEnd != null) {
      ///  ignore: always_specify_types
      wheel = NotificationListener(
          child: wheel,
          onNotification: widget.onNotification ??
              (Notification notification) {
                if (notification is ScrollStartNotification)
                  widget.onScrollStart(controller.selectedItem);
                if (notification is ScrollUpdateNotification)
                  widget.onScrollUpdate(controller.selectedItem);
                if (notification is ScrollEndNotification)
                  widget.onScrollEnd(controller.selectedItem);
                return true;
              });
    }
    return wheel;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AutoScrollEntry extends StatefulWidget {
  const AutoScrollEntry(
      {Key key,
      int initialIndex,
      this.itemHeight,
      this.maxItemCount,
      this.itemWidth,
      @required this.children,
      this.onChanged,
      this.margin,
      this.padding,
      this.duration,
      this.animateDuration})
      : initialIndex = initialIndex ?? 0,
        super(key: key);

  final int initialIndex;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Duration animateDuration;
  final int maxItemCount;

  ///  回调监听
  final ValueChanged<int> onChanged;

  ///  以下为滚轮属性
  ///  高度
  final double itemHeight;
  final double itemWidth;

  @override
  _AutoScrollEntryState createState() => _AutoScrollEntryState();
}

class _AutoScrollEntryState extends State<AutoScrollEntry> {
  FixedExtentScrollController controller;
  Timer timer;
  int index = 0;
  int maxItemCount = 10;
  double itemHeight = getHeight(30);

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null &&
        widget.initialIndex < widget.children.length)
      index = widget.initialIndex;
    if (widget.itemHeight != null) itemHeight = widget.itemHeight;
    controller = FixedExtentScrollController(initialItem: widget.initialIndex);
    if (widget.maxItemCount == null) {
      if (widget.children.length > maxItemCount)
        maxItemCount = widget.children.length;
    } else {
      maxItemCount = widget.maxItemCount;
    }
    Tools.addPostFrameCallback((Duration duration) {
      timer = Tools.timerPeriodic(widget.duration ?? const Duration(seconds: 3),
          (Timer callback) {
        index += 1;
        if (index >= maxItemCount) {
          index = 0;
          controller.jumpToItem(index);
        }
        controller?.animateToItem(index,
            duration:
                widget.animateDuration ?? const Duration(milliseconds: 500),
            curve: Curves.linear);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children == null || widget.children.isEmpty) return Container();
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
            physics: const NeverScrollableScrollPhysics(),
            onChanged: widget.onChanged ?? (int index) {}));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
