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
    if (icon != null)
      listWidget.add(Icon(icon,
          color: color,
          size: size,
          textDirection: textDirection,
          semanticLabel: semanticLabel));

    if (image != null) listWidget.add(image!);

    if (imageProvider != null)
      listWidget.add(Image(
          image: imageProvider!,
          width: size,
          height: size,
          color: color,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          excludeFromSemantics: true,
          semanticLabel: semanticLabel));

    if (widget != null) listWidget.add(widget!);

    return listWidget;
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({
    Key? key,
    this.size = 17,
    this.uncheckColor = ConstColors.black70,
    this.checkColor = ConstColors.white,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onChange,
    this.checkWidget,
    this.checkIcon,
    this.uncheckIcon,
    this.uncheckWidget,
    this.background,
    this.padding,
    this.margin,
    this.titleStyle,
    this.titleText,
    this.title,
    this.visible = true,
    this.activeColor,
    this.value = false,
    this.shape,
  }) : super(key: key);

  final ValueCallback<bool>? onChange;
  final Color checkColor;

  final Color? background;
  final Color uncheckColor;
  final TextStyle? titleStyle;
  final String? titleText;
  final Widget? title;
  final double size;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? checkWidget;
  final Widget? uncheckWidget;
  final IconData? checkIcon;
  final IconData? uncheckIcon;
  final bool value;
  final bool visible;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  /// [Checkbox]
  final OutlinedBorder? shape;
  final Color? activeColor;

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool value = false;
  IconData? icon;
  Widget? check;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckBox oldWidget) {
    if (oldWidget.value != widget.value)
      setState(() {
        value = widget.value;
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkWidget != null && widget.uncheckWidget != null) {
      check = value ? widget.checkWidget : widget.uncheckWidget;
    } else {
      if (widget.checkIcon != null && widget.uncheckIcon != null) {
        icon = value ? widget.checkIcon : widget.uncheckIcon;
      } else {
        check = checkBoxWidget;
      }
    }
    return IconBox(
        visible: widget.visible,
        icon: icon,
        size: widget.size,
        widget: check,
        color: value ? widget.checkColor : widget.uncheckColor,
        background: widget.background,
        margin: widget.margin,
        padding: widget.padding,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        titleStyle: widget.titleStyle,
        titleText: widget.titleText,
        title: widget.title,
        onTap: () {
          value = !value;
          setState(() {});
          if (widget.onChange is ValueChanged<bool>) widget.onChange!(value);
        });
  }

  Widget get checkBoxWidget => Checkbox(
      tristate: false,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      shape: widget.shape,
      value: value,
      onChanged: (bool? v) {
        if (value != v) {
          value = v ?? false;
          setState(() {});
          if (widget.onChange != null && widget.onChange is ValueCallback<bool>)
            widget.onChange!(value);
        }
      });
}
