part of 'root.dart';

/// ************ 以下为Scaffold Overlay *****************   ///
class ExtendedOverlayEntry extends OverlayEntry {
  ExtendedOverlayEntry({
    this.autoOff = false,
    WidgetBuilder? builder,
    Widget? widget,
    bool opaque = false,
    bool maintainState = false,
  })  : assert(builder != null || widget != null),
        super(
            builder: builder ?? (_) => widget!,
            opaque: opaque,
            maintainState: maintainState);

  /// 是否自动关闭
  final bool autoOff;

  bool removeEntry() {
    try {
      super.remove();
      if (!autoOff) _overlayEntryList.remove(this);
      if (scaffoldWillPop) scaffoldWillPop = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void remove() => removeEntry();
}

/// 自定义Overlay
ExtendedOverlayEntry? showOverlay(Widget widget, {bool autoOff = false}) {
  final OverlayState? _overlay = globalNavigatorKey.currentState!.overlay;
  if (_overlay == null) return null;
  final ExtendedOverlayEntry entryAuto =
      ExtendedOverlayEntry(autoOff: autoOff, widget: widget);
  _overlay.insert(entryAuto);
  if (!autoOff) _overlayEntryList.add(entryAuto);
  return entryAuto;
}

/// 关闭最顶层的Overlay
bool closeOverlay({ExtendedOverlayEntry? entry}) {
  if (entry != null) {
    return entry.removeEntry();
  } else {
    if (_overlayEntryList.isNotEmpty) {
      return _overlayEntryList.last.removeEntry();
    }
  }
  return false;
}

/// 关闭所有Overlay
void closeAllOverlay() {
  for (final ExtendedOverlayEntry element in _overlayEntryList) {
    element.removeEntry();
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    SnackBar snackBar) {
  if (globalScaffoldMessengerKey == null) {
    log('Please initialize globalScaffoldMessengerKey or ExtendedWidgetsApp widgetMode must be WidgetMode.material');
    return null;
  }
  return globalScaffoldMessengerKey!.currentState?.showSnackBar(snackBar);
}

/// loading 加载框
/// 关闭 closeOverlay();
ExtendedOverlayEntry? showLoading({
  Widget? custom,
  String text = '',
  TextStyle? textStyle,
  double? value,
  Color? backgroundColor,
  Animation<Color>? valueColor,
  double? strokeWidth,
  String? semanticsLabel,
  String? semanticsValue,
  LoadingType? loadingType,

  /// 背景点击事件
  GestureTapCallback? onTap,
  HitTestBehavior? behavior,

  /// 开启背景模糊
  bool gaussian = false,

  /// 背景模糊模糊程度 0-100 [gaussian]=true 有效
  double fuzzyDegree = 4,
}) =>
    showOverlay(Loading(
        custom: custom,
        gaussian: gaussian,
        onTap: onTap,
        behavior: behavior,
        text: text,
        value: value,
        fuzzyDegree: fuzzyDegree,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        strokeWidth: strokeWidth ?? 4.0,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        loadingType: loadingType ?? LoadingType.circular,
        textStyle: textStyle));

/// Toast
Duration _duration = const Duration(milliseconds: 1300);

/// 设置全局弹窗时间
void setToastDuration(Duration duration) => _duration = duration;

bool _haveToast = false;

/// Toast类型
/// 如果使用custom  请设置 customIcon
enum ToastType { success, fail, info, warning, smile, custom }

bool _allToastIgnoring = true;

AlignmentGeometry _allToastPositioned = Alignment.center;

/// 设置全局弹窗时间
void setToastPositioned(AlignmentGeometry positioned) =>
    _allToastPositioned = positioned;

/// 设置全局Toast 忽略背景点击事件
void setAllToastIgnoringBackground(bool value) => _allToastIgnoring = value;

/// Toast
/// 关闭 closeOverlay();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<void> showToast(String message,
    {Color? backgroundColor = const Color(0xCC000000),
    Color color = const Color(0xFFFFFFFF),
    BoxDecoration? boxDecoration,
    GestureTapCallback? onTap,
    TextStyle? textStyle,
    Duration? closeDuration,
    AlignmentGeometry? positioned,

    /// toast 是否忽略背景点击事件
    bool? ignoring,

    /// icon style
    /// 如果使用ToastType.custom  请设置 customIcon
    ToastType? toastType,
    IconData? customIcon,
    double? size,
    double? spacing,
    Axis? direction}) async {
  if (_haveToast) return;
  Widget toast = BText(message, color: color, maxLines: 4, fontSize: 14);
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
        color: color,
        title: toast);
  }

  final ExtendedOverlayEntry? entry = showOverlay(
      PopupOptions(
          ignoring: ignoring ?? _allToastIgnoring,
          alignment: positioned ?? _allToastPositioned,
          onTap: () {},
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              decoration: boxDecoration ??
                  BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(10),
              child: toast)),
      autoOff: true);
  _haveToast = true;
  await (closeDuration ?? _duration).delayed<dynamic>();
  closeOverlay(entry: entry);
  _haveToast = false;
}

/// ************ 以下为 Popup *****************///

/// showGeneralDialog 去除context
/// 添加popup进入方向属性
/// 关闭 [closePopup]
/// Dialog
enum PopupFromType {
  /// 从左边进入
  fromLeft,

  /// 从右边进入
  fromRight,

  /// 从头部进入
  fromTop,

  /// 从底部进入
  fromBottom,

  /// 默认渐变显示
  fromCenter,
}

Future<T?> showMenuPopup<T>({
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) =>
    showMenu(
        context: globalNavigatorKey.currentContext!,
        position: position,
        useRootNavigator: useRootNavigator,
        initialValue: initialValue,
        elevation: elevation,
        semanticLabel: semanticLabel,
        shape: shape,
        color: color,
        items: items);

Future<T?> showDialogPopup<T>({
  /// 这个参数是一个方法,入参是 context,animation,secondaryAnimation,返回一个 Widget
  RoutePageBuilder? builder,

  /// 这个 [widget] 就是显示在页面上的 dialog
  Widget? widget,

  /// GeneralDialog 配置
  GeneralDialogOptions? options,
}) {
  assert(builder != null || widget != null);
  options ??= GeneralDialogOptions();
  if (options.popupFromType != PopupFromType.fromCenter) {
    options.transitionBuilder ??=
        (__, Animation<double> animation, _, Widget child) {
      late Offset translation;
      switch (options!.popupFromType) {
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
        case PopupFromType.fromCenter:
          translation = const Offset(0, 0);
          break;
      }
      return FractionalTranslation(translation: translation, child: child);
    };
  }
  return showGeneralDialog(
      context: globalNavigatorKey.currentContext!,
      pageBuilder: builder ?? (_, Animation<double> animation, __) => widget!,
      barrierDismissible: options.barrierDismissible,
      barrierLabel: options.barrierLabel,
      barrierColor: options.barrierColor,
      transitionDuration: options.transitionDuration,
      transitionBuilder: options.transitionBuilder,
      useRootNavigator: options.useRootNavigator,
      routeSettings: options.routeSettings);
}

class GeneralDialogOptions {
  GeneralDialogOptions({
    this.startOffset,
    this.barrierLabel = '',
    this.barrierDismissible = true,
    this.transitionBuilder,
    this.routeSettings,
    this.barrierColor = const Color(0x80000000),
    this.transitionDuration = const Duration(milliseconds: 300),
    this.useRootNavigator = true,
    this.popupFromType = PopupFromType.fromCenter,
  });

  /// 进入方向的距离
  double? startOffset;

  /// popup 进入的方向
  PopupFromType popupFromType;

  /// 是否可以点击背景关闭 默认为 true 可关闭
  bool barrierDismissible;

  /// 语义化
  String barrierLabel;

  /// 背景颜色
  Color barrierColor;

  /// 这个是从开始到完全显示的时间
  Duration transitionDuration;

  /// 路由显示和隐藏的过程 这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  RouteTransitionsBuilder? transitionBuilder;

  bool useRootNavigator;

  RouteSettings? routeSettings;
}

/// showModalBottomSheet
/// 关闭 closePopup()
Future<T?> showBottomPopup<T>({
  WidgetBuilder? builder,
  Widget? widget,
  BottomSheetOptions? options,
}) {
  assert(builder != null || widget != null);
  options ??= BottomSheetOptions();
  return showModalBottomSheet(
      context: globalNavigatorKey.currentContext!,
      builder: builder ?? widget!.toWidgetBuilder,
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

class BottomSheetOptions {
  BottomSheetOptions({
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.barrierColor,
    this.routeSettings,
    this.transitionAnimationController,
    this.useRootNavigator = false,
    this.isDismissible = true,
    this.enableDrag = true,
    this.isScrollControlled = true,
  });

  /// 内容背景色
  Color? backgroundColor;

  double? elevation;

  ShapeBorder? shape;

  Clip? clipBehavior;

  /// 整个背景弹窗背景色 默认半透明灰
  Color? barrierColor;

  /// [isDismissible] = true 背景点击可关闭弹窗 默认 [true]
  bool isDismissible;

  /// 开启滑动关闭 默认[true]
  bool enableDrag;

  /// [isScrollControlled] = true 可全屏显示 默认 [true]
  bool isScrollControlled;

  RouteSettings? routeSettings;

  bool useRootNavigator;

  AnimationController? transitionAnimationController;
}

/// showCupertinoModalPopup
/// 关闭 closePopup()
/// 全屏显示
Future<T?> showCupertinoBottomPopup<T>({
  WidgetBuilder? builder,
  Widget? widget,
  bool useRootNavigator = true,
  ImageFilter? filter,
  Color barrierColor = kCupertinoModalBarrierColor,
  bool barrierDismissible = true,
  bool? semanticsDismissible,
  RouteSettings? routeSettings,
}) {
  assert(builder != null || widget != null);
  return showCupertinoModalPopup(
      context: globalNavigatorKey.currentContext!,
      builder: builder ?? (BuildContext context) => widget!,
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      semanticsDismissible: semanticsDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator);
}

/// 关闭 closePopup()
/// popup 确定和取消
/// Dialog
Future<T?>? showDialogSureCancel<T>({
  required Widget content,
  Widget? sure,
  Widget? cancel,

  /// 弹窗背景色
  Color? backgroundColor,

  /// 高度不建议设置
  double? height,
  double width = 300,
  bool isDismissible = true,
  EdgeInsetsGeometry? padding,

  /// 弹窗位置 默认居中
  AlignmentGeometry alignment = Alignment.center,

  /// 弹窗 decoration
  Decoration? decoration,

  /// 背景是否模糊
  bool gaussian = false,

  /// 是否使用Overlay
  bool isOverlay = false,

  /// 是否添加Material Widget 部分组件需要基于Material
  bool addMaterial = false,

  /// GeneralDialog 配置
  GeneralDialogOptions? options,
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
  if (isOverlay) {
    showOverlay(widget);
    return null;
  }
  options ??= GeneralDialogOptions(popupFromType: PopupFromType.fromCenter);
  return showDialogPopup(widget: widget, options: options);
}

/// 关闭弹窗
/// 也可以通过 Navigator.of(context).maybePop()
Future<bool> closePopup([dynamic value]) => maybePop(value);

/// 日期选择器
/// 关闭 closePopup()
Future<DateTime?> showDateTimePicker<T>({
  /// 选择框内单位文字样式
  TextStyle? unitStyle,

  /// 开始时间
  DateTime? startDate,

  /// 默认选中时间
  DateTime? defaultDate,

  /// 结束时间
  DateTime? endDate,

  /// 补全双位数
  bool dual = true,

  /// 是否显示单位
  bool showUnit = true,

  /// 单位设置
  DateTimePickerUnit unit = const DateTimePickerUnit(),

  /// 头部和背景色配置
  PickerOptions<DateTime>? options,

  /// Wheel配置信息
  PickerWheelOptions wheel = const PickerWheelOptions(),

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = DateTimePicker(
      options: options,
      wheel: wheel,
      unitStyle: unitStyle,
      startDate: startDate,
      endDate: endDate,
      defaultDate: defaultDate,
      dual: dual,
      showUnit: showUnit,
      unit: unit);
  return showBottomPopup<DateTime?>(
      widget: widget, options: bottomSheetOptions);
}

/// 地区选择器
/// 关闭 closePopup()
Future<String?> showAreaPicker<T>({
  /// 默认选择的省
  String? defaultProvince,

  /// 默认选择的市
  String? defaultCity,

  /// 默认选择的区
  String? defaultDistrict,

  /// 头部和背景色配置
  PickerOptions<String>? options,

  /// Wheel配置信息
  PickerWheelOptions wheel = const PickerWheelOptions(),

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = AreaPicker(
      defaultProvince: defaultProvince,
      defaultCity: defaultCity,
      defaultDistrict: defaultDistrict,
      options: options,
      wheel: wheel);
  return showBottomPopup<String?>(widget: widget, options: bottomSheetOptions);
}

/// wheel 单列 取消确认 选择
/// 关闭 closePopup()
Future<int?> showMultipleChoicePicker<T>({
  /// 默认选中
  int? initialIndex,
  required int itemCount,
  required IndexedWidgetBuilder itemBuilder,

  /// 头部和背景色配置
  PickerOptions<int>? options,

  /// Wheel配置信息
  PickerWheelOptions wheel = const PickerWheelOptions(),

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = MultipleChoicePicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      options: options,
      wheel: wheel,
      initialIndex: initialIndex);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

/// 取消 确认 选择
/// 关闭 closePopup()
Future<T?> showCustomPicker<T>({
  required Widget content,

  /// 自定义 确定 按钮 返回参数
  PickerSubjectTapCallback<T>? sureTap,

  /// 自定义 取消 按钮 返回参数
  PickerSubjectTapCallback<T?>? cancelTap,

  /// 头部和背景色配置
  PickerOptions<T?>? options,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  globalNavigatorKey.currentContext!.focusNode();
  options ??= PickerOptions<T?>();
  return showBottomPopup(
      options: bottomSheetOptions,
      widget: PickerSubject<T?>(
          sureTap: sureTap,
          cancelTap: cancelTap,
          options: options,
          child: content));
}
