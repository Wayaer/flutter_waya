import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef ValueBuilderCallback<T> = Widget Function(
    BuildContext context, T? value, ValueCallback<T> updater);

/// Example:
/// ```
///  ValueBuilder<T>(
///    initialValue: T,
///    builder: (BuildContext context, bool value, ValueCallback<T> update) {
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
  final VoidCallback? onDispose;
  final ValueCallback<T?>? onUpdate;

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

  void updater(T? newValue) {
    if (widget.onUpdate != null) widget.onUpdate!(newValue);
    value = newValue;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ValueBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != value) {
      value = widget.initialValue;
      setState(() {});
    }
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
    this.onDispose,
    this.onUpdate,
  }) : super(key: key);
  final T? initialValue;
  final ValueListenBuilderCallback<T> builder;
  final VoidCallback? onDispose;
  final ValueCallback<T?>? onUpdate;

  @override
  _ValueListenBuilderState<T> createState() => _ValueListenBuilderState<T>();
}

class _ValueListenBuilderState<T> extends State<ValueListenBuilder<T>> {
  T? value;
  late ValueNotifier<T?> valueListenable;

  @override
  void initState() {
    super.initState();
    valueListenable = ValueNotifier<T?>(widget.initialValue);
    value = valueListenable.value;
    valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(ValueListenBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != value) {
      valueListenable.value = widget.initialValue;
    }
  }

  void _valueChanged() {
    value = valueListenable.value;
    if (widget.onUpdate != null) widget.onUpdate!(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, valueListenable);

  @override
  void dispose() {
    valueListenable.removeListener(_valueChanged);
    super.dispose();
    if (widget.onDispose != null) widget.onDispose!.call();
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).dispose();
    } else if (value is StreamController) {
      (value as StreamController<T>).close();
    }
  }
}
