import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class RouteConfig {
  RouteConfig.fromContext(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    offset = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    if (offset.dx > MediaQuery.of(context).size.width / 2) {
      if (offset.dy > MediaQuery.of(context).size.height / 2) {
        circleRadius = sqrt(pow(offset.dx, 2) + pow(offset.dy, 2)).toDouble();
      } else {
        circleRadius = sqrt(pow(offset.dx, 2) +
                pow(MediaQuery.of(context).size.height - offset.dy, 2))
            .toDouble();
      }
    }
    if (offset.dx <= MediaQuery.of(context).size.width / 2) {
      if (offset.dy > MediaQuery.of(context).size.height / 2) {
        circleRadius = sqrt(
                pow(MediaQuery.of(context).size.width - offset.dx, 2) +
                    pow(offset.dy, 2))
            .toDouble();
      } else {
        circleRadius = sqrt(
                pow(MediaQuery.of(context).size.width - offset.dx, 2) +
                    pow(MediaQuery.of(context).size.height - offset.dy, 2))
            .toDouble();
      }
    }
  }

  Offset offset;
  double circleRadius;
}

class RipplePageRoute<T> extends PageRouteBuilder<T> {
  RipplePageRoute({this.widget, this.routeConfig})
      : super(
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder:
                (BuildContext context, Animation<double> animation, _) =>
                    widget,
            opaque: false,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> _,
                Widget child) {
              final Widget widget = Positioned(
                top: routeConfig.circleRadius * animation.value -
                    routeConfig.offset.dy,
                left: routeConfig.circleRadius * animation.value -
                    routeConfig.offset.dx,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: deviceWidth,
                        height: deviceHeight,
                        color: Colors.red,
                        child: child)),
              );
              return Stack(alignment: Alignment.center, children: <Widget>[
                Positioned(
                    top: routeConfig.offset.dy -
                        routeConfig.circleRadius * animation.value,
                    left: routeConfig.offset.dx -
                        routeConfig.circleRadius * animation.value,
                    child: SizedBox(
                        height: routeConfig.circleRadius * 2 * animation.value,
                        width: routeConfig.circleRadius * 2 * animation.value,
                        child: Universal(
                            isOval: true,
                            isStack: true,
                            children: widget.asList()))),
              ]);
            });
  final Widget widget;
  final RouteConfig routeConfig;
}
