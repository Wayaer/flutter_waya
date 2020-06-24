import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef WheelChangedListener = Function(int newIndex);

class ListWheel extends StatefulWidget {
  /// 每个Item的高度,固定的
  final double itemExtent;

  /// 条目构造器
  final IndexedWidgetBuilder itemBuilder;

  /// 条目数量
  final int itemCount;

  /// 半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  /// 选中item偏移
  final double offAxisFraction;

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  /// 初始选中的Item
  final int initialIndex;

  /// 回调监听
  final WheelChangedListener onChanged;

  /// ///放大倍率
  final double magnification;

  ///是否启用放大镜
  final bool useMagnifier;

  ///1或者2
  final double squeeze;

  ///
  final ScrollPhysics physics;

  final ListWheelChildDelegateType childDelegateType;
  final FixedExtentScrollController controller;
  final List<Widget> children;

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
    this.children,
  })  : this.diameterRatio = diameterRatio ?? 1,
        this.offAxisFraction = offAxisFraction ?? 0,
        this.initialIndex = initialIndex ?? 0,
        this.perspective = perspective ?? 0.01,
        this.magnification = magnification ?? 1.5,
        this.useMagnifier = useMagnifier ?? true,
        this.squeeze = squeeze ?? 1,
        this.itemExtent = itemExtent ?? Tools.getHeight(12),
        this.physics = physics ?? FixedExtentScrollPhysics(),
        super(key: key);

  @override
  ListWheelState createState() => ListWheelState();
}

class ListWheelState extends State<ListWheel> {
  FixedExtentScrollController controller;
  ListWheelChildDelegateType childDelegateType;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        FixedExtentScrollController(initialItem: widget.initialIndex);
    childDelegateType =
        widget.childDelegateType ?? ListWheelChildDelegateType.builder;
  }

  @override
  Widget build(BuildContext context) {
    ListWheelChildDelegate childDelegate;
    switch (childDelegateType) {
      case ListWheelChildDelegateType.builder:
        assert(widget.itemCount != null);
        assert(widget.itemBuilder != null);
        childDelegate = ListWheelChildBuilderDelegate(
            builder: widget.itemBuilder, childCount: widget.itemCount);
        break;
      case ListWheelChildDelegateType.list:
        assert(widget.children != null);
        childDelegate = ListWheelChildListDelegate(children: widget.children);
        break;
      case ListWheelChildDelegateType.looping:
        assert(widget.children != null);
        childDelegate =
            ListWheelChildLoopingListDelegate(children: widget.children);
        break;
    }
    if (childDelegate == null) return Container();

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: widget.itemExtent,
      physics: widget.physics,
      diameterRatio: widget.diameterRatio,
      onSelectedItemChanged: (int index) => widget.onChanged(index),
      offAxisFraction: widget.offAxisFraction,
      perspective: widget.perspective,
      useMagnifier: widget.useMagnifier,
      squeeze: widget.squeeze,
      magnification: widget.magnification,
      childDelegate: childDelegate,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
