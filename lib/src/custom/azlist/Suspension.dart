import 'package:flutter/material.dart';

import 'AzCommon.dart';

/// on all sus section callback(map: Used to scroll the list to the specified tag location).
typedef void OnSusSectionCallBack(Map<String, int> map);

///Suspension Widget.Currently only supports fixed height items!
class Suspension extends StatefulWidget {
  /// with  ISuspensionBean Data
  final List<SuspensionModel> data;

  /// content widget(must contain ListView).
  final Widget contentWidget;

  /// suspension widget.
  final Widget suspensionWidget;

  /// ListView ScrollController.
  final ScrollController controller;

  /// suspension widget Height.
  final int suspensionHeight;

  /// item Height.
  final int itemHeight;

  /// on sus tag change callback.
  final ValueChanged<String> onSusTagChanged;

  /// on sus section callback.
  final OnSusSectionCallBack onSusSectionInited;

  final AzListHeader header;

  Suspension({
    Key key,
    @required this.data,
    @required this.contentWidget,
    @required this.suspensionWidget,
    @required this.controller,
    this.suspensionHeight = 80,
    this.itemHeight = 50,
    this.onSusTagChanged,
    this.onSusSectionInited,
    this.header,
  })  : assert(contentWidget != null),
        assert(controller != null),
        super(key: key);

  @override
  SuspensionState createState() => SuspensionState();
}

class SuspensionState extends State<Suspension> {
  int suspensionTop = 0;
  int lastIndex;
  int suSectionListLength;

  List<int> suspensionSectionList = List();
  Map<String, int> suspensionSectionMap = Map();

  @override
  void initState() {
    super.initState();
    if (widget.header != null) {
      suspensionTop = -widget.header.height;
    }
    widget.controller.addListener(() {
      int offset = widget.controller.offset.toInt();
      int index = getIndex(offset);
      if (index != -1 && lastIndex != index) {
        lastIndex = index;
        if (widget.onSusTagChanged != null) {
          widget.onSusTagChanged(suspensionSectionMap.keys.toList()[index]);
        }
      }
    });
  }

  int getIndex(int offset) {
    if (widget.header != null && offset < widget.header.height) {
      if (suspensionTop != -widget.header.height &&
          widget.suspensionWidget != null) {
        setState(() {
          suspensionTop = -widget.header.height;
        });
      }
      return 0;
    }
    for (int i = 0; i < suSectionListLength - 1; i++) {
      int space = suspensionSectionList[i + 1] - offset;
      if (space > 0 && space < widget.suspensionHeight) {
        space = space - widget.suspensionHeight;
      } else {
        space = 0;
      }
      if (suspensionTop != space && widget.suspensionWidget != null) {
        setState(() {
          suspensionTop = space;
        });
      }
      int a = suspensionSectionList[i];
      int b = suspensionSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
      if (offset >= suspensionSectionList[suSectionListLength - 1]) {
        return suSectionListLength - 1;
      }
    }
    return -1;
  }

  void init() {
    suspensionSectionMap.clear();
    int offset = 0;
    String tag;
    if (widget.header != null) {
      suspensionSectionMap[widget.header.tag] = 0;
      offset = widget.header.height;
    }
    widget.data?.forEach((v) {
      if (tag != v.getSuspensionTag()) {
        tag = v.getSuspensionTag();
        suspensionSectionMap.putIfAbsent(tag, () => offset);
        offset = offset + widget.suspensionHeight + widget.itemHeight;
      } else {
        offset = offset + widget.itemHeight;
      }
    });
    suspensionSectionList
      ..clear()
      ..addAll(suspensionSectionMap.values);
    suSectionListLength = suspensionSectionList.length;
    if (widget.onSusSectionInited != null) {
      widget.onSusSectionInited(suspensionSectionMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    var children = <Widget>[
      widget.contentWidget,
    ];
    if (widget.suspensionWidget != null) {
      children.add(Positioned(
        ///-0.1修复部分手机丢失精度问题
        top: suspensionTop.toDouble() - 0.1,
        left: 0.0,
        right: 0.0,
        child: widget.suspensionWidget,
      ));
    }
    return Stack(children: children);
  }
}
