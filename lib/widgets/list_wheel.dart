import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum ListWheelChildDelegateType {
  /// 有大量子控件时使用 子组件不会全部渲染
  builder,

  /// 不推荐使用 子组件会全部渲染
  list,

  /// 一个提供无限通过循环显式列表的子级
  looping
}

class WheelOptions {
  const WheelOptions({
    this.backgroundColor,
    this.looping = false,
    this.diameterRatio = 1,
    this.offAxisFraction = 0,
    this.perspective = 0.01,
    this.magnification = 1.1,
    this.useMagnifier = false,
    this.squeeze = 1,
    this.isCupertino = true,
    this.itemExtent = 22,
    this.physics = const FixedExtentScrollPhysics(),
    this.onChanged,
  });

  /// 每个Item的高度,固定的
  final double itemExtent;

  /// 半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  /// 选中item偏移
  final double offAxisFraction;

  /// 表示车轮水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  /// 放大倍率
  final double magnification;

  /// 是否启用放大镜
  final bool useMagnifier;

  /// 上下间距默认为1 数越小 间距越大
  final double squeeze;

  /// 是否使用ios 样式
  final bool isCupertino;

  /// ScrollPhysics
  final ScrollPhysics physics;

  final bool looping;

  /// 回调监听
  final ValueChanged<int>? onChanged;

  /// [isCupertino]=true生效
  final Color? backgroundColor;
}

class ListWheel extends StatefulWidget {
  ListWheel({
    Key? key,
    this.initialIndex = 0,
    this.controller,
    this.itemBuilder,
    this.itemCount,
    this.childDelegateType = ListWheelChildDelegateType.looping,
    this.onScrollEnd,
    this.children,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options = const WheelOptions(),
  }) : super(key: key) {
    if (childDelegateType == ListWheelChildDelegateType.list ||
        childDelegateType == ListWheelChildDelegateType.looping) {
      assert(children != null);
    }
    if (childDelegateType == ListWheelChildDelegateType.builder) {
      assert(itemCount != null && itemBuilder != null,
          'childDelegateType default is "ListWheelChildDelegateType.builder", The necessary conditions must be passed');
    }
  }

  /// 初始选中的Item
  final int initialIndex;

  final WheelOptions options;

  /// 子组件
  final List<Widget>? children;

  /// 条目构造器
  final IndexedWidgetBuilder? itemBuilder;

  /// 条目数量
  final int? itemCount;

  /// 滚轮类型
  final ListWheelChildDelegateType childDelegateType;

  /// 控制器
  final FixedExtentScrollController? controller;

  /// 滚动监听 添加此方法  [onScrollStart],[onScrollUpdate],[onScrollEnd] 无效
  final NotificationListenerCallback<ScrollNotification>? onNotification;

  /// 动开始回调
  final ValueChanged<int>? onScrollStart;

  /// 滚动中回调
  final ValueChanged<int>? onScrollUpdate;

  /// 动结束回调
  final ValueChanged<int>? onScrollEnd;

  @override
  _ListWheelState createState() => _ListWheelState();
}

class _ListWheelState extends State<ListWheel> {
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  ListWheelChildDelegate getDelegate(ListWheelChildDelegateType type) {
    if (type == ListWheelChildDelegateType.list) {
      return ListWheelChildListDelegate(children: widget.children!);
    }
    if (type == ListWheelChildDelegateType.looping) {
      return ListWheelChildLoopingListDelegate(children: widget.children!);
    }
    return ListWheelChildBuilderDelegate(
        builder: widget.itemBuilder!, childCount: widget.itemCount);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.options.isCupertino) {
      child = widget.childDelegateType == ListWheelChildDelegateType.builder
          ? CupertinoPicker.builder(
              scrollController: controller,
              childCount: widget.itemCount,
              itemBuilder: widget.itemBuilder!,
              backgroundColor: widget.options.backgroundColor,
              itemExtent: widget.options.itemExtent,
              diameterRatio: widget.options.diameterRatio,
              onSelectedItemChanged: widget.options.onChanged,
              offAxisFraction: widget.options.offAxisFraction,
              useMagnifier: widget.options.useMagnifier,
              squeeze: widget.options.squeeze,
              magnification: widget.options.magnification)
          : CupertinoPicker(
              scrollController: controller,
              children: widget.children!,
              backgroundColor: widget.options.backgroundColor,
              looping: widget.childDelegateType ==
                  ListWheelChildDelegateType.looping,
              itemExtent: widget.options.itemExtent,
              diameterRatio: widget.options.diameterRatio,
              onSelectedItemChanged: widget.options.onChanged,
              offAxisFraction: widget.options.offAxisFraction,
              useMagnifier: widget.options.useMagnifier,
              squeeze: widget.options.squeeze,
              magnification: widget.options.magnification);
    } else {
      child = ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: widget.options.itemExtent,
          physics: widget.options.physics,
          diameterRatio: widget.options.diameterRatio,
          onSelectedItemChanged: widget.options.onChanged,
          offAxisFraction: widget.options.offAxisFraction,
          perspective: widget.options.perspective,
          useMagnifier: widget.options.useMagnifier,
          squeeze: widget.options.squeeze,
          magnification: widget.options.magnification,
          childDelegate: getDelegate(widget.childDelegateType));
    }
    if (widget.onScrollStart == null &&
        widget.onScrollUpdate == null &&
        widget.onScrollEnd == null) return child;
    return NotificationListener<ScrollNotification>(
        child: child,
        onNotification: widget.onNotification ??
            (ScrollNotification notification) {
              if (notification is ScrollStartNotification &&
                  widget.onScrollStart != null) {
                widget.onScrollStart!(controller.selectedItem);
              } else if (notification is ScrollUpdateNotification &&
                  widget.onScrollUpdate != null) {
                widget.onScrollUpdate!(controller.selectedItem);
              } else if (notification is ScrollEndNotification &&
                  widget.onScrollEnd != null) {
                widget.onScrollEnd!(controller.selectedItem);
              }
              return true;
            });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) controller.dispose();
  }
}

class AutoScrollEntry extends StatefulWidget {
  const AutoScrollEntry(
      {Key? key,
      this.duration = const Duration(seconds: 3),
      this.animateDuration = const Duration(milliseconds: 500),
      this.initialIndex = 0,
      this.itemHeight,
      this.maxItemCount,
      this.itemWidth,
      required this.children,
      this.onChanged,
      this.margin,
      this.padding})
      : super(key: key);

  final int initialIndex;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// 滚动停留时间
  final Duration duration;

  /// 滚动动画时间
  final Duration animateDuration;

  /// 滚动最大数量
  final int? maxItemCount;

  /// 回调监听
  final ValueChanged<int>? onChanged;

  /// 以下为滚轮属性
  /// 高度
  final double? itemHeight;
  final double? itemWidth;

  @override
  _AutoScrollEntryState createState() => _AutoScrollEntryState();
}

class _AutoScrollEntryState extends State<AutoScrollEntry> {
  late FixedExtentScrollController controller;
  Timer? timer;
  int index = 0;
  int maxItemCount = 10;
  double itemHeight = 30;

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex < widget.children.length) {
      index = widget.initialIndex;
    }
    if (widget.itemHeight != null) itemHeight = widget.itemHeight!;
    controller = FixedExtentScrollController(initialItem: widget.initialIndex);
    if (widget.maxItemCount == null) {
      if (widget.children.length > maxItemCount) {
        maxItemCount = widget.children.length;
      }
    } else {
      maxItemCount = widget.maxItemCount!;
    }
    addPostFrameCallback((Duration duration) {
      timer = widget.duration.timerPeriodic((Timer callback) {
        index += 1;
        if (index >= maxItemCount) {
          index = 0;
          controller.jumpToItem(index);
        }
        controller.animateToItem(index,
            duration: widget.animateDuration, curve: Curves.linear);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return Container();
    return Universal(
        margin: widget.margin,
        padding: widget.padding,
        width: widget.itemWidth,
        height: itemHeight,
        child: ListWheel(
          controller: controller,
          initialIndex: widget.initialIndex,
          options: WheelOptions(
              physics: const NeverScrollableScrollPhysics(),
              onChanged: widget.onChanged ?? (int index) {},
              itemExtent: itemHeight,
              magnification: 1,
              useMagnifier: false,
              squeeze: 2,
              isCupertino: false,
              perspective: 0.00001),
          childDelegateType: ListWheelChildDelegateType.looping,
          children: widget.children,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }
}

class ListEntry extends StatelessWidget {
  const ListEntry(
      {Key? key,
      this.isThreeLine = false,
      this.enabled = true,
      this.dense = true,
      this.arrow = false,
      this.inkWell = false,
      this.titleText = '',
      this.arrowSize = 15,
      this.onTap,
      this.heroTag,
      this.onDoubleTap,
      this.onLongPress,
      this.title,
      this.height,
      this.padding,
      this.margin,
      this.decoration,
      this.child,
      this.color,
      this.titleStyle,
      this.underlineColor,
      this.leading,
      this.subtitle,
      this.contentPadding,
      this.selected,
      this.prefix,
      this.arrowColor,
      this.arrowIcon})
      : super(key: key);

  /// 单击事件
  final GestureTapCallback? onTap;

  /// 双击事件
  final GestureTapCallback? onDoubleTap;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  /// 显示三行
  final bool isThreeLine;

  /// 是否默认3行高度，subtitle不为空时才能使用
  final bool? selected;

  /// 设置为true后 高度变小 默认为true
  final bool dense;

  /// 内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 左侧widget
  final Widget? leading;

  /// 副标题
  final Widget? subtitle;

  /// 右侧widget
  final Widget? child;

  /// 右边是否有箭头
  final bool arrow;
  final Widget? arrowIcon;
  final double arrowSize;
  final Color? arrowColor;

  /// 中间内容
  final Widget? title;
  final String titleText;
  final TextStyle? titleStyle;
  final String? heroTag;

  /// 高
  final double? height;

  /// 前缀
  final Widget? prefix;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool inkWell;
  final Color? underlineColor;
  final Color? color;

  /// 是否可点击
  final bool enabled;

  /// 整个ListEntry装饰器
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (prefix != null) children.add(prefix!);
    children.add(listTile);
    if (arrow || arrowIcon != null) children.add(arrowIcon ?? arrowWidget);
    return Universal(
        height: height,
        addInkWell: inkWell,
        margin: margin,
        padding: padding,
        onLongPress: enabled ? onLongPress : null,
        onDoubleTap: enabled ? onDoubleTap : null,
        onTap: enabled ? onTap : null,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        decoration: decoration ?? defaultDecoration,
        children: children);
  }

  Decoration? get defaultDecoration => color != null
      ? BoxDecoration(
          color: color,
          border: underlineColor != null
              ? Border(bottom: BorderSide(color: underlineColor!))
              : null)
      : null;

  Widget get arrowWidget =>
      Icon(ConstIcon.arrowRight, size: arrowSize, color: arrowColor);

  Widget get listTile => Expanded(
      child: ListTile(
          contentPadding: contentPadding,
          title: hero(title ?? BText(titleText, style: titleStyle)),
          subtitle: subtitle,
          leading: leading,
          trailing: child,
          isThreeLine: isThreeLine,
          dense: dense,
          enabled: false,
          selected: selected ?? false));

  Widget hero(Widget text) {
    if (heroTag != null) return Hero(tag: heroTag!, child: text);
    return text;
  }
}
