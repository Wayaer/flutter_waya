import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomFlex.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class ListItem extends StatelessWidget {
  final Text title;
  final String titleText;
  final TextStyle titleTextStyle;
  final double titleLeftSpacing;
  final double arrowLeftSpacing;
  final double height;
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool arrowShow;
  final bool inkWell;
  final bool underlineShow;
  final Color underlineColor;
  final Widget extra;
  final Widget child;
  final Color backgroundColor;
  final BoxDecoration decoration;
  final double arrowSize;
  final Color arrowColor;
  final double iconSize;
  final Color iconColor;
  final IconData icon;
  final Image iconImage;

  ListItem(
      {Key key,
      this.title,
      this.height,
      this.titleLeftSpacing,
      this.inkWell: false,
      this.onTap,
      this.arrowShow: true,
      this.extra,
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
      this.underlineColor, this.arrowLeftSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      height: height ?? WayUtils.getHeight(44),
      inkWell: inkWell,
      margin: margin,
      padding:
          padding ?? EdgeInsets.symmetric(vertical: WayUtils.getHeight(13)),
      direction: Axis.horizontal,
      decoration: decoration ?? underlineShow
          ? WayStyles.containerUnderlineBackground(context,
              underlineColor: underlineColor, color: backgroundColor)
          : BoxDecoration(color: backgroundColor),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Offstage(
          offstage: !((iconImage != null && iconImage is Image) ||
              (icon != null && icon is IconData)),
          child: iconImage != null
              ? iconImage
              : Icon(
                  icon,
                  size: iconSize ?? WayUtils.getWidth(17),
                  color: iconColor ?? getColors(iconBlack),
                ),
        ),
        Container(
          width: titleLeftSpacing ?? WayUtils.getWidth(10),
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Offstage(
              offstage:
                  !((title != null && title is Text) || titleText != null),
              child: title == null
                  ? Text(titleText, style: titleTextStyle)
                  : title,
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
        Container(
          width: arrowLeftSpacing ?? WayUtils.getWidth(10),
        ),
        Offstage(
          offstage: !(arrowShow != null && arrowShow),
          child: Icon(
            WayIcon.iconsRight,
            size: arrowSize ?? WayUtils.getWidth(17),
            color: arrowColor ?? getColors(iconBlack),
          ),
        ),
      ],
      onTap: onTap,
    );
  }
}
