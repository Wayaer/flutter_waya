import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 弹出组件每个item样式
typedef DropdownMenuButtonIndexBuilder = Widget Function(int index);

/// 初始化 默认显示的Widget
typedef DropdownMenuButtonBuilder = Widget Function(int? index);

class DropdownMenuButton extends StatefulWidget {
  const DropdownMenuButton(
      {super.key,
      required this.builder,
      required this.itemBuilder,
      required this.itemCount,
      this.onChanged,
      this.backgroundColor,
      this.decoration,
      this.margin,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
      this.icon});

  DropdownMenuButton.material({
    super.key,
    Color? iconColor,
    double iconSize = 24,
    IconData? iconData,
    required this.builder,
    required this.itemCount,
    required DropdownMenuButtonIndexBuilder itemBuilder,
    this.onChanged,
    this.backgroundColor,
    this.decoration,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
  })  : icon = Icon(iconData ?? Icons.arrow_right_rounded,
            color: iconColor, size: iconSize),
        itemBuilder = ((int index) =>
            itemBuilder(index).paddingSymmetric(vertical: 8, horizontal: 4));

  /// 旋转组件
  final Widget? icon;

  /// 当前选中显示的 内容 [index]== null  可显示 请选择
  final DropdownMenuButtonBuilder builder;

  /// item
  final int itemCount;

  /// item UI
  final DropdownMenuButtonIndexBuilder itemBuilder;

  /// index 改变
  final ValueCallback<int>? onChanged;

  /// menu 属性
  final Color? backgroundColor;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<DropdownMenuButton> createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState extends ExtendedState<DropdownMenuButton> {
  int? selectIndex;
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    final Widget current = widget.builder(selectIndex);
    if (widget.icon != null) {
      return ToggleRotate(
          isRotate: isShow,
          toggleBuilder: (Widget child) =>
              Row(mainAxisSize: MainAxisSize.min, children: [current, child]),
          onTap: showItem,
          child: widget.icon!);
    }
    return Universal(onTap: showItem, child: current);
  }

  void showItem() {
    final NavigatorState navigator = Navigator.of(context);
    final Rect? rect = context.getWidgetRectLocalToGlobal(
        ancestor: navigator.context.findRenderObject());
    ModalWindows(
        options: GlobalOptions().modalWindowsOptions.copyWith(
            top: rect?.top,
            alignment: Alignment.topLeft,
            left: rect?.left,
            onTap: () {
              isShow = false;
              maybePop();
              setState(() {});
            }),
        child: Universal(
            margin: widget.margin,
            padding: widget.padding,
            decoration: widget.decoration ??
                BoxDecoration(
                    color: widget.backgroundColor ?? context.theme.canvasColor,
                    boxShadow: getBoxShadow(
                        color: context.theme.dividerColor,
                        blurRadius: 2,
                        spreadRadius: 2)),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.itemCount.generate((int index) => Universal(
                onTap: () => itemTap(index),
                child: widget.itemBuilder(index))))).popupDialog<dynamic>(
        options: const DialogOptions(
            fromStyle: PopupFromStyle.fromCenter,
            barrierColor: Colors.transparent));
    isShow = true;
    setState(() {});
  }

  void itemTap(int index) {
    maybePop();
    isShow = false;
    widget.onChanged?.call(index);
    selectIndex = index;
    setState(() {});
  }
}
