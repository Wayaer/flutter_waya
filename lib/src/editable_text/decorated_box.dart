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

class UnderlineDecoratorBorder extends UnderlineInputBorder {
  const UnderlineDecoratorBorder(
      {super.borderSide = const BorderSide(),
      super.borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))});
}

class OutlineDecoratorBorder extends OutlineInputBorder {
  const OutlineDecoratorBorder({
    super.borderSide = const BorderSide(),
    super.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  });
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

/// [DecoratorBox] 样式
class FlBoxDecoration extends InputDecoration {
  const FlBoxDecoration({
    // this.borderType = BorderType.none,
    // this.borderRadius,
    // this.borderSide = const BorderSide(),
    // this.border,
    this.margin,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    // this.fillColor,
    // this.boxShadow,
    // this.gradient,
    // this.constraints,
  });

  /// 仅作用于 [DecoratorBox.child]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [DecoratorBox.child] 与 [extraPrefix]、[extraSuffix] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [DecoratorBox.child] 边框类型
// final BorderType borderType;

  /// [DecoratorBox.child] 边框样式
// final BorderSide borderSide;

  /// [DecoratorBox.child] 圆角
// final BorderRadius? borderRadius;

  /// [DecoratorBox.child] 边框
// final InputBorder? border;

  /// [DecoratorBox.child] 填充色
// final Color? fillColor;

  /// [DecoratorBox.child] 阴影
// final List<BoxShadow>? boxShadow;

  /// [DecoratorBox.child] 渐变色
// final Gradient? gradient;

  /// [DecoratorBox] 约束
// final BoxConstraints? constraints;
}

typedef DecoratorBoxStateBuilder = Widget Function(FocusNode focusNode);

/// [Widget] 装饰器 动态焦点样式
class DecoratorBoxState extends StatefulWidget {
  const DecoratorBoxState({
    super.key,
    required this.child,
    required this.focusNode,
    this.suffixes = const [],
    this.prefixes = const [],
    this.decoration = const FlBoxDecoration(
        // borderType: BorderType.outline,
        // borderSide: BorderSide(color: Colors.black),
        ),
    this.focusBorderSide,
    this.header,
    this.footer,
    this.disposeFocusNode = false,
  }) : builder = null;

  const DecoratorBoxState.builder({
    super.key,
    required this.builder,
    required this.focusNode,
    this.suffixes = const [],
    this.prefixes = const [],
    this.decoration = const FlBoxDecoration(
      // borderType: BorderType.outline,
      // borderSide: BorderSide(color: Colors.black),
    ),
    this.focusBorderSide,
    this.header,
    this.footer,
    this.disposeFocusNode = false,
  })  : assert(builder != null),
        child = null;

  /// [TextField]
  final Widget? child;

  /// builder [TextField]
  final DecoratorBoxStateBuilder? builder;

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

  /// [DecoratorBox] 装饰器
  final FlBoxDecoration decoration;

  @override
  State<DecoratorBoxState> createState() => _DecoratorBoxStateState();
}

class _DecoratorBoxStateState extends ExtendedState<DecoratorBoxState> {
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
  void didUpdateWidget(covariant DecoratorBoxState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      disposeFocusNode(oldWidget.focusNode);
      initFocusNode();
    }
  }

  void initFocusNode() {
    hasFocus = widget.focusNode.hasFocus;
    // borderSide = widget.decoration.borderSide;
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
    // if (hasFocus == widget.focusNode.hasFocus ||
    //     (widget.decoration.borderType == BorderType.none && !hasEditing)) {
    //   return;
    // }
    // hasFocus = widget.focusNode.hasFocus;
    // if (widget.focusBorderSide != null) {
    //   borderSide =
    //       hasFocus ? widget.focusBorderSide! : widget.decoration.borderSide;
    // }
    // focusNodeUpdate.value = !focusNodeUpdate.value;
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.child ??
        widget.builder?.call(widget.focusNode) ??
        const SizedBox();
    return DecoratorBox(
        decoration: widget.decoration,
        // header: widget.header,
        // footer: widget.footer,
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
class DecoratorBox extends StatelessWidget {
  const DecoratorBox({
    super.key,
    required this.child,
    this.extraPrefix,
    this.extraSuffix,
    this.prefix,
    this.suffix,
    this.decoration = const FlBoxDecoration(),
  });

  final Widget child;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? extraPrefix;
  final Widget? extraSuffix;

  /// [child] 左右两遍的挂件 在[Border] 内部
  final Widget? prefix;
  final Widget? suffix;

  /// [DecoratorBox] 样式
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
    return current;
  }

  Widget get buildCurrent {
    Widget current = child;
    final List<Widget> children = [Expanded(child: current)];
    if (prefix != null) children.insert(0, prefix!);
    if (suffix != null) children.add(suffix!);
    current = Container(
        margin: decoration.margin,
        padding: decoration.padding,
        child: children.length > 1 ? Row(children: children) : current);
    return InputDecorator(decoration: decoration, child: current);
  }
}
