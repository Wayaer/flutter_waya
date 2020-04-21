import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_waya/waya.dart';

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
  final WheelChangedListener onItemSelected;

  /// ///放大倍率
  final double magnification;

  ///是否启用放大镜
  final bool useMagnifier;

  ///1或者2
  final double squeeze;

  ///
  final ScrollPhysics physics;

  final FixedExtentScrollController controller;

  ListWheel({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    double itemExtent,
    double diameterRatio,
    double offAxisFraction,
    double perspective,
    int initialIndex,
    double magnification,
    bool useMagnifier,
    double squeeze,
    ScrollPhysics physics,
    FixedExtentScrollController controller,
    this.onItemSelected,
  })  : this.diameterRatio = diameterRatio ?? 1,
        this.offAxisFraction = offAxisFraction ?? 0,
        this.initialIndex = initialIndex ?? 0,
        this.perspective = perspective ?? 0.01,
        this.magnification = magnification ?? 1.5,
        this.useMagnifier = useMagnifier ?? true,
        this.squeeze = squeeze ?? 1,
        this.itemExtent = itemExtent ?? Tools.getHeight(12),
        this.physics = physics ?? FixedExtentScrollPhysics(),
        this.controller = controller ?? FixedExtentScrollController(initialItem: initialIndex),
        super(key: key);

  @override
  ListWheelState createState() => ListWheelState();
}

class ListWheelState extends State<ListWheel> {
  FixedExtentScrollController controller;

  void animateToItem(int index) {
    if (controller != null && controller.hasClients) {
      if (widget.onItemSelected != null && widget.itemCount > 0) {
        if (index == null || index < 0) {
          index = 0;
        } else if (index > this.widget.itemCount - 1) {
          index = this.widget.itemCount - 1;
        }
        controller.animateToItem(index, duration: Duration(milliseconds: 100), curve: Curves.linear);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    if (widget.controller != null && widget.initialIndex > widget.controller.initialItem) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        animateToItem(widget.initialIndex);
      });
    }
  }

  @override
  void didUpdateWidget(ListWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        animateToItem(widget.initialIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollEndNotification>(
        onNotification: onNotification,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: widget.itemExtent,
          physics: widget.physics,
          diameterRatio: widget.diameterRatio,
          onSelectedItemChanged: (_) {},
          offAxisFraction: widget.offAxisFraction,
          perspective: widget.perspective,
          useMagnifier: widget.useMagnifier,
          squeeze: widget.squeeze,
          magnification: widget.magnification,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: widget.itemBuilder,
            childCount: widget.itemCount,
          ),
        ),
      );

  bool onNotification(ScrollEndNotification notification) {
    //   滚动结束的监听事件
    if (notification is ScrollEndNotification && widget.onItemSelected != null) {
      var pixels = notification.metrics.pixels;
      var newIndex = (pixels / widget.itemExtent).round();
      widget.onItemSelected(newIndex);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
