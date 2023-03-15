import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'date_time.dart';

part 'multi_column.dart';

part 'multi_list.dart';

part 'single_column.dart';

/// 返回 false 不关闭弹窗;
typedef PickerTapConfirmCallback<T> = bool Function(T? value);
typedef PickerTapCancelCallback<T> = bool Function(T? value);

const double kPickerDefaultHeight = 180;
const double kPickerDefaultWidth = 90;

class PickerOptions<T> {
  const PickerOptions({
    this.top,
    this.bottom,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.contentPadding,
    this.confirm = const BText('confirm'),
    this.cancel = const BText('cancel'),
    this.backgroundColor,
    this.decoration,
    this.verifyConfirm,
    this.verifyCancel,
  });

  /// 容器属性
  /// 整个Picker的背景色
  final Color? backgroundColor;

  /// [title]底部内容
  final Widget? bottom;

  /// [title]顶部内容
  final Widget? top;
  final EdgeInsetsGeometry padding;

  /// right
  final Widget confirm;

  /// left
  final Widget cancel;

  /// center
  final Widget? title;

  /// 对内容
  final EdgeInsetsGeometry? contentPadding;

  /// 点击 [confirm] 后校验 [confirmTap] 数据，
  /// 返回 false 不关闭弹窗 默认 为 true;
  final PickerTapConfirmCallback<T>? verifyConfirm;

  /// 点击 [cancel] 后校验 [cancelTap] 数据，
  /// 返回 false 不关闭弹窗 默认 为 true;
  final PickerTapCancelCallback<T>? verifyCancel;

  /// Decoration
  final Decoration? decoration;

  PickerOptions copyWith({
    Color? backgroundColor,
    Decoration? decoration,
    Widget? bottom,
    Widget? top,
    EdgeInsetsGeometry? padding,
    Widget? confirm,
    Widget? cancel,
    Widget? title,
    PickerTapConfirmCallback<T>? verifyConfirm,
    PickerTapCancelCallback<T>? verifyCancel,
  }) =>
      PickerOptions<T>(
          decoration: decoration ?? this.decoration,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          bottom: bottom ?? this.bottom,
          top: top ?? this.top,
          padding: padding ?? this.padding,
          title: title ?? this.title,
          confirm: confirm ?? this.confirm,
          cancel: cancel ?? this.cancel,
          verifyConfirm: verifyConfirm ?? this.verifyConfirm,
          verifyCancel: verifyCancel ?? this.verifyCancel);

  PickerOptions merge(PickerOptions? options) => copyWith(
      decoration: options?.decoration,
      backgroundColor: options?.backgroundColor,
      top: options?.top,
      bottom: options?.bottom,
      padding: options?.padding,
      confirm: options?.confirm,
      cancel: options?.cancel,
      title: options?.title,
      verifyConfirm: options?.verifyConfirm,
      verifyCancel: options?.verifyCancel);
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

    /// physics
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
  final PickerOptions<T>? options;

  /// Wheel配置信息
  final PickerWheelOptions wheelOptions;
}

abstract class PickerStatefulWidget<T> extends StatefulWidget {
  const PickerStatefulWidget(
      {super.key, required this.options, required this.wheelOptions});

  /// 头部和背景色配置
  final PickerOptions<T>? options;

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
            final bool isPop = options.verifyCancel?.call(value) ?? true;
            if (isPop) closePopup(value);
          }),
          if (options.title != null) options.title!.expandedNull,
          options.confirm.onTap(() {
            final T? value = confirmTap?.call();
            final bool isPop = options.verifyConfirm?.call(value) ?? true;
            if (isPop) closePopup(value);
          }),
        ]));
    if (options.bottom != null) column.add(options.bottom!);
    column.add(options.contentPadding == null
        ? child
        : child.padding(options.contentPadding!));
    return Universal(
        onTap: () {},
        decoration: options.decoration,
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
    super.itemBuilder,
    super.onScrollEnd,
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

extension ExtensionCustomPicker on CustomPicker {
  Future<T?> show<T>({BottomSheetOptions? options}) =>
      popupBottomSheet<T?>(options: options);
}

class CustomPicker<T> extends PickerSubject<T> {
  CustomPicker({
    super.key,
    required Widget content,

    /// 自定义 确定 按钮 返回参数
    PickerSubjectTapCallback<T>? confirmTap,

    /// 自定义 取消 按钮 返回参数
    PickerSubjectTapCallback<T>? cancelTap,

    /// 头部和背景色配置
    PickerOptions<T>? options,
  }) : super(
            confirmTap: confirmTap,
            cancelTap: cancelTap,
            options: options ?? PickerOptions<T>(),
            child: content);
}
