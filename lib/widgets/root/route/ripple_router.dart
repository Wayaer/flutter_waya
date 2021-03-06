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

  late Offset offset;
  late double circleRadius;
}

class RipplePageRoute<T> extends PageRouteBuilder<T> {
  RipplePageRoute({required this.widget, required this.routeConfig})
      : super(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => widget,
            opaque: false,
            transitionsBuilder: (_, Animation<double> animation,
                Animation<double> __, Widget child) {
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
                          child: child)));
              return Stack(alignment: Alignment.center, children: <Widget>[
                Positioned(
                    top: routeConfig.offset.dy -
                        routeConfig.circleRadius * animation.value,
                    left: routeConfig.offset.dx -
                        routeConfig.circleRadius * animation.value,
                    child: Universal(
                        height: routeConfig.circleRadius * 2 * animation.value,
                        width: routeConfig.circleRadius * 2 * animation.value,
                        isOval: true,
                        isStack: true,
                        children: widget.asList())),
              ]);
            });
  final Widget widget;
  final RouteConfig routeConfig;
}
