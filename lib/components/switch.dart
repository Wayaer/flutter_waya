import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef SwitchStateWaitChanged = Future<bool> Function(bool value);

typedef SwitchStateBuilder = Widget Function(
    bool value, SwitchStateChanged onChanged);

typedef SwitchStateChanged = void Function(bool value);

/// 官方版增加状态
class SwitchState extends StatelessWidget {
  const SwitchState({
    super.key,
    required this.value,
    required this.builder,
    this.onChanged,
    this.initState,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.onWaitChanged,
  });

  final bool value;

  final SwitchStateBuilder builder;

  final ValueChanged<bool>? onChanged;

  final SwitchStateWaitChanged? onWaitChanged;

  /// initState
  final ValueCallback<BuildContext>? initState;

  /// dispose
  final ValueCallback<BuildContext>? dispose;

  /// didChangeDependencies
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// didUpdateWidget
  final ValueCallback<BuildContext>? didUpdateWidget;

  @override
  Widget build(BuildContext context) => ValueBuilder<bool>(
      initialValue: value,
      initState: initState,
      dispose: dispose,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
      builder: (_, bool? value, Function update) => builder(value!, (bool v) {
            onChanged?.call(v);
            if (onWaitChanged != null) {
              onWaitChanged!(v).then((result) => update(result));
            } else {
              update(v);
            }
          }));
}
