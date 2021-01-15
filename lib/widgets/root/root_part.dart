part of 'root.dart';

///  ************ 以下为Scaffold Overlay *****************   ///
class OverlayEntryAuto extends OverlayEntry {
  OverlayEntryAuto({
    WidgetBuilder builder,
    bool autoOff = false,
    Widget widget,
    bool opaque = false,
    bool maintainState = false,
  })  : autoOff = autoOff ?? false,
        super(
            builder: builder ?? (_) => widget,
            opaque: opaque ?? false,
            maintainState: maintainState ?? false);

  ///  是否自动关闭
  final bool autoOff;
}

///  自定义Overlay
OverlayEntryAuto showOverlay(Widget widget, {bool autoOff}) {
  if (_scaffoldKeyList.isEmpty) return null;
  _overlay ??=
      Overlay.of(_scaffoldKeyList?.last?.currentContext, rootOverlay: false);
  if (_overlay == null) return null;
  final OverlayEntryAuto entryAuto =
      OverlayEntryAuto(autoOff: autoOff ?? false, widget: widget);
  _overlay.insert(entryAuto);
  _overlayEntryList.add(entryAuto);
  return entryAuto;
}

///  关闭最顶层的Overlay
bool closeOverlay({OverlayEntryAuto entry}) {
  try {
    if (entry != null) {
      entry?.remove();
      if (_overlayEntryList.contains(entry))
        return _overlayEntryList?.remove(entry);
    } else {
      if (_overlayEntryList.isNotEmpty) {
        _overlayEntryList?.last?.remove();
        return _overlayEntryList?.remove(_overlayEntryList?.last);
      }
    }
  } catch (e) {
    log(e.toString());
  }
  return false;
}

///  关闭所有Overlay
void closeAllOverlay() {
  for (final OverlayEntryAuto element in _overlayEntryList) element?.remove();
  _overlayEntryList = <OverlayEntryAuto>[];
}

///  loading 加载框
///  关闭 closeOverlay();
OverlayEntryAuto showLoading({
  Widget custom,
  String text,
  double value,
  bool gaussian,
  Color backgroundColor,
  Animation<Color> valueColor,
  double strokeWidth,
  String semanticsLabel,
  String semanticsValue,
  LoadingType loadingType,
  TextStyle textStyle,
}) =>
    showOverlay(Loading(
        custom: custom,
        gaussian: gaussian,
        text: text,
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        strokeWidth: strokeWidth ?? 4.0,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        loadingType: loadingType ?? LoadingType.circular,
        textStyle: textStyle));

///  Toast
Duration _duration = const Duration(milliseconds: 1300);

///  设置全局弹窗时间
void setToastDuration(Duration duration) => _duration = duration;

bool haveToast = false;

///  Toast
///  关闭 closeOverlay();
Future<void> showToast(String message,
    {Color backgroundColor,
    BoxDecoration boxDecoration,
    GestureTapCallback onTap,
    TextStyle textStyle,
    Duration closeDuration,

    ///  icon style
    ///  如果使用ToastType.custom  请设置 customIcon
    ToastType toastType,
    IconData customIcon,
    double size,
    double spacing,
    Axis direction}) async {
  if (haveToast) return;
  Widget toast;
  if (toastType != null) {
    IconData icon;
    switch (toastType) {
      case ToastType.success:
        icon = ConstIcon.success;
        break;
      case ToastType.fail:
        icon = ConstIcon.fail;
        break;
      case ToastType.info:
        icon = ConstIcon.info;
        break;
      case ToastType.warning:
        icon = ConstIcon.warning;
        break;
      case ToastType.smile:
        icon = ConstIcon.smile;
        break;
      case ToastType.custom:
        assert(customIcon != null);
        icon = customIcon ?? ConstIcon.success;
        break;
    }
    toast = IconBox(
        icon: icon,
        direction: direction ?? Axis.vertical,
        spacing: spacing ?? 10,
        size: size ?? 30,
        color: ConstColors.white,
        title: MergeText(message, color: ConstColors.white, maxLines: 4));
  } else {
    toast = MergeText(message, color: ConstColors.white, maxLines: 4);
  }

  final OverlayEntryAuto entry = showOverlay(
      PopupBase(
          ignoring: true,
          alignment: Alignment.center,
          child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 100),
              decoration: boxDecoration ??
                  BoxDecoration(
                      color: ConstColors.black90,
                      borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(10),
              child: toast)),
      autoOff: true);
  haveToast = true;
  Ts.timerTs(closeDuration ?? _duration, () {
    closeOverlay(entry: entry);
    haveToast = false;
  });
}

///  ************ 以下为push Popup *****************///

///  showGeneralDialog 去除context
///  添加popup进入方向属性
///  关闭 closePopup()
///  Dialog
Future<T> showDialogPopup<T>({
  ///  进入方向的距离
  double startOffset,

  ///  popup 进入的方向
  PopupFromType popupFromType,

  ///  这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
  ///  这个 Widget 就是显示在页面上的 dialog
  RoutePageBuilder pageBuilder,
  Widget widget,

  ///  是否可以点击背景关闭
  bool barrierDismissible,

  ///  语义化
  String barrierLabel,

  ///  背景颜色
  Color backgroundColor,

  ///  这个是从开始到完全显示的时间
  Duration transitionDuration,

  ///  路由显示和隐藏的过程,这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  RouteTransitionsBuilder transitionBuilder,
  bool useRootNavigator,
  RouteSettings routeSettings,
}) {
  assert(pageBuilder != null || widget != null);
  if (transitionBuilder == null && popupFromType != null) {
    transitionBuilder =
        (BuildContext context, Animation<double> animation, _, Widget child) {
      Offset translation = Offset(0, 1 - animation.value);
      switch (popupFromType) {
        case PopupFromType.fromLeft:
          translation = Offset(animation.value - 1, 0);
          break;
        case PopupFromType.fromRight:
          translation = Offset(1 - animation.value, 0);
          break;
        case PopupFromType.fromTop:
          translation = Offset(0, animation.value - 1);
          break;
        case PopupFromType.fromBottom:
          translation = Offset(0, 1 - animation.value);
          break;
      }
      return FractionalTranslation(translation: translation, child: child);
    };
  }
  return showGeneralDialog(
      context: _globalNavigatorKey.currentContext,
      pageBuilder: pageBuilder ??
          (BuildContext context, Animation<double> animation, _) => widget,
      barrierDismissible: barrierDismissible ?? true,
      barrierLabel: barrierLabel ?? '',
      barrierColor: backgroundColor ?? ConstColors.transparent,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 80),
      transitionBuilder: transitionBuilder,
      useRootNavigator: useRootNavigator ?? true,
      routeSettings: routeSettings);
}

///  showModalBottomSheet 去除context
///  关闭 closePopup()
Future<T> showBottomPopup<T>({
  WidgetBuilder builder,
  Widget widget,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior,
  Color barrierColor,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  assert(builder != null || widget != null);
  return showModalBottomSheet(
      context: _globalNavigatorKey.currentContext,
      builder: builder ?? (BuildContext context) => widget,
      backgroundColor: backgroundColor ?? ConstColors.transparent,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: false,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag);
}

///  showModalBottomSheet
///  关闭 closePopup()
///  全屏显示
Future<T> showBottomPagePopup<T>({
  WidgetBuilder builder,
  Widget widget,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior,
  Color barrierColor,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  assert(builder != null || widget != null);
  return showModalBottomSheet(
      context: _globalNavigatorKey.currentContext,
      builder: builder ?? (BuildContext context) => widget,
      backgroundColor: backgroundColor ?? ConstColors.transparent,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag);
}

///  showCupertinoModalPopup
///  关闭 closePopup()
///  全屏显示
Future<T> showCupertinoBottomPagePopup<T>(
    {WidgetBuilder builder,
    Widget widget,
    bool useRootNavigator = false,
    ImageFilter filter}) {
  assert(builder != null || widget != null);
  return showCupertinoModalPopup(
      context: _globalNavigatorKey.currentContext,
      builder: builder ?? (BuildContext context) => widget,
      filter: filter,
      useRootNavigator: useRootNavigator);
}

///  关闭 closePopup()
///  popup 确定和取消
///  Dialog
Future<T> dialogSureCancel<T>({
  @required Widget content,
  Widget sure,
  Widget cancel,

  ///  弹窗背景色
  Color backgroundColor,

  ///  高度不建议设置
  double height,
  double width,
  bool isDismissible = true,
  EdgeInsetsGeometry padding,

  ///  弹窗位置 默认居中
  AlignmentGeometry alignment,

  ///  弹窗 decoration
  Decoration decoration,

  ///  背景是否模糊
  bool gaussian,

  ///  是否使用Overlay
  bool isOverlay = false,

  ///  是否添加Material Widget 部分组件需要基于Material
  bool addMaterial,
}) {
  final PopupSureCancel widget = PopupSureCancel(
      backsideTap: () {
        if (isDismissible) isOverlay ? closeOverlay() : closePopup();
      },
      width: width,
      addMaterial: addMaterial,
      gaussian: gaussian,
      content: content,
      decoration: decoration,
      alignment: alignment,
      height: height,
      sure: sure,
      cancel: cancel,
      backgroundColor: backgroundColor,
      padding: padding);
  if (isOverlay ?? false) {
    showOverlay(widget);
    return null;
  }
  return showDialogPopup(widget: widget);
}

///  关闭弹窗
///  也可以通过 Navigator.of(context).pop()
void closePopup([dynamic value]) => pop(value);

///  日期选择器
///  关闭 closePopup()
Future<T> showDateTimePicker<T>({
  ///  选择框内单位文字样式
  TextStyle unitStyle,

  ///  开始时间
  DateTime startDate,

  ///  默认选中时间
  DateTime defaultDate,

  ///  结束时间
  DateTime endDate,

  ///  补全双位数
  bool dual,

  ///  是否显示单位
  bool showUnit,

  ///  单位设置
  DateTimePickerUnit unit,

  /// 头部和背景色配置
  PickerSub pickerSub,

  /// Wheel配置信息
  PickerWheel pickerWheel,
}) {
  Ts.focusNode(_globalNavigatorKey.currentContext);
  pickerSub ??= PickerSub();
  pickerSub?.cancelTap ??= () => closePopup();
  pickerSub?.sureTap ??= (String text) => closePopup(text);
  final Widget widget = DateTimePicker(
      pickerSub: pickerSub,
      pickerWheel: pickerWheel,
      startDate: startDate,
      endDate: endDate,
      defaultDate: defaultDate,
      dual: dual,
      showUnit: showUnit,
      unit: unit);
  return showBottomPopup(widget: widget);
}

///  地区选择器
///  关闭 closePopup()
Future<T> showAreaPicker<T>({
  /// 默认选择的省
  String defaultProvince,

  /// 默认选择的市
  String defaultCity,

  /// 默认选择的区
  String defaultDistrict,

  /// 头部和背景色配置
  PickerSub pickerSub,

  /// Wheel配置信息
  PickerWheel pickerWheel,
}) {
  Ts.focusNode(_globalNavigatorKey.currentContext);
  pickerSub ??= PickerSub();
  pickerSub?.cancelTap ??= () => closePopup();
  pickerSub?.sureTap ??= (String text) => closePopup(text);
  final Widget widget = AreaPicker(
      defaultProvince: defaultProvince,
      defaultCity: defaultCity,
      defaultDistrict: defaultDistrict,
      pickerSub: pickerSub,
      pickerWheel: pickerWheel);
  return showBottomPopup(widget: widget);
}

///  wheel 单列 取消确认 选择
///  关闭 closePopup()
Future<T> showMultipleChoicePicker<T>({
  ///  默认选中
  int initialIndex,
  ScrollPhysics physics,
  @required int itemCount,
  @required IndexedWidgetBuilder itemBuilder,

  /// 头部和背景色配置
  PickerSub pickerSub,

  /// Wheel配置信息
  PickerWheel pickerWheel,
}) {
  Ts.focusNode(_globalNavigatorKey.currentContext);
  pickerSub ??= PickerSub();
  pickerSub?.cancelTap ??= () => closePopup();
  pickerSub?.sureIndexTap ??= (int index) => closePopup(index);
  final Widget widget = MultipleChoicePicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      pickerSub: pickerSub,
      pickerWheel: pickerWheel,
      initialIndex: initialIndex);
  return showBottomPopup(widget: widget);
}

///  showCupertinoDialog
///  去除context 简化参数
///  关闭 closePopup()
Future<T> showSimpleCupertinoDialog<T>({
  WidgetBuilder builder,
  Widget widget,
  bool useRootNavigator = true,
  bool barrierDismissible = false,
  RouteSettings routeSettings,
}) {
  assert(builder != null || widget != null);
  return showCupertinoDialog(
      context: _globalNavigatorKey.currentContext,
      builder: builder ?? (BuildContext context) => widget,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings);
}

///  showDialog 去除context
///  关闭 closePopup()
///  Dialog
Future<T> showSimpleDialog<T>({
  WidgetBuilder builder,
  Widget widget,
  bool barrierDismissible = true,
  Color barrierColor,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
}) {
  assert(builder != null || widget != null);
  return showDialog(
      context: _globalNavigatorKey.currentContext,
      builder: builder ?? (BuildContext context) => widget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings);
}

///  showMenu 去除context
///  关闭 closePopup()
Future<T> showMenuPopup<T>({
  @required RelativeRect position,
  @required List<PopupMenuEntry<T>> items,
  T initialValue,
  double elevation,
  String semanticLabel,
  ShapeBorder shape,
  Color color,
  bool useRootNavigator = false,
}) {
  return showMenu(
      context: _globalNavigatorKey.currentContext,
      items: items,
      initialValue: initialValue,
      elevation: elevation,
      semanticLabel: semanticLabel,
      shape: shape,
      color: color,
      useRootNavigator: useRootNavigator,
      position: position);
}
