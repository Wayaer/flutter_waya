import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef CheckBoxStateBuilder = Widget Function(bool? value);

/// 自定义版
class CheckBox extends StatefulWidget {
  const CheckBox({
    super.key,
    this.value = false,
    required this.builder,
    this.tristate = false,
    this.onChanged,
    this.decoration,
    this.margin,
    this.padding,
  });

  /// 不同状态时 显示的组件
  final CheckBoxStateBuilder builder;

  /// bool 类型是否使用后null
  final bool tristate;

  /// 初始化值 默认为 false
  final bool? value;

  /// bool 值改变回调
  final ValueChanged<bool?>? onChanged;

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
      if (mounted) setState(() {});
    }
  }

  void changeState() {
    if (widget.tristate) {
      if (value == null) {
        value = true;
      } else {
        value = value! ? false : null;
      }
    } else {
      value = !value!;
    }
    if (mounted) setState(() {});
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: changeState,
      child: Container(
          decoration: widget.decoration,
          margin: widget.margin,
          padding: widget.padding,
          child: widget.builder(value)));
}
