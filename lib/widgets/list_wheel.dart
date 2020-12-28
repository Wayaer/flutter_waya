import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListWheel extends StatelessWidget {
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
    FixedExtentScrollController controller,
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
        controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex),
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

  ListWheelChildDelegate getDelegate(ListWheelChildDelegateType type) {
    if (type == ListWheelChildDelegateType.list)
      return ListWheelChildListDelegate(children: children);
    if (type == ListWheelChildDelegateType.looping)
      return ListWheelChildLoopingListDelegate(children: children);
    return ListWheelChildBuilderDelegate(
        builder: itemBuilder, childCount: itemCount);
  }

  @override
  Widget build(BuildContext context) {
    final ListWheelChildDelegateType type =
        childDelegateType ?? ListWheelChildDelegateType.builder;
    Widget wheel;
    final Function(int index) onSelectedItemChanged =
        (int index) => onChanged != null ? onChanged(index) : null;
    if (isCupertino) {
      wheel = type == ListWheelChildDelegateType.builder
          ? CupertinoPicker.builder(
              scrollController: controller,
              childCount: itemCount,
              itemBuilder: itemBuilder,
              backgroundColor: backgroundColor,
              itemExtent: itemExtent,
              diameterRatio: diameterRatio,
              onSelectedItemChanged: onSelectedItemChanged,
              offAxisFraction: offAxisFraction,
              useMagnifier: useMagnifier,
              squeeze: squeeze,
              magnification: magnification)
          : CupertinoPicker(
              scrollController: controller,
              children: children,
              backgroundColor: backgroundColor,
              looping: type == ListWheelChildDelegateType.looping,
              itemExtent: itemExtent,
              diameterRatio: diameterRatio,
              onSelectedItemChanged: onSelectedItemChanged,
              offAxisFraction: offAxisFraction,
              useMagnifier: useMagnifier,
              squeeze: squeeze,
              magnification: magnification);
    } else {
      wheel = ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: itemExtent,
          physics: physics,
          diameterRatio: diameterRatio,
          onSelectedItemChanged: onSelectedItemChanged,
          offAxisFraction: offAxisFraction,
          perspective: perspective,
          useMagnifier: useMagnifier,
          squeeze: squeeze,
          magnification: magnification,
          childDelegate: getDelegate(type));
    }
    if (onScrollEnd != null) {
      wheel = NotificationListener<ScrollNotification>(
          child: wheel,
          onNotification: onNotification ??
              (ScrollNotification notification) {
                if (notification is ScrollStartNotification &&
                    onScrollStart != null)
                  onScrollStart(controller.selectedItem);

                if (notification is ScrollUpdateNotification &&
                    onScrollUpdate != null)
                  onScrollUpdate(controller.selectedItem);

                if (notification is ScrollEndNotification &&
                    onScrollEnd != null) onScrollEnd(controller.selectedItem);
                return true;
              });
    }
    return wheel;
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
    Ts.addPostFrameCallback((Duration duration) {
      timer = Ts.timerPeriodic(widget.duration ?? const Duration(seconds: 3),
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
