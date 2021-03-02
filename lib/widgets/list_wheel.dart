import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListWheel extends StatefulWidget {
  ListWheel({
    Key key,
    bool looping,
    double itemExtent,
    double diameterRatio,
    double offAxisFraction,
    double perspective,
    int initialIndex,
    double magnification,
    bool useMagnifier,
    double squeeze,
    bool isCupertino,
    ScrollPhysics physics,
    this.controller,
    this.itemBuilder,
    this.itemCount,
    this.childDelegateType,
    this.onChanged,
    this.onScrollEnd,
    this.children,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.backgroundColor,
  })  : diameterRatio = diameterRatio ?? 1,
        offAxisFraction = offAxisFraction ?? 0,
        initialIndex = initialIndex ?? 0,
        perspective = perspective ?? 0.01,
        magnification = magnification ?? ConstConstant.listWheelMagnification,
        useMagnifier = useMagnifier ?? false,
        looping = looping ?? false,
        squeeze = squeeze ?? 1,
        isCupertino = isCupertino ?? true,
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

  ///  子组件
  final List<Widget> children;

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

  ///  滚轮类型
  final ListWheelChildDelegateType childDelegateType;

  ///  控制器
  final FixedExtentScrollController controller;

  ///  滚动监听 添加此方法  [onScrollStart],[onScrollUpdate],[onScrollEnd] 无效
  final NotificationListenerCallback<dynamic> onNotification;

  ///  动开始回调
  final ValueChanged<int> onScrollStart;

  ///  滚动中回调
  final ValueChanged<int> onScrollUpdate;

  ///  动结束回调
  final ValueChanged<int> onScrollEnd;

  final bool looping;

  ///  是否使用ios 样式
  final bool isCupertino;

  ///  [isCupertino]=true生效
  final Color backgroundColor;

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

  ListWheelChildDelegate getDelegate(ListWheelChildDelegateType type) {
    if (type == ListWheelChildDelegateType.list)
      return ListWheelChildListDelegate(children: widget.children);
    if (type == ListWheelChildDelegateType.looping)
      return ListWheelChildLoopingListDelegate(children: widget.children);
    return ListWheelChildBuilderDelegate(
        builder: widget.itemBuilder, childCount: widget.itemCount);
  }

  @override
  Widget build(BuildContext context) {
    final ListWheelChildDelegateType type =
        widget.childDelegateType ?? ListWheelChildDelegateType.builder;
    Widget child;
    final Function(int index) onSelectedItemChanged = (int index) =>
        widget.onChanged != null ? widget.onChanged(index) : null;
    if (widget.isCupertino) {
      child = type == ListWheelChildDelegateType.builder
          ? CupertinoPicker.builder(
              scrollController: controller,
              childCount: widget.itemCount,
              itemBuilder: widget.itemBuilder,
              backgroundColor: widget.backgroundColor,
              itemExtent: widget.itemExtent,
              diameterRatio: widget.diameterRatio,
              onSelectedItemChanged: onSelectedItemChanged,
              offAxisFraction: widget.offAxisFraction,
              useMagnifier: widget.useMagnifier,
              squeeze: widget.squeeze,
              magnification: widget.magnification)
          : CupertinoPicker(
              scrollController: controller,
              children: widget.children,
              backgroundColor: widget.backgroundColor,
              looping: type == ListWheelChildDelegateType.looping,
              itemExtent: widget.itemExtent,
              diameterRatio: widget.diameterRatio,
              onSelectedItemChanged: onSelectedItemChanged,
              offAxisFraction: widget.offAxisFraction,
              useMagnifier: widget.useMagnifier,
              squeeze: widget.squeeze,
              magnification: widget.magnification);
    } else {
      child = ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: widget.itemExtent,
          physics: widget.physics,
          diameterRatio: widget.diameterRatio,
          onSelectedItemChanged: onSelectedItemChanged,
          offAxisFraction: widget.offAxisFraction,
          perspective: widget.perspective,
          useMagnifier: widget.useMagnifier,
          squeeze: widget.squeeze,
          magnification: widget.magnification,
          childDelegate: getDelegate(type));
    }
    if (widget.onScrollStart == null &&
        widget.onScrollUpdate == null &&
        widget.onScrollEnd == null) return child;
    return NotificationListener<ScrollNotification>(
        child: child,
        onNotification: widget.onNotification ??
            (ScrollNotification notification) {
              if (notification is ScrollStartNotification &&
                  widget.onScrollStart != null)
                widget.onScrollStart(controller.selectedItem);

              if (notification is ScrollUpdateNotification &&
                  widget.onScrollUpdate != null)
                widget.onScrollUpdate(controller.selectedItem);

              if (notification is ScrollEndNotification &&
                  widget.onScrollEnd != null)
                widget.onScrollEnd(controller.selectedItem);
              return true;
            });
  }

  @override
  void dispose() {
    controller?.dispose();
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
      Duration duration,
      Duration animateDuration})
      : duration = duration ?? const Duration(seconds: 3),
        animateDuration = animateDuration ?? const Duration(milliseconds: 500),
        initialIndex = initialIndex ?? 0,
        super(key: key);

  final int initialIndex;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  /// 滚动停留时间
  final Duration duration;

  /// 滚动动画时间
  final Duration animateDuration;

  /// 滚动最大数量
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
  double itemHeight = 30;

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
    addPostFrameCallback((Duration duration) {
      timer = widget.duration.timerPeriodic((Timer callback) {
        index += 1;
        if (index >= maxItemCount) {
          index = 0;
          controller.jumpToItem(index);
        }
        controller?.animateToItem(index,
            duration: widget.animateDuration, curve: Curves.linear);
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
            isCupertino: false,
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
