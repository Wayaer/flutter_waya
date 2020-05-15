import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';

class CustomCheckBox extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final Color checkColor;
  final Color background;
  final Color unCheckColor;
  final TextStyle titleStyle;
  final String titleText;
  final Widget title;
  final double iconSize;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget checkWidget;
  final Widget uncheckWidget;
  final IconData checkIcon;
  final IconData uncheckIcon;
  final bool value;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  CustomCheckBox({Key key,
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
    this.width,
    this.height,
    Color unCheckColor,
    Color checkColor,
    this.titleStyle,
    this.titleText,
    this.title})
      : this.value = value ?? false,
        this.iconSize = iconSize ?? Tools.getWidth(17),
        this.unCheckColor = unCheckColor ?? getColors(blue),
        this.checkColor = checkColor ?? getColors(blue),
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        this.crossAxisAlignment = crossAxisAlignment ??
            CrossAxisAlignment.center,
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
    if (widget.uncheckWidget != null && widget.checkWidget != null) {
      return customWidget(
          uncheckWidget: widget.uncheckWidget, checkWidget: widget.checkWidget);
    }
    if (widget.uncheckIcon != null || widget.checkIcon != null) {
      return customIcon(
          uncheckIcon: widget.uncheckIcon, checkIcon: widget.checkIcon);
    }
    return customIcon();
  }

  Widget customWidget({Widget uncheckWidget, Widget checkWidget}) {
    return CustomFlex(
        width: widget.width,
        height: widget.height,
        color: widget.background,
        margin: widget.margin,
        padding: widget.padding,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        onTap: () {
          setState(() {
            value = !value;
          });
          if (widget.onChange is ValueChanged<bool>) {
            widget.onChange(value);
          }
        },
        child: value ? checkWidget : uncheckWidget);
  }

  Widget customIcon({IconData uncheckIcon, IconData checkIcon}) {
    return CustomIcon(
        icon: value ? checkIcon ?? WayIcon.checked : uncheckIcon ??
            WayIcon.unChecked,
        iconSize: widget.iconSize,
        width: widget.width,
        height: widget.height,
        background: widget.background,
        margin: widget.margin,
        padding: widget.padding,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        iconColor: value ? widget.checkColor : widget.unCheckColor,
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

  Widget checkBox() {
    if (widget.title != null || widget.titleText != null) {
      List<Widget> children = [];
      children.add(checkBoxWidget());
      if (widget.title != null) {
        children.add(widget.title);
      } else {
        children.add(Text(
          widget.titleText,
          style: widget.titleStyle != null
              ? widget.titleStyle
              : TextStyle(
            fontSize: 12,
            color: getColors(black70),
          ),
        ));
      }
      return CustomFlex(
        onTap: () {
          setState(() {
            value = !value;
          });
          if (widget.onChange is ValueChanged<bool>) {
            widget.onChange(value);
          }
        },
        direction: Axis.horizontal,
        children: children,
      );
    } else {
      return checkBoxWidget();
    }
  }

  Widget checkBoxWidget() {
    return Checkbox(
//      tristate: widget.tristate,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      activeColor: widget.unCheckColor,
      value: value,
      checkColor: widget.checkColor,
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
