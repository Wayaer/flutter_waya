import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

extension ExtensionWidgetMethod on Widget {
  /// [push] or [pushReplacement]
  Future<T?> push<T extends Object?, TO extends Object?>(
      {bool maintainState = true,
      bool fullscreenDialog = false,
      RoutePushStyle pushStyle = RoutePushStyle.material,
      RouteSettings? settings,
      bool replacement = false,
      TO? result}) {
    if (replacement) {
      return pushReplacement(
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          pushStyle: pushStyle,
          result: result);
    } else {
      return GlobalOptions().globalNavigatorKey.currentState!.push(
          buildPageRoute(
              maintainState: maintainState,
              fullscreenDialog: fullscreenDialog,
              settings: settings,
              pushStyle: pushStyle));
    }
  }

  /// [pushReplacement]
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
          {bool maintainState = true,
          bool fullscreenDialog = false,
          RoutePushStyle pushStyle = RoutePushStyle.material,
          RouteSettings? settings,
          TO? result}) =>
      GlobalOptions().globalNavigatorKey.currentState!.pushReplacement(
          buildPageRoute(
              settings: settings,
              maintainState: maintainState,
              fullscreenDialog: fullscreenDialog,
              pushStyle: pushStyle),
          result: result);

  /// [pushAndRemoveUntil]
  Future<T?> pushAndRemoveUntil<T extends Object?>(
          {bool maintainState = true,
          bool fullscreenDialog = false,
          RoutePushStyle pushStyle = RoutePushStyle.material,
          RouteSettings? settings,
          RoutePredicate? predicate}) =>
      GlobalOptions().globalNavigatorKey.currentState!.pushAndRemoveUntil(
          buildPageRoute(
              settings: settings,
              maintainState: maintainState,
              fullscreenDialog: fullscreenDialog,
              pushStyle: pushStyle),
          predicate ?? (_) => false);

  /// [ExtendedOverlay().showOverlay()]
  ExtendedOverlayEntry? showOverlay({bool autoOff = false}) =>
      ExtendedOverlay().showOverlay(this, autoOff: autoOff);

  /// [ExtendedOverlay().showLoading(this)]
  ExtendedOverlayEntry? showLoading({ModalWindowsOptions? options}) =>
      Loading(custom: this, options: options).show();

  /// [showDialogPopup]
  Future<T?> showDialogPopup<T>({
    /// 这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
    RoutePageBuilder? builder,

    /// GeneralDialog 配置
    GeneralDialogOptions? options,
  }) {
    options = GlobalOptions().dialogOptions.merge(options);
    RouteTransitionsBuilder? transitionBuilder;
    if (options.fromStyle != PopupFromStyle.fromCenter) {
      transitionBuilder = options.transitionBuilder ??
          (__, Animation<double> animation, _, Widget child) {
            late Offset translation;
            switch (options!.fromStyle) {
              case PopupFromStyle.fromLeft:
                translation = Offset(animation.value - 1, 0);
                break;
              case PopupFromStyle.fromRight:
                translation = Offset(1 - animation.value, 0);
                break;
              case PopupFromStyle.fromTop:
                translation = Offset(0, animation.value - 1);
                break;
              case PopupFromStyle.fromBottom:
                translation = Offset(0, 1 - animation.value);
                break;
              case PopupFromStyle.fromCenter:
                translation = const Offset(0, 0);
                break;
            }
            return FractionalTranslation(
                translation: translation, child: child);
          };
    }
    return showGeneralDialog(
        context: GlobalOptions().globalNavigatorKey.currentContext!,
        pageBuilder: builder ?? (_, Animation<double> animation, __) => this,
        barrierDismissible: options.barrierDismissible,
        barrierLabel: options.barrierLabel,
        barrierColor: options.barrierColor,
        transitionDuration: options.transitionDuration,
        transitionBuilder: transitionBuilder,
        useRootNavigator: options.useRootNavigator,
        routeSettings: options.routeSettings);
  }

  /// showModalBottomSheet
  /// 关闭 closePopup()
  Future<T?> showBottomPopup<T>(
      {WidgetBuilder? builder, BottomSheetOptions? options}) {
    options = GlobalOptions().bottomSheetOptions.merge(options);
    return showModalBottomSheet(
        context: GlobalOptions().globalNavigatorKey.currentContext!,
        builder: builder ?? toWidgetBuilder,
        backgroundColor: options.backgroundColor,
        elevation: options.elevation,
        shape: options.shape,
        clipBehavior: options.clipBehavior,
        barrierColor: options.barrierColor,
        routeSettings: options.routeSettings,
        transitionAnimationController: options.transitionAnimationController,
        isScrollControlled: options.isScrollControlled,
        useRootNavigator: options.useRootNavigator,
        isDismissible: options.isDismissible,
        enableDrag: options.enableDrag);
  }

  /// showCupertinoModalPopup
  /// 关闭 closePopup()
  /// 全屏显示
  Future<T?> showCupertinoBottomPopup<T>({
    WidgetBuilder? builder,
    bool useRootNavigator = true,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) =>
      showCupertinoModalPopup(
          context: GlobalOptions().globalNavigatorKey.currentContext!,
          builder: builder ?? toWidgetBuilder,
          filter: filter,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          semanticsDismissible: semanticsDismissible,
          routeSettings: routeSettings,
          useRootNavigator: useRootNavigator);
}

extension ExtensionWidget on Widget {
  Widget get toSliverBox => SliverToBoxAdapter(child: this);

  SliverToBoxAdapter sliverToBoxAdapter({Key? key}) =>
      SliverToBoxAdapter(key: key, child: this);

  WidgetBuilder get toWidgetBuilder => (_) => this;

  RoutePageBuilder get toRoutePageBuilder =>
      (_, Animation<double> animation, Animation<double> secondaryAnimation) =>
          this;

  RouteTransitionsBuilder get toRouteTransitionsBuilder => (_,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      this;

  PageRoute<T> buildPageRoute<T>(
          {bool maintainState = true,
          bool fullscreenDialog = false,
          String? title,
          required RoutePushStyle pushStyle,
          RouteSettings? settings}) =>
      pushStyle.pageRoute(
          title: title,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          widget: this);

  BackdropFilter backdropFilter(
          {Key? key, ImageFilter? filter, double fuzzyDegree = 4}) =>
      BackdropFilter(
          key: key,
          filter: filter ??
              ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),
          child: this);

  FittedBox fittedBox(
          {Key? key,
          BoxFit fit = BoxFit.contain,
          AlignmentGeometry alignment = Alignment.center,
          Clip clipBehavior = Clip.none}) =>
      FittedBox(
          key: key,
          fit: fit,
          alignment: alignment,
          clipBehavior: clipBehavior,
          child: this);

  AnnotatedRegion<SystemUiOverlayStyle> statusBarStyle(
          SystemUiOverlayStyle style) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
          key: key, value: style, child: this);

  Padding padding(EdgeInsetsGeometry padding) =>
      Padding(key: key, padding: padding, child: this);

  Padding margin(EdgeInsetsGeometry margin, {Key? key}) =>
      Padding(key: key, padding: margin, child: this);

  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget paddingOnly(
          {double left = 0.0,
          double top = 0.0,
          double right = 0.0,
          double bottom = 0.0}) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget marginAll(double margin) =>
      Padding(padding: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget marginOnly(
          {double left = 0.0,
          double top = 0.0,
          double right = 0.0,
          double bottom = 0.0}) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  ColoredBox color(Color color, {Key? key}) =>
      ColoredBox(key: key, color: color, child: this);

  Card card({
    Color? color,
    Color? shadowColor,
    double? elevation,
    ShapeBorder? shape,
    bool? borderOnForeground,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool? semanticContainer,
  }) =>
      Card(
          color: color,
          shadowColor: shadowColor,
          elevation: elevation,
          shape: shape,
          borderOnForeground: borderOnForeground ?? true,
          margin: margin,
          clipBehavior: clipBehavior,
          semanticContainer: semanticContainer ?? true,
          child: this);

  Positioned positioned(
          {Key? key,
          double? left,
          double? top,
          double? right,
          double? bottom,
          double? width,
          double? height}) =>
      Positioned(
          key: key,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          width: width,
          height: height,
          child: this);

  Center center({Key? key, double? widthFactor, double? heightFactor}) =>
      Center(
          key: key,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: this);

  Expanded expanded({Key? key, int flex = 1}) =>
      Expanded(key: key, flex: flex, child: this);

  Expanded get expandedNull => Expanded(flex: 1, child: this);

  Flexible flexible({Key? key, int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(key: key, flex: flex, fit: fit, child: this);

  SizedBox sizedBox({Key? key, double? width, double? height}) =>
      SizedBox(key: key, width: width, height: height, child: this);

  SizedBox setWidth(double width, {Key? key}) =>
      SizedBox(key: key, width: width, child: this);

  SizedBox setHeight(double height, {Key? key}) =>
      SizedBox(key: key, height: height, child: this);

  SizedBox setSize(Size size, {Key? key}) =>
      SizedBox(key: key, height: size.height, width: size.width, child: this);

  SizedBox get expand => SizedBox.expand(child: this);

  SizedBox get shrink => SizedBox.shrink(child: this);

  SizedBox fromSize(Size size, {Key? key}) =>
      SizedBox.fromSize(key: key, size: size, child: this);

  ConstrainedBox constrainedBox(BoxConstraints constraints, {Key? key}) =>
      ConstrainedBox(key: key, constraints: constraints, child: this);

  Transform transform(
          {Key? key,
          required Matrix4 transform,
          Offset? origin,
          AlignmentGeometry? alignment,
          bool? transformHitTests}) =>
      Transform(
          key: key,
          transform: transform,
          origin: origin,
          alignment: alignment,
          transformHitTests: transformHitTests ?? true,
          child: this);

  Hero hero(
    Object tag, {
    Key? key,
    CreateRectTween? createRectTween,
    HeroFlightShuttleBuilder? flightShuttleBuilder,
    HeroPlaceholderBuilder? placeholderBuilder,
    bool transitionOnUserGestures = false,
  }) =>
      Hero(
          key: key,
          tag: tag,
          createRectTween: createRectTween,
          flightShuttleBuilder: flightShuttleBuilder,
          placeholderBuilder: placeholderBuilder,
          transitionOnUserGestures: transitionOnUserGestures,
          child: this);

  Container container({
    Key? key,
    EdgeInsetsGeometry? padding,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    BoxConstraints? constraints,
    Color? color,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    Clip? clipBehavior,
    AlignmentGeometry? alignment,
  }) =>
      Container(
          key: key,
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

  List<Widget> asList() => <Widget>[this];

  Align align(
          {Key? key,
          Alignment alignment = Alignment.center,
          double? widthFactor,
          double? heightFactor}) =>
      Align(
          key: key,
          alignment: alignment,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: this);

  ClipRRect clipRRect(
          {Key? key,
          BorderRadius borderRadius = BorderRadius.zero,
          CustomClipper<RRect>? clipper,
          Clip clipBehavior = Clip.antiAlias}) =>
      ClipRRect(
          key: key,
          borderRadius: borderRadius,
          clipper: clipper,
          clipBehavior: clipBehavior,
          child: this);

  ClipOval clipOval(
          {Key? key,
          BorderRadius borderRadius = BorderRadius.zero,
          CustomClipper<Rect>? clipper,
          Clip clipBehavior = Clip.antiAlias}) =>
      ClipOval(
          key: key, clipper: clipper, clipBehavior: clipBehavior, child: this);

  ClipPath clipPath(
          {Key? key,
          BorderRadius borderRadius = BorderRadius.zero,
          CustomClipper<Path>? clipper,
          Clip clipBehavior = Clip.antiAlias}) =>
      ClipPath(
          key: key, clipper: clipper, clipBehavior: clipBehavior, child: this);

  Offstage offstage(bool offstage, {Key? key}) =>
      Offstage(key: key, offstage: offstage, child: this);

  Visibility visibility(bool visible, {Key? key}) =>
      Visibility(key: key, visible: visible, child: this);

  LimitedBox limitedBox(
          {Key? key,
          double maxWidth = double.infinity,
          double maxHeight = double.infinity}) =>
      LimitedBox(
          key: key, maxWidth: maxWidth, maxHeight: maxHeight, child: this);

  OverflowBox overflowBox(
          {Key? key,
          Alignment alignment = Alignment.center,
          double? minWidth,
          double? maxWidth,
          double? minHeight,
          double? maxHeight}) =>
      OverflowBox(
          key: key,
          alignment: alignment,
          minWidth: minWidth,
          minHeight: minHeight,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          child: this);

  SizedOverflowBox sizedOverflowBox(Size size,
          {Key? key, Alignment alignment = Alignment.center}) =>
      SizedOverflowBox(key: key, size: size, alignment: alignment, child: this);

  DecoratedBox decoratedBox(Decoration decoration,
          {Key? key,
          DecorationPosition position = DecorationPosition.background}) =>
      DecoratedBox(
          key: key, decoration: decoration, position: position, child: this);

  RotatedBox rotatedBox(int quarterTurns, {Key? key}) =>
      RotatedBox(key: key, quarterTurns: quarterTurns, child: this);

  ConstrainedBox intoConstrainedBox(BoxConstraints constraints, {Key? key}) =>
      ConstrainedBox(key: key, constraints: constraints, child: this);

  UnconstrainedBox unconstrainedBox(
          {Key? key,
          TextDirection? textDirection,
          Alignment alignment = Alignment.center,
          Axis? constrainedAxis}) =>
      UnconstrainedBox(
          key: key,
          textDirection: textDirection,
          alignment: alignment,
          constrainedAxis: constrainedAxis,
          child: this);

  AnimatedAlign animatedAlign(Duration duration,
          {Key? key,
          Alignment alignment = Alignment.center,
          Curve curve = Curves.linear,
          VoidCallback? onEnd}) =>
      AnimatedAlign(
          key: key,
          alignment: alignment,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
          child: this);

  AnimatedPadding animatedPadding(
          {Key? key,
          Curve curve = Curves.linear,
          required Duration duration,
          required EdgeInsetsGeometry padding,
          VoidCallback? onEnd}) =>
      AnimatedPadding(
          key: key,
          padding: padding,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
          child: this);

  AnimatedContainer animatedContainer(Duration duration,
          {Key? key,
          Alignment? alignment,
          EdgeInsetsGeometry? padding,
          Color? color,
          Decoration? decoration,
          Decoration? foregroundDecoration,
          double? width,
          double? height,
          BoxConstraints? constraints,
          EdgeInsetsGeometry? margin,
          Matrix4? transform,
          Curve curve = Curves.linear,
          VoidCallback? onEnd}) =>
      AnimatedContainer(
          key: key,
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
          child: this);

  SingleChildScrollView singleChildScrollView(
          {Key? key,
          Axis scrollDirection = Axis.vertical,
          bool reverse = false,
          EdgeInsetsGeometry? padding,
          bool? primary,
          ScrollPhysics? physics,
          ScrollController? controller,
          DragStartBehavior dragStartBehavior = DragStartBehavior.start}) =>
      SingleChildScrollView(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          padding: padding,
          primary: primary,
          physics: physics,
          controller: controller,
          dragStartBehavior: dragStartBehavior,
          child: this);

  GestureDetector onTap(GestureTapCallback? onTap, {Key? key}) =>
      gestureDetector(onTap: onTap, key: key);

  GestureDetector onDoubleTap(GestureTapCallback onDoubleTap, {Key? key}) =>
      gestureDetector(onDoubleTap: onDoubleTap, key: key);

  GestureDetector onLongPress(GestureLongPressCallback onLongPress,
          {Key? key}) =>
      gestureDetector(onLongPress: onLongPress, key: key);

  GestureDetector gestureDetector(
          {Key? key,
          GestureTapDownCallback? onTapDown,
          GestureTapUpCallback? onTapUp,
          GestureTapCallback? onTap,
          GestureTapCancelCallback? onTapCancel,
          GestureTapDownCallback? onSecondaryTapDown,
          GestureTapUpCallback? onSecondaryTapUp,
          GestureTapCancelCallback? onSecondaryTapCancel,
          GestureTapCallback? onDoubleTap,
          GestureLongPressCallback? onLongPress,
          GestureLongPressStartCallback? onLongPressStart,
          GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
          GestureLongPressUpCallback? onLongPressUp,
          GestureLongPressEndCallback? onLongPressEnd,
          GestureDragDownCallback? onVerticalDragDown,
          GestureDragStartCallback? onVerticalDragStart,
          GestureDragUpdateCallback? onVerticalDragUpdate,
          GestureDragEndCallback? onVerticalDragEnd,
          GestureDragCancelCallback? onVerticalDragCancel,
          GestureDragDownCallback? onHorizontalDragDown,
          GestureDragStartCallback? onHorizontalDragStart,
          GestureDragUpdateCallback? onHorizontalDragUpdate,
          GestureDragEndCallback? onHorizontalDragEnd,
          GestureDragCancelCallback? onHorizontalDragCancel,
          GestureForcePressStartCallback? onForcePressStart,
          GestureForcePressPeakCallback? onForcePressPeak,
          GestureForcePressUpdateCallback? onForcePressUpdate,
          GestureForcePressEndCallback? onForcePressEnd,
          GestureDragDownCallback? onPanDown,
          GestureDragStartCallback? onPanStart,
          GestureDragUpdateCallback? onPanUpdate,
          GestureDragEndCallback? onPanEnd,
          GestureDragCancelCallback? onPanCancel,
          GestureScaleStartCallback? onScaleStart,
          GestureScaleUpdateCallback? onScaleUpdate,
          GestureScaleEndCallback? onScaleEnd,
          HitTestBehavior? behavior,
          bool excludeFromSemantics = false,
          DragStartBehavior dragStartBehavior = DragStartBehavior.start}) =>
      GestureDetector(
          key: key,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTap: onTap,
          onTapCancel: onTapCancel,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onSecondaryTapCancel: onSecondaryTapCancel,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onLongPressStart: onLongPressStart,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onLongPressUp: onLongPressUp,
          onLongPressEnd: onLongPressEnd,
          onVerticalDragDown: onVerticalDragDown,
          onVerticalDragStart: onVerticalDragStart,
          onVerticalDragUpdate: onVerticalDragUpdate,
          onVerticalDragEnd: onVerticalDragEnd,
          onVerticalDragCancel: onVerticalDragCancel,
          onHorizontalDragDown: onHorizontalDragDown,
          onHorizontalDragStart: onHorizontalDragStart,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onHorizontalDragEnd: onHorizontalDragEnd,
          onHorizontalDragCancel: onHorizontalDragCancel,
          onForcePressStart: onForcePressStart,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onForcePressEnd: onForcePressEnd,
          onPanDown: onPanDown,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          onPanCancel: onPanCancel,
          onScaleStart: onScaleStart,
          onScaleUpdate: onScaleUpdate,
          onScaleEnd: onScaleEnd,
          behavior: behavior,
          excludeFromSemantics: excludeFromSemantics,
          dragStartBehavior: dragStartBehavior,
          child: this);

  DecoratorEntry toDecoratorEntry({
    DecoratorPositioned positioned = DecoratorPositioned.outer,
    OverlayVisibilityMode mode = OverlayVisibilityMode.always,
  }) =>
      DecoratorEntry(widget: this, positioned: positioned, mode: mode);
}

extension ExtensionFlex on Flex {
  Widget isScroll({
    Key? key,
    bool noScrollBehavior = true,
    ScrollPhysics? physics,
    ScrollController? scrollController,
    bool reverse = false,
    bool? primary,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) =>
      noScrollBehavior
          ? ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: SingleChildScrollView(
                  key: key,
                  physics: physics ?? const BouncingScrollPhysics(),
                  reverse: reverse,
                  primary: primary,
                  dragStartBehavior: dragStartBehavior,
                  controller: scrollController,
                  scrollDirection: direction,
                  child: this))
          : SingleChildScrollView(
              key: key,
              physics: physics ?? const BouncingScrollPhysics(),
              reverse: reverse,
              primary: primary,
              dragStartBehavior: dragStartBehavior,
              controller: scrollController,
              scrollDirection: direction,
              child: this);
}
