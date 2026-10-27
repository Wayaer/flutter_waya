import 'package:flutter/material.dart';

/// Widget 扩展，用于快速转换为 [FlDecoratorPendant] 挂件。
extension FlDecoratorBoxExtension on Widget {
  /// 将当前 widget 转换为挂件，默认放在边框外部。
  FlDecoratorPendant<T> toDecoratorPendant<T>({
    FlDecoratorPendantPosition positioned = FlDecoratorPendantPosition.outer,
    bool maintainSize = false,
    bool? needFocus,
    bool? needEditing,
    FlDecoratorPendantValueCallback<T?>? needValue,
  }) => FlDecoratorPendant<T>(
    child: this,
    maintainSize: maintainSize,
    positioned: positioned,
    needValue: needValue,
    needEditing: needEditing,
    needFocus: needFocus,
  );

  /// 以 builder 形式转换为挂件，默认放在边框外部。
  FlDecoratorPendant<T> toDecoratorPendantBuilder<T>({
    FlDecoratorPendantPosition positioned = FlDecoratorPendantPosition.outer,
    bool maintainSize = false,
    bool? needFocus,
    bool? needEditing,
    FlDecoratorPendantValueCallback<T?>? needValue,
  }) => FlDecoratorPendant<T>.builder(
    builder: (_) => this,
    maintainSize: maintainSize,
    positioned: positioned,
    needValue: needValue,
    needEditing: needEditing,
    needFocus: needFocus,
  );
}

/// 挂件相对于边框的位置：内部或外部。
enum FlDecoratorPendantPosition {
  /// 在 Border 内部
  inner,

  /// 在 Border 外部
  outer,
}

/// 装饰器当前状态：是否聚焦、是否编辑中以及关联的值。
class FlDecoratorBoxStatus<T> {
  const FlDecoratorBoxStatus({required this.hasFocus, required this.isEditing, this.value});

  /// 是否有焦点
  final bool hasFocus;

  /// 是否编辑中
  final bool isEditing;

  /// 数据
  final T? value;
}

/// 根据装饰器状态构建挂件内容的回调。
typedef FlDecoratorBoxPendantBuilder<T> = Widget Function(FlDecoratorBoxStatus<T> status);

/// 判断给定值是否满足显示条件的回调。
typedef FlDecoratorPendantValueCallback<T> = bool Function(T value);

/// 装饰挂件，根据焦点、编辑状态或值决定是否显示在边框内外。
class FlDecoratorPendant<T> {
  const FlDecoratorPendant({
    this.child,
    this.positioned = FlDecoratorPendantPosition.inner,
    this.maintainSize = false,
    this.needValue,
    this.needFocus,
    this.needEditing,
  }) : builder = null;

  const FlDecoratorPendant.builder({
    this.builder,
    this.positioned = FlDecoratorPendantPosition.inner,
    this.maintainSize = false,
    this.needValue,
    this.needFocus,
    this.needEditing,
  }) : child = null;

  /// 显示位置，默认在边框内部。
  final FlDecoratorPendantPosition positioned;

  /// 是否在不可见时保持占位，默认 false。
  final bool maintainSize;

  /// 要显示的 [builder] 会覆盖 [child]
  final FlDecoratorBoxPendantBuilder<T>? builder;

  /// 要显示的 widget
  final Widget? child;

  /// 是否需要编辑状态(输入框是否有内容)
  /// [needEditing] == nul 无需判断 是否编辑状态
  final bool? needEditing;

  /// 是否需要焦点
  /// [needFocus] == null 无需判断 是否有焦点
  final bool? needFocus;

  /// 是否需要值
  /// `onValue` == null 无需判断 值是否满足条件
  final FlDecoratorPendantValueCallback<T?>? needValue;
}

/// 构建装饰器外层样式的回调，可包裹 child 并按状态定制。
typedef FlDecoratorBoxDecorativeBuilder<T> = Widget Function(Widget child, FlDecoratorBoxStatus<T> status);

/// 无参的布尔状态查询回调，用于焦点、编辑状态判断。
typedef FlDecoratorBoxStatusCallback = bool Function();

/// 无参取值回调，用于读取需要判断的值。
typedef FlDecoratorBoxStatusValueCallback<T> = T Function();

/// 装饰器内外间距配置，单位与 Flutter 逻辑像素一致。
class FlDecoratorBoxSpacing {
  /// 内部列间距
  /// 作用于 `headers` spacing `child` spacing `footers`
  final double innerColumnSpacing;

  /// 内部行间距
  /// 作用于 `suffixes` spacing `child` spacing `prefixes`
  final double innerRowSpacing;

  /// 外部列间距
  /// 作用于 `headers` spacing `child` spacing `footers`
  final double outerColumnSpacing;

  /// 外部行间距
  /// 作用于 `suffixes` spacing `child` spacing `prefixes`
  final double outerRowSpacing;

  const FlDecoratorBoxSpacing({
    this.innerColumnSpacing = 0,
    this.innerRowSpacing = 0,
    this.outerColumnSpacing = 0,
    this.outerRowSpacing = 0,
  });

  /// 复制当前间距配置并覆盖传入的字段。
  FlDecoratorBoxSpacing copyWith({
    double? innerColumnSpacing,
    double? innerRowSpacing,
    double? outerColumnSpacing,
    double? outerRowSpacing,
  }) => FlDecoratorBoxSpacing(
    innerColumnSpacing: innerColumnSpacing ?? this.innerColumnSpacing,
    innerRowSpacing: innerRowSpacing ?? this.innerRowSpacing,
    outerColumnSpacing: outerColumnSpacing ?? this.outerColumnSpacing,
    outerRowSpacing: outerRowSpacing ?? this.outerRowSpacing,
  );
}

/// 头部与尾部挂件的排列方向配置，内外层可分别设置。
class FlDecoratorBoxHeadersFootersDirection {
  /// inner `headers` 方向
  final Axis innerHeaders;

  /// inner `footers` 方向
  final Axis innerFooters;

  /// outer `headers` 方向
  final Axis outerHeaders;

  /// outer `footers` 方向
  final Axis outerFooters;

  const FlDecoratorBoxHeadersFootersDirection({
    this.innerHeaders = Axis.vertical,
    this.innerFooters = Axis.vertical,
    this.outerHeaders = Axis.vertical,
    this.outerFooters = Axis.vertical,
  });

  /// 复制当前方向配置并覆盖传入的字段。
  FlDecoratorBoxHeadersFootersDirection copyWith({
    Axis? innerHeaders,
    Axis? innerFooters,
    Axis? outerHeaders,
    Axis? outerFooters,
  }) => FlDecoratorBoxHeadersFootersDirection(
    innerHeaders: innerHeaders ?? this.innerHeaders,
    innerFooters: innerFooters ?? this.innerFooters,
    outerHeaders: outerHeaders ?? this.outerHeaders,
    outerFooters: outerFooters ?? this.outerFooters,
  );
}

/// 通用组件装饰器，可在边框内外添加头部、尾部、前缀与后缀挂件。
class FlDecoratorBox<T> extends StatelessWidget {
  const FlDecoratorBox({
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
    this.spacing = const FlDecoratorBoxSpacing(),
    this.direction = const FlDecoratorBoxHeadersFootersDirection(),
  });

  /// 被装饰的内容。
  final Widget child;

  /// [child] 头部
  final List<FlDecoratorPendant<T>> headers;

  /// [child] 尾部
  final List<FlDecoratorPendant<T>> footers;

  /// [child] 前缀
  final List<FlDecoratorPendant<T>> suffixes;

  /// [child] 后缀
  final List<FlDecoratorPendant<T>> prefixes;

  /// [FlDecoratorBox] 样式
  final FlDecoratorBoxDecorativeBuilder<T>? decoration;

  /// 是否 [Expanded]
  final bool expanded;

  /// 添加 [Listenable] 监听
  /// 当 [listenable] 发生变化时，会重新构建 [FlDecoratorBox]
  /// 注意：[listenable] 必须是 [Listenable] 或 [Listenable] 的子类
  final Listenable? listenable;

  /// 是否有焦点监听
  final FlDecoratorBoxStatusCallback? onFocus;

  /// 是否在编辑中
  final FlDecoratorBoxStatusCallback? onEditing;

  /// value 回调
  final FlDecoratorBoxStatusValueCallback<T>? onValue;

  /// 间距
  final FlDecoratorBoxSpacing spacing;

  /// [headers], [footers] 方向
  final FlDecoratorBoxHeadersFootersDirection direction;

  @override
  Widget build(BuildContext context) {
    if (listenable == null) return buildDecoratorBox(_status);
    return ListenableBuilder(
      listenable: listenable!,
      builder: (_, Widget? child) => buildDecoratorBox(_status),
      child: child,
    );
  }

  FlDecoratorBoxStatus<T> get _status {
    final hasFocus = onFocus?.call() ?? false;
    final isEditing = onEditing?.call() ?? false;
    final value = onValue?.call();
    return FlDecoratorBoxStatus<T>(hasFocus: hasFocus, isEditing: isEditing, value: value);
  }

  /// 构建外层挂件布局，返回完整的装饰结果。
  Widget buildDecoratorBox(FlDecoratorBoxStatus<T> status) => _buildPendantLayout(
    buildInner(status),
    status,
    positioned: FlDecoratorPendantPosition.outer,
    rowSpacing: spacing.outerRowSpacing,
    columnSpacing: spacing.outerColumnSpacing,
    headersDirection: direction.outerHeaders,
    footersDirection: direction.outerFooters,
  );

  /// 构建内层挂件布局，并应用 [decoration] 样式。
  Widget buildInner(FlDecoratorBoxStatus<T> status) {
    final Widget current = _buildPendantLayout(
      child,
      status,
      positioned: FlDecoratorPendantPosition.inner,
      rowSpacing: spacing.innerRowSpacing,
      columnSpacing: spacing.innerColumnSpacing,
      headersDirection: direction.innerHeaders,
      footersDirection: direction.innerFooters,
    );
    return decoration?.call(current, status) ?? current;
  }

  /// 按位置构建前后缀行与头尾列，内外层共用。
  Widget _buildPendantLayout(
    Widget child,
    FlDecoratorBoxStatus<T> status, {
    required FlDecoratorPendantPosition positioned,
    required double rowSpacing,
    required double columnSpacing,
    required Axis headersDirection,
    required Axis footersDirection,
  }) {
    final header = buildPendant(headers, positioned, status, direction: headersDirection, spacing: columnSpacing);
    final prefix = buildPendant(prefixes, positioned, status, spacing: rowSpacing);
    final suffix = buildPendant(suffixes, positioned, status, spacing: rowSpacing);
    final footer = buildPendant(footers, positioned, status, direction: footersDirection, spacing: columnSpacing);
    Widget current = child;
    if (prefix != null || suffix != null) {
      final Widget rowChild = current;
      current = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool useExpanded = expanded && constraints.hasBoundedWidth;
          return Row(
            spacing: rowSpacing,
            mainAxisSize: MainAxisSize.min,
            children: [
              ?prefix,
              useExpanded ? Expanded(child: rowChild) : rowChild,
              ?suffix,
            ],
          );
        },
      );
    }
    if (header != null || footer != null) {
      current = Column(
        spacing: columnSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [?header, current, ?footer],
      );
    }
    return current;
  }

  /// 按指定位置与状态构建挂件，无可显示内容时返回 null。
  Widget? buildPendant(
    List<FlDecoratorPendant<T>> list,
    FlDecoratorPendantPosition positioned,
    FlDecoratorBoxStatus<T> status, {
    Axis direction = Axis.horizontal,
    double spacing = 0,
  }) {
    final List<FlDecoratorPendant<T>> listPendant = list
        .where((FlDecoratorPendant<T> element) => element.positioned == positioned)
        .toList();
    if (listPendant.isEmpty) return null;

    bool isVisible(FlDecoratorPendant<T> pendant) {
      bool isEditingVisible = true;
      bool isHasFocusVisible = true;
      bool isValueVisible = true;
      if (pendant.needEditing != null) isEditingVisible = pendant.needEditing == status.isEditing;
      if (pendant.needFocus != null) isHasFocusVisible = pendant.needFocus == status.hasFocus;
      if (pendant.needValue != null) isValueVisible = pendant.needValue!(status.value);
      return isEditingVisible && isHasFocusVisible && isValueVisible;
    }

    final List<Widget> pendants = <Widget>[];
    for (final FlDecoratorPendant<T> pendant in listPendant) {
      final bool visible = isVisible(pendant);
      // 不可见且不占位时直接跳过，避免在前后缀 / 头尾之间留下多余间距。
      if (!visible && !pendant.maintainSize) continue;
      pendants.add(
        Visibility(
          visible: visible,
          maintainAnimation: pendant.maintainSize,
          maintainState: pendant.maintainSize,
          maintainSize: pendant.maintainSize,
          child: pendant.builder?.call(status) ?? pendant.child ?? const SizedBox.shrink(),
        ),
      );
    }
    if (pendants.isEmpty) return null;
    if (pendants.length == 1) return pendants.first;
    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: direction,
      spacing: spacing,
      children: pendants,
    );
  }
}
