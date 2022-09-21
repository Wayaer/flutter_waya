import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'area.dart';

part 'date_time.dart';

part 'multi_column.dart';

part 'single_column.dart';

/// 返回 false 不关闭弹窗;
typedef PickerTapSureCallback<T> = bool Function(T? value);
typedef PickerTapCancelCallback<T> = bool Function(T? value);

const double kPickerDefaultHeight = 180;
const double kPickerDefaultWidth = 90;

class PickerOptions<T> {
  PickerOptions({
    this.top,
    this.bottom,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.sure = const BText('sure'),
    this.cancel = const BText('cancel'),
    this.backgroundColor,
    this.contentStyle,
    PickerTapSureCallback<T>? sureTap,
    PickerTapCancelCallback<T>? cancelTap,
  })  : sureTap = sureTap ?? ((T? value) => true),
        cancelTap = cancelTap ?? ((T? value) => true);

  /// 容器属性
  /// 整个Picker的背景色
  Color? backgroundColor;

  /// [title]底部内容
  Widget? bottom;

  /// [title]顶部内容
  Widget? top;
  EdgeInsetsGeometry padding;

  /// right
  Widget sure;

  /// left
  Widget cancel;

  /// center
  Widget? title;

  /// 字体样式
  TextStyle? contentStyle;

  /// 确定点击事件 picker 关闭前，返回 false 不关闭弹窗
  /// 默认 为 true;
  PickerTapSureCallback<T> sureTap;

  /// 取消点击事件 picker 关闭前，返回 false 不关闭弹窗
  /// 默认 为 true;
  PickerTapCancelCallback<T> cancelTap;

  PickerOptions copyWith({
    Color? backgroundColor,
    Widget? bottom,
    Widget? top,
    EdgeInsetsGeometry? padding,
    Widget? sure,
    Widget? cancel,
    Widget? title,
    TextStyle? contentStyle,
    PickerTapSureCallback<T>? sureTap,
    PickerTapCancelCallback<T>? cancelTap,
  }) {
    if (backgroundColor != null) this.backgroundColor = backgroundColor;
    if (bottom != null) this.bottom = bottom;
    if (top != null) this.top = top;
    if (padding != null) this.padding = padding;
    if (sure != null) this.sure = sure;
    if (cancel != null) this.cancel = cancel;
    if (title != null) this.title = title;
    if (contentStyle != null) this.contentStyle = contentStyle;
    if (sureTap != null) this.sureTap = sureTap;
    if (cancelTap != null) this.cancelTap = cancelTap;
    return this;
  }

  PickerOptions merge(PickerOptions? options) => copyWith(
      backgroundColor: options?.backgroundColor,
      top: options?.top,
      bottom: options?.bottom,
      padding: options?.padding,
      sure: options?.sure,
      cancel: options?.cancel,
      title: options?.title,
      contentStyle: options?.contentStyle,
      sureTap: options?.sureTap,
      cancelTap: options?.cancelTap);
}

class PickerWheelOptions extends WheelOptions {
  const PickerWheelOptions({
    /// 高度
    super.itemExtent = 22,

    /// 半径大小,越大则越平面,越小则间距越大
    super.diameterRatio = 1.3,

    /// 选中item偏移
    super.offAxisFraction = 0,

    /// 表示ListWheel水平偏离中心的程度  范围[0,0.01]
    super.perspective = 0.01,

    /// 是否启用放大
    super.useMagnifier = true,

    /// 放大倍率
    super.magnification = 1.1,

    /// 上下间距默认为1 数越小 间距越大
    super.squeeze = 1,

    /// 使用ios Cupertino 风格
    super.isCupertino = true,

    /// [isCupertino]=true生效
    super.backgroundColor,
    super.physics = const FixedExtentScrollPhysics(),
    this.itemWidth,
  });

  /// 不设置 [itemWidth] 默认均分
  final double? itemWidth;

  @override
  PickerWheelOptions copyWith({
    double? itemExtent,
    double? diameterRatio,
    double? offAxisFraction,
    double? perspective,
    double? magnification,
    bool? useMagnifier,
    double? squeeze,
    bool? isCupertino,
    ScrollPhysics? physics,
    Color? backgroundColor,
    double? itemWidth,
    bool? looping,
    ValueChanged<int>? onChanged,
  }) =>
      PickerWheelOptions(
          diameterRatio: diameterRatio ?? this.diameterRatio,
          offAxisFraction: offAxisFraction ?? this.offAxisFraction,
          perspective: perspective ?? this.perspective,
          magnification: magnification ?? this.magnification,
          useMagnifier: useMagnifier ?? this.useMagnifier,
          squeeze: squeeze ?? this.squeeze,
          isCupertino: isCupertino ?? this.isCupertino,
          physics: physics ?? this.physics,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          itemWidth: itemWidth ?? this.itemWidth);
}

abstract class _PickerConfig<T> extends StatefulWidget {
  const _PickerConfig(
      {super.key, required this.options, required this.wheelOptions});

  final PickerOptions<T> options;
  final PickerWheelOptions wheelOptions;
}

typedef PickerSubjectTapCallback<T> = T Function();

class PickerSubject<T> extends StatelessWidget {
  const PickerSubject({
    super.key,
    required this.options,
    required this.child,
    required this.sureTap,
    this.cancelTap,
  });

  final PickerOptions<T> options;
  final Widget child;
  final PickerSubjectTapCallback<T>? sureTap;
  final PickerSubjectTapCallback<T>? cancelTap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> column = <Widget>[];
    if (options.top != null) column.add(options.top!);
    column.add(Universal(
        direction: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          options.cancel.onTap(() {
            final T? value = cancelTap?.call();
            final bool isPop = options.cancelTap.call(value);
            if (isPop) closePopup(value);
          }),
          if (options.title != null) options.title!.expandedNull,
          options.sure.onTap(() {
            final T? value = sureTap?.call();
            final bool isPop = options.sureTap.call(value);
            if (isPop) closePopup(value);
          }),
        ]));
    if (options.bottom != null) column.add(options.bottom!);
    column.add(child);
    return Universal(
        onTap: () {},
        padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
        mainAxisSize: MainAxisSize.min,
        color: options.backgroundColor,
        children: column);
  }
}

class _PickerListWheel extends ListWheel {
  _PickerListWheel({
    ValueChanged<int>? onChanged,
    required super.itemCount,
    required PickerWheelOptions wheel,
    super.controller,
    super.childDelegateType = ListWheelChildDelegateType.builder,
    super.children,
    super.itemBuilder,
    super.onScrollEnd,
  }) : super(
            options: WheelOptions(
                backgroundColor: wheel.backgroundColor,
                isCupertino: wheel.isCupertino,
                itemExtent: wheel.itemExtent,
                diameterRatio: wheel.diameterRatio,
                offAxisFraction: wheel.offAxisFraction,
                perspective: wheel.perspective,
                magnification: wheel.magnification,
                useMagnifier: wheel.useMagnifier,
                squeeze: wheel.squeeze,
                physics: wheel.physics,
                onChanged: onChanged));
}

class _PickerListStateWheel extends ListStateWheel {
  _PickerListStateWheel({
    ValueChanged<int>? onChanged,
    required super.itemCount,
    required PickerWheelOptions wheel,
    super.itemBuilder,
    super.onScrollEnd,
    super.initialItem = 0,
  }) : super(
            childDelegateType: ListWheelChildDelegateType.builder,
            options: WheelOptions(
                backgroundColor: wheel.backgroundColor,
                isCupertino: wheel.isCupertino,
                itemExtent: wheel.itemExtent,
                diameterRatio: wheel.diameterRatio,
                offAxisFraction: wheel.offAxisFraction,
                perspective: wheel.perspective,
                magnification: wheel.magnification,
                useMagnifier: wheel.useMagnifier,
                squeeze: wheel.squeeze,
                physics: wheel.physics,
                onChanged: onChanged));
}

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
  DateTimePickerUnit unit = const DateTimePickerUnit.all(),

  /// 头部和背景色配置
  PickerOptions<DateTime>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = DateTimePicker(
      options: options,
      wheelOptions: wheelOptions,
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
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = AreaPicker(
      defaultProvince: defaultProvince,
      defaultCity: defaultCity,
      defaultDistrict: defaultDistrict,
      options: options,
      wheelOptions: wheelOptions ?? GlobalOptions().pickerWheelOptions);
  return showBottomPopup<String?>(widget: widget, options: bottomSheetOptions);
}

/// wheel 单列 取消确认 选择
/// 关闭 closePopup()
Future<int?> showSingleColumnPicker<T>({
  /// 默认选中
  int initialIndex = 0,

  /// 渲染子组件
  required int itemCount,
  required IndexedWidgetBuilder itemBuilder,

  /// 头部和背景色配置
  PickerOptions<int>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = SingleColumnPicker(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      options: options,
      wheelOptions: wheelOptions,
      initialIndex: initialIndex);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

/// wheel 多列 取消 确认 选择 不联动
/// 关闭 closePopup()
Future<List<int>?> showMultiColumnPicker<T>({
  required List<PickerEntry> entry,

  /// 头部和背景色配置
  PickerOptions<List<int>>? options,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// 是否可以横向滚动
  /// [horizontalScroll]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [horizontalScroll]==false 使用[Row] 创建每个滚动，居中显示
  bool horizontalScroll = false,

  /// [horizontalScroll]==false
  bool addExpanded = true,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = MultiColumnPicker(
      horizontalScroll: horizontalScroll,
      addExpanded: addExpanded,
      entry: entry,
      options: options,
      wheelOptions: wheelOptions);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

/// wheel 多列 取消 确认 选择 联动
/// 关闭 closePopup()
Future<List<int>?> showMultiColumnLinkagePicker<T>({
  /// 头部和背景色配置
  PickerOptions<List<int>>? options,

  /// 要渲染的数据
  required List<PickerLinkageEntry> entry,

  /// 是否可以横向滚动
  /// [horizontalScroll]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [horizontalScroll]==false 使用[Row] 创建每个滚动，居中显示
  bool horizontalScroll = false,

  /// [horizontalScroll]==false
  bool addExpanded = true,

  /// Wheel配置信息
  PickerWheelOptions? wheelOptions,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = MultiColumnLinkagePicker(
      horizontalScroll: horizontalScroll,
      addExpanded: addExpanded,
      entry: entry,
      options: options,
      wheelOptions: wheelOptions);
  return showBottomPopup(widget: widget, options: bottomSheetOptions);
}

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
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  options ??= PickerOptions<T?>();
  return showBottomPopup(
      options: bottomSheetOptions,
      widget: PickerSubject<T?>(
          sureTap: sureTap,
          cancelTap: cancelTap,
          options: options,
          child: content));
}

/// 多选或单选 取消 确认 选择
/// 关闭 closePopup()
Future<List<int>?> showSingleListPicker<T>({
  /// 默认选中
  int initialIndex = 0,

  /// 渲染子组件
  required int itemCount,
  required SelectIndexedWidgetBuilder itemBuilder,

  /// 头部和背景色配置
  PickerOptions<List<int>>? options,

  /// BottomSheet 配置
  BottomSheetOptions? bottomSheetOptions,
  SingleListPickerOptions singleListPickerOptions =
      const SingleListPickerOptions(),
  SelectScrollListBuilder? listBuilder,
}) {
  GlobalOptions().globalNavigatorKey.currentContext!.focusNode();
  final Widget widget = SingleListPicker(
      listBuilder: listBuilder,
      singleListPickerOptions: singleListPickerOptions,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      options: options);
  final bottomSheet =
      GlobalOptions().bottomSheetOptions.copyWith(isScrollControlled: false);
  return showBottomPopup(widget: widget, options: bottomSheet);
}
