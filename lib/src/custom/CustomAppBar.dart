import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayConstant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leftWidget;
  final Widget rightWidget;
  final IconData leftIcon;
  final IconData rightIcon;
  final AppBar appBar;

  final bool paddingStatusBar;
  final GestureTapCallback leftOnTap;
  final GestureTapCallback rightOnTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  double statusBarHeight = 0;
  double height;
  double rightLeftWidth = BaseUtils.getWidth() / 4.5;
  double contentHeight = 0;
  double iconSize;
  Color iconColor;
  Color textColor;

  CustomAppBar({Key key,
    this.title: 'title',
    this.leftWidget,
    this.rightWidget,
    this.leftOnTap,
    this.rightOnTap,
    this.leftIcon,
    this.rightIcon,
    this.iconColor,
    this.iconSize,
    this.textColor,
    this.padding,
    this.margin,
    this.height,
    this.paddingStatusBar: true,
    this.backgroundColor,
    this.appBar})
      : super(key: key) {
    iconSize = iconSize ?? BaseUtils.getWidth(20);
    iconColor = iconColor ?? getColors(white);
    textColor = textColor ?? getColors(white);
    statusBarHeight = MediaQueryUtils.getStatusBarHeight();
    if (height != null) {
      height = height + (paddingStatusBar ? statusBarHeight : 0);
    } else {
      height = BaseUtils.getHeight(WayConstant.appBarHeight) +
          (paddingStatusBar ? statusBarHeight : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return appBar == null ? appBarWidget() : appBar;
    return Container(
        height: height,
        child: AppBar(
          leading: leftWidget,
          title: Text(
            title,
            maxLines: 1,
            style: TextStyle(
                fontSize: 18,
                color: textColor ?? getColors(white),
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: backgroundColor ?? Colors.transparent,
          actions: <Widget>[
            Container(
                child: rightWidget ??
                    (rightIcon != null
                        ? CustomIcon(
                      width: iconSize ?? BaseUtils.getWidth(28),
                      icon: rightIcon,
                      padding: EdgeInsets.all(8.0),
                      iconColor: iconColor ?? getColors(white),
                      iconSize: iconSize ?? BaseUtils.getWidth(22),
                      onTap: rightOnTap,
                    )
                        : null)),
          ],
        ));
  }

  Widget appBarWidget() {
    return CustomFlex(
        color: backgroundColor,
        height: height,
        direction: Axis.horizontal,
        padding: padding ??
            EdgeInsets.only(
                left: BaseUtils.getWidth(12),
                right: BaseUtils.getWidth(12),
                top: paddingStatusBar ? statusBarHeight : 0),
        margin: margin,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              width: rightLeftWidth,
              child: leftWidget != null
                  ? leftWidget
                  : CustomIcon(
                width: iconSize,
                icon: leftIcon ?? Icons.arrow_back_ios,
                iconColor: iconColor,
                iconSize: iconSize,
                onTap: leftOnTap ??
                        () {
                      BaseNavigatorUtils.getInstance().pop();
                    },
              )),
          Expanded(
              child: Center(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18,
                        color: textColor ?? getColors(white),
                        fontWeight: FontWeight.w700),
                  ))),
          Container(
              alignment: Alignment.centerRight,
              height: height - contentHeight,
              width: rightLeftWidth,
              child: rightWidget ??
                  (rightIcon != null
                      ? CustomIcon(
                    width: iconSize,
                    icon: rightIcon,
                    iconColor: iconColor,
                    iconSize: iconSize,
                    onTap: rightOnTap,
                  )
                      : null)),
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
