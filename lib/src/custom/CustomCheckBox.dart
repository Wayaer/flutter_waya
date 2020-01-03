import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

import 'CustomFlex.dart';
import 'CustomIcon.dart';

class CustomCheckBox extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final String label;
  final bool value;
  final Color checkColor;
  final Color background;
  final Color unCheckColor;

  final TextStyle textStyle;
  final double iconSize;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget checkWidget;
  final Widget uncheckWidget;
  final IconData checkIcon;
  final IconData uncheckIcon;

  CustomCheckBox({Key key,
    this.value: false,
    this.onChange,
    this.checkWidget,
    this.checkIcon,
    this.uncheckIcon,
    this.uncheckWidget,
    this.background,
    this.padding,
    this.margin,
    this.label,
    this.iconSize,
    this.width,
    this.height,
    this.unCheckColor,
    this.checkColor,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textStyle})
      : super(key: key);

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
        icon: value
            ? checkIcon ?? WayIcon.iconsChecked
            : uncheckIcon ?? WayIcon.iconsUnChecked,
        iconSize: widget.iconSize ?? WayUtils.getWidth(17.5),
        width: widget.width,
        height: widget.height,
        background: widget.background,
        margin: widget.margin,
        padding: widget.padding,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        iconColor: value
            ? widget.checkColor ?? getColors(blue)
            : widget.unCheckColor ?? getColors(black),
        textStyle: widget.textStyle,
        text: widget.label,
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
    return widget.label != null
        ? CustomFlex(
      onTap: () {
        setState(() {
          value = !value;
        });
        if (widget.onChange is ValueChanged<bool>) {
          widget.onChange(value);
        }
      },
      direction: Axis.horizontal,
      children: <Widget>[
        checkBoxWidget(),
        Text(
          widget.label,
          style: widget.textStyle != null
              ? widget.textStyle
              : TextStyle(
            fontSize: 12,
            color: getColors(black70),
          ),
        ),
      ],
    )
        : checkBoxWidget();
  }

  Widget checkBoxWidget() {
    return Checkbox(
//      tristate: widget.tristate,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      activeColor: widget.unCheckColor ?? getColors(blue),
      value: value,
      checkColor: widget.checkColor ?? getColors(black),
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
