import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

extension ExtensionWidgetDecoratedPendant on Widget {
  DecoratedPendant toDecoratedPendant({
    DecoratedPendantPosition positioned = DecoratedPendantPosition.outer,
    OverlayVisibilityMode mode = OverlayVisibilityMode.always,
    bool maintainSize = false,
  }) =>
      DecoratedPendant(
          widget: this,
          maintainSize: maintainSize,
          positioned: positioned,
          mode: mode);
}

enum DecoratedPendantPosition {
  /// 在 Border 内部
  inner,

  /// 在 Border 外部
  outer,
}

enum BorderType {
  outline,
  underline,
  none,
  ;

  /// BorderType to Border
  Border? value([BorderSide borderSide = const BorderSide()]) {
    switch (this) {
      case BorderType.outline:
        return Border.fromBorderSide(borderSide);
      case BorderType.underline:
        return Border(bottom: borderSide);
      case BorderType.none:
        return null;
    }
  }
}

class DecoratedPendant {
  const DecoratedPendant(
      {required this.positioned,
      required this.widget,
      this.maintainSize = false,
      this.mode = OverlayVisibilityMode.always});

  /// 显示的位置
  final DecoratedPendantPosition positioned;

  /// 叠加可见性模式
  final OverlayVisibilityMode mode;

  /// 保持占位
  final bool maintainSize;

  /// 要显示的 组件
  final Widget widget;
}

/// [FlDecoratedBox] 样式
class FlBoxDecoration {
  const FlBoxDecoration({
    this.borderType = BorderType.none,
    this.borderRadius,
    this.borderSide = const BorderSide(),
    this.margin,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.fillColor,
    this.boxShadow,
    this.gradient,
    this.constraints,
  });

  /// 仅作用于 [FlDecoratedBox.child]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [FlDecoratedBox.child] 与 [extraPrefix]、[extraSuffix] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [FlDecoratedBox.child] 边框类型
  final BorderType borderType;

  /// [FlDecoratedBox.child] 边框样式
  final BorderSide borderSide;

  /// [FlDecoratedBox.child] 填充色
  final Color? fillColor;

  /// [FlDecoratedBox.child] 圆角
  final BorderRadius? borderRadius;

  /// [FlDecoratedBox.child] 阴影
  final List<BoxShadow>? boxShadow;

  /// [FlDecoratedBox.child] 渐变色
  final Gradient? gradient;

  /// [FlDecoratedBox] 约束
  final BoxConstraints? constraints;
}

typedef FlDecoratedBoxStateBuilder = Widget Function(FocusNode focusNode);

/// [Widget] 装饰器 动态焦点样式
class FlDecoratedBoxState extends StatefulWidget {
  const FlDecoratedBoxState({
    super.key,
    required this.child,
    required this.focusNode,
    this.suffixes = const [],
    this.prefixes = const [],
    this.decoration = const FlBoxDecoration(
        borderType: BorderType.outline,
        borderSide: BorderSide(color: Colors.black)),
    this.focusBorderSide,
    this.header,
    this.footer,
    this.disposeFocusNode = false,
  }) : builder = null;

  const FlDecoratedBoxState.builder({
    super.key,
    required this.builder,
    required this.focusNode,
    this.suffixes = const [],
    this.prefixes = const [],
    this.decoration = const FlBoxDecoration(
        borderType: BorderType.outline,
        borderSide: BorderSide(color: Colors.black)),
    this.focusBorderSide,
    this.header,
    this.footer,
    this.disposeFocusNode = false,
  })  : assert(builder != null),
        child = null;

  /// [TextField]
  final Widget? child;

  /// builder [TextField]
  final FlDecoratedBoxStateBuilder? builder;

  /// 根据焦点状态改变边框样式
  final FocusNode focusNode;

  /// 组件销毁自动调用 [dispose]
  final bool disposeFocusNode;

  /// 获得焦点时的边框样式
  final BorderSide? focusBorderSide;

  /// [TextField] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// 前缀
  final List<DecoratedPendant> suffixes;

  /// 后缀
  final List<DecoratedPendant> prefixes;

  /// [FlDecoratedBox] 装饰器
  final FlBoxDecoration decoration;

  @override
  State<FlDecoratedBoxState> createState() => _FlDecoratedBoxStateState();
}

class _FlDecoratedBoxStateState extends ExtendedState<FlDecoratedBoxState> {
  late BorderSide borderSide;
  bool hasFocus = false;
  bool hasEditing = false;
  ValueNotifier<bool> focusNodeUpdate = ValueNotifier(false);

  @override
  void initState() {
    initFocusNode();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlDecoratedBoxState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      disposeFocusNode(oldWidget.focusNode);
      initFocusNode();
    }
  }

  void initFocusNode() {
    hasFocus = widget.focusNode.hasFocus;
    borderSide = widget.decoration.borderSide;
    if (widget.focusBorderSide != null && hasFocus) {
      borderSide = widget.focusBorderSide!;
    }
    final editingSuffixes = widget.suffixes.where((element) =>
        element.mode == OverlayVisibilityMode.editing ||
        element.mode == OverlayVisibilityMode.notEditing);
    final editingPrefixes = widget.prefixes.where((element) =>
        element.mode == OverlayVisibilityMode.editing ||
        element.mode == OverlayVisibilityMode.notEditing);
    hasEditing = editingSuffixes.isNotEmpty || editingPrefixes.isNotEmpty;
    if (hasEditing) {
      widget.focusNode.addListener(listener);
    }
  }

  void listener() {
    if (hasFocus == widget.focusNode.hasFocus ||
        (widget.decoration.borderType == BorderType.none && !hasEditing)) {
      return;
    }
    hasFocus = widget.focusNode.hasFocus;
    if (widget.focusBorderSide != null) {
      borderSide =
          hasFocus ? widget.focusBorderSide! : widget.decoration.borderSide;
    }
    focusNodeUpdate.value = !focusNodeUpdate.value;
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.child ??
        widget.builder?.call(widget.focusNode) ??
        const SizedBox();
    return FlDecoratedBox(
        decoration: widget.decoration,
        header: widget.header,
        footer: widget.footer,
        prefix: buildDecoratedPendant(
            widget.prefixes, DecoratedPendantPosition.inner),
        suffix: buildDecoratedPendant(
            widget.suffixes, DecoratedPendantPosition.inner),
        extraPrefix: buildDecoratedPendant(
            widget.prefixes, DecoratedPendantPosition.outer),
        extraSuffix: buildDecoratedPendant(
            widget.suffixes, DecoratedPendantPosition.outer),
        child: current);
  }

  Widget? buildDecoratedPendant(
      List<DecoratedPendant> list, DecoratedPendantPosition positioned) {
    final children = list.where((element) => element.positioned == positioned);
    if (children.isEmpty) return null;
    Widget buildWidget() {
      Widget buildPendant(DecoratedPendant pendant) => Visibility(
          visible: getVisible(pendant),
          maintainAnimation: pendant.maintainSize,
          maintainState: pendant.maintainSize,
          maintainSize: pendant.maintainSize,
          child: pendant.widget);
      if (children.length == 1) return buildPendant(children.first);
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: children.map(buildPendant).toList());
    }

    final hasEditing = children
        .where((e) =>
            e.mode == OverlayVisibilityMode.editing ||
            e.mode == OverlayVisibilityMode.notEditing)
        .isNotEmpty;
    if (!hasEditing) return buildWidget();
    return ValueListenableBuilder(
        valueListenable: focusNodeUpdate,
        builder: (_, __, ___) => buildWidget());
  }

  bool getVisible(DecoratedPendant pendant) {
    if (pendant.mode == OverlayVisibilityMode.never) {
      return false;
    } else if (pendant.mode == OverlayVisibilityMode.editing) {
      return widget.focusNode.hasFocus;
    } else if (pendant.mode == OverlayVisibilityMode.notEditing) {
      return !widget.focusNode.hasFocus;
    }
    return true;
  }

  void disposeFocusNode([FocusNode? focusNode]) {
    (focusNode ?? widget.focusNode).removeListener(listener);
  }

  @override
  void dispose() {
    focusNodeUpdate.dispose();
    super.dispose();
    disposeFocusNode();
  }
}

/// [Widget] 装饰器
class FlDecoratedBox extends StatelessWidget {
  const FlDecoratedBox({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.extraPrefix,
    this.extraSuffix,
    this.prefix,
    this.suffix,
    this.decoration = const FlBoxDecoration(),
  });

  final Widget child;

  /// [child] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? extraPrefix;
  final Widget? extraSuffix;

  /// [child] 左右两遍的挂件 在[Border] 内部
  final Widget? prefix;
  final Widget? suffix;

  /// [FlDecoratedBox] 样式
  final FlBoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    Widget current = buildCurrent;
    if (extraPrefix != null || extraSuffix != null) {
      final List<Widget> row = [];
      if (extraPrefix != null) row.add(extraPrefix!);
      row.add(Expanded(child: current));
      if (extraSuffix != null) row.add(extraSuffix!);
      current =
          Row(crossAxisAlignment: decoration.crossAxisAlignment, children: row);
    }

    if (header != null || footer != null) {
      final List<Widget> children = [];
      if (header != null) children.add(header!);
      children.add(current);
      if (footer != null) children.add(footer!);
      current = Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return current;
  }

  Widget get buildCurrent {
    Widget current = child;
    Border? border = decoration.borderType.value(decoration.borderSide);
    Decoration? boxDecoration;
    if (border != null ||
        decoration.fillColor != null ||
        decoration.boxShadow != null ||
        decoration.borderRadius != null ||
        decoration.gradient != null) {
      boxDecoration = BoxDecoration(
          border: border,
          color: decoration.fillColor,
          borderRadius: decoration.borderType == BorderType.underline
              ? null
              : decoration.borderRadius,
          gradient: decoration.gradient,
          boxShadow: decoration.boxShadow);
    }
    final List<Widget> children = [Expanded(child: current)];
    if (prefix != null) children.insert(0, prefix!);
    if (suffix != null) children.add(suffix!);
    current = Container(
        decoration: boxDecoration,
        constraints: decoration.constraints,
        margin: decoration.margin,
        padding: decoration.padding,
        child: children.length > 1 ? Row(children: children) : current);
    if (decoration.borderRadius != null) {
      current =
          ClipRRect(borderRadius: decoration.borderRadius!, child: current);
    }
    return current;
  }
}
