import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/assets.dart';
import 'package:flutter_waya/src/widget/custom/Universal.dart';

class AreaPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AreaPickerState();
  }
}

class AreaPickerState extends State<AreaPicker> {
  @override
  void initState() {
    super.initState();
    Tools.addPostFrameCallback((duration) async {
      var data = await rootBundle.load(Assets.area);
      log(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Universal();
  }
}
