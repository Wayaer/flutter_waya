import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/custom/marquee/Marquee.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

class MarqueeListWidget extends StatelessWidget {
  final int itemCount;
  final double animateDistance;
  final List<Widget> children;

  MarqueeListWidget({
    this.itemCount,
    this.children,
    this.animateDistance,
  }) : assert(itemCount != null);

  @override
  Widget build(BuildContext context) {
    return itemCount > 0
        ? Marquee(
            center: false,
            animateDistance: animateDistance ?? BaseUtils.getHeight(100),
            children: children,
          )
        : Container();
    ;
  }
}
