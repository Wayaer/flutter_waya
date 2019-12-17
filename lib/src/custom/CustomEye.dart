import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/utils/Utils.dart';


class CustomEye extends StatefulWidget {
  final Function onChange;
  final bool defaultOpen;
  final Color color;
  final double size;

  const CustomEye({Key key, this.onChange, this.color, this.defaultOpen = true, this.size})
      : super(key: key);

  @override
  CustomEyeState createState() => CustomEyeState();
}

class CustomEyeState extends State<CustomEye> {
  bool _status;

  @override
  void initState() {
    _status = widget.defaultOpen;
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      borderRadius: BorderRadius.circular(2),
      onTap: () {
        setState(() {
          _status = !_status;
        });
        if (widget.onChange is Function) {
          widget.onChange(_status);
        }
      },
      child: Icon(
        _status ? WayIcon.iconsEyeOpen : WayIcon.iconsEyeClose,
        size: widget.size ?? Utils.getWidth( 16),
        color: widget.color ?? getColors(iconGray),
      ),
      // child: Text("2121"),
    );
  }
}
