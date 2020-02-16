import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class SearchInput extends StatelessWidget {
  final String searchText;
  final TextStyle searchStyle;
  final GestureTapCallback searchTap;
  final EdgeInsetsGeometry searchPadding;

  final double iconSize;
  final Color iconColor;
  final IconData icon;
  final Widget prefixIcon;

  final double labelSpacing;
  final LineType lineType;
  final EdgeInsetsGeometry margin;

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle inputStyle;
  final double borderRadius;
  final Color cursorColor;
  final InputBorder defaultBorder;
  final InputBorder focusedBorder;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Widget extraPrefix;



  SearchInput({
    Key key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.iconColor,
    this.icon,
    this.iconSize,
    this.borderRadius,
    this.inputStyle,
    this.cursorColor,
    this.labelSpacing,
    this.searchText,
    this.searchPadding,
    this.defaultBorder,
    this.focusedBorder,
    this.lineType: LineType.outline,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.margin,
    this.extraPrefix,
    this.prefixIcon,
    this.searchStyle,
    this.searchTap,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      margin: margin,
      child: textInputBox(),
    );
  }

  Widget textInputBox() {
    return TextInputBox(
      controller: controller,
      isDense: true,
      focusedBorder: inputBorder(focusedBorderColor ?? enabledBorderColor ?? getColors(blue)),
      enabledBorder: inputBorder(enabledBorderColor ?? getColors(white50)),
      inputStyle: inputStyle,
      contentPadding: EdgeInsets.all(BaseUtils.getWidth(5)),
      hintStyle: hintStyle,
      hintText: hintText,
      cursorColor: cursorColor ?? enabledBorderColor ?? getColors(blue),
      prefixIcon: prefixIcon ??
          Icon(
            icon ?? WayIcon.iconsSearch,
            size: iconSize,
            color: iconColor,
          ),
      onChanged: onChanged,
      icon: extraPrefix,
      suffix: searchText == null
          ? null
          : CustomButton(
              text: '搜索',
              onTap: searchTap,
              padding: searchPadding ?? EdgeInsets.symmetric(horizontal: BaseUtils.getWidth(3)),
              textStyle: searchStyle ?? TextStyle(color: getColors(white)),
            ),
    );
  }

  InputBorder inputBorder(Color color) {
    if (lineType == LineType.outline) {
      return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: BaseUtils.getWidth(0.5), color: color));
    } else if (lineType == LineType.underline) {
      return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: BaseUtils.getWidth(0.5), color: color));
    } else {
      return InputBorder.none;
    }
  }
}
