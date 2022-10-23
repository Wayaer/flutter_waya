import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef ValueBuilderCallback<T> = Widget Function(
    BuildContext context, T? value, ValueCallback<T> updater);

/// Example:
/// ```
/// ValueBuilder<T>(
///   initialValue: T,
///   builder: (BuildContext context, bool value, ValueCallback<T> update) {
///
///   return (你需要局部刷新的组件)
///
///   }),
///   onUpdate: (value) => print("Value updated: $value"),
/// ),
/// ```
class ValueBuilder<T> extends StatefulWidget {
  const ValueBuilder({
    super.key,
    this.initialValue,
    this.initState,
    this.didChangeDependencies,
    required this.builder,
    this.didUpdateWidget,
    this.onUpdate,
    this.deactivate,
    this.dispose,
  });

  final T? initialValue;
  final ValueCallback<BuildContext>? initState;
  final ValueCallback<BuildContext>? didChangeDependencies;
  final ValueBuilderCallback<T> builder;
  final ValueCallback<BuildContext>? didUpdateWidget;
  final ValueCallback<T?>? onUpdate;
  final ValueCallback<BuildContext>? deactivate;
  final ValueCallback<BuildContext>? dispose;

  @override
  State<ValueBuilder<T>> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends State<ValueBuilder<T>> {
  T? value;

  @override
  void initState() {
    super.initState();
    widget.initState?.call(context);
    value = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value, updater);

  void updater(T? newValue) {
    if (mounted) {
      widget.onUpdate?.call(newValue);
      value = newValue;
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ValueBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context);
    if (widget.initialValue != null && widget.initialValue != value) {
      value = widget.initialValue;
      if (mounted) setState(() {});
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.deactivate?.call(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(context);
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).dispose();
    } else if (value is StreamController) {
      (value as StreamController<T>).close();
    }
  }
}

/// Example:
/// ```
///      ValueListenBuilder<bool>(
///         initialValue: false,
///         builder: (BuildContext context,
///             ValueNotifier<bool> valueListenable) {
///             /// 赋值即刷新
///             valueListenable.value = true;
///             return (你需要局部刷新的组件)
///          }),
/// ```

typedef ValueListenBuilderCallback<T> = Widget Function(
    BuildContext context, ValueNotifier<T?> valueListenable);

class ValueListenBuilder<T> extends StatefulWidget {
  const ValueListenBuilder({
    super.key,
    this.initialValue,
    this.initState,
    this.didChangeDependencies,
    required this.builder,
    this.didUpdateWidget,
    this.onUpdate,
    this.deactivate,
    this.dispose,
  });

  final T? initialValue;
  final ValueCallback<BuildContext>? initState;
  final ValueCallback<BuildContext>? didChangeDependencies;
  final ValueListenBuilderCallback<T> builder;
  final ValueCallback<BuildContext>? didUpdateWidget;
  final ValueCallback<T?>? onUpdate;
  final ValueCallback<BuildContext>? deactivate;
  final ValueCallback<BuildContext>? dispose;

  @override
  State<ValueListenBuilder<T>> createState() => _ValueListenBuilderState<T>();
}

class _ValueListenBuilderState<T> extends State<ValueListenBuilder<T>> {
  T? value;
  late ValueNotifier<T?> valueListenable;

  @override
  void initState() {
    super.initState();
    widget.initState?.call(context);
    valueListenable = ValueNotifier<T?>(widget.initialValue);
    value = valueListenable.value;
    valueListenable.addListener(_valueChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context);
  }

  @override
  void didUpdateWidget(ValueListenBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context);
    if (widget.initialValue != null && widget.initialValue != value) {
      valueListenable.value = widget.initialValue;
    }
  }

  void _valueChanged() {
    if (mounted) {
      value = valueListenable.value;
      widget.onUpdate?.call(value);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, valueListenable);

  @override
  void deactivate() {
    super.deactivate();
    widget.deactivate?.call(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(context);
    valueListenable.removeListener(_valueChanged);
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).dispose();
    } else if (value is StreamController) {
      (value as StreamController<T>).close();
    }
  }
}

typedef StatefulWidgetFunction = void Function(
    BuildContext context, StateSetter setState);

/// StatefulBuilder 扩展
class ExtendedStatefulBuilder extends StatefulWidget {
  const ExtendedStatefulBuilder({
    super.key,
    this.initState,
    this.didChangeDependencies,
    required this.builder,
    this.didUpdateWidget,
    this.deactivate,
    this.dispose,
  });

  final StatefulWidgetFunction? initState;
  final StatefulWidgetFunction? didChangeDependencies;
  final StatefulWidgetBuilder builder;
  final StatefulWidgetFunction? didUpdateWidget;
  final ValueCallback<BuildContext>? deactivate;
  final ValueCallback<BuildContext>? dispose;

  @override
  State<ExtendedStatefulBuilder> createState() =>
      _ExtendedStatefulBuilderState();
}

class _ExtendedStatefulBuilderState extends State<ExtendedStatefulBuilder> {
  @override
  void initState() {
    super.initState();
    widget.initState?.call(context, setState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context, setState);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void didUpdateWidget(covariant ExtendedStatefulBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context, setState);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.deactivate?.call(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(context);
  }
}

typedef CustomBuilderContext = Widget Function(BuildContext context);

enum BuilderState {
  /// 异步返回数据 为 null
  none,

  /// 等待中
  waiting,

  /// 异步有数据
  done,

  /// 异步错误
  error,
}

typedef CustomFutureBuilderDone<T> = Widget Function(
    BuildContext context, T data, Function() reset);

typedef CustomFutureBuilderNone = Widget Function(
    BuildContext context, Function() reset);

typedef CustomFutureBuilderError = Widget Function(
    BuildContext context, Object? error, Function() reset);

/// 自定义版 FutureBuilder
class CustomFutureBuilder<T> extends StatefulWidget {
  const CustomFutureBuilder({
    super.key,
    this.initialData,
    required this.future,
    required this.onDone,
    this.onNone,
    this.onWaiting,
    this.onError,
    this.didUpdateWidgetCallFuture = false,
    this.initialCallFuture = false,
    this.initState,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.deactivate,
    this.dispose,
  });

  /// 初始化数据
  final T? initialData;

  /// 异步方法
  final Future<T> Function() future;

  /// 没有数据时 为 null UI回调
  final CustomFutureBuilderNone? onNone;

  /// 等待异步执行 UI回调
  final CustomBuilderContext? onWaiting;

  /// 异步错误时或者返回值为null时 UI回调
  final CustomFutureBuilderError? onError;

  /// 完成时 UI回调 异步返回的数据一定不为null
  final CustomFutureBuilderDone<T> onDone;

  /// 父组件update时 是否重新执行异步请求 默认为false
  final bool didUpdateWidgetCallFuture;

  /// 当 [initialData] !=null 时第一次渲染是否执行异步请求  默认为false
  final bool initialCallFuture;

  final ValueCallback<BuildContext>? initState;
  final ValueCallback<BuildContext>? didChangeDependencies;
  final ValueCallback<BuildContext>? didUpdateWidget;
  final ValueCallback<BuildContext>? deactivate;
  final ValueCallback<BuildContext>? dispose;

  @override
  State<CustomFutureBuilder<T>> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomFutureBuilder<T>> {
  BuilderState state = BuilderState.none;
  T? data;
  Object? _error;

  @override
  void initState() {
    super.initState();
    widget.initState?.call(context);
    if (widget.initialData != null) {
      state = BuilderState.done;
      data = widget.initialData as T;
    }
    if (widget.initialData == null || widget.initialCallFuture) {
      addPostFrameCallback((duration) => _subscribe());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context);
  }

  void _subscribe() {
    state = BuilderState.waiting;
    if (mounted && widget.onWaiting != null) setState(() {});
    widget.future.call().then((value) {
      state = BuilderState.done;
      data = value;
      if (mounted) setState(() {});
    }, onError: (Object error, StackTrace stackTrace) {
      state = BuilderState.error;
      _error = error;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BuilderState.none:
        if (widget.onNone != null) {
          return widget.onNone!.call(context, _subscribe);
        }
        break;
      case BuilderState.waiting:
        if (widget.onWaiting != null) {
          return widget.onWaiting!.call(context);
        }
        break;
      case BuilderState.error:
        if (widget.onError != null) {
          return widget.onError!.call(context, _error, _subscribe);
        }
        break;
      case BuilderState.done:
        return widget.onDone.call(context, data as T, _subscribe);
    }
    return const SizedBox();
  }

  @override
  void didUpdateWidget(covariant CustomFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context);
    if (widget.didUpdateWidgetCallFuture) _subscribe();
  }

  @override
  void deactivate() {
    widget.deactivate?.call(context);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.dispose?.call(context);
    super.dispose();
  }
}

typedef CustomStreamBuilderDone<T> = Widget Function(
    BuildContext context, T data);

typedef CustomStreamBuilderError = Widget Function(
    BuildContext context, Object? error);

/// 自定义版 StreamBuilder
class CustomStreamBuilder<T> extends StatefulWidget {
  const CustomStreamBuilder({
    super.key,
    this.initialData,
    required this.stream,
    required this.onDone,
    this.onNone,
    this.onWaiting,
    this.onError,
    this.didUpdateWidgetCallStream = false,
    this.initialCallStream = false,
    this.initState,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.deactivate,
    this.dispose,
  });

  /// 初始化数据
  final T? initialData;

  /// 异步方法
  final Stream<T> stream;

  /// 没有数据时 为 null UI回调
  final CustomBuilderContext? onNone;

  /// 等待异步执行 UI回调
  final CustomBuilderContext? onWaiting;

  /// 异步错误时或者返回值为null时 UI回调
  final CustomStreamBuilderError? onError;

  /// 完成时 UI回调 异步返回的数据一定不为null
  final CustomStreamBuilderDone<T> onDone;

  /// 父组件update时 是否重新执行异步请求 默认为false
  final bool didUpdateWidgetCallStream;

  /// 当 [initialData] !=null 时第一次渲染是否执行异步请求  默认为false
  final bool initialCallStream;

  final ValueCallback<BuildContext>? initState;
  final ValueCallback<BuildContext>? didChangeDependencies;
  final ValueCallback<BuildContext>? didUpdateWidget;
  final ValueCallback<BuildContext>? deactivate;
  final ValueCallback<BuildContext>? dispose;

  @override
  State<CustomStreamBuilder<T>> createState() => _CustomStreamBuilderState<T>();
}

class _CustomStreamBuilderState<T> extends State<CustomStreamBuilder<T>> {
  BuilderState state = BuilderState.none;
  StreamSubscription<T>? _subscription;
  T? data;
  Object? _error;

  @override
  void initState() {
    super.initState();
    widget.initState?.call(context);
    if (widget.initialData != null) {
      state = BuilderState.done;
      data = widget.initialData as T;
    }
    if (widget.initialData == null || widget.initialCallStream) {
      addPostFrameCallback((duration) => _subscribe());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context);
  }

  void _subscribe() {
    state = BuilderState.waiting;
    if (mounted && widget.onWaiting != null) setState(() {});
    _subscription = widget.stream.listen((T value) {
      if (value != null) {
        state = BuilderState.done;
        data = value;
      }
      if (mounted) setState(() {});
    }, onError: (Object error, StackTrace stackTrace) {
      state = BuilderState.error;
      _error = error;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BuilderState.none:
        if (widget.onNone != null) {
          return widget.onNone!.call(context);
        }
        break;
      case BuilderState.waiting:
        if (widget.onWaiting != null) {
          return widget.onWaiting!.call(context);
        }
        break;
      case BuilderState.error:
        if (widget.onError != null) {
          return widget.onError!.call(context, _error);
        }
        break;
      case BuilderState.done:
        return widget.onDone.call(context, data as T);
    }
    return const SizedBox();
  }

  @override
  void didUpdateWidget(covariant CustomStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context);
    if (widget.didUpdateWidgetCallStream) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void deactivate() {
    widget.deactivate?.call(context);
    super.deactivate();
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    widget.dispose?.call(context);
    super.dispose();
  }
}

typedef AsyncSnapshotBuilder<T> = Widget Function(BuildContext context, T data);

/// 扩展 FutureBuilder
class ExtendedFutureBuilder<T> extends FutureBuilder {
  ExtendedFutureBuilder({
    super.key,
    super.initialData,
    super.future,

    /// [ConnectionState.none] 显示的内容
    AsyncSnapshotBuilder<T>? onNone,

    /// [ConnectionState.waiting] 显示的内容
    AsyncSnapshotBuilder<T>? onWaiting,

    /// [ConnectionState.active] 显示的内容
    AsyncSnapshotBuilder<T>? onActive,

    /// [ConnectionState.done] 显示的内容
    AsyncSnapshotBuilder<T>? onDone,

    /// [error] 显示的内容
    AsyncSnapshotBuilder<Object?>? onError,
  }) : super(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return onError?.call(context, snapshot.error) ?? const SizedBox();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return onNone?.call(context, snapshot.data) ?? const SizedBox();
            case ConnectionState.waiting:
              return onWaiting?.call(context, snapshot.data) ??
                  const SizedBox();
            case ConnectionState.active:
              return onActive?.call(context, snapshot.data) ?? const SizedBox();
            case ConnectionState.done:
              return onDone?.call(context, snapshot.data) ?? const SizedBox();
          }
        });
}

/// 扩展 StreamBuilder
class ExtendedStreamBuilder<T> extends StreamBuilder {
  ExtendedStreamBuilder({
    super.key,
    super.initialData,
    super.stream,

    /// [ConnectionState.none] 显示的内容
    AsyncSnapshotBuilder<T>? onNone,

    /// [ConnectionState.waiting] 显示的内容
    AsyncSnapshotBuilder<T>? onWaiting,

    /// [ConnectionState.active] 显示的内容
    AsyncSnapshotBuilder<T>? onActive,

    /// [ConnectionState.done] 显示的内容
    AsyncSnapshotBuilder<T>? onDone,

    /// [error] 显示的内容
    AsyncSnapshotBuilder<Object?>? onError,
  }) : super(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return onError?.call(context, snapshot.error) ?? const SizedBox();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return onNone?.call(context, snapshot.data) ?? const SizedBox();
            case ConnectionState.waiting:
              return onWaiting?.call(context, snapshot.data) ??
                  const SizedBox();
            case ConnectionState.active:
              return onActive?.call(context, snapshot.data) ?? const SizedBox();
            case ConnectionState.done:
              return onDone?.call(context, snapshot.data) ?? const SizedBox();
          }
        });
}
