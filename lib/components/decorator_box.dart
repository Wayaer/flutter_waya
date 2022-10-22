import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum DecoratorPositioned {
  /// 在 Border 内部
  inner,

  /// 在 Border 外部
  outer,

  /// 在最外部
  outermost,
}

class DecoratorEntry {
  const DecoratorEntry(
      {required this.positioned,
      required this.widget,
      this.mode = OverlayVisibilityMode.always});

  /// 显示的位置
  final DecoratorPositioned positioned;

  /// 模式
  final OverlayVisibilityMode mode;

  /// 要显示的 组件
  final Widget widget;
}

typedef DecoratorBoxStateBuilder = Widget Function(FocusNode focusNode);

/// [Widget] 装饰器 动态焦点样式
class DecoratorBoxState extends StatefulWidget {
  const DecoratorBoxState({
    super.key,
    this.suffixes = const [],
    this.prefixes = const [],
    this.borderType = BorderType.outline,
    this.borderRadius,
    this.borderSide = const BorderSide(color: Colors.black),
    this.focusBorderSide = const BorderSide(color: Colors.red),
    this.header,
    this.footer,
    this.margin,
    this.padding,
    this.fillColor,
    this.boxShadow,
    this.gradient,
    this.constraints,
    this.hasFocusChangeBorder = true,
    required this.focusNode,
    required this.child,
  })  : assert(focusNode != null),
        builder = null;

  const DecoratorBoxState.builder({
    super.key,
    this.suffixes = const [],
    this.prefixes = const [],
    this.borderType = BorderType.outline,
    this.borderRadius,
    this.borderSide = const BorderSide(color: Colors.black),
    this.focusBorderSide,
    this.header,
    this.footer,
    this.margin,
    this.padding,
    this.fillColor,
    this.boxShadow,
    this.gradient,
    this.constraints,
    required this.builder,
    this.hasFocusChangeBorder = true,
  })  : assert(builder != null),
        child = null,
        focusNode = null;

  final DecoratorBoxStateBuilder? builder;

  /// 边框类型
  final BorderType borderType;

  /// 边框圆角
  final BorderRadius? borderRadius;

  /// 边框样式
  final BorderSide borderSide;

  /// 获得焦点时的边框样式
  final BorderSide? focusBorderSide;

  /// [TextField] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// 仅作用于 [TextField]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [TextField] 填充色
  final Color? fillColor;

  /// [TextField] 阴影
  final List<BoxShadow>? boxShadow;

  /// [TextField] 渐变色
  final Gradient? gradient;

  final FocusNode? focusNode;

  final Widget? child;

  /// 前缀
  final List<DecoratorEntry> suffixes;

  /// 后缀
  final List<DecoratorEntry> prefixes;

  /// 作用于整个组件
  final BoxConstraints? constraints;

  /// 获取焦点修改 border 样式
  final bool hasFocusChangeBorder;

  @override
  State<DecoratorBoxState> createState() => _DecoratorBoxStateState();
}

class _DecoratorBoxStateState extends State<DecoratorBoxState> {
  late FocusNode focusNode;
  late BorderSide borderSide;
  bool hasFocus = false;
  bool hasEditingEntry = false;

  @override
  void initState() {
    super.initState();
    initFocusNode();
  }

  void initFocusNode() {
    focusNode = widget.focusNode ?? FocusNode();
    hasFocus = focusNode.hasFocus;
    borderSide = widget.borderSide;
    if (widget.focusBorderSide != null && hasFocus) {
      borderSide = widget.focusBorderSide!;
    }
    focusNode.addListener(listener);
    final editingSuffixes = widget.suffixes.where((element) =>
        element.mode == OverlayVisibilityMode.editing ||
        element.mode == OverlayVisibilityMode.notEditing);
    final editingPrefixes = widget.prefixes.where((element) =>
        element.mode == OverlayVisibilityMode.editing ||
        element.mode == OverlayVisibilityMode.notEditing);
    hasEditingEntry = editingSuffixes.isNotEmpty || editingPrefixes.isNotEmpty;
  }

  void listener() {
    if (hasFocus == focusNode.hasFocus ||
        (widget.borderType == BorderType.none && !hasEditingEntry)) {
      return;
    }
    hasFocus = focusNode.hasFocus;
    if (widget.focusBorderSide != null) {
      borderSide = hasFocus ? widget.focusBorderSide! : widget.borderSide;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DecoratorBox(
        constraints: widget.constraints,
        borderType: widget.borderType,
        borderRadius: widget.borderRadius,
        borderSide: borderSide,
        header: widget.header,
        footer: widget.footer,
        fillColor: widget.fillColor,
        boxShadow: widget.boxShadow,
        gradient: widget.gradient,
        margin: widget.margin,
        padding: widget.padding,
        prefix: buildPrefix(DecoratorPositioned.inner),
        suffix: buildSuffix(DecoratorPositioned.inner),
        extraPrefix: buildPrefix(DecoratorPositioned.outer),
        extraSuffix: buildSuffix(DecoratorPositioned.outer),
        child: widget.child ??
            widget.builder?.call(focusNode) ??
            const SizedBox());
  }

  /// 后缀
  Widget? buildSuffix(DecoratorPositioned positioned) {
    List children = widget.suffixes.where((element) {
      if (element.positioned != positioned) return false;
      switch (element.mode) {
        case OverlayVisibilityMode.never:
          return false;
        case OverlayVisibilityMode.editing:
          return focusNode.hasFocus;
        case OverlayVisibilityMode.notEditing:
          return !focusNode.hasFocus;
        case OverlayVisibilityMode.always:
          return true;
      }
    }).toList();

    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.builder((entry) => entry.widget));
  }

  /// 前缀
  Widget? buildPrefix(DecoratorPositioned positioned) {
    final children = widget.prefixes.where((element) {
      if (element.positioned != positioned) return false;
      switch (element.mode) {
        case OverlayVisibilityMode.never:
          return false;
        case OverlayVisibilityMode.editing:
          return focusNode.hasFocus;
        case OverlayVisibilityMode.notEditing:
          return !focusNode.hasFocus;
        case OverlayVisibilityMode.always:
          return true;
      }
    }).toList();
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first.widget;
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: children.builder((entry) => entry.widget));
  }

  void disposeFocusNode() {
    focusNode.removeListener(listener);
    focusNode.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    disposeFocusNode();
  }
}

/// [Widget] 装饰器
class DecoratorBox extends StatelessWidget {
  const DecoratorBox({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.extraPrefix,
    this.extraSuffix,
    this.prefix,
    this.suffix,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.borderType = BorderType.none,
    this.fillColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.margin,
    this.padding,
    this.borderSide = const BorderSide(),
    this.constraints,
  });

  final Widget child;

  /// 作用于整个组件
  final BoxConstraints? constraints;

  /// [child] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? extraPrefix;
  final Widget? extraSuffix;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? prefix;
  final Widget? suffix;

  /// 仅作用于 [child]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [child] 与 [extraPrefix]、[extraSuffix] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [child] 边框类型
  final BorderType borderType;

  /// [child] 边框样式
  final BorderSide borderSide;

  /// [child] 填充色
  final Color? fillColor;

  /// [child] 圆角
  final BorderRadius? borderRadius;

  /// [child] 阴影
  final List<BoxShadow>? boxShadow;

  /// [child] 渐变色
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    Widget current = buildCurrent;
    if (extraPrefix != null || extraSuffix != null) {
      final List<Widget> row = <Widget>[];
      if (extraPrefix != null) row.add(extraPrefix!);
      row.add(Expanded(child: current));
      if (extraSuffix != null) row.add(extraSuffix!);
      current = Row(crossAxisAlignment: crossAxisAlignment, children: row);
    }

    if (header != null || footer != null) {
      final List<Widget> children = <Widget>[];
      if (header != null) children.add(header!);
      children.add(current);
      if (footer != null) children.add(footer!);
      current = Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return current;
  }

  Widget get buildCurrent {
    Widget current = child;
    Border? border = borderType.value(borderSide);
    Decoration? decoration;
    if (border != null ||
        fillColor != null ||
        boxShadow != null ||
        borderRadius != null ||
        gradient != null) {
      decoration = BoxDecoration(
          border: border,
          color: fillColor,
          borderRadius:
              borderType == BorderType.underline ? null : borderRadius,
          gradient: gradient,
          boxShadow: boxShadow);
    }
    final List<Widget> children = [current.expandedNull];
    if (prefix != null) children.insert(0, prefix!);
    if (suffix != null) children.add(suffix!);
    current = Universal(
        decoration: decoration,
        constraints: constraints,
        borderRadius: borderRadius,
        isClipRRect: borderRadius != null,
        margin: margin,
        padding: padding,
        direction: Axis.horizontal,
        child: children.length > 1 ? null : current,
        children: children.length > 1 ? children : null);
    return current;
  }
}
