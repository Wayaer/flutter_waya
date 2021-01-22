import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef ValueCallback<int> = void Function(int titleIndex, int valueIndex);

class PopupBase extends StatelessWidget {
  const PopupBase(
      {Key key,
      double fuzzyDegree,
      bool gaussian,
      this.color,
      bool addMaterial,
      bool ignoring,
      double left,
      double top,
      double right,
      double bottom,
      AlignmentGeometry alignment,
      MainAxisSize mainAxisSize,
      this.behavior,
      this.child,
      this.onTap,
      this.children,
      this.mainAxisAlignment,
      this.crossAxisAlignment,
      this.direction,
      this.isScroll,
      this.isStack})
      : top = top ?? 0,
        left = left ?? 0,
        right = right ?? 0,
        bottom = bottom ?? 0,
        alignment = alignment ?? Alignment.topLeft,
        gaussian = gaussian ?? false,
        addMaterial = addMaterial ?? false,
        ignoring = ignoring ?? false,
        fuzzyDegree = fuzzyDegree ?? 2,
        mainAxisSize = mainAxisSize ?? MainAxisSize.min,
        super(key: key);

  /// 顶层组件
  final Widget child;
  final List<Widget> children;

  /// 背景事件
  final GestureTapCallback onTap;
  final HitTestBehavior behavior;

  /// 背景色
  final Color color;

  /// false 底层不响应事件  true 底层响应事件
  final bool ignoring;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  /// 是否开始背景模糊
  final bool gaussian;

  /// 模糊程度 0-100
  final double fuzzyDegree;

  /// 具体位置
  final double left;
  final double top;
  final double right;
  final double bottom;

  /// 位置
  final AlignmentGeometry alignment;

  //// [children] 不为null 时以下参数有效
  ///  ****** Flex ******  ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final MainAxisSize mainAxisSize;

  ///  ****** SingleChildScrollView ******  ///
  final bool isScroll;

  ///  ****** Stack ******  ///
  final bool isStack;

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget;
    if (gaussian) child = backdropFilter(child);
    if (addMaterial)
      child = Material(
          color: ConstColors.transparent,
          child: MediaQuery(
              data: MediaQueryData.fromWindow(window), child: child));
    if (ignoring) child = IgnorePointer(child: child);
    return child;
  }

  Widget backdropFilter(Widget child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),
      child: child);

  Widget get childWidget => Universal(
      color: color,
      onTap: onTap,
      behavior: behavior,
      alignment: alignment,
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
      direction: direction,
      isScroll: isScroll,
      isStack: isStack,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children);
}

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({
    Key key,
    Color itemBackground,
    Color titleBackground,
    @required this.title,
    @required this.value,
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
  final ValueChanged<int> titleTap;

  /// 点击菜单的回调
  final ValueCallback<int> valueTap;
  final Color iconColor;
  final Color itemBackground;
  final Color background;
  final Color titleBackground;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final double width;
  final EdgeInsetsGeometry alertMargin;
  final EdgeInsetsGeometry itemPadding;
  final Decoration decoration;
  final Decoration itemDecoration;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  List<String> title = <String>[];
  List<List<String>> value = <List<String>>[];
  List<bool> titleState = <bool>[];
  GlobalKey titleKey = GlobalKey();

  void changeState(int index) => setState(() {
        titleState[index] = !titleState[index];
      });

  void popupWidget(int index) {
    final RenderBox title =
        titleKey.currentContext.findRenderObject() as RenderBox;
    final Offset local = title.localToGlobal(Offset.zero);
    final double titleHeight = context.size.height;

    final ScrollList listBuilder = ScrollList.builder(
        itemCount: value[index].length,
        itemBuilder: (_, int i) => SimpleButton(
              text: value[index][i],
              width: double.infinity,
              textStyle: widget.valueStyle,
              onTap: () {
                if (widget.valueTap != null) widget.valueTap(index, i);
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
    if (title == null || title.isEmpty) return <Widget>[];
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
    if (widget.titleTap != null) widget.titleTap(index);
    final double keyboardHeight = getViewInsets.bottom;
    if (keyboardHeight > 0) {
      context.focusNode();
      Timer timer;
      timer = Timer(const Duration(milliseconds: 300), () {
        changeState(index);
        popupWidget(index);
        if (timer != null) timer.cancel();
      });
    } else {
      changeState(index);
      popupWidget(index);
    }
  }
}

class PopupSureCancel extends StatelessWidget {
  const PopupSureCancel({
    Key key,
    Color backgroundColor,
    Color barrierColor,
    double width,
    this.height,
    @required this.content,
    this.padding,
    this.sure,
    this.cancel,
    this.backsideTap,
    this.alignment,
    this.decoration,
    this.gaussian,
    this.addMaterial,
  })  : width = width ?? 300,
        backgroundColor = backgroundColor ?? ConstColors.white,
        barrierColor = barrierColor ?? ConstColors.black50,
        super(key: key);

  final Widget content;

  /// 弹框背景色
  final Color backgroundColor;

  /// 弹框底部 背景色
  final Color barrierColor;

  /// 弹框
  final EdgeInsetsGeometry padding;

  /// 确定按钮
  final Widget sure;

  /// 取消按钮
  final Widget cancel;

  /// 背景是否可点击
  final GestureTapCallback backsideTap;
  final double width;
  final double height;
  final Decoration decoration;

  /// 弹窗位置
  final AlignmentGeometry alignment;

  /// 背景是否模糊
  final bool gaussian;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = <Widget>[];
    widgets.add(content);
    widgets.add(sureCancel());
    return PopupBase(
        addMaterial: addMaterial,
        gaussian: gaussian,
        onTap: backsideTap,
        color: barrierColor,
        alignment: alignment ?? Alignment.center,
        child: Universal(
            onTap: () {},
            width: width,
            height: height,
            decoration: decoration ?? BoxDecoration(color: backgroundColor),
            padding: padding,
            mainAxisSize: MainAxisSize.min,
            children: widgets));
  }

  Widget sureCancel() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        Expanded(child: cancel),
        Expanded(child: sure),
      ]);
}

class Loading extends Dialog {
  const Loading({
    Key key,
    LoadingType loadingType,
    this.textStyle,
    double strokeWidth,
    String text,
    Color backgroundColor,
    this.custom,
    this.ignoring,
    this.gaussian,
    this.animatedOpacity,
    this.value,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  })  : text = text ?? '加载中...',
        strokeWidth = strokeWidth ?? 4.0,
        color = backgroundColor ?? ConstColors.white,
        loadingType = loadingType ?? LoadingType.circular,
        super(key: key);

  final double value;
  final Animation<Color> valueColor;
  final String semanticsLabel;
  final String semanticsValue;
  final LoadingType loadingType;
  final TextStyle textStyle;
  final double strokeWidth;
  final String text;
  final Widget custom;
  final Color color;

  /// 是否开始背景模糊
  final bool gaussian;
  final bool animatedOpacity;

  /// 是否可以操作背景 默认false 不可操作
  final bool ignoring;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    switch (loadingType) {
      case LoadingType.circular:
        children.add(CircularProgressIndicator(
            value: value,
            backgroundColor: color,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingType.linear:
        children.add(LinearProgressIndicator(
            value: value,
            backgroundColor: color,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingType.refresh:
        children.add(RefreshProgressIndicator(
            value: value,
            backgroundColor: color,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
    }
    children.add(Container(
        margin: const EdgeInsets.only(top: 16),
        child: BasisText(text, style: textStyle)));
    return PopupBase(
        ignoring: ignoring,
        gaussian: gaussian,
        alignment: Alignment.center,
        onTap: () {},
        child: custom ??
            Universal(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(8.0)),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: children));
  }
}
