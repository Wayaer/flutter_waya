import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/custom/CustomIcon.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class BlueIcons extends StatelessWidget {
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final String text;

  BlueIcons(this.icon, {
    Key key,
    this.onTap,
    this.text,
    this.margin,
    this.padding,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIcon(
      icon: icon,
      margin: margin,
      padding: padding,
      onTap: onTap,
      iconSize: BaseUtils.getWidth(22),
      iconColor: getColors(blue),
      text: text,
    );
  }
}
