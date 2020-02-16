import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CustomDrawer extends StatefulWidget {
  final Color backgroundColor;
  final double elevation;
  final Widget child;
  double width;
  final DrawerCallback callback;

  CustomDrawer({
    this.backgroundColor,
    this.elevation: 16.0,
    @required this.child,
    this.width,
    this.callback,
  }) {
    if (width == null) {
      width = BaseUtils.getWidth() * 0.7;
    }
  }

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    if (widget.callback != null) {
      widget.callback(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.callback != null) {
      widget.callback(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: widget.width),
      child: AlertBase(
        center: false,
        backgroundColor: widget.backgroundColor,
        child: widget.child,
      ),
    );
  }
}
