import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class WheelOptions {
  const WheelOptions.custom(
      {this.physics,
      this.diameterRatio = 2.0,
      this.perspective = 0.003,
      this.offAxisFraction = 0.0,
      this.useMagnifier = false,
      this.magnification = 1.0,
      this.overAndUnderCenterOpacity = 1.0,
      this.itemExtent = 30,
      this.squeeze = 1.0,
      this.renderChildrenOutsideViewport = false,
      this.clipBehavior = Clip.hardEdge,
      this.restorationId,
      this.scrollBehavior,
      this.selectionOverlay,
      this.backgroundColor,
      this.isCupertino = false});

  const WheelOptions({
    this.physics,
    this.diameterRatio = 2.0,
    this.perspective = 0.003,
    this.offAxisFraction = 0.0,
    this.useMagnifier = true,
    this.magnification = 1.2,
    this.overAndUnderCenterOpacity = 1.0,
    this.itemExtent = 30,
    this.squeeze = 1.0,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
  })  : selectionOverlay = null,
        backgroundColor = null,
        isCupertino = false;

  const WheelOptions.cupertino({
    this.diameterRatio = 1.07,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = true,
    this.magnification = 1.1,
    this.squeeze = 1.45,
    this.itemExtent = 30,
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
  })  : physics = null,
        overAndUnderCenterOpacity = 0.447,
        renderChildrenOutsideViewport = false,
        clipBehavior = Clip.hardEdge,
        perspective = 0.003,
        restorationId = null,
        scrollBehavior = null,
        isCupertino = true;

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

  /// 上下间距默认为1.45 数越小 间距越大
  final double squeeze;

  /// ScrollPhysics
  final ScrollPhysics? physics;

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

  WheelOptions copyWith(
          {double? itemExtent,
          double? diameterRatio,
          double? offAxisFraction,
          double? perspective,
          double? magnification,
          bool? useMagnifier,
          double? squeeze,
          ScrollPhysics? physics,
          Widget? selectionOverlay,
          Color? backgroundColor,
          bool? isCupertino,
          double? overAndUnderCenterOpacity,
          bool? renderChildrenOutsideViewport,
          Clip? clipBehavior,
          ScrollBehavior? scrollBehavior,
          String? restorationId}) =>
      WheelOptions.custom(
          isCupertino: isCupertino ?? this.isCupertino,
          itemExtent: itemExtent ?? this.itemExtent,
          diameterRatio: diameterRatio ?? this.diameterRatio,
          offAxisFraction: offAxisFraction ?? this.offAxisFraction,
          perspective: perspective ?? this.perspective,
          magnification: magnification ?? this.magnification,
          useMagnifier: useMagnifier ?? this.useMagnifier,
          squeeze: squeeze ?? this.squeeze,
          physics: physics ?? this.physics,
          selectionOverlay: selectionOverlay ?? this.selectionOverlay,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          clipBehavior: clipBehavior ?? this.clipBehavior,
          overAndUnderCenterOpacity:
              overAndUnderCenterOpacity ?? this.overAndUnderCenterOpacity,
          renderChildrenOutsideViewport: renderChildrenOutsideViewport ??
              this.renderChildrenOutsideViewport,
          scrollBehavior: scrollBehavior ?? this.scrollBehavior,
          restorationId: restorationId ?? this.restorationId);

  WheelOptions merge([WheelOptions? options]) => WheelOptions.custom(
      itemExtent: options?.itemExtent ?? itemExtent,
      diameterRatio: options?.diameterRatio ?? diameterRatio,
      offAxisFraction: options?.offAxisFraction ?? offAxisFraction,
      perspective: options?.perspective ?? perspective,
      magnification: options?.magnification ?? magnification,
      useMagnifier: options?.useMagnifier ?? useMagnifier,
      squeeze: options?.squeeze ?? squeeze,
      physics: options?.physics ?? physics,
      selectionOverlay: options?.selectionOverlay ?? selectionOverlay,
      backgroundColor: options?.backgroundColor ?? backgroundColor,
      isCupertino: options?.isCupertino ?? isCupertino,
      clipBehavior: options?.clipBehavior ?? clipBehavior,
      overAndUnderCenterOpacity:
          options?.overAndUnderCenterOpacity ?? overAndUnderCenterOpacity,
      renderChildrenOutsideViewport: options?.renderChildrenOutsideViewport ??
          renderChildrenOutsideViewport,
      scrollBehavior: options?.scrollBehavior ?? scrollBehavior,
      restorationId: options?.restorationId ?? restorationId);
}

class CupertinoListWheelScrollView extends CupertinoPicker {
  CupertinoListWheelScrollView.useDelegate({
    super.key,
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
    required this.onSelectedItemChanged,
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
    required this.onSelectedItemChanged,
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
    required this.onSelectedItemChanged,
  }) : delegate = looping
            ? ListWheelChildLoopingListDelegate(children: children)
            : ListWheelChildListDelegate(children: children);

  final ListWheelChildDelegate delegate;

  final WheelOptions? options;

  /// 控制器
  final FixedExtentScrollController? controller;

  /// 回调监听
  final ValueChanged<int>? onSelectedItemChanged;

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
      child = CupertinoListWheelScrollView.useDelegate(
          scrollController: controller,
          delegate: delegate,
          onSelectedItemChanged: onSelectedItemChanged,
          diameterRatio: wheelOptions.diameterRatio,
          backgroundColor: wheelOptions.backgroundColor,
          offAxisFraction: wheelOptions.offAxisFraction,
          useMagnifier: wheelOptions.useMagnifier,
          magnification: wheelOptions.magnification,
          squeeze: wheelOptions.squeeze,
          itemExtent: wheelOptions.itemExtent,
          selectionOverlay: wheelOptions.selectionOverlay);
    } else {
      child = ListWheelScrollView.useDelegate(
          controller: controller,
          childDelegate: delegate,
          itemExtent: wheelOptions.itemExtent,
          physics: wheelOptions.physics,
          diameterRatio: wheelOptions.diameterRatio,
          onSelectedItemChanged: onSelectedItemChanged,
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
          scrollBehavior: wheelOptions.scrollBehavior);
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

class ListEntry extends StatelessWidget {
  const ListEntry(
      {super.key,
      this.isThreeLine = false,
      this.enabled = true,
      this.dense = true,
      this.arrow = false,
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
