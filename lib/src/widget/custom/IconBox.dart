import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class IconBox extends StatelessWidget {
  ///icon > image > imageProvider > widget
  final Widget widget;
  final IconData icon;
  final Widget image;
  final ImageProvider imageProvider;

  ///显示图片
  final TextDirection textDirection;

  ///仅支持icon
  final String semanticLabel;
  final String titleText;
  final Widget title;
  final bool addInkWell;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color background;
  final Color color;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final int maxLines;
  final bool reversal;
  final bool visible;
  final TextOverflow overflow;
  final double spacing;
  final double size;
  final AlignmentGeometry alignment;
  final TextAlign textAlign;

  final String heroTag;

  IconBox({
    Key key,
    Axis direction,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    int maxLines,
    bool reversal,
    TextOverflow overflow,
    double spacing,
    double size,
    TextAlign textAlign,
    this.heroTag,
    this.icon,
    this.background,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.titleText,
    this.addInkWell,
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
    this.visible,
    this.widget,
  })  : this.maxLines = maxLines ?? 1,
        this.overflow = overflow ?? TextOverflow.ellipsis,
        this.textAlign = textAlign ?? TextAlign.start,
        this.size = size ?? ScreenFit.getWidth(15),
        this.reversal = reversal ?? false,
        this.direction = direction ?? Axis.horizontal,
        this.spacing = spacing ?? ScreenFit.getWidth(4),
        this.crossAxisAlignment =
            crossAxisAlignment ?? CrossAxisAlignment.center,
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidget = [];
    if (isChildren()) {
      if (reversal) {
        listWidget.add(titleWidget());
        listWidget.add(spacingWidget());
        listWidget.addAll(iconWidget());
      } else {
        listWidget.addAll(iconWidget());
        listWidget.add(spacingWidget());
        listWidget.add(titleWidget());
      }
      return universal(children: listWidget);
    }
    if (iconWidget().length > 0) {
      return universal(child: iconWidget()[0]);
    }
    return Container();
  }

  Widget universal({List<Widget> children, Widget child}) {
    return Universal(
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
      alignment: alignment,
    );
  }

  Widget spacingWidget() {
    return Container(
        width: direction == Axis.horizontal ? spacing : 0,
        height: direction == Axis.vertical ? spacing : 0);
  }

  Widget titleWidget() {
    if (title != null) {
      return title;
    }
    return Text(
      titleText ?? '',
      style: titleStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      textDirection: textDirection,
      overflow: overflow,
    );
  }

  bool isChildren() {
    return (titleText != null || title != null) &&
        (icon != null ||
            image != null ||
            widget != null ||
            imageProvider != null);
  }

  List<Widget> iconWidget() {
    List<Widget> listWidget = [];
    if (icon != null) {
      listWidget.add(Icon(icon,
          color: color,
          size: size,
          textDirection: textDirection,
          semanticLabel: semanticLabel));

      ///帮助盲人或者视力有障碍的用户提供语言辅助描述
    }
    if (image != null) {
      listWidget.add(image);
    }
    if (imageProvider != null) {
      listWidget.add(ImageIcon(imageProvider,
          color: color, size: size, semanticLabel: semanticLabel));
    }
    if (widget != null) {
      listWidget.add(widget);
    }
    return listWidget;
  }
}

class CheckBox extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final Color checkColor;
  final Color activeColor;
  final Color background;
  final Color uncheckColor;
  final TextStyle titleStyle;
  final String titleText;
  final Widget title;
  final double size;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget checkWidget;
  final Widget uncheckWidget;
  final IconData checkIcon;
  final IconData uncheckIcon;
  final bool value;
  final bool visible;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  CheckBox(
      {Key key,
      double size,
      Color uncheckColor,
      Color checkColor,
      MainAxisAlignment mainAxisAlignment,
      CrossAxisAlignment crossAxisAlignment,
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
      this.visible,
      this.activeColor,
      this.value})
      : this.size = size ?? ScreenFit.getWidth(17),
        this.uncheckColor = uncheckColor ?? getColors(black70),
        this.checkColor = checkColor ?? getColors(white),
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        this.crossAxisAlignment =
            crossAxisAlignment ?? CrossAxisAlignment.center,
        super(key: key);

  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) value = widget.value;
    IconData icon;
    if (widget.checkIcon != null && widget.uncheckIcon != null)
      icon = value ? widget.checkIcon : widget.uncheckIcon;
    Widget check;
    if (widget.checkWidget != null && widget.uncheckWidget != null) {
      check = value ? widget.checkWidget : widget.uncheckWidget;
    } else {
      check = checkBoxWidget();
    }
    return IconBox(
        visible: widget.visible,
        icon: icon,
        size: widget.size,
        color: value ? widget.checkColor : widget.uncheckColor,
        widget: check,
        background: widget.background,
        margin: widget.margin,
        padding: widget.padding,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        titleStyle: widget.titleStyle,
        titleText: widget.titleText,
        title: widget.title,
        onTap: () {
          setState(() {
            value = !value;
          });
          if (widget.onChange is ValueChanged<bool>) {
            widget.onChange(value);
          }
        });
  }

  Widget checkBoxWidget() {
    return Checkbox(
      tristate: false,
//      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      value: value,
      onChanged: (bool v) {
        if (value != v) {
          setState(() {
            value = v;
          });
          if (widget.onChange is ValueChanged<bool>) {
            widget.onChange(v);
          }
        }
      },
    );
  }
}
