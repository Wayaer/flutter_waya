import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'area.dart';

part 'date_time.dart';

part 'multi_column.dart';

part 'single_column.dart';

/// 返回 false 不关闭弹窗;
typedef PickerTapConfirmCallback<T> = bool Function(T? value);
typedef PickerTapCancelCallback<T> = bool Function(T? value);

const double kPickerDefaultHeight = 180;
const double kPickerDefaultWidth = 90;

class PickerOptions<T> {
  PickerOptions({
    this.top,
    this.bottom,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.confirm = const BText('confirm'),
    this.cancel = const BText('cancel'),
    this.backgroundColor,
    this.contentStyle,
    PickerTapConfirmCallback<T>? confirmTap,
    PickerTapCancelCallback<T>? cancelTap,
  })  : confirmTap = confirmTap ?? ((T? value) => true),
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
  Widget confirm;

  /// left
  Widget cancel;

  /// center
  Widget? title;

  /// 字体样式
  TextStyle? contentStyle;

  /// 确定点击事件 picker 关闭前，返回 false 不关闭弹窗
  /// 默认 为 true;
  PickerTapConfirmCallback<T> confirmTap;

  /// 取消点击事件 picker 关闭前，返回 false 不关闭弹窗
  /// 默认 为 true;
  PickerTapCancelCallback<T> cancelTap;

  PickerOptions copyWith({
    Color? backgroundColor,
    Widget? bottom,
    Widget? top,
    EdgeInsetsGeometry? padding,
    Widget? confirm,
    Widget? cancel,
    Widget? title,
    TextStyle? contentStyle,
    PickerTapConfirmCallback<T>? confirmTap,
    PickerTapCancelCallback<T>? cancelTap,
  }) {
    if (backgroundColor != null) this.backgroundColor = backgroundColor;
    if (bottom != null) this.bottom = bottom;
    if (top != null) this.top = top;
    if (padding != null) this.padding = padding;
    if (confirm != null) this.confirm = confirm;
    if (cancel != null) this.cancel = cancel;
    if (title != null) this.title = title;
    if (contentStyle != null) this.contentStyle = contentStyle;
    if (confirmTap != null) this.confirmTap = confirmTap;
    if (cancelTap != null) this.cancelTap = cancelTap;
    return this;
  }

  PickerOptions merge(PickerOptions? options) => copyWith(
      backgroundColor: options?.backgroundColor,
      top: options?.top,
      bottom: options?.bottom,
      padding: options?.padding,
      confirm: options?.confirm,
      cancel: options?.cancel,
      title: options?.title,
      contentStyle: options?.contentStyle,
      confirmTap: options?.confirmTap,
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

  PickerWheelOptions mergePicker([PickerWheelOptions? options]) =>
      PickerWheelOptions(
          diameterRatio: options?.diameterRatio ?? diameterRatio,
          offAxisFraction: options?.offAxisFraction ?? offAxisFraction,
          perspective: options?.perspective ?? perspective,
          magnification: options?.magnification ?? magnification,
          useMagnifier: options?.useMagnifier ?? useMagnifier,
          squeeze: options?.squeeze ?? squeeze,
          isCupertino: options?.isCupertino ?? isCupertino,
          physics: options?.physics ?? physics,
          backgroundColor: options?.backgroundColor ?? backgroundColor,
          itemWidth: options?.itemWidth ?? itemWidth);
}

abstract class PickerStatelessWidget<T> extends StatelessWidget {
  const PickerStatelessWidget(
      {super.key, required this.options, required this.wheelOptions});

  /// 头部和背景色配置
  final PickerOptions<T> options;

  /// Wheel配置信息
  final PickerWheelOptions wheelOptions;
}

abstract class PickerStatefulWidget<T> extends StatefulWidget {
  const PickerStatefulWidget(
      {super.key, required this.options, required this.wheelOptions});

  /// 头部和背景色配置
  final PickerOptions<T> options;

  /// Wheel配置信息
  final PickerWheelOptions wheelOptions;
}

typedef PickerSubjectTapCallback<T> = T Function();

class PickerSubject<T> extends StatelessWidget {
  const PickerSubject({
    super.key,
    required this.options,
    required this.child,
    required this.confirmTap,
    this.cancelTap,
  });

  final PickerOptions<T> options;
  final Widget child;
  final PickerSubjectTapCallback<T>? confirmTap;
  final PickerSubjectTapCallback<T>? cancelTap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> column = <Widget>[];
    if (options.top != null) column.add(options.top!);
    column.add(Universal(
        direction: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          options.cancel.onTap(() {
            final T? value = cancelTap?.call();
            final bool isPop = options.cancelTap.call(value);
            if (isPop) closePopup(value);
          }),
          if (options.title != null) options.title!.expandedNull,
          options.confirm.onTap(() {
            final T? value = confirmTap?.call();
            final bool isPop = options.confirmTap.call(value);
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

class _PickerListWheelState extends ListWheelState {
  _PickerListWheelState({
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

extension ExtensionCustomPicker<T> on CustomPicker {
  Future<T?> show({BottomSheetOptions? options}) =>
      showBottomPopup<T?>(options: options);
}

class CustomPicker<T> extends PickerSubject {
  CustomPicker({
    super.key,
    required Widget content,

    /// 自定义 确定 按钮 返回参数
    PickerSubjectTapCallback<T>? confirmTap,

    /// 自定义 取消 按钮 返回参数
    PickerSubjectTapCallback<T?>? cancelTap,

    /// 头部和背景色配置
    PickerOptions<T?>? options,
  }) : super(
            confirmTap: confirmTap,
            cancelTap: cancelTap,
            options: options ?? PickerOptions<T?>(),
            child: content);
}
