import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/constant/way.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 弹出组件每个item样式
typedef IndexedBuilder = Widget Function(int index);

/// 初始化 默认显示的Widget
typedef DefaultBuilder = Widget Function(int? index);

typedef ToggleDefaultBuilder = Widget Function(Widget child, Widget toggle);

/// DropdownMenuButton(
///   defaultBuilder: (int index) {
///     return Universal(
///         padding:
///         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
///         decoration: BoxDecoration(
///             color: Colors.blue,
///             borderRadius: BorderRadius.circular(4)),
///         direction: Axis.horizontal,
///         mainAxisSize: MainAxisSize.min,
///         children: <Widget>[
///           BasisText(index == null ? '请选择' : _colors[index],
///               color: Colors.white),
///           const Icon(Icons.arrow_drop_down, color: Colors.white),
///         ]);
///   },
///   decoration: BoxDecoration(
///       color: Colors.blue, borderRadius: BorderRadius.circular(4)),
///   margin: const EdgeInsets.only(top: 2),
///   itemCount: _colors.length,
///   onChanged: (int index) {
///     showToast('点击了${_colors[index]}');
///   },
///   itemBuilder: (int index) =>
///       Container(
///           alignment: Alignment.center,
///           padding: const EdgeInsets.symmetric(vertical: 6),
///           decoration: const BoxDecoration(
///               border: Border(bottom: BorderSide(color: Colors.white))),
///           child: BasisText(_colors[index])),
/// )
///
///
///     DropdownMenuButton.material(
///           itemBuilder: (int index) =>
///           BasisText(_colors[index], color: Colors.black),
///           itemCount: _colors.length,
///           defaultBuilder: (int index) {
///               return BasisText(index == null ? '请选择' : _colors[index],
///                         color: Colors.black)
///                     .paddingSymmetric(vertical: 10);
///           })
///
///

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
      this.padding,
      this.toggle})
      : super(key: key);

  DropdownMenuButton.material({
    Key? key,
    required IndexedBuilder itemBuilder,
    Color? iconColor,
    double iconSize = 24,
    IconData? iconData,
    required this.itemCount,
    required this.defaultBuilder,
    this.onChanged,
    this.backgroundColor,
    this.onTap,
    this.margin,
    this.padding,
  })  : toggle = Icon(iconData ?? Icons.arrow_right_rounded,
            color: iconColor ?? Colors.black, size: iconSize),
        decoration = BoxDecoration(
            color: backgroundColor ?? Colors.white,
            boxShadow: WayStyles.boxShadow),
        itemBuilder = ((int index) =>
            itemBuilder(index).paddingSymmetric(vertical: 8, horizontal: 4)),
        super(key: key);

  final Widget? toggle;
  final DefaultBuilder defaultBuilder;

  final int itemCount;
  final IndexedBuilder itemBuilder;
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
        widget: PopupBase(
      top: offset.dy + size.height,
      left: offset.dx,
      onTap: () {
        isShow = false;
        maybePop();
        setState(() {});
      },
      child: Universal(
          width: size.width,
          margin: widget.margin,
          padding: widget.padding,
          decoration: widget.decoration,
          color: widget.backgroundColor,
          mainAxisSize: MainAxisSize.min,
          children: widget.itemCount.generate((int index) => Universal(
              onTap: () => tapItem(index), child: widget.itemBuilder(index)))),
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

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({
    Key? key,
    Color? itemBackground,
    Color? titleBackground,
    TextStyle? titleStyle,
    required this.title,
    required this.value,
    this.titleTap,
    this.valueTap,
    this.valueStyle,
    this.width,
    this.alertMargin,
    this.iconColor,
    this.itemPadding,
    this.decoration,
    this.itemDecoration,
    this.background,
  })  : titleStyle = titleStyle ?? const TextStyle(color: Colors.black),
        itemBackground = itemBackground ?? Colors.white,
        titleBackground = titleBackground ?? Colors.white,
        super(key: key);

  /// 头部数组
  final List<String> title;

  /// 每个头部弹出菜单数组， 必须和title长度一样
  final List<List<String>> value;

  /// 点击头部item回调
  final ValueCallback<int>? titleTap;

  /// 点击菜单的回调
  final ValueTwoCallback<int, int>? valueTap;
  final Color? iconColor;
  final Color itemBackground;
  final Color? background;
  final Color? titleBackground;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final double? width;
  final EdgeInsetsGeometry? alertMargin;
  final EdgeInsetsGeometry? itemPadding;
  final Decoration? decoration;
  final Decoration? itemDecoration;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  List<String> title = <String>[];
  List<List<String>> value = <List<String>>[];
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
        itemCount: value[index].length,
        itemBuilder: (_, int i) => SimpleButton(
              text: value[index][i],
              width: double.infinity,
              textStyle: widget.valueStyle ??
                  const BasisTextStyle(color: Colors.black),
              onTap: () {
                if (widget.valueTap != null) widget.valueTap!(index, i);
                changeState(index);
              },
              alignment: Alignment.center,
              decoration: widget.itemDecoration ??
                  BoxDecoration(
                      color: widget.itemBackground,
                      border: const Border(
                          top: BorderSide(color: ConstColors.background))),
              padding: widget.itemPadding,
              height: titleHeight,
            ));
    final Widget popup = PopupBase(
      top: local.dy + titleHeight,
      alignment: Alignment.center,
      onTap: () {
        changeState(index);
        pop();
      },
      child: Universal(
          width: widget.width ?? double.infinity,
          margin: widget.alertMargin,
          height: double.infinity,
          color: widget.background ?? ConstColors.black70.withOpacity(0.2),
          child: listBuilder),
    );
    showDialogPopup<dynamic>(widget: popup);
  }

  @override
  Widget build(BuildContext context) {
    title = widget.title;
    value = widget.value;
    if (title.isEmpty) return Container();
    if (title.length != value.length) return Container();
    return Universal(
        key: titleKey,
        width: widget.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        direction: Axis.horizontal,
        color: widget.titleBackground ?? ConstColors.white,
        decoration: widget.decoration,
        children: title.length.generate((int index) {
          titleState.add(false);
          return ToggleRotate(
              rad: pi,
              isRotate: titleState[index],
              toggleBuilder: (Widget child) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        BasisText(title[index], style: widget.titleStyle),
                        child
                      ]),
              child: Icon(Icons.keyboard_arrow_up,
                  color: widget.iconColor ?? ConstColors.black, size: 20),
              onTap: () => onTap(index));
        }));
  }

  void onTap(int index) {
    if (widget.titleTap != null) widget.titleTap!(index);
    final double keyboardHeight = getViewInsets.bottom;
    if (keyboardHeight > 0) {
      context.focusNode();
      const Duration(milliseconds: 300).timer(() {
        changeState(index);
        popupWidget(index);
      });
    } else {
      changeState(index);
      popupWidget(index);
    }
  }
}
