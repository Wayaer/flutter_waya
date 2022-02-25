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

  WheelOptions copyWith({
    double? itemExtent,
    double? diameterRatio,
    double? offAxisFraction,
    double? perspective,
    double? magnification,
    bool? useMagnifier,
    double? squeeze,
    bool? isCupertino,
    ScrollPhysics? physics,
    bool? looping,
    ValueChanged<int>? onChanged,
    Color? backgroundColor,
  }) =>
      WheelOptions(
          itemExtent: itemExtent ?? this.itemExtent,
          diameterRatio: diameterRatio ?? this.diameterRatio,
          offAxisFraction: offAxisFraction ?? this.offAxisFraction,
          perspective: perspective ?? this.perspective,
          magnification: magnification ?? this.magnification,
          useMagnifier: useMagnifier ?? this.useMagnifier,
          squeeze: squeeze ?? this.squeeze,
          isCupertino: isCupertino ?? this.isCupertino,
          physics: physics ?? this.physics,
          looping: looping ?? this.looping,
          onChanged: onChanged ?? this.onChanged,
          backgroundColor: backgroundColor ?? this.backgroundColor);
}

class ListWheel extends StatelessWidget {
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
    this.options,
  })  : assert(_checkType(childDelegateType, children, itemBuilder, itemCount)),
        super(key: key);

  static bool _checkType(
      ListWheelChildDelegateType childDelegateType,
      List<Widget>? children,
      IndexedWidgetBuilder? itemBuilder,
      int? itemCount) {
    if (childDelegateType == ListWheelChildDelegateType.list ||
        childDelegateType == ListWheelChildDelegateType.looping) {
      assert(children != null, 'The list and Looping types must use children');
      return children != null;
    } else {
      assert(itemCount != null && itemBuilder != null,
          'childDelegateType default is "ListWheelChildDelegateType.builder", The necessary conditions must be passed');
      return itemCount != null && itemBuilder != null;
    }
  }

  const ListWheel.builder({
    Key? key,
    this.initialIndex = 0,
    this.controller,
    required this.itemBuilder,
    required this.itemCount,
    this.onScrollEnd,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options,
  })  : assert(itemBuilder != null && itemCount != null),
        childDelegateType = ListWheelChildDelegateType.builder,
        children = null,
        super(key: key);

  const ListWheel.list({
    Key? key,
    this.initialIndex = 0,
    this.controller,
    this.onScrollEnd,
    required this.children,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options,
  })  : assert(children != null),
        childDelegateType = ListWheelChildDelegateType.list,
        itemBuilder = null,
        itemCount = null,
        super(key: key);

  const ListWheel.looping({
    Key? key,
    this.initialIndex = 0,
    this.controller,
    this.onScrollEnd,
    this.children,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options,
  })  : assert(children != null),
        childDelegateType = ListWheelChildDelegateType.looping,
        itemBuilder = null,
        itemCount = null,
        super(key: key);

  /// 初始选中的Item
  final int initialIndex;

  final WheelOptions? options;

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

  /// 滚动开始回调
  final ValueChanged<int>? onScrollStart;

  /// 滚动中回调
  final ValueChanged<int>? onScrollUpdate;

  /// 滚动结束回调
  final ValueChanged<int>? onScrollEnd;

  ListWheelChildDelegate getDelegate(ListWheelChildDelegateType type) {
    if (type == ListWheelChildDelegateType.list) {
      return ListWheelChildListDelegate(children: children!);
    }
    if (type == ListWheelChildDelegateType.looping) {
      return ListWheelChildLoopingListDelegate(children: children!);
    }
    return ListWheelChildBuilderDelegate(
        builder: itemBuilder!, childCount: itemCount);
  }

  @override
  Widget build(BuildContext context) {
    if (onScrollStart != null ||
        onScrollEnd != null ||
        onScrollUpdate != null) {
      assert(controller != null, 'controller must be added');
    }

    final _options = options ?? GlobalOptions().wheelOptions;
    Widget child;
    if (_options.isCupertino) {
      child = childDelegateType == ListWheelChildDelegateType.builder
          ? CupertinoPicker.builder(
              scrollController: controller,
              childCount: itemCount,
              itemBuilder: itemBuilder!,
              backgroundColor: _options.backgroundColor,
              itemExtent: _options.itemExtent,
              diameterRatio: _options.diameterRatio,
              onSelectedItemChanged: _options.onChanged,
              offAxisFraction: _options.offAxisFraction,
              useMagnifier: _options.useMagnifier,
              squeeze: _options.squeeze,
              magnification: _options.magnification)
          : CupertinoPicker(
              scrollController: controller,
              children: children!,
              backgroundColor: _options.backgroundColor,
              looping: childDelegateType == ListWheelChildDelegateType.looping,
              itemExtent: _options.itemExtent,
              diameterRatio: _options.diameterRatio,
              onSelectedItemChanged: _options.onChanged,
              offAxisFraction: _options.offAxisFraction,
              useMagnifier: _options.useMagnifier,
              squeeze: _options.squeeze,
              magnification: _options.magnification);
    } else {
      child = ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: _options.itemExtent,
          physics: _options.physics,
          diameterRatio: _options.diameterRatio,
          onSelectedItemChanged: _options.onChanged,
          offAxisFraction: _options.offAxisFraction,
          perspective: _options.perspective,
          useMagnifier: _options.useMagnifier,
          squeeze: _options.squeeze,
          magnification: _options.magnification,
          childDelegate: getDelegate(childDelegateType));
    }
    if (onScrollStart == null &&
        onScrollUpdate == null &&
        onScrollEnd == null &&
        controller != null) {
      return child;
    }
    return NotificationListener<ScrollNotification>(
        child: child,
        onNotification: onNotification ??
            (ScrollNotification notification) {
              if (notification is ScrollStartNotification &&
                  onScrollStart != null) {
                onScrollStart!(controller!.selectedItem);
              } else if (notification is ScrollUpdateNotification &&
                  onScrollUpdate != null) {
                onScrollUpdate!(controller!.selectedItem);
              } else if (notification is ScrollEndNotification &&
                  onScrollEnd != null) {
                onScrollEnd!(controller!.selectedItem);
              }
              return true;
            });
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

  Decoration? get defaultDecoration => color != null || underlineColor != null
      ? BoxDecoration(
          color: color,
          border: underlineColor != null
              ? Border(bottom: BorderSide(color: underlineColor!, width: 0.8))
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
