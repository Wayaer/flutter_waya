import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

extension ExtensionWidget on Widget {
  Padding padding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);

  Center center() => Center(child: this);

  Expanded get expanded => Expanded(child: this);

  SizedBox get expand => SizedBox.expand(child: this);

  SizedBox get shrink => SizedBox.shrink(child: this);

  SizedBox fromSize(Size size) => SizedBox.fromSize(child: this, size: size);

  Flexible flexible({int flex, FlexFit fit = FlexFit.loose}) =>
      Flexible(child: this, flex: flex, fit: fit);

  GestureDetector gestureDetector({
    GestureTapCallback onTap,
    GestureTapCallback onDoubleTap,
    GestureLongPressCallback onLongPress,
    GestureLongPressStartCallback onLongPressStart,
    GestureLongPressEndCallback onLongPressEnd,
    GestureLongPressMoveUpdateCallback onLongPressMoveUpdate,
    GestureLongPressUpCallback onLongPressUp,
  }) =>
      GestureDetector(
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onLongPressUp: onLongPressUp);

  ConstrainedBox constrainedBox(BoxConstraints constraints) =>
      ConstrainedBox(constraints: constraints, child: this);

  Hero hero(
    Object tag, {
    CreateRectTween createRectTween,
    HeroFlightShuttleBuilder flightShuttleBuilder,
    HeroPlaceholderBuilder placeholderBuilder,
    bool transitionOnUserGestures = false,
  }) =>
      Hero(
          tag: tag,
          createRectTween: createRectTween,
          flightShuttleBuilder: flightShuttleBuilder,
          placeholderBuilder: placeholderBuilder,
          transitionOnUserGestures: transitionOnUserGestures,
          child: this);

  Container container({
    EdgeInsetsGeometry padding,
    Decoration foregroundDecoration,
    Matrix4 transform,
    BoxConstraints constraints,
    Color color,
    double width,
    double height,
    EdgeInsetsGeometry margin,
    Decoration decoration,
    Clip clipBehavior,
    AlignmentGeometry alignment,
  }) =>
      Container(
          foregroundDecoration: foregroundDecoration,
          clipBehavior: clipBehavior ?? Clip.none,
          transform: transform,
          constraints: constraints,
          alignment: alignment,
          color: decoration == null ? color : null,
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: decoration,
          child: this);
}

extension ExtensionFlex on Flex {
  Widget isScroll({
    bool noScrollBehavior = true,
    ScrollPhysics physics,
    ScrollController scrollController,
    bool reverse = false,
    bool primary,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) =>
      noScrollBehavior
          ? ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: SingleChildScrollView(
                  physics: physics,
                  reverse: reverse,
                  primary: primary,
                  dragStartBehavior: dragStartBehavior,
                  controller: scrollController,
                  scrollDirection: direction,
                  child: this))
          : SingleChildScrollView(
              physics: physics,
              reverse: reverse,
              primary: primary,
              dragStartBehavior: dragStartBehavior,
              controller: scrollController,
              scrollDirection: direction,
              child: this);
}
