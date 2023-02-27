import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef DropdownMenusTitleBuilder = Widget Function(
    BuildContext context, int index, bool visible);

typedef DropdownMenusIconBuilder = Widget Function(bool selected);

typedef DropdownMenusValueCallback = void Function(
    int labelIndex, int? valueIndex);

typedef DropdownMenusValueBuilder = Widget Function(
    BuildContext context, int labelIndex, int valueIndex);

class DropdownMenusItem<T> {
  const DropdownMenusItem({required this.label, this.onTap});

  /// label
  final Widget label;

  /// onTap
  final ValueCallback<T>? onTap;
}

class DropdownMenusLabelItem<T, K> extends DropdownMenusItem<T> {
  DropdownMenusLabelItem(
      {required super.label,
      required this.items,
      this.icon,
      super.onTap,
      this.isRotate = true});

  /// icon
  final Widget? icon;

  /// icon 是否 添加旋转
  final bool isRotate;

  /// items
  final List<DropdownMenusItem<K>> items;
}

/// 下拉菜单
class DropdownMenus extends StatefulWidget {
  DropdownMenus({
    super.key,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    this.backgroundColor = const Color(0x80000000),
    required List<String> label,
    required List<List<String>> value,
    this.width,
    this.decoration,
    DropdownMenusIconBuilder? icon,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.isModal = false,
    this.onTap,
    this.isRotate = true,
  })  : assert(label.isNotEmpty, 'label cannot be empty'),
        assert(label.length == value.length,
            'the length of label and value must be consistent'),
        labelCount = label.length,
        valueCount = value.builder((List<String> item) => item.length),
        icon = icon ??
            ((bool selected) => const Icon(Icons.keyboard_arrow_up, size: 20)),
        labelBuilder = ((BuildContext context, int index, bool isSelect) =>
            Padding(
                padding: const EdgeInsets.only(right: 6),
                child: BText(label[index],
                    style: labelStyle ?? context.textTheme.labelSmall))),
        valueBuilder = ((BuildContext context, int labelIndex,
                int valueIndex) =>
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: context.theme.canvasColor,
                    border: Border(
                        top: BorderSide(color: context.theme.dividerColor))),
                child: BText(value[labelIndex][valueIndex],
                    style: valueStyle ?? context.textTheme.bodyLarge)));

  const DropdownMenus.custom({
    super.key,
    required this.labelCount,
    required this.labelBuilder,
    required this.valueCount,
    required this.valueBuilder,
    this.icon,
    this.width,
    this.decoration,
    this.backgroundColor = const Color(0x80000000),
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.isModal = false,
    this.onTap,
    this.isRotate = true,
  }) : assert(labelCount == valueCount.length);

  /// label 长度
  final int labelCount;

  /// label 每个item
  final DropdownMenusTitleBuilder labelBuilder;

  /// value 长度
  final List<int> valueCount;

  /// value 每个item
  final DropdownMenusValueBuilder valueBuilder;

  /// icon 是否 添加旋转
  final bool isRotate;

  /// 自定义icon
  final DropdownMenusIconBuilder? icon;

  /// 点击回调 valueIndex == null 表示 只是点击了label
  final DropdownMenusValueCallback? onTap;

  /// value 显示时 的背景色
  final Color backgroundColor;

  /// label 和 value 宽
  final double? width;

  /// 是否模态 [isModal]=true,背景点击无响应
  final bool isModal;

  /// 以下属性作用于 label
  final Decoration? decoration;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<DropdownMenus> createState() => _DropdownMenusState();
}

class _DropdownMenusState extends State<DropdownMenus> {
  List<bool> labelState = <bool>[];
  late GlobalKey labelKey = GlobalKey();

  void changeState(int index) => setState(() {
        labelState[index] = !labelState[index];
      });

  void popupWidget(int index) {
    final NavigatorState navigator = Navigator.of(context);
    final Rect? rect = context.getWidgetRectLocalToGlobal(
        ancestor: navigator.context.findRenderObject());
    final ScrollList listBuilder = ScrollList.builder(
        itemCount: widget.valueCount[index],
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, int i) => Universal(
            alignment: Alignment.center,
            width: double.infinity,
            onTap: () {
              changeState(index);
              pop();
              if (widget.onTap != null) widget.onTap!(index, i);
            },
            child: widget.valueBuilder(context, index, i)));
    ModalWindows(
            options: GlobalOptions().modalWindowsOptions.copyWith(
                top: (rect?.top ?? 0) + context.size!.height,
                alignment: Alignment.topLeft,
                color: Colors.transparent,
                onTap: widget.isModal
                    ? null
                    : () {
                        changeState(index);
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
        children: widget.labelCount.generate((int index) {
          labelState.add(false);
          if (widget.icon != null && widget.isRotate) {
            return ToggleRotate(
                rad: pi,
                isRotate: labelState[index],
                toggleBuilder: (Widget child) =>
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      widget.labelBuilder(context, index, labelState[index]),
                      child
                    ]),
                child: widget.icon!(labelState[index]),
                onTap: () => onTap(index));
          } else {
            return widget
                .labelBuilder(context, index, labelState[index])
                .onTap(() => onTap(index));
          }
        }));
  }

  Future<void> onTap(int index) async {
    widget.onTap?.call(index, null);
    final double keyboardHeight = getViewInsets.bottom;
    if (keyboardHeight > 0) {
      context.unfocus();
      await 300.milliseconds.delayed(() {});
    }
    changeState(index);
    popupWidget(index);
  }
}
