import 'dart:async';

import 'package:flutter/widgets.dart';

typedef ValueBuilderUpdateCallback<T> = void Function(T snapshot);
typedef ValueBuilderBuilder<T> = Widget Function(
    T snapshot, ValueBuilderUpdateCallback<T> updater);

/// Manages a local state like ObxValue, but uses a callback instead of
/// a Rx value.
///
/// Example:
/// ```
///  ValueBuilder<bool>(
///    initialValue: false,
///    builder: (value, update) => Switch(
///    value: value,
///    onChanged: (flag) {
///       update( flag );
///    },),
///    onUpdate: (value) => print("Value updated: $value"),
///  ),
///  ```
class ValueBuilder<T> extends StatefulWidget {
  const ValueBuilder({
    Key key,
    this.initialValue,
    this.onDispose,
    this.onUpdate,
    @required this.builder,
  }) : super(key: key);

  final T initialValue;
  final ValueBuilderBuilder<T> builder;
  final void Function() onDispose;
  final void Function(T) onUpdate;

  @override
  _ValueBuilderState<T> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends State<ValueBuilder<T>> {
  T value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => widget.builder(value, updater);

  void updater(T newValue) {
    if (widget.onUpdate != null) widget.onUpdate(newValue);
    value = newValue;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget?.onDispose?.call();
    if (value is ChangeNotifier) {
      (value as ChangeNotifier)?.dispose();
    } else if (value is StreamController) {
      (value as StreamController<T>)?.close();
    }
    value = null;
  }
}
