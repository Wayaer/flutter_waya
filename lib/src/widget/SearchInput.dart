import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';
import 'package:flutter_waya/waya.dart';

class SearchInput extends StatelessWidget {
  final String searchText;
  final Widget search;
  final TextStyle searchStyle;
  final GestureTapCallback searchTap;

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
  final EdgeInsetsGeometry contentPadding;

  SearchInput({
    Key key,
    IconData icon,
    LineType lineType,
    EdgeInsetsGeometry contentPadding,
    this.controller,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.iconColor,
    this.iconSize,
    this.borderRadius,
    this.inputStyle,
    this.cursorColor,
    this.labelSpacing,
    this.searchText,
    this.defaultBorder,
    this.focusedBorder,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.margin,
    this.extraPrefix,
    this.prefixIcon,
    this.searchStyle,
    this.searchTap,
    this.search,
  })  : this.icon = icon ?? WayIcon.iconsSearch,
        this.lineType = lineType ?? LineType.outline,
        this.contentPadding = contentPadding ?? EdgeInsets.all(BaseUtils.getWidth(5)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      margin: margin,
      child: textInput(),
    );
  }

  Widget textInput() {
    return TextInputField(
      controller: controller,
      isDense: true,
      focusedBorder: inputBorder(focusedBorderColor ?? enabledBorderColor ?? getColors(blue)),
      enabledBorder: inputBorder(enabledBorderColor ?? getColors(white50)),
      inputStyle: inputStyle,
      contentPadding: contentPadding,
      hintStyle: hintStyle,
      hintText: hintText,
      cursorColor: cursorColor ?? enabledBorderColor ?? getColors(blue),
      prefixIcon: prefix(),
      onChanged: onChanged,
      icon: extraPrefix,
      suffix: suffix(),
    );
  }

  Widget prefix() {
    if (prefixIcon == null) {
      return icon == null
          ? null
          : Icon(
              icon,
              size: iconSize,
              color: iconColor,
            );
    } else {
      return prefixIcon;
    }
  }

  Widget suffix() {
    if (search == null) {
      return searchText == null
          ? null
          : CustomButton(
              text: '搜索',
              onTap: searchTap,
              padding: EdgeInsets.symmetric(horizontal: BaseUtils.getWidth(4)),
              textStyle: searchStyle ?? TextStyle(color: getColors(white)),
            );
    } else {
      return search;
    }
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
