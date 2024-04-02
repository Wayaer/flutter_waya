import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

class IconBox extends StatelessWidget {
  const IconBox({
    super.key,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.reversal = false,
    this.direction = Axis.horizontal,
    this.spacing = 4,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.size,
    this.heroTag,
    this.icon,
    this.background,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.labelText,
    this.labelStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
    this.imageProvider,
    this.image,
    this.label,
    this.widget,
    this.onPressed,
    this.unifiedButtonCategory,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.onLongPress,
    this.clipBehavior,
  });

  /// icon > image > imageProvider > widget
  final Widget? widget;
  final IconData? icon;
  final Image? image;
  final ImageProvider? imageProvider;

  final TextDirection? textDirection;

  /// 文字
  final String? labelText;
  final TextStyle? labelStyle;
  final TextAlign textAlign;
  final TextOverflow overflow;

  /// [labelText]显示时最大行数
  final int maxLines;

  final Widget? label;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? background;

  /// [icon]、[imageProvider]、[labelText] 颜色
  final Color? color;

  /// 仅支持 [icon]、[imageProvider]
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

  /// 与[label]或者[labelText]间距
  final double spacing;

  /// add [Hero]
  final String? heroTag;

  /// ****** [UnifiedButton] ****** ///
  final VoidCallback? onPressed;
  final GestureLongPressCallback? onLongPress;
  final UnifiedButtonCategory? unifiedButtonCategory;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialStatesController? statesController;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    if (isChildren) {
      if (reversal) {
        list.add(buildTitle);
        list.add(buildSpacing);
        list.addAll(buildIcon);
      } else {
        list.addAll(buildIcon);
        list.add(buildSpacing);
        list.add(buildTitle);
      }
      return universal(children: list);
    }
    if (buildIcon.isNotEmpty) return universal(child: buildIcon[0]);
    return Container();
  }

  Widget universal({List<Widget>? children, Widget? child}) => Universal(
      heroTag: heroTag,
      unifiedButtonCategory: unifiedButtonCategory,
      onPressed: onTap ?? onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      clipBehavior: clipBehavior ?? Clip.none,
      focusNode: focusNode,
      autofocus: autofocus,
      statesController: statesController,
      child: child,
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      color: background,
      decoration: decoration,
      padding: padding,
      alignment: alignment);

  Widget get buildSpacing => SizedBox(
      width: direction == Axis.horizontal ? spacing : 0,
      height: direction == Axis.vertical ? spacing : 0);

  Widget get buildTitle {
    if (label != null) return label!;
    final TextStyle style = BTextStyle(color: color).merge(labelStyle);
    return BText(labelText ?? '',
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        textDirection: textDirection,
        overflow: overflow);
  }

  bool get isChildren =>
      (labelText != null || label != null) &&
      (icon != null ||
          image != null ||
          widget != null ||
          imageProvider != null);

  List<Widget> get buildIcon {
    final List<Widget> list = [];
    if (icon != null) {
      list.add(Icon(icon,
          color: color,
          size: size,
          textDirection: textDirection,
          semanticLabel: semanticLabel));
    }
    if (image != null) list.add(image!);
    if (imageProvider != null) {
      list.add(Image(
          image: imageProvider!,
          width: size,
          height: size,
          color: color,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          excludeFromSemantics: true,
          semanticLabel: semanticLabel));
    }
    if (widget != null) list.add(widget!);
    return list;
  }
}
