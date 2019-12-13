import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/ColorInfo.dart';
import 'package:flutter_waya/src/constant/IconInfo.dart';
import 'package:flutter_waya/src/utils/Utils.dart';

import 'CustomFlex.dart';
import 'CustomIcon.dart';

class CustomCheckBox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final String label;
  final bool value;
  final Color checkColor;
  final Color background;
  final Color activeColor;
  final bool tristate;
  final TextStyle textStyle;
  final double iconSize;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  CustomCheckBox(
      {Key key,
      this.value: false,
      this.tristate: false,
      this.onChanged,
      this.background,
      this.padding,
      this.margin,
      this.label,
      this.iconSize,
      this.width,
      this.height,
      this.activeColor,
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
    return CustomIcon(value ? IconInfo.iconsChecked : IconInfo.iconsUnChecked,
        iconSize: widget.iconSize ?? Utils.getWidth( 17.5),
        width: widget.width,
        height: widget.height,
        background: widget.background,
        margin: widget.margin,
        padding: widget.padding,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        iconColor: value
            ? widget.activeColor ?? getColors(iconBlue)
            : widget.checkColor ?? getColors(iconGray),
        textStyle: widget.textStyle,
        text: widget.label, onTap: () {
      setState(() {
        value = !value;
      });
      widget.onChanged(value);
    });
  }

  Widget checkBox() {
    return widget.label != null
        ? CustomFlex(
            onTap: () {
              setState(() {
                value = !value;
              });
              widget.onChanged(value);
            },
            direction: Axis.horizontal,
            children: <Widget>[
              Checkbox(
                tristate: widget.tristate,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor:
                    widget.activeColor ?? getColors(checkboxActiveColor),
                value: value,
                checkColor: widget.checkColor ?? getColors(checkboxCheckColor),
                onChanged: onChange,
              ),
              Text(
                widget.label,
                style: widget.textStyle != null
                    ? widget.textStyle
                    : TextStyle(
                        fontSize: 12,
                        color: getColors(textBlack70),
                      ),
              ),
            ],
          )
        : Checkbox(
            tristate: widget.tristate,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: widget.activeColor ?? getColors(checkboxActiveColor),
            value: value,
            checkColor: widget.checkColor ?? getColors(checkboxCheckColor),
            onChanged: onChange,
          );
  }

  onChange(bool v) {
    if (value != v) {
      setState(() {
        value = v;
      });
      widget.onChanged(v);
    }
  }
}
