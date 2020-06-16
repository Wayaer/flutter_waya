import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

class CheckBox extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final Color checkColor;
  final Color activeColor;
  final Color background;
  final Color uncheckColor;
  final TextStyle titleStyle;
  final String titleText;
  final Widget title;
  final double iconSize;
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
      double iconSize,
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
      : this.iconSize = iconSize ?? Tools.getWidth(17),
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
        iconSize: widget.iconSize,
        iconColor: value ? widget.checkColor : widget.uncheckColor,
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
