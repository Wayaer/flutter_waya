import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef CheckboxStateWaitChanged = Future<bool?> Function(bool? value);

typedef CheckboxStateBuilder = Widget Function(
    bool? value, CheckboxStateChanged onChanged);

typedef CheckboxStateChanged = void Function(bool? value);

/// 官方版增加状态
class CheckboxState extends StatelessWidget {
  const CheckboxState(
      {super.key,
      required this.value,
      this.onChanged,
      this.onWaitChanged,
      this.initState,
      this.dispose,
      this.didChangeDependencies,
      this.didUpdateWidget,
      required this.builder});

  /// build [Checkbox]
  final CheckboxStateBuilder builder;

  ///  value
  final bool? value;

  /// onChanged
  final ValueChanged<bool?>? onChanged;

  /// onWaitChanged
  final CheckboxStateWaitChanged? onWaitChanged;

  /// initState
  final ValueCallback<BuildContext>? initState;

  /// dispose
  final ValueCallback<BuildContext>? dispose;

  /// didChangeDependencies
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// didUpdateWidget
  final ValueCallback<BuildContext>? didUpdateWidget;

  @override
  Widget build(BuildContext context) => ValueBuilder<bool?>(
      initialValue: value,
      initState: initState,
      dispose: dispose,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
      builder: (_, bool? value, Function updater) => builder(value, (bool? v) {
            onChanged?.call(v);
            if (onWaitChanged != null) {
              onWaitChanged!(v).then((result) {
                updater(result);
              });
            } else {
              updater(v);
            }
          }));
}

typedef CheckBoxStateBuilder = Widget Function(bool? value);

/// 自定义版
class CheckBox extends StatefulWidget {
  const CheckBox({
    super.key,
    this.value = false,
    required this.builder,
    this.useNull = false,
    this.onChanged,
    this.decoration,
    this.margin,
    this.padding,
  });

  /// 不同状态时 显示的组件
  final CheckBoxStateBuilder builder;

  /// bool 类型是否使用后null
  final bool useNull;

  /// 初始化值 默认为 false
  final bool? value;

  /// bool 值改变回调
  final ValueCallback<bool?>? onChanged;

  /// decoration
  final Decoration? decoration;

  /// margin
  final EdgeInsetsGeometry? margin;

  /// padding
  final EdgeInsetsGeometry? padding;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends ExtendedState<CheckBox> {
  bool? value = false;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      value = widget.value;
      setState(() {});
    }
  }

  void changeState() {
    if (widget.useNull) {
      if (value == null) {
        value = true;
      } else {
        value = value! ? false : null;
      }
    } else {
      value = !value!;
    }
    setState(() {});
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) => Universal(
      decoration: widget.decoration,
      margin: widget.margin,
      padding: widget.padding,
      onTap: changeState,
      child: widget.builder(value));
}
