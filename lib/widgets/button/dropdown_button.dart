import 'package:flutter/material.dart';
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

  const DropdownMenuButton.material({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.defaultBuilder,
    this.onChanged,
    this.backgroundColor = Colors.black12,
    this.onTap,
    this.decoration,
    this.margin,
    this.padding,
    this.toggle,
  }) : super(key: key);

  final Widget? toggle;
  final DefaultBuilder defaultBuilder;

  final int itemCount;
  final IndexedBuilder itemBuilder;
  final ValueCallback<int>? onChanged;

  /// menu 属性
  final Color backgroundColor;
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
    required this.title,
    required this.value,
    this.titleTap,
    this.valueTap,
    this.titleStyle,
    this.valueStyle,
    this.width,
    this.alertMargin,
    this.iconColor,
    this.itemPadding,
    this.decoration,
    this.itemDecoration,
    this.background,
  })  : itemBackground = itemBackground ?? Colors.white,
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
        children: titleChildren());
  }

  List<Widget> titleChildren() {
    if (title.isEmpty) return <Widget>[];
    return title.length.generate((int index) {
      titleState.add(false);
      return IconBox(
          onTap: () => onTap(index),
          titleStyle: widget.titleStyle,
          titleText: title[index],
          reversal: true,
          color: widget.iconColor ?? ConstColors.black70,
          size: 20,
          icon: titleState[index]
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down);
    });
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
