import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomIcon.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

import '../custom/CustomFlex.dart';

class SearchInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double width;
  final double height;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final String hintText;
  final TextStyle hintStyle;
  final Color iconColor;
  final IconData icon;

  SearchInputWidget({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
        height: height,
        width: width ?? WayUtils.getWidth(220),
        padding: padding ?? EdgeInsets.only(left: WayUtils.getWidth(8)),
        margin: margin,
        decoration: BoxDecoration(
          color: getColors(background),
          border: Border.all(color: getColors(background)),
        ),
        direction: Axis.horizontal,
        children: <Widget>[
          CustomIcon(
            icon: icon ?? WayIcon.iconsSearch,
            iconColor: iconColor ?? getColors(black),
            iconSize: iconSize ?? WayUtils.getWidth(14),
          ),
          Expanded(
              child: TextField(
            style: WayStyles.textStyleBlack70( fontSize: 13.5),
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: hintText ?? "搜索",
              hintStyle: hintStyle ??
                  WayStyles.textStyleBlack30( fontSize: 12),
              border: InputBorder.none, //隐藏下划线
            ),
            onChanged: onChanged,
          )),
        ]);
  }
}
