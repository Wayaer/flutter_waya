import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/BaseEnum.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double width;
  final double height;

  final double iconSize;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final String hintText;
  final String labelText;
  final TextStyle hintStyle;
  final TextStyle inputTextStyle;
  final TextStyle labelTextStyle;
  final Color labelIconColor;
  final double labelIconSize;
  final Color iconColor;
  final Color borderColor;
  final IconData icon;
  final double borderRadius;
  final Color cursorColor;
  final EdgeInsetsGeometry labelMargin;
  final EdgeInsetsGeometry labelPadding;
  final double labelSpacing;
  final bool labelShow;
  final double lineWidth;
  final String searchButtonText;
  final TextStyle searchButtonTextStyle;
  final GestureTapCallback labelTap;
  double labelWidth; //不建议设置宽度
  final GestureTapCallback searchButtonTap;
  final EdgeInsetsGeometry searchPadding;

  SearchInput({
    Key key,
    this.controller,
    this.onChanged,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.hintText,
    this.hintStyle,
    this.iconColor,
    this.icon,
    this.iconSize,
    this.borderColor,
    this.borderRadius,
    this.inputTextStyle,
    this.cursorColor,
    this.labelTextStyle,
    this.labelIconColor,
    this.labelIconSize,
    this.labelMargin,
    this.labelPadding,
    this.labelSpacing,
    this.labelText,
    this.labelShow: false,
    this.lineWidth,
    this.labelTap,
    this.labelWidth,
    this.searchButtonText,
    this.searchButtonTextStyle,
    this.searchButtonTap,
    this.searchPadding,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        padding: padding,
        child: TextInputWidget(
          inputBoxHeight: height,
          hintStyle: hintStyle,
          hintText: hintText,
          inputBoxLineBorderRadius: BorderRadius.circular(borderRadius),
          lineWidth: lineWidth ?? BaseUtils.getWidth(0.5),
          lineBackground: borderColor,
          lineFocusBackground: borderColor,
          inputTextStyle: inputTextStyle,
          cursorColor: cursorColor ?? borderColor,
          inputBoxPadding:
              EdgeInsets.symmetric(horizontal: BaseUtils.getWidth(10)),
          inputBoxLeftWight: CustomIcon(
            margin: EdgeInsets.only(right: BaseUtils.getWidth(5)),
            icon: WayIcon.iconsSearch,
            iconSize: iconSize,
            iconColor: iconColor,
          ),
          onChanged: onChanged,
          lineType: LineType.outLine,
          inputBoxRightWight: searchButtonText == null
              ? null
              : CustomButton(
                  text: '搜索',
                  onTap: searchButtonTap,
                  padding: searchPadding ??
                      EdgeInsets.symmetric(horizontal: BaseUtils.getWidth(3)),
                  textStyle: searchButtonTextStyle ??
                      TextStyle(color: getColors(white)),
                ),
          inputBoxOutLeftWidget: labelShow
              ? CustomFlex(
                  direction: Axis.horizontal,
                  margin: labelMargin,
                  padding: labelPadding,
                  onTap: labelTap,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  width: labelWidth,
                  children: <Widget>[
                      CustomButton(
                        alignment: Alignment.centerLeft,
                        text: labelText ?? '选择',
                        textStyle: labelTextStyle,
                      ),
                      CustomIcon(
                        margin: EdgeInsets.only(
                            left: labelSpacing ?? BaseUtils.getWidth(5)),
                        icon: Icons.arrow_drop_down,
                        iconSize: labelIconSize ?? iconSize,
                        iconColor: labelIconColor,
                      )
                    ])
              : null,
        ));
  }
}
