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

///日期选择器
Future<T> showDateTimePicker<T>({
  ///背景色
  Color backgroundColor,

  ///头部
  Widget titleBottom,
  Widget title,

  ///头部右侧 确定
  Widget sure,

  ///头部左侧 取消
  Widget cancel,

  ///内容文字样式
  TextStyle contentStyle,

  ///选择框内单位文字样式
  TextStyle unitStyle,

  ///取消点击事件
  GestureTapCallback cancelTap,

  ///确认点击事件
  ValueChanged<String> sureTap,

  ///单个item的高度
  double itemHeight,

  ///单个item的宽度
  double itemWidth,

  ///整个弹框高度
  double height,

  ///开始时间
  DateTime startDate,

  ///默认选中时间
  DateTime defaultDate,

  ///结束时间
  DateTime endDate,

  ///补全双位数
  bool dual,

  ///是否显示单位
  bool showUnit,

  ///单位设置
  DateTimePickerUnit unit,

  /// 半径大小,越大则越平面,越小则间距越大
  double diameterRatio,

  /// 选中item偏移
  double offAxisFraction,

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  double perspective,

  ///放大倍率
  double magnification,

  ///是否启用放大镜
  bool useMagnifier,

  ///1或者2
  double squeeze,
  ScrollPhysics physics,
}) {
  Tools.closeKeyboard(globalNavigatorKey.currentContext);
  Widget widget = DateTimePicker(
      diameterRatio: diameterRatio,
      offAxisFraction: offAxisFraction,
      perspective: perspective,
      magnification: magnification,
      useMagnifier: useMagnifier,
      squeeze: squeeze,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      height: height,
      startDate: startDate,
      endDate: endDate,
      defaultDate: defaultDate,
      dual: dual,
      showUnit: showUnit,
      unit: unit,
      backgroundColor: backgroundColor,
      sure: sure,
      title: title,
      cancel: cancel,
      titleBottom: titleBottom,
      contentStyle: contentStyle,
      unitStyle: unitStyle,
      cancelTap: cancelTap ?? () => popupClose(),
      sureTap: sureTap ?? () => popupClose());
  return showModalBottomPopup(backgroundColor: Colors.transparent, builder: (BuildContext context) => widget);
}

///地区选择器
Future<T> showAreaPicker<T>({
  ///背景色
  Color backgroundColor,

  ///头部
  Widget titleBottom,
  Widget title,

  ///头部右侧 确定
  Widget sure,

  ///头部左侧 取消
  Widget cancel,

  ///内容文字样式
  TextStyle contentStyle,

  ///取消点击事件
  GestureTapCallback cancelTap,

  ///确认点击事件
  ValueChanged<String> sureTap,

  ///单个item的高度
  double itemHeight,

  ///单个item的宽度
  double itemWidth,

  ///整个弹框高度
  double height,

  /// 半径大小,越大则越平面,越小则间距越大
  double diameterRatio,

  /// 选中item偏移
  double offAxisFraction,

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  double perspective,

  ///放大倍率
  double magnification,

  ///是否启用放大镜
  bool useMagnifier,

  ///1或者2
  double squeeze,
  ScrollPhysics physics,
  String defaultProvince,
  String defaultCity,
  String defaultDistrict,
}) {
  Tools.closeKeyboard(globalNavigatorKey.currentContext);
  Widget widget = AreaPicker(
      defaultProvince: defaultProvince,
      defaultCity: defaultCity,
      defaultDistrict: defaultDistrict,
      diameterRatio: diameterRatio,
      offAxisFraction: offAxisFraction,
      perspective: perspective,
      magnification: magnification,
      useMagnifier: useMagnifier,
      squeeze: squeeze,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      height: height,
      backgroundColor: backgroundColor,
      sure: sure,
      title: title,
      cancel: cancel,
      titleBottom: titleBottom,
      contentStyle: contentStyle,
      cancelTap: cancelTap ?? () => popupClose(),
      sureTap: sureTap ?? () => popupClose());
  return showModalBottomPopup(backgroundColor: Colors.transparent, builder: (BuildContext context) => widget);
}

///wheel 单列 取消确认 选择
Future<T> showMultipleChoicePicker<T>({
  ///默认选中
  int initialIndex,

  ///背景色
  Color color,

  ///确认按钮
  Widget sure,

  ///取消按钮
  Widget cancel,

  ///头部文字
  Widget title,

  ///取消点击事件
  GestureTapCallback cancelTap,

  ///确认点击事件
  ValueChanged<int> sureTap,

  ///单个item的高度
  double itemHeight,

  ///单个item的宽度
  double itemWidth,

  ///整个弹框高度
  double height,

  /// 半径大小,越大则越平面,越小则间距越大
  double diameterRatio,

  /// 选中item偏移
  double offAxisFraction,

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  double perspective,

  ///放大倍率
  double magnification,

  ///是否启用放大镜
  bool useMagnifier,

  ///1或者2
  double squeeze,
  ScrollPhysics physics,
  @required int itemCount,
  @required IndexedWidgetBuilder itemBuilder,
}) {
  Tools.closeKeyboard(globalNavigatorKey.currentContext);
  Widget widget = MultipleChoicePicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      diameterRatio: diameterRatio,
      offAxisFraction: offAxisFraction,
      perspective: perspective,
      magnification: magnification,
      useMagnifier: useMagnifier,
      squeeze: squeeze,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      height: height,
      initialIndex: initialIndex,
      sure: sure,
      cancel: cancel,
      title: title,
      color: color,
      cancelTap: cancelTap ?? () => popupClose(),
      sureTap: sureTap ?? () => popupClose());
  return showModalBottomPopup(backgroundColor: Colors.transparent, builder: (BuildContext context) => widget);
}
