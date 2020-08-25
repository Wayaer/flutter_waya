import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

///showPopup
Future<T> showPopup<T>({
  WidgetBuilder builder,
  bool barrierDismissible = true,
  Color barrierColor,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
  Widget child,
}) {
  return showDialog(
    context: globalNavigatorKey.currentContext,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    child: child,
  );
}

///showCupertinoDialog
Future<T> showCupertinoPopup<T>({
  @required WidgetBuilder builder,
  bool useRootNavigator = true,
  bool barrierDismissible = false,
  RouteSettings routeSettings,
}) {
  return showCupertinoDialog(
    context: globalNavigatorKey.currentContext,
    builder: builder,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    routeSettings: routeSettings,
  );
}

///showGeneralDialog
Future<T> showGeneralPopup<T>({
  ///这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
  ///这个 Widget 就是显示在页面上的 dialog
  @required RoutePageBuilder pageBuilder,

  ///是否可以点击背景关闭
  bool barrierDismissible,
  String barrierLabel,

  ///背景颜色
  Color barrierColor,

  ///这个是从开始到完全显示的时间
  Duration transitionDuration,

  ///路由显示和隐藏的过程,这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  RouteTransitionsBuilder transitionBuilder,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
}) {
  return showGeneralDialog(
    context: globalNavigatorKey.currentContext,
    pageBuilder: pageBuilder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

///showBottomSheet
PersistentBottomSheetController<T> showBottomPopup<T>({
  @required WidgetBuilder builder,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior,
}) {
  return showBottomSheet(
    context: globalNavigatorKey.currentContext,
    builder: builder,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
  );
}

///showModalBottomSheet
Future<T> showModalBottomPopup<T>({
  @required WidgetBuilder builder,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior,
  Color barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet(
    context: globalNavigatorKey.currentContext,
    builder: builder,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
  );
}

///showCupertinoModalPopup
Future<T> showModalPopup<T>({
  @required WidgetBuilder builder,
  ImageFilter filter,
  bool useRootNavigator = true,
  bool semanticsDismissible,
}) {
  return showCupertinoModalPopup(
    context: globalNavigatorKey.currentContext,
    builder: builder,
    filter: filter,
    useRootNavigator: useRootNavigator,
    semanticsDismissible: semanticsDismissible,
  );
}

///showMenu
Future<T> showMenuPopup<T>({
  @required RelativeRect position,
  @required List<PopupMenuEntry<T>> items,
  T initialValue,
  double elevation,
  String semanticLabel,
  ShapeBorder shape,
  Color color,
  bool captureInheritedThemes = true,
  bool useRootNavigator = false,
}) {
  return showMenu(
    context: globalNavigatorKey.currentContext,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    shape: shape,
    color: color,
    captureInheritedThemes: captureInheritedThemes,
    useRootNavigator: useRootNavigator,
    position: position,
  );
}

///showAboutDialog
showAboutPopup({
  String applicationName,
  String applicationVersion,
  Widget applicationIcon,
  String applicationLegalese,
  List<Widget> children,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
}) {
  showAboutDialog(
    context: globalNavigatorKey.currentContext,
    applicationName: applicationName,
    applicationVersion: applicationVersion,
    applicationIcon: applicationIcon,
    applicationLegalese: applicationLegalese,
    children: children,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

///showLicensePage
showLicensePopup({
  String applicationName,
  String applicationVersion,
  Widget applicationIcon,
  String applicationLegalese,
  bool useRootNavigator = false,
}) {
  showLicensePage(
    context: globalNavigatorKey.currentContext,
    applicationName: applicationName,
    applicationVersion: applicationVersion,
    applicationIcon: applicationIcon,
    applicationLegalese: applicationLegalese,
    useRootNavigator: useRootNavigator,
  );
}

Future<T> popupSureCancel<T>({
  @required List<Widget> children,
  GestureTapCallback sureTap,
  GestureTapCallback cancelTap,
  String cancelText,
  String sureText,
  Widget sure,
  Widget cancel,
  PopupMode popupMode,
  Color backgroundColor,
  TextStyle cancelTextStyle,
  TextStyle sureTextStyle,
  double height,
  bool isDismissible: true,
  EdgeInsetsGeometry padding,
  EdgeInsetsGeometry margin,
  AlignmentGeometry alignment,
  Decoration decoration,
  bool animatedOpacity,
  bool gaussian,
  double width,
  bool addMaterial, //是否添加Material Widget 部分组件需要基于Material
}) {
  var alert = PopupSureCancel(
    backsideTap: () {
      if (isDismissible) popupClose();
    },
    width: width,
    popupMode: popupMode,
    addMaterial: addMaterial,
    animatedOpacity: animatedOpacity,
    gaussian: gaussian,
    children: children,
    sureTap: sureTap ?? popupClose(),
    cancelTap: cancelTap ?? popupClose(),
    decoration: decoration,
    alignment: alignment,
    cancelText: cancelText,
    sureText: sureText,
    height: height,
    cancelTextStyle: cancelTextStyle,
    sureTextStyle: sureTextStyle,
    sure: sure,
    cancel: cancel,
    backgroundColor: backgroundColor,
    padding: padding,
    margin: margin,
  );
  return showGeneralPopup(
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) => alert);
}

popupClose() {
  NavigatorTools.getInstance().pop();
}

Future<T> popupWidget<T>({
  @required Widget child,
  double top,
  double left,
  double right,
  double bottom,
  Color color,
  GestureTapCallback onTap,
  bool addMaterial,
}) {
  var widget = PopupBase(
    child: child,
    top: top,
    left: left,
    right: right,
    bottom: bottom,
    color: color,
    onTap: onTap ?? () => popupClose(),
    addMaterial: addMaterial,
  );
  return showGeneralPopup(
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) => widget);
}

Future<T> showSimplePopup<T>(Widget widget) {
  return showCupertinoPopup(builder: (BuildContext context) => widget);
}

Future<T> showSimpleBottomPopup<T>(Widget widget) {
  return showModalBottomPopup(builder: (BuildContext context) => widget);
}
