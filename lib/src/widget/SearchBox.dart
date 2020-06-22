import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/colors.dart';
import 'package:flutter_waya/src/constant/icons.dart';
import 'package:flutter_waya/src/tools/Tools.dart';

class SearchBox extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Decoration decoration;

  final String searchText;
  final Widget search;
  final TextStyle searchStyle;
  final GestureTapCallback searchTap;
  final double size;
  final Color color;
  final IconData icon;
  final Widget prefixIcon;
  final double labelSpacing;
  final LineType lineType;
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
  final Widget extraSuffix;
  final EdgeInsetsGeometry contentPadding;
  final Color fillColor;
  final double height;
  final double width;
  final bool autoFocus;
  final FocusNode focusNode;
  final Widget suffixIcon;

  SearchBox({
    Key key,
    IconData icon,
    EdgeInsetsGeometry contentPadding,
    this.controller,
    this.suffixIcon,
    this.extraSuffix,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.color,
    double size,
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
    this.lineType,
    this.decoration,
    this.padding,
    this.alignment,
    this.fillColor,
    this.height,
    this.width,
    this.autoFocus,
    this.focusNode,
  })  : this.icon = icon ?? WayIcon.search,
        this.size = size ?? Tools.getWidth(14),
        this.contentPadding =
            contentPadding ?? EdgeInsets.all(Tools.getWidth(6)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    if (extraSuffix == null && extraPrefix == null) {
      children = null;
    } else {
      if (extraPrefix != null) {
        children.add(extraPrefix);
      }
      children.add(Expanded(child: textInput()));
      if (extraSuffix != null) {
        children.add(extraSuffix);
      }
    }
    return Universal(
      decoration: decoration,
      margin: margin,
      height: height,
      width: width,
      alignment: alignment,
      padding: padding,
      direction: Axis.horizontal,
      children: children,
      child: extraPrefix == null ? textInput() : null,
    );
  }

  Widget textInput() {
    return InputField(
      controller: controller,
      isDense: true,
      focusNode: focusNode,
      fillColor: fillColor,
      filled: true,
      focusedBorder: inputBorder(
          focusedBorderColor ?? enabledBorderColor ?? getColors(blue)),
      enabledBorder: inputBorder(enabledBorderColor ?? getColors(white50)),
      inputStyle: inputStyle,
      contentPadding: contentPadding,
      hintStyle: hintStyle,
      hintText: hintText,
      cursorColor: cursorColor ?? enabledBorderColor ?? getColors(blue),
      prefixIcon: prefix(),
      onChanged: onChanged,
      autoFocus: autoFocus,
      suffix: suffix(),
      suffixIcon: suffixIcon,
    );
  }

  Widget prefix() {
    if (prefixIcon == null) {
      return Icon(
        icon,
        size: size,
        color: color,
      );
    } else {
      return prefixIcon;
    }
  }

  Widget suffix() {
    if (search == null) {
      return searchText == null
          ? null
          : SimpleButton(
              text: searchText,
              onTap: searchTap,
              padding: EdgeInsets.symmetric(horizontal: Tools.getWidth(4)),
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
          borderSide: BorderSide(width: Tools.getWidth(0.5), color: color));
    } else if (lineType == LineType.underline) {
      return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: Tools.getWidth(0.5), color: color));
    } else {
      return InputBorder.none;
    }
  }
}
