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
      DecoratorPendant<T>.builder(
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
    this.positioned = DecoratorPendantPosition.inner,
    this.maintainSize = false,
    this.needValue,
    this.needFocus,
    this.needEditing,
  }) : builder = null;

  const DecoratorPendant.builder({
    this.builder,
    this.positioned = DecoratorPendantPosition.inner,
    this.maintainSize = false,
    this.needValue,
    this.needFocus,
    this.needEditing,
  }) : child = null;

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

class DecoratorBoxSpacing {
  /// 内部列间距
  /// 作用于 [headers] spacing [child] spacing [footers]
  final double innerColumnSpacing;

  /// 内部行间距
  /// 作用于 [suffixes] spacing [child] spacing [prefixes]
  final double innerRowSpacing;

  /// 外部列间距
  /// 作用于 [headers] spacing [child] spacing [footers]
  final double outerColumnSpacing;

  /// 外部行间距
  /// 作用于 [suffixes] spacing [child] spacing [prefixes]
  final double outerRowSpacing;

  const DecoratorBoxSpacing({
    this.innerColumnSpacing = 0,
    this.innerRowSpacing = 0,
    this.outerColumnSpacing = 0,
    this.outerRowSpacing = 0,
  });

  DecoratorBoxSpacing copyWith({
    double? innerColumnSpacing,
    double? innerRowSpacing,
    double? outerColumnSpacing,
    double? outerRowSpacing,
  }) =>
      DecoratorBoxSpacing(
        innerColumnSpacing: innerColumnSpacing ?? this.innerColumnSpacing,
        innerRowSpacing: innerRowSpacing ?? this.innerRowSpacing,
        outerColumnSpacing: outerColumnSpacing ?? this.outerColumnSpacing,
        outerRowSpacing: outerRowSpacing ?? this.outerRowSpacing,
      );
}

class DecoratorBoxHeadersFootersDirection {
  /// inner [headers] 方向
  final Axis innerHeaders;

  /// inner [footers] 方向
  final Axis innerFooters;

  /// outer [headers] 方向
  final Axis outerHeaders;

  /// outer [footers] 方向
  final Axis outerFooters;

  const DecoratorBoxHeadersFootersDirection({
    this.innerHeaders = Axis.vertical,
    this.innerFooters = Axis.vertical,
    this.outerHeaders = Axis.vertical,
    this.outerFooters = Axis.vertical,
  });

  DecoratorBoxHeadersFootersDirection copyWith({
    Axis? innerHeaders,
    Axis? innerFooters,
    Axis? outerHeaders,
    Axis? outerFooters,
  }) =>
      DecoratorBoxHeadersFootersDirection(
        innerHeaders: innerHeaders ?? this.innerHeaders,
        innerFooters: innerFooters ?? this.innerFooters,
        outerHeaders: outerHeaders ?? this.outerHeaders,
        outerFooters: outerFooters ?? this.outerFooters,
      );
}

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
    this.spacing = const DecoratorBoxSpacing(),
    this.direction = const DecoratorBoxHeadersFootersDirection(),
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

  /// 间距
  final DecoratorBoxSpacing spacing;

  /// [headers], [footers] 方向
  final DecoratorBoxHeadersFootersDirection direction;

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

  /// outer
  Widget buildDecoratorBox(DecoratorBoxStatus<T> status) {
    final position = DecoratorPendantPosition.outer;
    final outerHeader = buildPendant(headers, position, status, direction: direction.outerHeaders);
    final outerPrefix = buildPendant(prefixes, position, status);
    final outerSuffix = buildPendant(suffixes, position, status);
    final outerFooter = buildPendant(footers, position, status, direction: direction.outerFooters);
    Widget current = buildInner(status);
    if (outerPrefix != null || outerSuffix != null) {
      current = Row(spacing: spacing.outerRowSpacing, mainAxisSize: MainAxisSize.min, children: [
        if (outerPrefix != null) outerPrefix,
        expanded ? Expanded(child: current) : current,
        if (outerSuffix != null) outerSuffix,
      ]);
    }
    if (outerHeader != null || outerFooter != null) {
      current = Column(spacing: spacing.outerColumnSpacing, mainAxisSize: MainAxisSize.min, children: [
        if (outerHeader != null) outerHeader,
        current,
        if (outerFooter != null) outerFooter,
      ]);
    }
    return current;
  }

  /// inner
  Widget buildInner(DecoratorBoxStatus<T> status) {
    final position = DecoratorPendantPosition.inner;
    final innerHeader = buildPendant(headers, position, status, direction: direction.innerHeaders);
    final innerPrefix = buildPendant(prefixes, position, status);
    final innerSuffix = buildPendant(suffixes, position, status);
    final innerFooter = buildPendant(footers, position, status, direction: direction.innerFooters);
    Widget current = child;
    if (innerPrefix != null || innerSuffix != null) {
      current = Row(spacing: spacing.innerRowSpacing, mainAxisSize: MainAxisSize.min, children: [
        if (innerPrefix != null) innerPrefix,
        expanded ? Expanded(child: current) : current,
        if (innerSuffix != null) innerSuffix,
      ]);
    }
    if (innerHeader != null || innerFooter != null) {
      current = Column(spacing: spacing.innerColumnSpacing, mainAxisSize: MainAxisSize.min, children: [
        if (innerHeader != null) innerHeader,
        current,
        if (innerFooter != null) innerFooter,
      ]);
    }
    return decoration?.call(current, status) ?? current;
  }

  Widget? buildPendant(List<DecoratorPendant<T>> list, DecoratorPendantPosition positioned, DecoratorBoxStatus<T> status,
      {Axis direction = Axis.horizontal}) {
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
    return Flex(
        mainAxisSize: MainAxisSize.min,
        direction: direction,
        children: listPendant
            .map((pendant) => buildVisibilityPendant(pendant))
            .toList());
  }
}
