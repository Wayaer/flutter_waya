import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/constant/ColorInfo.dart';
import 'package:flutter_waya/src/custom/CustomIcon.dart';
import 'package:flutter_waya/src/utils/Utils.dart';


class BlueIcons extends StatelessWidget {
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final String text;

  BlueIcons(
    this.icon, {
    this.onTap,
    this.text,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomIcon(
      icon,
      margin: margin,
      padding: padding,
      onTap: onTap,
      iconSize: Utils.getWidth( 22),
      iconColor: getColors(iconBlue),
      text: text,
    );
  }
}
