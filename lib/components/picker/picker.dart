import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'date.dart';

part 'date_time.dart';

part 'multi_list_wheel.dart';

part 'multi_list.dart';

part 'single_list.dart';

part 'single_list_wheel.dart';

/// 返回 false 不关闭弹窗;
typedef PickerTapConfirmCallback<T> = bool Function(T? value);
typedef PickerTapCancelCallback<T> = bool Function(T? value);

const double kPickerDefaultHeight = 180;

const double kPickerDefaultItemWidth = 90;

class PickerOptions<T> {
  const PickerOptions({
    this.top,
    this.cancel,
    this.title,
    this.confirm,
    this.bottom,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.contentPadding,
    this.backgroundColor,
    this.background,
    this.decoration,
    this.verifyConfirm,
    this.verifyCancel,
  });

  /// 容器属性
  /// 整个Picker的背景色
  final Color? backgroundColor;

  /// 背景
  final Widget? background;

  /// [title]底部内容
  final Widget? bottom;

  /// bottom navigation bar
  final Widget? bottomNavigationBar;

  /// left
  final Widget? cancel;

  /// center
  final Widget? title;

  /// right
  final Widget? confirm;

  /// [title]顶部内容
  final Widget? top;

  final EdgeInsetsGeometry padding;

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

  PickerOptions<T> copyWith({
    Color? backgroundColor,
    Decoration? decoration,
    Widget? bottom,
    Widget? top,
    EdgeInsetsGeometry? padding,
    Widget? confirm,
    Widget? cancel,
    Widget? title,
    Widget? background,
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
          background: background ?? this.background,
          verifyConfirm: verifyConfirm ?? this.verifyConfirm,
          verifyCancel: verifyCancel ?? this.verifyCancel);

  PickerOptions<T> merge(PickerOptions<T>? options) => copyWith(
      decoration: options?.decoration,
      backgroundColor: options?.backgroundColor,
      top: options?.top,
      bottom: options?.bottom,
      padding: options?.padding,
      confirm: options?.confirm,
      cancel: options?.cancel,
      title: options?.title,
      background: options?.background,
      verifyConfirm: options?.verifyConfirm,
      verifyCancel: options?.verifyCancel);
}

typedef PickerPositionIndexChanged = void Function(List<int> index);

typedef PickerPositionValueChanged<T> = void Function(List<T> value);

abstract class PickerStatelessWidget<T> extends StatelessWidget {
  const PickerStatelessWidget(
      {super.key,
      required this.options,
      required this.wheelOptions,
      this.height = kPickerDefaultHeight,
      this.width = double.infinity,
      this.itemWidth});

  /// 头部和背景色配置
  final PickerOptions<T>? options;

  /// Wheel配置信息
  final WheelOptions? wheelOptions;

  /// height
  final double height;

  /// width
  final double width;

  /// wheel width
  final double? itemWidth;
}

abstract class PickerStatefulWidget<T> extends StatefulWidget {
  const PickerStatefulWidget(
      {super.key,
      required this.options,
      required this.wheelOptions,
      this.height = kPickerDefaultHeight,
      this.width = double.infinity,
      this.itemWidth});

  /// 头部和背景色配置
  final PickerOptions<T>? options;

  /// Wheel配置信息
  final WheelOptions? wheelOptions;

  /// height
  final double height;

  /// width
  final double width;

  /// wheel width
  final double? itemWidth;
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
    final List<Widget> column = [];
    if (options.top != null) column.add(options.top!);
    if (options.cancel != null ||
        options.title != null ||
        options.confirm != null) {
      column.add(Universal(
          direction: Axis.horizontal,
          padding: const EdgeInsets.all(10),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (options.cancel != null)
              options.cancel!.onTap(() {
                final T? value = cancelTap?.call();
                final bool isPop = options.verifyCancel?.call(value) ?? true;
                if (isPop) closePopup(value);
              }),
            if (options.title != null) options.title!.expandedNull,
            if (options.confirm != null)
              options.confirm!.onTap(() {
                final T? value = confirmTap?.call();
                final bool isPop = options.verifyConfirm?.call(value) ?? true;
                if (isPop) closePopup(value);
              }),
          ]));
    }
    if (options.bottom != null) column.add(options.bottom!);
    Widget content = child;
    if (options.background != null) {
      content = Stack(children: [
        Positioned(
            left: 0, bottom: 0, right: 0, top: 0, child: options.background!),
        content,
      ]);
    }
    if (options.contentPadding != null) {
      content = Padding(padding: options.contentPadding!, child: content);
    }
    column.add(content);
    if (options.bottomNavigationBar != null) {
      column.add(options.bottomNavigationBar!);
    }
    return Universal(
        decoration: options.decoration,
        padding: EdgeInsets.only(bottom: context.padding.bottom),
        mainAxisSize: MainAxisSize.min,
        color: options.backgroundColor,
        children: column);
  }
}

class _PickerListWheel extends ListWheel {
  _PickerListWheel({
    ValueChanged<int>? onChanged,
    required super.itemCount,
    required super.itemBuilder,
    required super.options,
    super.controller,
    super.onScrollEnd,
  }) : super.builder(onSelectedItemChanged: onChanged);
}

extension ExtensionCustomPicker on CustomPicker {
  Future<T?> show<T>({BottomSheetOptions? options}) =>
      popupBottomSheet<T?>(options: options);
}

class CustomPicker<T> extends PickerSubject<T> {
  const CustomPicker({
    super.key,
    required Widget content,

    /// 头部和背景色配置
    required PickerOptions<T> options,

    /// 自定义 确定 按钮 返回参数
    PickerSubjectTapCallback<T>? confirmTap,

    /// 自定义 取消 按钮 返回参数
    PickerSubjectTapCallback<T>? cancelTap,
  }) : super(
            confirmTap: confirmTap,
            cancelTap: cancelTap,
            options: options,
            child: content);
}
