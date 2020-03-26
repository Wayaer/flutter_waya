import 'package:flutter/material.dart';
import 'package:flutter_waya/waya.dart';

class CustomDrawer extends StatefulWidget {
  final Color backgroundColor;
  final Widget child;
  final DrawerCallback callback;
  double width;
  double elevation;

  CustomDrawer({
    this.backgroundColor,
    this.elevation,
    @required this.child,
    this.width,
    this.callback,
  }) {
    if (width == null) width = BaseUtils.getWidth() * 0.7;
    if (elevation == null) elevation = 16.0;
  }

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
    assert(debugCheckHasMaterialLocalizations(context));
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: widget.width),
      child: AlertBase(
        backgroundColor: widget.backgroundColor,
        child: widget.child,
      ),
    );
  }
}
