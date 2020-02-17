import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

import '../CustomListView.dart';
import 'AzCommon.dart';
import 'AzIndexBar.dart';
import 'Suspension.dart';

/// Called to build children for the listview.
typedef Widget ItemWidgetBuilder(BuildContext context, SuspensionModel model);

/// Called to build IndexBar.
typedef Widget IndexBarBuilder(BuildContext context, List<String> tags, IndexBarTouchCallback onTouch);

/// Called to build index hint.
typedef Widget IndexHintBuilder(BuildContext context, String hint);

/// Header.
class Header extends SuspensionModel {
  String tag;

  @override
  String getSuspensionTag() => tag;

  @override
  bool get isShowSuspension => false;
}

/// AzListView.
class AzListView extends StatefulWidget {
  AzListView(
      {Key key,
      this.data,
      this.topData,
      this.itemBuilder,
      this.controller,
      this.physics,
      this.shrinkWrap = true,
      this.padding = EdgeInsets.zero,
      this.suspensionWidget,
      this.isUseRealIndex = true,
      this.itemHeight,
      this.suspensionHeight,
      this.onSusTagChanged,
      this.header,
      this.indexBarBuilder,
      this.indexHintBuilder,
      this.showIndexHint = true})
      : assert(itemBuilder != null),
        super(key: key);

  ///with SuspensionModel Data
  final List<SuspensionModel> data;

  ///with SuspensionModel topData, Do not participate in [A-Z] sorting (such as hotList).
  final List<SuspensionModel> topData;

  final ItemWidgetBuilder itemBuilder;

  final ScrollController controller;

  final ScrollPhysics physics;

  final bool shrinkWrap;

  final EdgeInsetsGeometry padding;

  ///suspension widget.
  final Widget suspensionWidget;

  ///is use real index data.(false: use INDEXDATADEF)
  final bool isUseRealIndex;

  ///item Height.
  final int itemHeight;

  ///suspension widget Height.
  final int suspensionHeight;

  ///on sus tag change callback.
  final ValueChanged<String> onSusTagChanged;

  final AzListHeader header;

  final IndexBarBuilder indexBarBuilder;

  final IndexHintBuilder indexHintBuilder;

  final bool showIndexHint;

  @override
  State<StatefulWidget> createState() {
    return AzListViewState();
  }
}

class AzListViewState extends State<AzListView> {
  Map<String, int> suspensionSectionMap = Map();
  List<SuspensionModel> cityList = List();
  List<String> indexTagList = List();
  bool isShowIndexBarHint = false;
  String indexBarHint = "";

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  void onIndexBarTouch(AzIndexBarDetails model) {
    setState(() {
      indexBarHint = model.tag;
      isShowIndexBarHint = model.isTouchDown;
      int offset = suspensionSectionMap[model.tag];
      if (offset != null) {
        scrollController.jumpTo(offset.toDouble().clamp(.0, scrollController.position.maxScrollExtent));
      }
    });
  }

  void init() {
    cityList.clear();
    if (widget.topData != null && widget.topData.isNotEmpty) {
      cityList.addAll(widget.topData);
    }
    List<SuspensionModel> list = widget.data;
    if (list != null && list.isNotEmpty) {
//      SuspensionUtil.sortListBySuspensionTag(list);
      cityList.addAll(list);
    }

    SuspensionUtil.setShowSuspensionStatus(cityList);

    if (widget.header != null) {
      cityList.insert(0, Header()..tag = widget.header.tag);
    }
    indexTagList.clear();
    if (widget.isUseRealIndex) {
      indexTagList.addAll(SuspensionUtil.getTagIndexList(cityList));
    } else {
      indexTagList.addAll(AzIndexData);
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    List<Widget> children = <Widget>[
      Suspension(
        data: widget.header == null ? cityList : cityList.sublist(1),
        contentWidget: CustomListView(
            controller: scrollController,
            padding: widget.padding,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
            itemCount: cityList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0 && cityList[index] is Header) {
                return SizedBox(height: widget.header.height.toDouble(), child: widget.header.builder(context));
              }
              return widget.itemBuilder(context, cityList[index]);
            }),
        suspensionWidget: widget.suspensionWidget,
        controller: scrollController,
        suspensionHeight: widget.suspensionHeight ?? BaseUtils.getWidth(80, true),
        itemHeight: widget.itemHeight ?? BaseUtils.getHeight(40, true),
        onSusTagChanged: widget.onSusTagChanged,
        header: widget.header,
        onSusSectionInited: (Map<String, int> map) => suspensionSectionMap = map,
      )
    ];

    Widget indexBar;
    if (widget.indexBarBuilder == null) {
      indexBar = AzIndexBar(
        data: indexTagList,
        size: BaseUtils.getWidth(23, true),
        onTouch: onIndexBarTouch,
      );
    } else {
      indexBar = widget.indexBarBuilder(
        context,
        indexTagList,
        onIndexBarTouch,
      );
    }
    children.add(Align(
      alignment: Alignment.centerRight,
      child: indexBar,
    ));
    Widget indexHint;
    if (widget.indexHintBuilder != null) {
      indexHint = widget.indexHintBuilder(context, '$indexBarHint');
    } else {
      indexHint = Container(
        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        width: BaseUtils.getWidth(60),
        height: BaseUtils.getWidth(60),
        child: Text(
          '$indexBarHint',
          style: TextStyle(
            fontSize: 32.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (isShowIndexBarHint && widget.showIndexHint) {
      children.add(Center(
        child: indexHint,
      ));
    }

    return Stack(children: children);
  }
}
