import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/constant/src/way.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 弹出组件每个item样式
typedef IndexBuilder = Widget Function(int index);

/// 初始化 默认显示的Widget
typedef DefaultBuilder = Widget Function(int? index);

typedef ToggleDefaultBuilder = Widget Function(Widget child, Widget toggle);

class DropdownMenuButton extends StatefulWidget {
  const DropdownMenuButton(
      {Key? key,
      required this.defaultBuilder,
      required this.itemBuilder,
      required this.itemCount,
      this.onChanged,
      this.backgroundColor = Colors.black12,
      this.onTap,
      this.decoration,
      this.margin,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
      this.toggle})
      : super(key: key);

  DropdownMenuButton.material({
    Key? key,
    Color? iconColor,
    double iconSize = 24,
    IconData? iconData,
    required this.itemCount,
    required this.defaultBuilder,
    required IndexBuilder itemBuilder,
    this.onChanged,
    this.backgroundColor,
    this.onTap,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
  })  : toggle = Icon(iconData ?? Icons.arrow_right_rounded,
            color: iconColor ?? Colors.black, size: iconSize),
        decoration = BoxDecoration(
            color: backgroundColor ?? Colors.white, boxShadow: baseBoxShadow),
        itemBuilder = ((int index) =>
            itemBuilder(index).paddingSymmetric(vertical: 8, horizontal: 4)),
        super(key: key);

  /// 旋转组件
  final Widget? toggle;

  /// 当前选中显示的 内容 [index]== null  可显示 请选择
  final DefaultBuilder defaultBuilder;

  /// item
  final int itemCount;

  /// item UI
  final IndexBuilder itemBuilder;

  /// index 改变
  final ValueCallback<int>? onChanged;

  /// menu 属性
  final Color? backgroundColor;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// button 点击事件
  final GestureTapCallback? onTap;

  @override
  _DropdownMenuButtonState createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState extends State<DropdownMenuButton> {
  int? selectIndex;
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    final Widget current = widget.defaultBuilder(selectIndex);
    if (widget.toggle != null) {
      return ToggleRotate(
          isRotate: isShow,
          toggleBuilder: (Widget child) => Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[current, child]),
          child: widget.toggle!,
          onTap: showItem);
    }
    return Universal(onTap: showItem, child: current);
  }

  void showItem() {
    if (widget.onTap != null) widget.onTap!.call();
    final Offset offset = context.getWidgetLocalToGlobal;
    final Size size = context.size!;
    showDialogPopup<dynamic>(
        popupFromType: PopupFromType.fromCenter,
        widget: PopupOptions(
          top: offset.dy + size.height,
          left: offset.dx,
          onTap: () {
            isShow = false;
            maybePop();
            setState(() {});
          },
          child: Universal(
              margin: widget.margin,
              padding: widget.padding,
              decoration: widget.decoration,
              color: widget.backgroundColor,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.itemCount.generate((int index) => Universal(
                  onTap: () => tapItem(index),
                  child: widget.itemBuilder(index)))),
        ));
    isShow = true;
    setState(() {});
  }

  void tapItem(int index) {
    maybePop();
    isShow = false;
    if (widget.onChanged != null) widget.onChanged!(index);
    selectIndex = index;
    setState(() {});
  }
}

typedef DropdownMenuTitleBuilder = Widget Function(int index, bool visible);

typedef DropdownMenuLabelBuilder = Widget Function(bool visible);

typedef DropdownMenuValueCallback = void Function(
    int titleIndex, int? valueIndex);

typedef DropdownMenuValueBuilder = Widget Function(
    int titleIndex, int valueIndex);

class DropdownMenu extends StatefulWidget {
  DropdownMenu({
    Key? key,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? background,
    required List<String> title,
    required List<List<String>> value,
    this.width,
    this.decoration,
    this.hasRotateLabel = true,
    DropdownMenuLabelBuilder? label,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.isModal = false,
    this.onTap,
  })  : assert(title.isNotEmpty, 'title cannot be empty'),
        assert(title.length == value.length,
            'the length of title and value must be consistent'),
        background = background ?? ConstColors.black70.withOpacity(0.2),
        titleCount = title.length,
        valueCount = value.builder((List<String> item) => item.length),
        label = label ??
            ((bool isSelect) => const Icon(Icons.keyboard_arrow_up,
                color: ConstColors.black, size: 20)),
        titleBuilder = ((int index, bool isSelect) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: BText(title[index],
                style:
                    titleStyle ?? const BTextStyle(color: ConstColors.black)))),
        valueBuilder = ((int titleIndex, int valueIndex) => Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12))),
            child: BText(value[titleIndex][valueIndex],
                style:
                    valueStyle ?? const BTextStyle(color: ConstColors.black)))),
        super(key: key);

  DropdownMenu.custom({
    Key? key,
    required this.titleCount,
    required this.titleBuilder,
    required this.valueCount,
    required this.valueBuilder,
    this.width,
    this.decoration,
    this.hasRotateLabel = true,
    Color? background,
    DropdownMenuLabelBuilder? label,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.isModal = false,
    this.onTap,
  })  : assert(titleCount == valueCount.length),
        background = background ?? ConstColors.black70.withOpacity(0.2),
        label = label ??
            ((bool isSelect) => const Icon(Icons.keyboard_arrow_up,
                color: ConstColors.black, size: 20)),
        super(key: key);

  /// title 长度
  final int titleCount;

  /// title 每个item
  final DropdownMenuTitleBuilder titleBuilder;

  /// value 长度
  final List<int> valueCount;

  /// value 每个item
  final DropdownMenuValueBuilder valueBuilder;

  /// 是否在title 右边添加 label 默认添加箭头
  final bool hasRotateLabel;

  /// 自定义label
  late final DropdownMenuLabelBuilder label;

  /// 点击回调 valueIndex == null 表示 只是点击了title
  final DropdownMenuValueCallback? onTap;

  /// value 显示时 的背景色
  final Color? background;

  /// title 和 value 宽
  final double? width;

  /// 是否模态 [isModal]=true,背景点击无响应
  final bool isModal;

  /// 以下属性作用于 title
  final Decoration? decoration;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  List<bool> titleState = <bool>[];
  late GlobalKey titleKey = GlobalKey();

  void changeState(int index) => setState(() {
        titleState[index] = !titleState[index];
      });

  void popupWidget(int index) {
    final RenderBox title =
        titleKey.currentContext!.findRenderObject() as RenderBox;
    final Offset local = title.localToGlobal(Offset.zero);
    final double titleHeight = context.size!.height;
    final ScrollList listBuilder = ScrollList.builder(
        itemCount: widget.valueCount[index],
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, int i) => Universal(
            alignment: Alignment.center,
            child: widget.valueBuilder(index, i),
            width: double.infinity,
            onTap: () {
              changeState(index);
              pop();
              if (widget.onTap != null) widget.onTap!(index, i);
            }));
    final Widget popup = PopupOptions(
        top: local.dy + titleHeight,
        alignment: Alignment.center,
        color: ConstColors.transparent,
        onTap: widget.isModal
            ? null
            : () {
                changeState(index);
                pop();
              },
        child: Universal(
            width: widget.width, color: widget.background, child: listBuilder));
    showDialogPopup<dynamic>(
        widget: popup, popupFromType: PopupFromType.fromCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
        key: titleKey,
        width: widget.width,
        padding: widget.padding,
        margin: widget.margin,
        mainAxisAlignment: widget.mainAxisAlignment,
        direction: Axis.horizontal,
        decoration: widget.decoration,
        children: widget.titleCount.generate((int index) {
          titleState.add(false);
          if (widget.hasRotateLabel) {
            return ToggleRotate(
                rad: pi,
                isRotate: titleState[index],
                toggleBuilder: (Widget child) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          widget.titleBuilder(index, titleState[index]),
                          child
                        ]),
                child: widget.label(titleState[index]),
                onTap: () => onTap(index));
          } else {
            return widget
                .titleBuilder(index, titleState[index])
                .onTap(() => onTap(index));
          }
        }));
  }

  Future<void> onTap(int index) async {
    if (widget.onTap != null) widget.onTap!(index, null);
    final double keyboardHeight = getViewInsets.bottom;
    if (keyboardHeight > 0) {
      context.focusNode();
      await 300.milliseconds.delayed(() {});
    }
    changeState(index);
    popupWidget(index);
  }
}
