import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class WheelOptions {
  const WheelOptions({
    this.diameterRatio = 1,
    this.offAxisFraction = 0,
    this.perspective = 0.01,
    this.magnification = 1.1,
    this.useMagnifier = false,
    this.squeeze = 1,
    this.itemExtent = 22,
    this.physics,
    this.onChanged,
    this.overAndUnderCenterOpacity = 0.447,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.isCupertino = true,
    this.backgroundColor,
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
  });

  /// wheel子item高度
  final double itemExtent;

  /// 半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  /// 选中item偏移
  final double offAxisFraction;

  /// 放大倍率
  final double magnification;

  /// 是否启用放大镜
  final bool useMagnifier;

  /// 上下间距默认为1 数越小 间距越大
  final double squeeze;

  /// ScrollPhysics
  final ScrollPhysics? physics;

  /// 回调监听
  final ValueChanged<int>? onChanged;

  /// 表示车轮水平偏离中心的程度  范围[0,0.01]
  /// [isCupertino]=false生效
  final double perspective;

  /// [isCupertino]=false生效
  final double overAndUnderCenterOpacity;

  /// [isCupertino]=false生效
  final bool renderChildrenOutsideViewport;

  /// [isCupertino]=false生效
  final Clip clipBehavior;

  /// [isCupertino]=false生效
  final String? restorationId;

  /// [isCupertino]=false生效
  final ScrollBehavior? scrollBehavior;

  /// 是否使用ios 样式
  final bool isCupertino;

  /// [isCupertino]=true生效
  final Color? backgroundColor;

  /// [isCupertino]=true生效
  final Widget? selectionOverlay;

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
          onChanged: onChanged ?? this.onChanged,
          backgroundColor: backgroundColor ?? this.backgroundColor);

  WheelOptions merge([WheelOptions? options]) => WheelOptions(
      itemExtent: options?.itemExtent ?? itemExtent,
      diameterRatio: options?.diameterRatio ?? diameterRatio,
      offAxisFraction: options?.offAxisFraction ?? offAxisFraction,
      perspective: options?.perspective ?? perspective,
      magnification: options?.magnification ?? magnification,
      useMagnifier: options?.useMagnifier ?? useMagnifier,
      squeeze: options?.squeeze ?? squeeze,
      isCupertino: options?.isCupertino ?? isCupertino,
      physics: options?.physics ?? physics,
      onChanged: options?.onChanged ?? onChanged,
      backgroundColor: options?.backgroundColor ?? backgroundColor);
}

class _CupertinoPicker extends CupertinoPicker {
  _CupertinoPicker.useDelegate({
    required super.itemExtent,
    required super.onSelectedItemChanged,
    required this.delegate,
    super.backgroundColor,
    super.diameterRatio,
    super.magnification,
    super.offAxisFraction,
    super.scrollController,
    super.selectionOverlay,
    super.squeeze,
    super.useMagnifier,
  }) : super(children: []);

  final ListWheelChildDelegate delegate;

  @override
  ListWheelChildDelegate get childDelegate => delegate;
}

class ListWheel extends StatelessWidget {
  const ListWheel({
    super.key,
    required this.delegate,
    this.controller,
    this.onScrollEnd,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options,
  });

  ListWheel.builder({
    super.key,
    required NullableIndexedWidgetBuilder itemBuilder,
    int? itemCount,
    this.controller,
    this.onScrollEnd,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options,
  }) : delegate = ListWheelChildBuilderDelegate(
            builder: itemBuilder, childCount: itemCount);

  ListWheel.count({
    super.key,
    required List<Widget> children,
    this.controller,
    this.onScrollEnd,
    this.onNotification,
    this.onScrollStart,
    this.onScrollUpdate,
    this.options,
    bool looping = false,
  }) : delegate = looping
            ? ListWheelChildLoopingListDelegate(children: children)
            : ListWheelChildListDelegate(children: children);

  final ListWheelChildDelegate delegate;

  final WheelOptions? options;

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

  @override
  Widget build(BuildContext context) {
    final wheelOptions = GlobalOptions().wheelOptions.merge(options);
    Widget child;
    if (wheelOptions.isCupertino) {
      child = _CupertinoPicker.useDelegate(
          scrollController: controller,
          backgroundColor: wheelOptions.backgroundColor,
          delegate: delegate,
          itemExtent: wheelOptions.itemExtent,
          diameterRatio: wheelOptions.diameterRatio,
          onSelectedItemChanged: wheelOptions.onChanged,
          offAxisFraction: wheelOptions.offAxisFraction,
          useMagnifier: wheelOptions.useMagnifier,
          squeeze: wheelOptions.squeeze,
          magnification: wheelOptions.magnification,
          selectionOverlay: wheelOptions.selectionOverlay);
    } else {
      child = ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: wheelOptions.itemExtent,
          physics: wheelOptions.physics,
          diameterRatio: wheelOptions.diameterRatio,
          onSelectedItemChanged: wheelOptions.onChanged,
          offAxisFraction: wheelOptions.offAxisFraction,
          perspective: wheelOptions.perspective,
          useMagnifier: wheelOptions.useMagnifier,
          squeeze: wheelOptions.squeeze,
          magnification: wheelOptions.magnification,
          renderChildrenOutsideViewport:
              wheelOptions.renderChildrenOutsideViewport,
          overAndUnderCenterOpacity: wheelOptions.overAndUnderCenterOpacity,
          clipBehavior: wheelOptions.clipBehavior,
          restorationId: wheelOptions.restorationId,
          scrollBehavior: wheelOptions.scrollBehavior,
          childDelegate: delegate);
    }
    if (onNotification == null &&
        onScrollStart == null &&
        onScrollUpdate == null &&
        onScrollEnd == null) return child;
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          onNotification?.call(notification);
          if (notification is ScrollStartNotification &&
              onScrollStart != null) {
            onScrollStart!(controller?.selectedItem ?? 0);
          } else if (notification is ScrollUpdateNotification &&
              onScrollUpdate != null) {
            onScrollUpdate!(controller?.selectedItem ?? 0);
          } else if (notification is ScrollEndNotification &&
              onScrollEnd != null) {
            onScrollEnd!(controller?.selectedItem ?? 0);
          }
          return false;
        },
        child: child);
  }
}

typedef ListWheelStateBuilder = ListWheel Function(
    FixedExtentScrollController controller);

/// 解决父组件重新 build 时 改变子元素长度后显示异常问题
/// 添加支持初始位置
class ListWheelState extends StatefulWidget {
  const ListWheelState(
      {super.key,
      this.initialItem = 0,
      this.controller,
      this.disposeController = true,
      this.animateDuration = const Duration(milliseconds: 10),
      this.curve = Curves.linear,
      this.onCreateController,
      required this.count,
      required this.builder});

  /// 默认为 true 组件 dispose 自动调用 controller.dispose()
  final bool disposeController;

  /// 条目数量
  final int count;

  /// 初始item
  final int initialItem;

  /// 控制器
  final FixedExtentScrollController? controller;

  /// [controller] 为null  自动创建 controller 回调
  final ValueCallback<FixedExtentScrollController>? onCreateController;

  /// animateToItem
  final Duration animateDuration;

  /// curve
  final Curve curve;

  final ListWheelStateBuilder builder;

  @override
  State<ListWheelState> createState() => _ListWheelStateState();
}

class _ListWheelStateState extends ExtendedState<ListWheelState> {
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        FixedExtentScrollController(initialItem: initialItem);
    if (widget.controller == null) widget.onCreateController?.call(controller);
  }

  int get initialItem =>
      widget.initialItem > widget.count ? widget.count : widget.initialItem;

  @override
  Widget build(BuildContext context) => widget.builder(controller);

  @override
  void didUpdateWidget(covariant ListWheelState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && controller != widget.controller) {
      controller.dispose();
      controller = widget.controller!;
    }
    if (controller.selectedItem > widget.count ||
        controller.selectedItem != widget.initialItem) {
      controller.animateToItem(initialItem,
          duration: widget.animateDuration, curve: widget.curve);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.disposeController) controller.dispose();
  }
}

class AutoScrollEntry extends StatefulWidget {
  const AutoScrollEntry(
      {super.key,
      this.duration = const Duration(seconds: 3),
      this.animateDuration = const Duration(milliseconds: 500),
      this.initialIndex = 0,
      this.itemHeight,
      this.maxItemCount,
      this.itemWidth,
      required this.children,
      this.onChanged,
      this.margin,
      this.padding});

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
  State<AutoScrollEntry> createState() => _AutoScrollEntryState();
}

class _AutoScrollEntryState extends ExtendedState<AutoScrollEntry> {
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
        child: ListWheel.count(
            looping: true,
            controller: controller,
            options: WheelOptions(
                physics: const NeverScrollableScrollPhysics(),
                onChanged: widget.onChanged ?? (int index) {},
                itemExtent: itemHeight,
                magnification: 1,
                useMagnifier: false,
                squeeze: 2,
                isCupertino: false,
                perspective: 0.00001),
            children: widget.children));
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
      {super.key,
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
      this.arrowIcon});

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
    final List<Widget> children = [];
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
      Icon(WayIcons.arrowRight, size: arrowSize, color: arrowColor);

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
