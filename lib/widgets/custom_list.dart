import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class CustomList extends BoxScrollView {
  CustomList({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    this.gridDelegate,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount ?? children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.builder({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    this.gridDelegate,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(itemCount == null || itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        childrenDelegate = SliverChildBuilderDelegate(itemBuilder,
            childCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount ?? itemCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.separated({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required IndexedWidgetBuilder itemBuilder,
    @required IndexedWidgetBuilder separatorBuilder,
    @required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(itemBuilder != null),
        assert(separatorBuilder != null),
        assert(itemCount != null && itemCount >= 0),
        itemExtent = null,
        gridDelegate = null,
        childrenDelegate = SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          Widget widget;
          if (index.isEven) {
            widget = itemBuilder(context, itemIndex);
          } else {
            widget = separatorBuilder(context, itemIndex);
            assert(() {
              if (widget == null)
                throw FlutterError('separatorBuilder cannot return null.');
              return true;
            }());
          }
          return widget;
        },
            childCount: _computeActualChildCount(itemCount),
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: (Widget _, int index) =>
                index.isEven ? index ~/ 2 : null),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: itemCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  const CustomList.custom({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    this.gridDelegate,
    @required this.childrenDelegate,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(childrenDelegate != null),
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.count({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio),
        childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        itemExtent = null,
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount ?? children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  CustomList.extent({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required double maxCrossAxisExtent,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio),
        childrenDelegate = SliverChildListDelegate(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes),
        itemExtent = null,
        super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount ?? children.length,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  final double itemExtent;

  ///  SliverChildBuilderDelegate
  ///  SliverChildListDelegate
  final SliverChildDelegate childrenDelegate;

  /// SliverGridDelegateWithMaxCrossAxisExtent
  /// SliverGridDelegateWithFixedCrossAxisCount
  final SliverGridDelegate gridDelegate;

  @override
  Widget buildChildLayout(BuildContext context) {
    if (gridDelegate != null)
      return SliverGrid(delegate: childrenDelegate, gridDelegate: gridDelegate);
    if (itemExtent != null)
      return SliverFixedExtentList(
          delegate: childrenDelegate, itemExtent: itemExtent);
    return SliverList(delegate: childrenDelegate);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (itemExtent != null)
      properties
          .add(DoubleProperty('itemExtent', itemExtent, defaultValue: null));
  }

  static int _computeActualChildCount(int itemCount) =>
      math.max(0, itemCount * 2 - 1);
}
