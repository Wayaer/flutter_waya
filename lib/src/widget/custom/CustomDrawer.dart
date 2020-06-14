import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CustomDrawer extends StatefulWidget {
  final Color backgroundColor;
  final Widget child;
  final DrawerCallback callback;
  final double width;
  final double elevation;

  CustomDrawer({
    Key key,
    double elevation,
    double width,
    @required this.child,
    this.backgroundColor,
    this.callback,
  })  : this.width = width ?? Tools.getWidth() * 0.7,
        this.elevation = elevation ?? 16.0,
        super(key: key);

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    if (widget.callback != null) widget.callback(true);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.callback != null) widget.callback(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.width),
      child: AlertBase(
        color: widget.backgroundColor,
        child: widget.child,
      ),
    );
  }
}
