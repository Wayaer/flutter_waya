import 'package:flutter/material.dart';
import 'package:flutter_waya/src/animation/toggle_rotate.dart';

/// 菜单项构建器，提供 key、当前 value 以及打开、取消、选中回调
typedef FlMultiPopupMenuButtonItemBuilder<K, V> = Widget Function(
  BuildContext context,
  K key,
  V? value,
  VoidCallback onOpened,
  VoidCallback onCanceled,
  PopupMenuItemSelected<V> onSelected,
);

/// 多菜单按钮中的单个菜单项配置
class FlMultiPopupMenuButtonItem<K, V> {
  FlMultiPopupMenuButtonItem({required this.key, this.value, required this.builder});

  /// 菜单项构建器
  final FlMultiPopupMenuButtonItemBuilder<K, V> builder;

  /// 菜单项唯一标识
  final K key;

  /// 菜单项当前选中的值
  V? value;
}

/// 菜单项回调，回传上下文、key 与选中的值
typedef FlMultiPopupMenuButtonValueCallbackKV<K, V> = void Function(BuildContext context, K key, V value);

/// 一行内并排多个菜单按钮，常用于带旋转箭头的多级菜单入口
class FlMultiPopupMenuButton<K, V> extends StatefulWidget {
  const FlMultiPopupMenuButton({super.key, required this.menus, this.onOpened, this.onSelected, this.onCanceled});

  /// 菜单项列表
  final List<FlMultiPopupMenuButtonItem<K, V>> menus;

  /// 菜单打开回调
  final FlMultiPopupMenuButtonValueCallbackKV<K, V?>? onOpened;

  /// 菜单取消回调
  final FlMultiPopupMenuButtonValueCallbackKV<K, V?>? onCanceled;

  /// 菜单选中回调
  final FlMultiPopupMenuButtonValueCallbackKV<K, V?>? onSelected;

  @override
  State<FlMultiPopupMenuButton<K, V>> createState() => _MultiPopupMenuButtonState<K, V>();
}

class _MultiPopupMenuButtonState<K, V> extends State<FlMultiPopupMenuButton<K, V>> {
  @override
  Widget build(BuildContext context) {
    final children = widget.menus.map((entry) {
      return entry.builder(
        context,
        entry.key,
        entry.value,
        () => widget.onOpened?.call(context, entry.key, entry.value),
        () => widget.onCanceled?.call(context, entry.key, entry.value),
        (V? value) {
          entry.value = value;
          widget.onSelected?.call(context, entry.key, value);
          setState(() {});
        },
      );
    }).toList();
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: children);
  }
}

/// 菜单按钮构建器，提供旋转图标、打开与关闭回调
typedef FlPopupMenuButtonBuilder = Widget Function(
  BuildContext context,
  Widget rotateIcon,
  VoidCallback onOpened,
  VoidCallback onClosed,
);

/// 带旋转图标的菜单按钮，打开菜单时图标旋转
class FlPopupMenuButtonRotateBuilder extends StatelessWidget {
  const FlPopupMenuButtonRotateBuilder({
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

  /// 旋转图标构建器
  final FlToggleRotateIconBuilder icon;

  /// 初始是否处于旋转状态，默认 false
  final bool isRotate;

  /// 菜单按钮构建器
  final FlPopupMenuButtonBuilder builder;

  /// 旋转圈数，1 = 一圈，0.5 = 半圈，2 = 两圈，默认 0.5
  final double turns;

  /// 旋转动画时长，默认 200 毫秒
  final Duration animationDuration;

  /// 是否顺时针旋转，默认 true
  final bool clockwise;

  /// 旋转动画曲线，默认 [Curves.fastOutSlowIn]
  final Curve curve;

  /// 关闭菜单时是否需要重建，默认 true
  final bool closedNeedsBuild;

  /// 打开菜单时是否需要重建，默认 false
  final bool openedNeedsBuild;

  /// 旋转状态变化回调
  final FlToggleRotateCallback? onChanged;

  @override
  Widget build(BuildContext context) => FlToggleRotate(
    turns: turns,
    duration: animationDuration,
    clockwise: clockwise,
    curve: curve,
    isRotate: isRotate,
    icon: icon,
    onChanged: onChanged,
    builder: (Widget child, FlToggleRotateHandleRotation rotate) =>
        builder(context, child, () => rotate(needsBuild: openedNeedsBuild), () => rotate(needsBuild: closedNeedsBuild)),
  );
}
