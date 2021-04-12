import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_waya/constant/constant.dart';

typedef ValueBuilderCallback<T> = Widget Function(
    BuildContext context, T? value, ValueCallback<T> updater);

/// Example:
/// ```
///  ValueBuilder<bool>(
///    initialValue: false,
///    builder: (BuildContext context, bool value, ValueCallback<bool> update) {
///
///    return (你需要局部刷新的组件)
///
///    }),
///    onUpdate: (value) => print("Value updated: $value"),
///  ),
///  ```
class ValueBuilder<T> extends StatefulWidget {
  const ValueBuilder({
    Key? key,
    this.initialValue,
    this.onDispose,
    this.onUpdate,
    required this.builder,
  }) : super(key: key);

  final T? initialValue;
  final ValueBuilderCallback<T> builder;
  final void Function()? onDispose;
  final void Function(T)? onUpdate;

  @override
  _ValueBuilderState<T> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends State<ValueBuilder<T>> {
  T? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value, updater);

  void updater(T newValue) {
    if (widget.onUpdate != null) widget.onUpdate!(newValue);
    value = newValue;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) widget.onDispose!.call();
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).dispose();
    } else if (value is StreamController) {
      (value as StreamController<T>).close();
    }
    value = null;
  }
}

/// Example:
/// ```
///       ValueListenBuilder<bool>(
///          initialValue: false,
///          builder: (BuildContext context,
///              ValueNotifier<bool> valueListenable) {
///              /// 赋值即刷新
///              valueListenable.value = true;
///              return (你需要局部刷新的组件)
///           }),
///  ```

typedef ValueListenBuilderCallback<T> = Widget Function(
    BuildContext context, ValueNotifier<T?> valueListenable);

class ValueListenBuilder<T> extends StatefulWidget {
  const ValueListenBuilder({
    Key? key,
    required this.builder,
    this.initialValue,
  }) : super(key: key);
  final T? initialValue;
  final ValueListenBuilderCallback<T> builder;

  @override
  _ValueListenBuilderState<T> createState() => _ValueListenBuilderState<T>();
}

class _ValueListenBuilderState<T> extends State<ValueListenBuilder<T>> {
  late T? value;
  late ValueNotifier<T?> valueListenable;

  @override
  void initState() {
    super.initState();
    valueListenable = ValueNotifier<T?>(widget.initialValue);
    value = valueListenable.value;
    valueListenable.addListener(_valueChanged);
  }

  ///@override
  ///void didUpdateWidget(ValueListenBuilder<T> oldWidget) {
  ///  if (oldWidget.builder != widget.builder) {
  ///    oldWidget.valueListenable.removeListener(_valueChanged);
  ///    value = widget.valueListenable.value;
  ///    widget.valueListenable.addListener(_valueChanged);
  ///  }
  ///  super.didUpdateWidget(oldWidget);
  ///}

  @override
  void dispose() {
    valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    value = valueListenable.value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, valueListenable);
}
