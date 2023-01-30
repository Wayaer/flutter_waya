import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

extension ExtensionNavigatorStateContext on BuildContext {
  /// [NavigatorState]
  NavigatorState get navigator => Navigator.of(this);

  /// [push]
  Future<T?> push<T extends Object?>(Route<T> route) => navigator.push(route);

  /// [pushNamed]
  Future<T?> pushNamed<T extends Object?>(String routeName,
          {Object? arguments}) =>
      navigator.pushNamed(routeName, arguments: arguments);

  /// [restorablePush]
  String restorablePush<T extends Object?>(
          RestorableRouteBuilder<T> routeBuilder,
          {Object? arguments}) =>
      navigator.restorablePush(routeBuilder, arguments: arguments);

  /// [restorablePushNamed]
  String restorablePushNamed<T extends Object?>(String routeName,
          {Object? arguments}) =>
      navigator.restorablePushNamed(routeName, arguments: arguments);

  /// [pushReplacement]
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
          Route<T> newRoute,
          {TO? result}) =>
      navigator.pushReplacement(newRoute, result: result);

  /// [pushReplacementNamed]
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      navigator.pushReplacementNamed<T, TO>(routeName,
          result: result, arguments: arguments);

  /// [restorablePushReplacement]
  String restorablePushReplacement<T extends Object?, TO extends Object?>(
          RestorableRouteBuilder<T> routeBuilder,
          {TO? result,
          Object? arguments}) =>
      navigator.restorablePushReplacement(routeBuilder,
          result: result, arguments: arguments);

  /// [restorablePushReplacementNamed]
  String restorablePushReplacementNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      navigator.restorablePushReplacementNamed(routeName,
          result: result, arguments: arguments);

  /// [pushAndRemoveUntil]
  Future<T?> pushAndRemoveUntil<T extends Object?>(
          Route<T> newRoute, RoutePredicate predicate) =>
      navigator.pushAndRemoveUntil(newRoute, predicate);

  /// [pushNamedAndRemoveUntil]
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
          String newRouteName, RoutePredicate predicate, {Object? arguments}) =>
      navigator.pushNamedAndRemoveUntil(newRouteName, predicate,
          arguments: arguments);

  /// [restorablePushNamedAndRemoveUntil]
  String restorablePushNamedAndRemoveUntil<T extends Object?>(
          String newRouteName, RoutePredicate predicate, {Object? arguments}) =>
      navigator.restorablePushNamedAndRemoveUntil(newRouteName, predicate,
          arguments: arguments);

  /// [popAndPushNamed]
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      navigator.popAndPushNamed(routeName,
          result: result, arguments: arguments);

  /// [restorablePopAndPushNamed]
  String restorablePopAndPushNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      navigator.restorablePopAndPushNamed(routeName,
          result: result, arguments: arguments);

  /// [restorableReplace]
  String restorableReplace<T extends Object?>(
          {required Route<dynamic> oldRoute,
          required RestorableRouteBuilder<T> newRouteBuilder,
          Object? arguments}) =>
      navigator.restorableReplace(
          oldRoute: oldRoute,
          newRouteBuilder: newRouteBuilder,
          arguments: arguments);

  /// [restorableReplaceRouteBelow]
  String restorableReplaceRouteBelow<T extends Object?>(
          {required Route<dynamic> anchorRoute,
          required RestorableRouteBuilder<T> newRouteBuilder,
          Object? arguments}) =>
      navigator.restorableReplaceRouteBelow(
          anchorRoute: anchorRoute,
          newRouteBuilder: newRouteBuilder,
          arguments: arguments);

  /// [pop]
  void pop<T extends Object?>([T? result]) => navigator.pop(result);

  /// [maybePop]
  Future<bool> maybePop<T extends Object?>([T? result]) => navigator.maybePop();

  /// [popUntil]
  void popUntil(RoutePredicate predicate) => navigator.popUntil(predicate);

  /// [removeRoute]
  void removeRoute(Route<dynamic> route) => navigator.removeRoute(route);

  /// [removeRouteBelow]
  void removeRouteBelow(Route<dynamic> route) =>
      navigator.removeRouteBelow(route);

  /// [canPop]
  bool canPop() => navigator.canPop();

  /// [userGestureInProgress]
  bool get userGestureInProgress => navigator.userGestureInProgress;

  /// [overlay]
  OverlayState? get overlay => navigator.overlay;
}

extension ExtensionFocusScopeContext on BuildContext {
  /// [FocusScope]
  FocusScopeNode get focusScope => FocusScope.of(this);

  FocusScopeNode get nearestScope => focusScope.nearestScope;

  bool get isFirstFocus => focusScope.isFirstFocus;

  bool get hasFocus => focusScope.hasFocus;

  bool get canRequestFocus => focusScope.canRequestFocus;

  bool get hasPrimaryFocus => focusScope.hasPrimaryFocus;

  FocusNode? get parent => focusScope.parent;

  /// focusNode==null  移出焦点 （可用于关闭键盘） focusNode！!= null 获取焦点
  void requestFocus([FocusNode? focusNode]) =>
      focusScope.requestFocus(focusNode ?? FocusNode());

  /// 自动获取焦点
  void autofocus([FocusNode? focusNode]) =>
      focusScope.autofocus(focusNode ?? FocusNode());

  bool nextFocus() => focusScope.nextFocus();

  bool previousFocus() => focusScope.previousFocus();

  bool focusInDirection(TraversalDirection direction) =>
      focusScope.focusInDirection(direction);

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      focusScope.unfocus(disposition: disposition);

  FocusAttachment attach(BuildContext? context,
          {FocusOnKeyEventCallback? onKeyEvent, FocusOnKeyCallback? onKey}) =>
      focusScope.attach(context, onKey: onKey, onKeyEvent: onKeyEvent);

  void addListener(VoidCallback listener) => focusScope.addListener(listener);

  void removeListener(VoidCallback listener) =>
      focusScope.removeListener(listener);

  void setFirstFocus(FocusScopeNode scope) => focusScope.setFirstFocus(scope);
}

extension ExtensionContext on BuildContext {
  /// Gives you the power to get a portion of the height.
  /// Useful for responsive applications.
  ///
  /// [dividedBy] is for when you want to have a portion of the value you
  /// would get like for example: if you want a value that represents a third
  /// of the screen you can set it to 3, and you will get a third of the height
  ///
  /// [reducedBy] is a percentage value of how much of the height you want
  /// if you for example want 46% of the height, then you reduce it by 56%.
  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) =>
      (mediaQuerySize.height - ((mediaQuerySize.height / 100) * reducedBy)) /
      dividedBy;

  /// Gives you the power to get a portion of the width.
  /// Useful for responsive applications.
  ///
  /// [dividedBy] is for when you want to have a portion of the value you
  /// would get like for example: if you want a value that represents a third
  /// of the screen you can set it to 3, and you will get a third of the width
  ///
  /// [reducedBy] is a percentage value of how much of the width you want
  /// if you for example want 46% of the width, then you reduce it by 56%.
  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) =>
      (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) /
      dividedBy;

  /// Divide the height proportionally by the given value
  double ratio(
          {double dividedBy = 1,
          double reducedByW = 0.0,
          double reducedByH = 0.0}) =>
      heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
      widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);

  /// similar to [MediaQuery.of(context).padding]
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode theme is enable
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// give access to Theme.of(context).iconTheme.color
  Color? get iconColor => theme.iconTheme.color;

  /// similar to [MediaQuery.of(context).padding]
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// similar to [MediaQuery.of(context).padding]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// similar to [MediaQuery.of(context).padding]
  EdgeInsets get mediaQueryPadding => mediaQuery.padding;

  /// similar to [MediaQuery.of(context).viewPadding]
  EdgeInsets get mediaQueryViewPadding => mediaQuery.viewPadding;

  /// similar to [MediaQuery.of(context).viewInsets]
  EdgeInsets get mediaQueryViewInsets => mediaQuery.viewInsets;

  /// similar to [MediaQuery.of(context).orientation]
  Orientation get orientation => mediaQuery.orientation;

  /// check if device is on landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// check if device is on portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// similar to [MediaQuery.of(this).devicePixelRatio]
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// similar to [MediaQuery.of(this).textScaleFactor]
  double get textScaleFactor => mediaQuery.textScaleFactor;

  /// get the shortestSide from screen
  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// True if width be larger than 800
  bool get showNavBar => width > 800;

  /// The same of [MediaQuery.of(context).size]
  Size get mediaQuerySize => mediaQuery.size;

  /// The same of [MediaQuery.of(context).size.height]
  /// Note: updates when you rezise your screen (like on a browser or
  /// desktop window)
  double get height => mediaQuerySize.height;

  /// The same of [MediaQuery.of(context).size.width]
  /// Note: updates when you rezise your screen (like on a browser or
  /// desktop window)
  double get width => mediaQuerySize.width;

  /// True if the shortestSide is smaller than 600p
  bool get isPhone => mediaQueryShortestSide < 600;

  /// True if the shortestSide is largest than 600p
  bool get isSmallTablet => mediaQueryShortestSide >= 600;

  /// True if the shortestSide is largest than 720p
  bool get isLargeTablet => mediaQueryShortestSide >= 720;

  /// True if the current device is Tablet
  bool get isTablet => isSmallTablet || isLargeTablet;

  /// get Widget Bounds (width, height, left, top, right, bottom and so on).Widgets must be rendered completely.
  /// 获取widget Rect
  Rect get getWidgetBounds {
    final RenderBox? box = getRenderBox;
    return box?.semanticBounds ?? Rect.zero;
  }

  RenderBox? get getRenderBox {
    final RenderObject? renderObject = findRenderObject();
    RenderBox? box;
    if (renderObject != null) box = renderObject as RenderBox;
    return box;
  }

  /// Get the coordinates of the widget on the screen.Widgets must be rendered completely.
  /// 获取widget在屏幕上的坐标,widget必须渲染完成
  Offset getWidgetLocalToGlobal(
      {Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null
        ? Offset.zero
        : box.localToGlobal(point, ancestor: ancestor);
  }

  /// Get the Rect of the widget on the screen.Widgets must be rendered completely.
  /// 获取widget在屏幕上的Rect,widget必须渲染完成
  Rect? getWidgetRectLocalToGlobal(
      {Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null
        ? null
        : box.localToGlobal(point, ancestor: ancestor) & box.size;
  }

  /// Get the coordinates of the widget on the screen.Widgets must be rendered completely.
  /// 获取widget在屏幕上的坐标,widget必须渲染完成
  Offset getWidgetGlobalToLocal(
      {Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null
        ? Offset.zero
        : box.globalToLocal(point, ancestor: ancestor);
  }

  /// Get the Rect of the widget on the screen.Widgets must be rendered completely.
  /// 获取widget在屏幕上的Rect,widget必须渲染完成
  Rect? getWidgetRectGlobalToLocal(
      {Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null
        ? null
        : box.globalToLocal(point, ancestor: ancestor) & box.size;
  }
}

extension ExtensionGlobalKey on GlobalKey {
  /// 截屏
  /// format 图片格式
  /// pixelRatio 截图分辨率比例
  Future<ByteData?> screenshots(
      {ui.ImageByteFormat? format, double? pixelRatio}) async {
    final RenderRepaintBoundary boundary =
        currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(
        pixelRatio: pixelRatio ?? ui.window.devicePixelRatio);
    final ByteData? byteData =
        await image.toByteData(format: format ?? ui.ImageByteFormat.rawRgba);

    /// Uint8List uint8list = byteData.buffer.asUint8List();
    return byteData;
  }
}
