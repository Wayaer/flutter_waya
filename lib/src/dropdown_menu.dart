import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DropdownMenusItem<K, V> {
  DropdownMenusItem({
    required this.builder,
    required this.value,
    required this.itemBuilder,
    this.icon,
    this.initialValue,
    this.enabled = true,
  });

  final V? initialValue;

  final DropdownMenuButtonBuilder<V?>? builder;

  final bool enabled;

  /// icon
  final Widget? icon;

  /// items
  final DropdownMenuButtonItemBuilder<V> itemBuilder;

  /// value
  final K value;
}

/// 下拉菜单
class DropdownMenusButton<K, V> extends StatelessWidget {
  const DropdownMenusButton({
    super.key,
    required this.menus,
    this.constraints = const BoxConstraints(minWidth: double.infinity),
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.all(8.0),
    this.splashRadius,
    this.iconSize,
    this.offset = Offset.zero,
    this.shape,
    this.color,
    this.iconColor,
    this.enableFeedback,
    this.position = PopupMenuPosition.under,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.popUpAnimationStyle,
    this.rad = pi,
    this.clockwise = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
  });

  /// 子menus
  final List<DropdownMenusItem<K, V>> menus;

  final ValueCallback<K>? onOpened;

  final ValueTwoCallback<K, V?>? onSelected;

  final ValueCallback<K>? onCanceled;

  final String? tooltip;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final EdgeInsetsGeometry padding;

  final double? splashRadius;

  final Offset offset;

  final ShapeBorder? shape;

  final Color? color;

  final Color? iconColor;

  final bool? enableFeedback;

  final double? iconSize;

  final BoxConstraints constraints;

  final PopupMenuPosition? position;

  final Clip clipBehavior;

  final bool useRootNavigator;

  final AnimationStyle? popUpAnimationStyle;

  /// 旋转角度 pi / 1
  /// 1=180℃  2=90℃
  final double rad;

  /// 动画时长
  final Duration animationDuration;

  /// 是否顺时针旋转
  final bool clockwise;

  /// 动画曲线
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: menus.builder((entry) {
          return DropdownMenuButton<V>(
              initialValue: entry.initialValue,
              tooltip: tooltip,
              rad: rad,
              animationDuration: animationDuration,
              clockwise: clockwise,
              curve: curve,
              elevation: elevation,
              shadowColor: shadowColor,
              surfaceTintColor: surfaceTintColor,
              padding: padding,
              splashRadius: splashRadius,
              offset: offset,
              enabled: entry.enabled,
              shape: shape,
              color: color,
              enableFeedback: enableFeedback,
              constraints: constraints,
              position: position,
              clipBehavior: clipBehavior,
              useRootNavigator: useRootNavigator,
              popUpAnimationStyle: popUpAnimationStyle,
              onOpened: () {
                onOpened?.call(entry.value);
              },
              onCanceled: () {
                onCanceled?.call(entry.value);
              },
              onSelected: (V? value) {
                onSelected?.call(entry.value, value);
              },
              icon: entry.icon,
              itemBuilder: entry.itemBuilder,
              builder: entry.builder);
        }));
  }
}

/// 初始化 默认显示的Widget
typedef DropdownMenuButtonBuilder<T> = Widget Function(T? value, Widget? icon);

typedef DropdownMenuButtonItemBuilder<T> = List<PopupMenuEntry<T>> Function(
    BuildContext context, T? current, ValueCallback<T> updater);

class DropdownMenuButton<T> extends StatefulWidget {
  const DropdownMenuButton({
    super.key,
    this.builder,
    required this.itemBuilder,
    this.icon,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.splashRadius,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.iconColor,
    this.enableFeedback,
    this.constraints,
    this.position = PopupMenuPosition.under,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.popUpAnimationStyle,
    this.rad = pi / 2,
    this.clockwise = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
  }) : assert(builder != null || child != null);

  final Widget? icon;

  final DropdownMenuButtonBuilder<T>? builder;

  final Widget? child;

  final DropdownMenuButtonItemBuilder<T> itemBuilder;

  final T? initialValue;

  final VoidCallback? onOpened;

  final PopupMenuItemSelected<T>? onSelected;

  final PopupMenuCanceled? onCanceled;

  final String? tooltip;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final EdgeInsetsGeometry padding;

  final double? splashRadius;

  final Offset offset;

  final bool enabled;

  final ShapeBorder? shape;

  final Color? color;

  final Color? iconColor;

  final bool? enableFeedback;

  final double? iconSize;

  final BoxConstraints? constraints;

  final PopupMenuPosition? position;

  final Clip clipBehavior;

  final bool useRootNavigator;

  final AnimationStyle? popUpAnimationStyle;

  /// 旋转角度 pi / 2
  /// 1=180℃  2=90℃
  final double rad;

  /// 动画时长
  final Duration animationDuration;

  /// 是否顺时针旋转
  final bool clockwise;

  /// 动画曲线
  final Curve curve;

  @override
  State<DropdownMenuButton<T>> createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState<T> extends State<DropdownMenuButton<T>> {
  T? value;

  ValueNotifier<bool> isExpand = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant DropdownMenuButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != value) value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
        initialValue: value,
        tooltip: widget.tooltip,
        elevation: widget.elevation,
        shadowColor: widget.shadowColor,
        surfaceTintColor: widget.surfaceTintColor,
        padding: widget.padding,
        splashRadius: widget.splashRadius,
        offset: widget.offset,
        enabled: widget.enabled,
        shape: widget.shape,
        color: widget.color,
        enableFeedback: widget.enableFeedback,
        constraints: widget.constraints,
        position: widget.position,
        clipBehavior: widget.clipBehavior,
        useRootNavigator: widget.useRootNavigator,
        popUpAnimationStyle: widget.popUpAnimationStyle,
        itemBuilder: (_) => widget.itemBuilder(_, value, (T value) {
              widget.onSelected?.call(value);
              this.value = value;
              isExpand.value = false;
              setState(() {});
            }),
        onOpened: () {
          widget.onOpened?.call();
          isExpand.value = true;
        },
        onCanceled: () {
          widget.onCanceled?.call();
          isExpand.value = false;
        },
        onSelected: (T value) {
          widget.onSelected?.call(value);
          isExpand.value = false;
          this.value = value;
          setState(() {});
        },
        child: widget.child ?? buildChild);
  }

  Widget get buildChild {
    final current = widget.icon == null
        ? null
        : ValueListenableBuilder(
            valueListenable: isExpand,
            builder: (_, bool value, __) => ToggleRotate(
                rad: widget.rad,
                duration: widget.animationDuration,
                clockwise: widget.clockwise,
                curve: widget.curve,
                isRotate: value,
                child: widget.icon!));
    return widget.builder!(value, current);
  }

  @override
  void dispose() {
    super.dispose();
    isExpand.dispose();
  }
}
