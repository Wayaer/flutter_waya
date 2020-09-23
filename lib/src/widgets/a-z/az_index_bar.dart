import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// IndexBar touch callback IndexModel.
typedef IndexBarTouchCallback = void Function(AzIndexBarDetails model);

/// IndexModel.
class AzIndexBarDetails {
  AzIndexBarDetails({this.tag, this.position, this.isTouchDown});

  ///current touch tag.
  String tag;

  ///current touch position.
  int position;

  ///is touch down.
  bool isTouchDown;
}

///Default Index data.
const List<String> AzIndexData = <String>[
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '#'
];

/// Base IndexBar.
class AzIndexBar extends StatefulWidget {
  const AzIndexBar(
      {Key key,
      this.data = AzIndexData,
      @required this.onTouch,
      this.size = 23,
      this.textStyle,
      this.padding,
      this.margin,
      this.radius,
      this.touchDownRadius,
      this.color,
      this.onTouchColor,
      this.touchDownTextStyle})
      : assert(onTouch != null),
        assert(size >= 15),
        assert(size <= 24),
        super(key: key);

  /// index data.
  final List<String> data;

  /// IndexBar width(def:30).
  final int size;

  /// IndexBar item height(def:16).
  ///  final int itemHeight;
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

  @override
  _AzIndexBarState createState() => _AzIndexBarState();
}

class _AzIndexBarState extends State<AzIndexBar> {
  List<int> indexSectionList = <int>[];
  int widgetTop = -1;
  int lastIndex = 0;
  double radius = 60;
  bool widgetTopChange = false;
  AzIndexBarDetails indexModel = AzIndexBarDetails();
  Color color;
  Color onTouchColor;

  @override
  void initState() {
    super.initState();
    color = widget.color ?? getColors(white);
    onTouchColor = widget.onTouchColor ?? getColors(blue);
    init();
  }

  /// get index.
  int getIndex(int offset) {
    for (int i = 0, length = indexSectionList.length; i < length - 1; i++) {
      final int a = indexSectionList[i];
      final int b = indexSectionList[i + 1];
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
    widget.data?.forEach((String value) {
      tempHeight = tempHeight + widget.size;
      indexSectionList.add(tempHeight);
    });
  }

  void triggerTouchEvent() {
    if (widget.onTouch != null) widget.onTouch(indexModel);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    widget.data.forEach((String v) {
      children.add(Container(
        decoration: BoxDecoration(
            color: indexModel.isTouchDown == true && v == indexModel.tag ? onTouchColor : color,
            borderRadius: widget.touchDownRadius ?? BorderRadius.circular(radius)),
        alignment: Alignment.center,
        width: widget.size.toDouble(),
        height: widget.size.toDouble(),
        child: Text(v,
            textAlign: TextAlign.center,
            style:
                indexModel.isTouchDown == true && v == indexModel.tag ? widget.touchDownTextStyle : widget.textStyle),
      ));
    });

    return Container(
        padding: widget.padding,
        margin: EdgeInsets.only(right: getWidth(10)),
        decoration: BoxDecoration(color: color, borderRadius: widget.radius ?? BorderRadius.circular(radius)),
        child: GestureDetector(
          onVerticalDragDown: (DragDownDetails details) {
            if (widgetTop == -1 || widgetTopChange) {
              widgetTopChange = false;
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset topLeftPosition = box.localToGlobal(Offset.zero);
              widgetTop = topLeftPosition.dy.toInt();
            }
            final int offset = details.globalPosition.dy.toInt() - widgetTop;
            final int index = getIndex(offset);
            if (index != -1) {
              lastIndex = index;
              indexModel.position = index;
              indexModel.tag = widget.data[index];
              indexModel.isTouchDown = true;
              triggerTouchEvent();
            }
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            final int offset = details.globalPosition.dy.toInt() - widgetTop;
            final int index = getIndex(offset);
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
