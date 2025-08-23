import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

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

/// 多个 [PopupMenuButton] 旋转 Builder
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
  Widget build(BuildContext context) {
    final children = menus.map((entry) {
      return entry.builder(context, entry.key, entry.value, () {
        onOpened?.call(context, entry.key, entry.value);
      }, () {
        onCanceled?.call(context, entry.key, entry.value);
      }, (V? value) {
        entry.value = value;
        onSelected?.call(context, entry.key, value);
      });
    }).toList();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, children: children);
  }
}

typedef PopupMenuButtonBuilder = Widget Function(BuildContext context,
    Widget rotateIcon, VoidCallback onOpened, VoidCallback onClosed);

/// [PopupMenuButton] 旋转 Builder
class PopupMenuButtonRotateBuilder extends StatelessWidget {
  const PopupMenuButtonRotateBuilder({
    super.key,
    required this.builder,
    required this.icon,
    this.isRotate = false,
    this.turns = 0.5,
    this.clockwise = true,
    this.closedNeedsBuild = true,
    this.openedNeedsBuild = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
    this.onChanged,
  });

  /// 旋转的icon
  final ToggleRotateIconBuilder icon;

  /// 初始是否旋转
  final bool isRotate;

  /// builder PopupMenuButton
  final PopupMenuButtonBuilder builder;

  /// 旋转圈数
  /// 1 = 一圈    0.5 = 半圈    2 = 两圈
  final double turns;

  /// 动画时长
  final Duration animationDuration;

  /// 是否顺时针旋转
  final bool clockwise;

  /// 动画曲线
  final Curve curve;

  /// 关闭时是否需要重建
  final bool closedNeedsBuild;

  /// 打开时是否需要重建
  final bool openedNeedsBuild;

  /// 变化监听
  final ToggleRotateCallback? onChanged;

  @override
  Widget build(BuildContext context) => ToggleRotate(
      turns: turns,
      duration: animationDuration,
      clockwise: clockwise,
      curve: curve,
      isRotate: isRotate,
      icon: icon,
      onChanged: onChanged,
      builder: (Widget child, ToggleRotateHandleRotation rotate) => builder(
          context,
          child,
          () => rotate(needsBuild: openedNeedsBuild),
          () => rotate(needsBuild: closedNeedsBuild)));
}
