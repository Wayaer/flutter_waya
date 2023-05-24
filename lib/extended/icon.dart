import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

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
    this.titleText,
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
  });

  /// icon > image > imageProvider > widget
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

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? background;

  /// [icon]、[imageProvider]、[titleText] 颜色
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

  /// 显示 [false]
  final bool visible;

  /// 与[title]或者[titleText]间距
  final double spacing;

  /// add [Hero]
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listWidget = [];
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
      color: background,
      decoration: decoration,
      padding: padding,
      alignment: alignment);

  Widget get spacingWidget => SizedBox(
      width: direction == Axis.horizontal ? spacing : 0,
      height: direction == Axis.vertical ? spacing : 0);

  Widget get titleWidget {
    if (title != null) return title!;
    final TextStyle style = BTextStyle(color: color).merge(titleStyle);
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
    final List<Widget> listWidget = [];
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
