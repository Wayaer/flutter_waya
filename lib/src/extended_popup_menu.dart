import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef MultiPopupMenuButtonItemBuilder<K, V> = Widget Function(
    BuildContext context,
    K key,
    V? value,
    VoidCallback onOpened,
    VoidCallback onCanceled,
    PopupMenuItemSelected<V> onSelected);

class MultiPopupMenuButtonItem<K, V> {
  MultiPopupMenuButtonItem({
    required this.key,
    this.value,
    required this.builder,
  });

  final MultiPopupMenuButtonItemBuilder<K, V> builder;

  /// key
  final K key;

  /// value
  V? value;
}

typedef MultiPopupMenuButtonValueCallbackKV<K, V> = void Function(
    BuildContext context, K key, V value);

/// 多个下拉菜单
class MultiPopupMenuButton<K, V> extends StatelessWidget {
  const MultiPopupMenuButton({
    super.key,
    required this.menus,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
  });

  /// 菜单
  final List<MultiPopupMenuButtonItem<K, V>> menus;

  /// onOpened
  final MultiPopupMenuButtonValueCallbackKV<K, V?>? onOpened;

  /// onCanceled
  final MultiPopupMenuButtonValueCallbackKV<K, V?>? onCanceled;

  /// onSelected
  final MultiPopupMenuButtonValueCallbackKV<K, V?>? onSelected;

  @override
  Widget build(BuildContext context) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        final children = menus.map((entry) {
          return entry.builder(context, entry.key, entry.value, () {
            this.onOpened?.call(context, entry.key, entry.value);
          }, () {
            this.onCanceled?.call(context, entry.key, entry.value);
          }, (V? value) {
            entry.value = value;
            this.onSelected?.call(context, entry.key, value);
            if (context.mounted) setState(() {});
          });
        }).toList();
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children);
      });
}

typedef PopupMenuButtonBuilder = Widget Function(BuildContext context,
    Widget rotateIcon, VoidCallback onOpened, VoidCallback onClosed);

class PopupMenuButtonRotateBuilder extends StatefulWidget {
  const PopupMenuButtonRotateBuilder({
    super.key,
    required this.builder,
    required this.icon,
    this.initialRotate = false,
    this.rad = pi / 2,
    this.clockwise = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
  });

  final Widget icon;

  final bool initialRotate;

  /// builder PopupMenuButton
  final PopupMenuButtonBuilder builder;

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
  State<PopupMenuButtonRotateBuilder> createState() =>
      _PopupMenuButtonRotateBuilderState();
}

class _PopupMenuButtonRotateBuilderState
    extends ExtendedState<PopupMenuButtonRotateBuilder> {
  bool isRotate = false;

  @override
  void initState() {
    super.initState();
    isRotate = widget.initialRotate;
  }

  @override
  void didUpdateWidget(covariant PopupMenuButtonRotateBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isRotate != widget.initialRotate) {
      isRotate = widget.initialRotate;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, rotateIcon, () {
        isRotate = true;
        setState(() {});
      }, () {
        isRotate = false;
        setState(() {});
      });

  Widget get rotateIcon => ToggleRotate(
      rad: widget.rad,
      duration: widget.animationDuration,
      clockwise: widget.clockwise,
      curve: widget.curve,
      isRotate: isRotate,
      child: widget.icon);
}
