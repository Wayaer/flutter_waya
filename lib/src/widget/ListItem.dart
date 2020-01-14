import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomFlex.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class ListItem extends StatelessWidget {
  final Text title;
  final String titleText;
  final TextStyle titleTextStyle;
  final double titleLeftSpacing;
  final double arrowLeftSpacing;
  final double height;
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool arrowShow;
  final bool inkWell;
  final bool underlineShow;
  final Color underlineColor;
  final Widget child;
  final Color backgroundColor;
  final BoxDecoration decoration;
  final double arrowSize;
  final Color arrowColor;
  final double iconSize;
  final Color iconColor;
  final IconData icon;
  final Image iconImage;

  ListItem({Key key,
    this.title,
    this.height,
    this.titleLeftSpacing,
    this.inkWell: false,
    this.onTap,
    this.arrowShow: true,
    this.underlineShow: false,
    this.padding,
    this.margin,
    this.decoration,
    this.child,
    this.backgroundColor,
    this.titleText,
    this.titleTextStyle,
    this.arrowSize,
    this.arrowColor,
    this.iconSize,
    this.iconColor,
    this.icon,
    this.iconImage,
    this.underlineColor,
    this.arrowLeftSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      height: height,
      inkWell: inkWell,
      margin: margin,
      padding:
      padding ?? EdgeInsets.symmetric(vertical: BaseUtils.getHeight(13)),
      direction: Axis.horizontal,
      decoration: decoration ??
          (underlineShow
              ? WayStyles.containerUnderlineBackground(
              underlineColor: underlineColor, color: backgroundColor)
              : BoxDecoration(color: backgroundColor)),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Offstage(
          offstage: !((iconImage != null && iconImage is Image) ||
              (icon != null && icon is IconData)),
          child: iconImage != null
              ? iconImage
              : Icon(
            icon,
            size: iconSize ?? BaseUtils.getWidth(17),
            color: iconColor ?? getColors(black),
          ),
        ),
        Container(
          width: titleLeftSpacing ?? BaseUtils.getWidth(10),
        ),
        Expanded(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Offstage(
                  offstage:
                  !((title != null && title is Text) || titleText != null),
                  child: title == null
                      ? Text(titleText, style: titleTextStyle)
                      : title,
                ),
                Expanded(
                    child: Offstage(
                      offstage: !(child != null && child is Widget),
                      child: Container(
                        child: child,
                        alignment: Alignment.centerRight,
                      ),
                    ))
              ],
            )),
        Container(
          width: arrowLeftSpacing ?? BaseUtils.getWidth(10),
        ),
        Offstage(
          offstage: !(arrowShow != null && arrowShow),
          child: Icon(
            WayIcon.iconsRight,
            size: arrowSize ?? BaseUtils.getWidth(17),
            color: arrowColor ?? getColors(black),
          ),
        ),
      ],
      onTap: onTap,
    );
  }
}
