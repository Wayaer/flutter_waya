import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/ColorInfo.dart';
import 'package:flutter_waya/src/constant/IconInfo.dart';
import 'package:flutter_waya/src/constant/Styles.dart';
import 'package:flutter_waya/src/custom/CustomFlex.dart';
import 'package:flutter_waya/src/custom/CustomIcon.dart';
import 'package:flutter_waya/src/utils/Utils.dart';

class ItemWidget extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final double iconRightSpacing;
  final double height;
  final Color background;
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool arrow;
  final bool inkWell;
  final bool underline;
  final Widget extra;
  final Widget child;
  final BoxDecoration decoration;

  ItemWidget(
      {Key key,
      this.title,
      this.height,
      this.iconRightSpacing: 1,
      this.icon,
      this.inkWell: true,
      this.onTap,
      this.arrow: true,
      this.extra,
      this.underline: true,
      this.padding,
      this.margin,
      this.decoration,
      this.background,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      height: height ?? Utils.getHeight(44),
      inkWell: inkWell,
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(vertical: Utils.getHeight(13)),
      direction: Axis.horizontal,
      decoration: underline
          ? Styles.containerUnderlineBackground(
              context,
              color: background ?? getColors(lineBackground),
            )
          : BoxDecoration(color: background ?? getColors(containerColor)),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Offstage(
          offstage: !(icon != null && title is Widget),
          child: icon,
        ),
        Container(
          width: iconRightSpacing,
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Offstage(
              offstage: !(title != null && title is Widget),
              child: title,
            ),
            Row(children: <Widget>[
              Offstage(
                offstage: !(extra != null && extra is Widget),
                child: extra,
              ),
              Offstage(
                offstage: !(child != null && child is Widget),
                child: child,
              ),
            ])
          ],
        )),
        Offstage(
          offstage: !(arrow != null && arrow),
          child: CustomIcon(
            IconInfo.iconsRight,
            iconSize: Utils.getWidth(17),
            iconColor: getColors(iconGray),
          ),
        ),
      ],
      onTap: onTap,
    );
  }
}
