import 'package:flutter/material.dart';

extension ExtensionWidgetDecoratorBox on Widget {
  DecoratorPendant<T> toDecoratorPendant<T>({
    DecoratorPendantPosition positioned = DecoratorPendantPosition.outer,
    bool maintainSize = false,
    bool? needFocus,
    bool? needEditing,
    DecoratorPendantValueCallback<T?>? needValue,
  }) =>
      DecoratorPendant<T>(
          child: this,
          maintainSize: maintainSize,
          positioned: positioned,
          needValue: needValue,
          needEditing: needEditing,
          needFocus: needFocus);

  DecoratorPendant<T> toDecoratorPendantBuilder<T>({
    DecoratorPendantPosition positioned = DecoratorPendantPosition.outer,
    bool maintainSize = false,
    bool? needFocus,
    bool? needEditing,
    DecoratorPendantValueCallback<T?>? needValue,
  }) =>
      DecoratorPendant<T>(
          builder: (_) => this,
          maintainSize: maintainSize,
          positioned: positioned,
          needValue: needValue,
          needEditing: needEditing,
          needFocus: needFocus);
}

enum DecoratorPendantPosition {
  /// 在 Border 内部
  inner,

  /// 在 Border 外部
  outer,
}

class DecoratorBoxStatus<T> {
  const DecoratorBoxStatus(
      {required this.hasFocus, required this.isEditing, this.value});

  /// 是否有焦点
  final bool hasFocus;

  /// 是否编辑中
  final bool isEditing;

  /// 数据
  final T? value;
}

typedef DecoratorBoxPendantBuilder<T> = Widget Function(
    DecoratorBoxStatus<T> status);

typedef DecoratorPendantValueCallback<T> = bool Function(T value);

/// Decorator Pendant
class DecoratorPendant<T> {
  const DecoratorPendant({
    this.child,
    this.builder,
    this.positioned = DecoratorPendantPosition.inner,
    this.maintainSize = false,
    this.needValue,
    this.needFocus,
    this.needEditing,
  }) : assert(child != null || builder != null);

  /// 显示的位置
  final DecoratorPendantPosition positioned;

  /// 保持占位
  final bool maintainSize;

  /// 要显示的 [builder] 会覆盖 [child]
  final DecoratorBoxPendantBuilder<T>? builder;

  /// 要显示的 widget
  final Widget? child;

  /// 是否需要编辑状态(输入框是否有内容)
  /// [needEditing] == nul 无需判断 是否编辑状态
  final bool? needEditing;

  /// 是否需要焦点
  /// [needFocus] == null 无需判断 是否有焦点
  final bool? needFocus;

  /// 是否需要值
  /// [onValue] == null 无需判断 值是否满足条件
  final DecoratorPendantValueCallback<T?>? needValue;
}

typedef DecoratorBoxDecorativeBuilder<T> = Widget Function(
    Widget child, DecoratorBoxStatus<T> status);

typedef DecoratorBoxStatusCallback = bool Function();

typedef DecoratorBoxStatusValueCallback<T> = T Function();

/// [Widget] 装饰器
class DecoratorBox<T> extends StatelessWidget {
  const DecoratorBox({
    super.key,
    required this.child,
    this.headers = const [],
    this.footers = const [],
    this.suffixes = const [],
    this.prefixes = const [],
    this.expanded = true,
    this.decoration,
    this.listenable,
    this.onFocus,
    this.onEditing,
    this.onValue,
  });

  final Widget child;

  /// [child] 头部
  final List<DecoratorPendant<T>> headers;

  /// [child] 尾部
  final List<DecoratorPendant<T>> footers;

  /// [child] 前缀
  final List<DecoratorPendant<T>> suffixes;

  /// [child] 后缀
  final List<DecoratorPendant<T>> prefixes;

  /// [DecoratorBox] 样式
  final DecoratorBoxDecorativeBuilder<T>? decoration;

  /// 是否 [Expanded]
  final bool expanded;

  /// 添加 [Listenable] 监听
  /// 当 [listenable] 发生变化时，会重新构建 [DecoratorBox]
  /// 注意：[listenable] 必须是 [Listenable] 或 [Listenable] 的子类
  final Listenable? listenable;

  /// 是否有焦点监听
  final DecoratorBoxStatusCallback? onFocus;

  /// 是否在编辑中
  final DecoratorBoxStatusCallback? onEditing;

  /// value 回调
  final DecoratorBoxStatusValueCallback<T>? onValue;

  @override
  Widget build(BuildContext context) {
    if (listenable == null) return buildDecoratorBox(_status);
    return ListenableBuilder(
        listenable: listenable!,
        builder: (_, Widget? child) => buildDecoratorBox(_status),
        child: child);
  }

  DecoratorBoxStatus<T> get _status {
    final hasFocus = onFocus?.call() ?? false;
    final isEditing = onEditing?.call() ?? false;
    final value = onValue?.call();
    return DecoratorBoxStatus<T>(
        hasFocus: hasFocus, isEditing: isEditing, value: value);
  }

  Widget buildDecoratorBox(DecoratorBoxStatus<T> status) {
    final outerHeader =
        buildPendant(headers, DecoratorPendantPosition.outer, status);
    final outerPrefix =
        buildPendant(prefixes, DecoratorPendantPosition.outer, status);
    final outerSuffix =
        buildPendant(suffixes, DecoratorPendantPosition.outer, status);
    final outerFooter =
        buildPendant(footers, DecoratorPendantPosition.outer, status);
    Widget current = buildInner(status);
    if (outerPrefix != null || outerSuffix != null) {
      current = Row(mainAxisSize: MainAxisSize.min, children: [
        if (outerPrefix != null) outerPrefix,
        expanded ? Expanded(child: current) : current,
        if (outerSuffix != null) outerSuffix,
      ]);
    }
    if (outerHeader != null || outerFooter != null) {
      current = Column(mainAxisSize: MainAxisSize.min, children: [
        if (outerHeader != null) outerHeader,
        current,
        if (outerFooter != null) outerFooter,
      ]);
    }
    return current;
  }

  Widget buildInner(DecoratorBoxStatus<T> status) {
    final innerHeader =
        buildPendant(headers, DecoratorPendantPosition.inner, status);
    final innerPrefix =
        buildPendant(prefixes, DecoratorPendantPosition.inner, status);
    final innerSuffix =
        buildPendant(suffixes, DecoratorPendantPosition.inner, status);
    final innerFooter =
        buildPendant(footers, DecoratorPendantPosition.inner, status);
    Widget current = child;
    if (innerPrefix != null || innerSuffix != null) {
      current = Row(mainAxisSize: MainAxisSize.min, children: [
        if (innerPrefix != null) innerPrefix,
        expanded ? Expanded(child: current) : current,
        if (innerSuffix != null) innerSuffix,
      ]);
    }
    if (innerHeader != null || innerFooter != null) {
      current = Column(mainAxisSize: MainAxisSize.min, children: [
        if (innerHeader != null) innerHeader,
        current,
        if (innerFooter != null) innerFooter,
      ]);
    }
    return decoration?.call(current, status) ?? current;
  }

  Widget? buildPendant(List<DecoratorPendant<T>> list,
      DecoratorPendantPosition positioned, DecoratorBoxStatus<T> status) {
    final listPendant =
        list.where((element) => element.positioned == positioned);
    if (listPendant.isEmpty) return null;
    Widget buildVisibilityPendant(DecoratorPendant<T> pendant) {
      if (pendant.builder != null) {
        return Visibility(
            maintainAnimation: pendant.maintainSize,
            maintainState: pendant.maintainSize,
            maintainSize: pendant.maintainSize,
            child: pendant.builder!(status));
      }

      bool isEditingVisible = true;
      bool isHasFocusVisible = true;
      bool isValueVisible = true;

      if (pendant.needEditing != null) {
        isEditingVisible = pendant.needEditing == status.isEditing;
      }
      if (pendant.needFocus != null) {
        isHasFocusVisible = pendant.needFocus == status.hasFocus;
      }
      if (pendant.needValue != null) {
        isValueVisible = pendant.needValue!(status.value);
      }
      return Visibility(
          visible: isEditingVisible && isHasFocusVisible && isValueVisible,
          maintainAnimation: pendant.maintainSize,
          maintainState: pendant.maintainSize,
          maintainSize: pendant.maintainSize,
          child: pendant.child!);
    }

    if (listPendant.length == 1) {
      return buildVisibilityPendant(listPendant.first);
    }
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: listPendant
            .map((pendant) => buildVisibilityPendant(pendant))
            .toList());
  }
}
