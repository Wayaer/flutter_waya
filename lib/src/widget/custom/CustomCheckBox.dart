import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

class CustomCheckBox extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final Color checkColor;
  final Color activeColor;
  final Color background;
  final Color unCheckColor;
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

  CustomCheckBox(
      {Key key,
      bool value,
      double iconSize,
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
      Color unCheckColor,
      Color checkColor,
      this.titleStyle,
      this.titleText,
      this.title,
      this.visible,
      this.activeColor})
      : this.value = value ?? false,
        this.iconSize = iconSize ?? Tools.getWidth(17),
        this.unCheckColor = unCheckColor ?? getColors(black70),
        this.checkColor = checkColor ?? getColors(white),
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        this.crossAxisAlignment =
            crossAxisAlignment ?? CrossAxisAlignment.center,
        super(key: key);

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  bool value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (widget.checkIcon != null && widget.uncheckIcon != null)
      icon = value ? widget.checkIcon : widget.uncheckIcon;
    Widget check;
    if (widget.checkWidget != null && widget.uncheckWidget != null) {
      check = value ? widget.checkWidget : widget.uncheckWidget;
    } else {
      check = checkBoxWidget();
    }

    return CustomIcon(
        visible: widget.visible,
        icon: icon,
        iconSize: widget.iconSize,
        iconColor: value ? widget.checkColor : widget.unCheckColor,
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
