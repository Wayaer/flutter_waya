import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class IconBox extends StatelessWidget {
  const IconBox({
    Key? key,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    int? maxLines,
    bool? reversal,
    TextOverflow? overflow,
    double? spacing,
    double? size,
    TextAlign? textAlign,
    this.heroTag,
    this.icon,
    this.background,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.titleText,
    this.addInkWell = false,
    this.titleStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
    this.imageProvider,
    this.image,
    this.title,
    this.visible = true,
    this.widget,
  })  : maxLines = maxLines ?? 1,
        overflow = overflow ?? TextOverflow.ellipsis,
        textAlign = textAlign ?? TextAlign.start,
        size = size ?? 16,
        reversal = reversal ?? false,
        direction = direction ?? Axis.horizontal,
        spacing = spacing ?? 4,
        crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        super(key: key);

  ///  icon > image > imageProvider > widget
  final Widget? widget;
  final IconData? icon;
  final Image? image;
  final ImageProvider? imageProvider;

  final TextDirection? textDirection;

  /// 文字
  final String? titleText;
  final TextStyle? titleStyle;
  final TextAlign textAlign;
  final TextOverflow overflow;

  /// [titleText]显示时最大行数
  final int maxLines;

  final Widget? title;

  /// 点击添加水波纹 [InkWell]
  final bool addInkWell;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? background;

  /// [icon]、[imageProvider]、[titleText] 颜色
  final Color? color;

  ///  仅支持 [icon]、[imageProvider]
  final String? semanticLabel;

  /// [icon]、[imageProvider] 大小
  final double? size;

  /// 整个组件宽高
  final double? height;
  final double? width;

  /// 整个组件装饰器
  final Decoration? decoration;

  /// 整个组件点击事件
  final GestureTapCallback? onTap;

  /// 整个组件居中
  final AlignmentGeometry? alignment;

  /// 组件水平或 垂直
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  /// 收尾颠倒 [false]
  final bool reversal;

  /// 显示 [false]
  final bool visible;

  /// 与[title]或者[titleText]间距
  final double spacing;

  /// add [Hero]
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listWidget = <Widget>[];
    if (isChildren) {
      if (reversal) {
        listWidget.add(titleWidget);
        listWidget.add(spacingWidget);
        listWidget.addAll(iconWidget);
      } else {
        listWidget.addAll(iconWidget);
        listWidget.add(spacingWidget);
        listWidget.add(titleWidget);
      }
      return universal(children: listWidget);
    }
    if (iconWidget.isNotEmpty) return universal(child: iconWidget[0]);
    return Container();
  }

  Widget universal({List<Widget>? children, Widget? child}) => Universal(
      heroTag: heroTag,
      addInkWell: addInkWell,
      child: child,
      visible: visible,
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      decoration: decoration ?? BoxDecoration(color: background),
      padding: padding,
      alignment: alignment);

  Widget get spacingWidget => SizedBox(
      width: direction == Axis.horizontal ? spacing : 0,
      height: direction == Axis.vertical ? spacing : 0);

  Widget get titleWidget {
    if (title != null) return title!;
    final TextStyle style =
        BTextStyle(color: color ?? ConstColors.black70).merge(titleStyle);
    return BText(titleText ?? '',
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        textDirection: textDirection,
        overflow: overflow);
  }

  bool get isChildren =>
      (titleText != null || title != null) &&
      (icon != null ||
          image != null ||
          widget != null ||
          imageProvider != null);

  List<Widget> get iconWidget {
    final List<Widget> listWidget = <Widget>[];
    if (icon != null) {
      listWidget.add(Icon(icon,
          color: color,
          size: size,
          textDirection: textDirection,
          semanticLabel: semanticLabel));
    }
    if (image != null) listWidget.add(image!);
    if (imageProvider != null) {
      listWidget.add(Image(
          image: imageProvider!,
          width: size,
          height: size,
          color: color,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          excludeFromSemantics: true,
          semanticLabel: semanticLabel));
    }

    if (widget != null) listWidget.add(widget!);
    return listWidget;
  }
}

typedef CheckBoxStateBuilder = Widget Function(bool? value);

class CheckBox extends StatefulWidget {
  const CheckBox({
    Key? key,
    this.value = false,
    required this.stateBuilder,
    this.useNull = false,
    this.onChanged,
    this.decoration,
    this.margin,
    this.padding,
  }) : super(key: key);

  /// 不同状态时 显示的组件
  final CheckBoxStateBuilder stateBuilder;

  /// bool 类型是否使用后null
  final bool useNull;

  /// 初始化值 默认为 false
  final bool? value;

  /// bool 值改变回调
  final ValueCallback<bool?>? onChanged;

  /// decoration
  final Decoration? decoration;

  /// margin
  final EdgeInsetsGeometry? margin;

  /// padding
  final EdgeInsetsGeometry? padding;

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool? value = false;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.stateBuilder != widget.stateBuilder) {
      value = widget.value;
      setState(() {});
    }
  }

  void changeState() {
    if (widget.useNull) {
      if (value == null) {
        value = true;
      } else {
        value = value! ? false : null;
      }
    } else {
      value = !value!;
    }
    setState(() {});
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
        decoration: widget.decoration,
        margin: widget.margin,
        padding: widget.padding,
        onTap: changeState,
        child: widget.stateBuilder(value));
  }
}
