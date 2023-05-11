import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef DropdownMenusChanged<K, V> = void Function(K key, V? value);

class DropdownMenusItem {
  const DropdownMenusItem({required this.child, this.onTap});

  /// label
  final Widget child;

  /// onTap
  final GestureTapCallback? onTap;
}

class DropdownMenusValueItem<V> extends DropdownMenusItem {
  const DropdownMenusValueItem(
      {required super.child, super.onTap, required this.value});

  /// value
  final V value;
}

class DropdownMenusKeyItem<K, V> extends DropdownMenusItem {
  DropdownMenusKeyItem({
    required super.child,
    required this.value,
    super.onTap,
    this.items = const [],
    this.icon,
    this.enabled = true,
  });

  /// icon 自动旋转
  final Widget? icon;

  /// items
  final List<DropdownMenusValueItem<V>> items;

  /// value
  final K value;

  /// 是否可点击
  final bool enabled;

  bool rotateState = false;

  set setRotateState(bool value) {
    rotateState = value;
  }
}

/// 下拉菜单
class DropdownMenus<K, V> extends StatefulWidget {
  const DropdownMenus(
      {super.key,
      required this.menus,
      this.backgroundColor = const Color(0x80000000),
      this.width,
      this.isModal = false,
      this.decoration,
      this.mainAxisAlignment = MainAxisAlignment.spaceAround,
      this.margin,
      this.padding,
      this.onChanged});

  /// 子menus
  final List<DropdownMenusKeyItem<K, V>> menus;

  final DropdownMenusChanged<K, V>? onChanged;

  /// value 显示时 的背景色
  final Color backgroundColor;

  /// label 和 value 宽
  final double? width;

  /// 是否模态 [isModal]=true,背景点击无响应
  final bool isModal;

  final Decoration? decoration;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<DropdownMenus<K, V>> createState() => _DropdownMenusState<K, V>();
}

class _DropdownMenusState<K, V> extends ExtendedState<DropdownMenus<K, V>> {
  late List<DropdownMenusKeyItem<K, V>> menus;

  late GlobalKey labelKey = GlobalKey();

  @override
  void initState() {
    menus = widget.menus;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropdownMenus<K, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.menus != menus) {
      menus = widget.menus;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
        key: labelKey,
        width: widget.width,
        padding: widget.padding,
        margin: widget.margin,
        mainAxisAlignment: widget.mainAxisAlignment,
        direction: Axis.horizontal,
        decoration: widget.decoration,
        children: menus.builder((entry) {
          if (entry.icon != null) {
            return ToggleRotate(
                rad: pi,
                isRotate: !entry.rotateState,
                toggleBuilder: (Widget child) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [entry.child, child]),
                onTap: () => labelTap(entry),
                child: entry.icon!);
          } else {
            return entry.child.onTap(() => labelTap(entry));
          }
        }));
  }

  Future<void> labelTap(DropdownMenusKeyItem<K, V> entry) async {
    if (!entry.enabled) return;
    widget.onChanged?.call(entry.value, null);
    entry.onTap?.call();
    if (entry.items.isEmpty) return;
    final double keyboardHeight = context.viewInsets.bottom;
    if (keyboardHeight > 0) {
      context.unfocus();
      await 200.milliseconds.delayed(() {});
    }
    changeRotateState(entry);
    popupItems(entry);
  }

  void changeRotateState(DropdownMenusKeyItem<K, V> entry) {
    entry.rotateState = !entry.rotateState;
    setState(() {});
  }

  void popupItems(DropdownMenusKeyItem<K, V> entry) {
    final items = entry.items;
    final NavigatorState navigator = Navigator.of(context);
    final Rect? rect = context.getWidgetRectLocalToGlobal(
        ancestor: navigator.context.findRenderObject());
    final ScrollList listBuilder = ScrollList.builder(
        itemCount: items.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, int i) {
          final item = items[i];
          return Universal(
              alignment: Alignment.center,
              width: double.infinity,
              onTap: () {
                item.onTap?.call();
                widget.onChanged?.call(entry.value, item.value);
                changeRotateState(entry);
                pop();
              },
              child: item.child);
        });
    ModalWindows(
            options: GlobalOptions().modalWindowsOptions.copyWith(
                top: (rect?.top ?? 0) + context.size!.height,
                alignment: Alignment.topLeft,
                color: Colors.transparent,
                onTap: widget.isModal
                    ? null
                    : () {
                        widget.onChanged?.call(entry.value, null);
                        changeRotateState(entry);
                        pop();
                      }),
            child: Universal(
                width: widget.width,
                color: widget.backgroundColor,
                child: listBuilder))
        .popupDialog<dynamic>(
            options: const DialogOptions(
                fromStyle: PopupFromStyle.fromCenter,
                barrierColor: Colors.transparent));
  }
}
