import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

/// IndexBar touch callback IndexModel.
typedef void IndexBarTouchCallback(AzIndexBarDetails model);

/// IndexModel.
class AzIndexBarDetails {
  String tag; //current touch tag.
  int position; //current touch position.
  bool isTouchDown; //is touch down.

  AzIndexBarDetails({this.tag, this.position, this.isTouchDown});
}

///Default Index data.
const List<String> AzIndexData = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

/// Base IndexBar.
class AzIndexBar extends StatefulWidget {
  /// index data.
  final List<String> data;

  /// IndexBar width(def:30).
  final int size;

  /// IndexBar item height(def:16).
//  final int itemHeight;
  final Color onTouchColor;
  final Color color;

  /// IndexBar text style.
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  /// Item touch callback.
  final IndexBarTouchCallback onTouch;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius radius;
  final BorderRadius touchDownRadius;

  AzIndexBar({Key key,
    this.data = AzIndexData,
    @required this.onTouch,
    this.size = 23,
    this.textStyle,
    this.padding,
    this.margin,
    this.radius,
    this.touchDownRadius,
    this.color: Colors.white,
    this.onTouchColor: Colors.lightBlue,
    this.touchDownTextStyle})
      : assert(onTouch != null),
        assert(size >= 15),
        assert(size <= 24),
        super(key: key);

  @override
  AzIndexBarState createState() => AzIndexBarState();
}

class AzIndexBarState extends State<AzIndexBar> {
  List<int> indexSectionList = List();
  int widgetTop = -1;
  int lastIndex = 0;
  double radius = 60;
  bool widgetTopChange = false;
  AzIndexBarDetails indexModel = AzIndexBarDetails();

  /// get index.
  int getIndex(int offset) {
    for (int i = 0, length = indexSectionList.length; i < length - 1; i++) {
      int a = indexSectionList[i];
      int b = indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
    }
    return -1;
  }

  void init() {
    widgetTopChange = true;
    indexSectionList.clear();
    indexSectionList.add(0);
    int tempHeight = 0;
    widget.data?.forEach((value) {
      tempHeight = tempHeight + widget.size;
      indexSectionList.add(tempHeight);
    });
  }

  triggerTouchEvent() {
    if (widget.onTouch != null) {
      widget.onTouch(indexModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    List<Widget> children = List();
    widget.data.forEach((v) {
      children.add(Container(
        decoration: BoxDecoration(
            color: indexModel.isTouchDown == true && v == indexModel.tag
                ? widget.onTouchColor
                : widget.color,
            borderRadius:
            widget.touchDownRadius ?? BorderRadius.circular(radius)),
        alignment: Alignment.center,
        width: widget.size.toDouble(),
        height: widget.size.toDouble(),
        child: Text(v,
            textAlign: TextAlign.center,
            style: indexModel.isTouchDown == true && v == indexModel.tag
                ? widget.touchDownTextStyle
                : widget.textStyle),
      ));
    });

    return Container(
        padding: widget.padding,
        margin: EdgeInsets.only(right: WayUtils.getWidth(10)),
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.radius ?? BorderRadius.circular(radius)),
        child: GestureDetector(
          onVerticalDragDown: (DragDownDetails details) {
            if (widgetTop == -1 || widgetTopChange) {
              widgetTopChange = false;
              RenderBox box = context.findRenderObject();
              Offset topLeftPosition = box.localToGlobal(Offset.zero);
              widgetTop = topLeftPosition.dy.toInt();
            }
            int offset = details.globalPosition.dy.toInt() - widgetTop;
            int index = getIndex(offset);
            if (index != -1) {
              lastIndex = index;
              indexModel.position = index;
              indexModel.tag = widget.data[index];
              indexModel.isTouchDown = true;
              triggerTouchEvent();
            }
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            int offset = details.globalPosition.dy.toInt() - widgetTop;
            int index = getIndex(offset);
            if (index != -1 && lastIndex != index) {
              lastIndex = index;
              indexModel.position = index;
              indexModel.tag = widget.data[index];
              indexModel.isTouchDown = true;
              triggerTouchEvent();
            }
          },
          onVerticalDragEnd: (DragEndDetails details) {
            indexModel.isTouchDown = false;
            triggerTouchEvent();
          },
          onTapUp: (TapUpDetails details) {
            indexModel.isTouchDown = false;
            triggerTouchEvent();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ));
  }
}
