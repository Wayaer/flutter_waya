import 'package:flutter/widgets.dart';

///  ISuspension Bean.
abstract class SuspensionModel {
  bool isShowSuspension;

  String getSuspensionTag();
}

///  AzListView Header.
class AzListHeader {
  AzListHeader({
    @required this.height,
    @required this.builder,
    this.tag = '↑',
  });

  final int height;
  final String tag;
  final WidgetBuilder builder;
}

///  Suspension Util.
class SuspensionUtil {
  ///  sort list  by suspension tag.
  ///  根据[A-Z]排序。
  static void sortListBySuspensionTag(List<SuspensionModel> list) {
    if (list == null || list.isEmpty) return;
    list.sort((SuspensionModel a, SuspensionModel b) {
      if (a.getSuspensionTag() == '@' || b.getSuspensionTag() == '#') {
        return -1;
      } else if (a.getSuspensionTag() == '#' || b.getSuspensionTag() == '@') {
        return 1;
      } else {
        return a.getSuspensionTag().compareTo(b.getSuspensionTag());
      }
    });
  }

  ///  get index data list by suspension tag.
  ///  获取索引列表。
  static List<String> getTagIndexList(List<SuspensionModel> list) {
    final List<String> indexData = <String>[];
    if (list != null && list.isNotEmpty) {
      String tempTag;
      for (final SuspensionModel item in list) {
        String tag = item.getSuspensionTag();
        if (tag.length > 2) tag = tag.substring(0, 2);
        if (tempTag != tag) {
          indexData.add(tag);
          tempTag = tag;
        }
      }
    }
    return indexData;
  }

  ///  set show suspension status.
  ///  设置显示悬停Header状态。
  static void setShowSuspensionStatus(List<SuspensionModel> list) {
    if (list == null || list.isEmpty) return;
    String tempTag;
    for (int i = 0; i < list.length; i++) {
      final String tag = list[i].getSuspensionTag();
      if (tempTag != tag) {
        tempTag = tag;
        list[i].isShowSuspension = true;
      } else {
        list[i].isShowSuspension = false;
      }
    }
  }
}

///  on all sus section callback(map: Used to scroll the list to the specified tag location).
typedef OnSusSectionCallBack = void Function(Map<String, int> map);

///  Suspension Widget.Currently only supports fixed height items!
class Suspension extends StatefulWidget {
  const Suspension({
    Key key,
    @required this.data,
    @required this.contentWidget,
    @required this.suspensionWidget,
    @required this.controller,
    this.suspensionHeight = 80,
    this.itemHeight = 50,
    this.onSusTagChanged,
    this.onSusSection,
    this.header,
  })  : assert(contentWidget != null),
        assert(controller != null),
        super(key: key);

  ///  with  ISuspensionBean Data
  final List<SuspensionModel> data;

  ///  content widget(must contain ListView).
  final Widget contentWidget;

  ///  suspension widget.
  final Widget suspensionWidget;

  ///  ListView ScrollController.
  final ScrollController controller;

  ///  suspension widget Height.
  final int suspensionHeight;

  ///  item Height.
  final int itemHeight;

  ///  on sus tag change callback.
  final ValueChanged<String> onSusTagChanged;

  ///  on sus section callback.
  final OnSusSectionCallBack onSusSection;

  final AzListHeader header;

  @override
  SuspensionState createState() => SuspensionState();
}

class SuspensionState extends State<Suspension> {
  int suspensionTop = 0;
  int lastIndex;
  int suSectionListLength;

  List<int> suspensionSectionList = <int>[];
  Map<String, int> suspensionSectionMap = <String, int>{};

  @override
  void initState() {
    super.initState();
    if (widget.header != null) {
      suspensionTop = -widget.header.height;
    }
    widget.controller.addListener(() {
      final int offset = widget.controller.offset.toInt();
      final int index = getIndex(offset);
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
        suspensionTop = -widget.header.height;
        setState(() {});
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
        suspensionTop = space;
        setState(() {});
      }
      final int a = suspensionSectionList[i];
      final int b = suspensionSectionList[i + 1];
      if (offset >= a && offset < b) return i;
      if (offset >= suspensionSectionList[suSectionListLength - 1])
        return suSectionListLength - 1;
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
    widget.data?.map((SuspensionModel v) {
      if (tag != v.getSuspensionTag()) {
        tag = v.getSuspensionTag();
        suspensionSectionMap.putIfAbsent(tag, () => offset);
        offset = offset + widget.suspensionHeight + widget.itemHeight;
      } else {
        offset = offset + widget.itemHeight;
      }
    })?.toList();
    suspensionSectionList
      ..clear()
      ..addAll(suspensionSectionMap.values);
    suSectionListLength = suspensionSectionList.length;
    if (widget.onSusSection != null) {
      widget.onSusSection(suspensionSectionMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    final List<Widget> children = <Widget>[widget.contentWidget];
    if (widget.suspensionWidget != null) {
      children.add(Positioned(

          ///  -0.1修复部分手机丢失精度问题
          top: suspensionTop.toDouble() - 0.1,
          left: 0.0,
          right: 0.0,
          child: widget.suspensionWidget));
    }
    return Stack(children: children);
  }
}
