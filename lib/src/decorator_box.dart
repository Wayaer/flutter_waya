import 'package:flutter/material.dart';

extension ExtensionWidgetDecoratorBox on Widget {
  DecoratorPendant toDecoratorPendant({
    DecoratorPendantPosition positioned = DecoratorPendantPosition.outer,
    DecoratorPendantVisibilityMode mode = DecoratorPendantVisibilityMode.always,
    bool maintainSize = false,
  }) =>
      DecoratorPendant(
          widget: this,
          maintainSize: maintainSize,
          positioned: positioned,
          mode: mode);
}

enum DecoratorPendantPosition {
  /// 在 Border 内部
  inner,

  /// 在 Border 外部
  outer,
}

enum BorderType {
  /// outline
  outline,

  /// underline
  underline,

  /// none
  none,
  ;

  /// BorderType to Border
  Border? toBorder([BorderSide? borderSide]) {
    borderSide ??= const BorderSide();
    switch (this) {
      case BorderType.outline:
        return Border.fromBorderSide(borderSide);
      case BorderType.underline:
        return Border(bottom: borderSide);
      case BorderType.none:
        return null;
    }
  }

  ///BorderType to InputBorder
  InputBorder toInputBorder({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double gapPadding = 4.0,
  }) {
    borderSide ??= const BorderSide();
    borderRadius ??= const BorderRadius.all(Radius.circular(4.0));
    switch (this) {
      case BorderType.outline:
        return OutlineInputBorder(
            gapPadding: gapPadding,
            borderRadius: borderRadius,
            borderSide: borderSide);
      case BorderType.underline:
        borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0));
        return UnderlineInputBorder(
            borderRadius: borderRadius, borderSide: borderSide);
      case BorderType.none:
        return InputBorder.none;
    }
  }
}

enum DecoratorPendantVisibilityMode {
  /// 从不显示
  never,

  /// 只在焦点时显示
  focused,

  /// 只在失去焦点时显示
  unfocused,

  /// 只在焦点时显示
  editing,

  /// 只在失去焦点时显示
  notEditing,

  /// 一直显示
  always,
}

typedef DecoratorPendantBuilder = Widget Function(
    DecoratorPendantPosition positioned,
    DecoratorPendantVisibilityMode mode,
    bool maintainSize);

/// Decorator Pendant
class DecoratorPendant {
  const DecoratorPendant(
      {this.widget,
      this.builder,
      this.positioned = DecoratorPendantPosition.inner,
      this.maintainSize = false,
      this.mode = DecoratorPendantVisibilityMode.always})
      : assert(widget != null || builder != null);

  /// 显示的位置
  final DecoratorPendantPosition positioned;

  /// 叠加可见性模式
  final DecoratorPendantVisibilityMode mode;

  /// 保持占位
  final bool maintainSize;

  /// 要显示的 widget
  final Widget? widget;

  /// 要显示的 builder
  final DecoratorPendantBuilder? builder;
}

/// [DecoratorBox] 样式
class BoxDecorative {
  const BoxDecorative({
    this.shape,
    this.borderType = BorderType.none,
    this.borderRadius,
    this.borderSide,
    this.focusedBorderSide,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.fillColor,
    this.boxShadow,
    this.gradient,
    this.constraints,
  });

  /// 仅作用于 [DecoratorBox.child]
  final EdgeInsetsGeometry? padding;

  /// [DecoratorBox.child] 与 [extraPrefix]、[extraSuffix] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [DecoratorBox.child] 边框类型
  final BorderType borderType;

  /// [DecoratorBox.child] 边框样式
  final BorderSide? borderSide;

  /// [DecoratorBox.child] 有焦点时的边框样式
  final BorderSide? focusedBorderSide;

  /// [DecoratorBox.child] 填充色
  final Color? fillColor;

  /// [DecoratorBox.child] 圆角
  final BorderRadius? borderRadius;

  /// [DecoratorBox.child] 阴影
  final List<BoxShadow>? boxShadow;

  /// [DecoratorBox.child] 形状
  final BoxShape? shape;

  /// [DecoratorBox.child] 渐变色
  final Gradient? gradient;

  /// [DecoratorBox] 约束
  final BoxConstraints? constraints;
}

/// [Widget] 装饰器
class DecoratorBox extends StatelessWidget {
  const DecoratorBox({
    super.key,
    required this.child,
    this.headers = const [],
    this.footers = const [],
    this.suffixes = const [],
    this.prefixes = const [],
    this.expand = true,
    this.hasFocus = false,
    this.isEditing = false,
    this.decoration = const BoxDecorative(),
  });

  final Widget child;

  /// [child] 头部
  final List<DecoratorPendant> headers;

  /// [child] 尾部
  final List<DecoratorPendant> footers;

  /// [child] 前缀
  final List<DecoratorPendant> suffixes;

  /// [child] 后缀
  final List<DecoratorPendant> prefixes;

  /// [DecoratorBox] 样式
  final BoxDecorative decoration;

  /// 是否 expand
  final bool expand;

  /// 是否有焦点
  final bool hasFocus;

  /// 是否编辑中
  final bool isEditing;

  Widget? buildDecoratorPendant(
      List<DecoratorPendant> list, DecoratorPendantPosition positioned) {
    final listPendant =
        list.where((element) => element.positioned == positioned);
    if (listPendant.isEmpty) return null;
    Widget? buildVisibilityPendant(DecoratorPendant pendant) {
      if (pendant.builder != null) {
        return pendant.builder!(
            pendant.positioned, pendant.mode, pendant.maintainSize);
      }
      if (pendant.widget != null) {
        Widget buildVisibility(bool visible) => Visibility(
            visible: visible,
            maintainAnimation: pendant.maintainSize,
            maintainState: pendant.maintainSize,
            maintainSize: pendant.maintainSize,
            child: pendant.widget!);
        switch (pendant.mode) {
          case DecoratorPendantVisibilityMode.never:
            return buildVisibility(false);
          case DecoratorPendantVisibilityMode.always:
            return buildVisibility(true);
          case DecoratorPendantVisibilityMode.focused:
            return buildVisibility(hasFocus);
          case DecoratorPendantVisibilityMode.unfocused:
            return buildVisibility(!hasFocus);
          case DecoratorPendantVisibilityMode.editing:
            return buildVisibility(isEditing);
          case DecoratorPendantVisibilityMode.notEditing:
            return buildVisibility(!isEditing);
        }
      }
      return null;
    }

    if (listPendant.length == 1) {
      return buildVisibilityPendant(listPendant.first);
    }
    List<Widget> children = [];
    for (var e in listPendant) {
      final widget = buildVisibilityPendant(e);
      if (widget != null) {
        children.add(widget);
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    final outerHeader =
        buildDecoratorPendant(headers, DecoratorPendantPosition.outer);
    final outerPrefix =
        buildDecoratorPendant(prefixes, DecoratorPendantPosition.outer);
    final outerSuffix =
        buildDecoratorPendant(suffixes, DecoratorPendantPosition.outer);
    final outerFooter =
        buildDecoratorPendant(footers, DecoratorPendantPosition.outer);
    Widget current = buildInner;
    if (outerPrefix != null || outerSuffix != null) {
      current = Row(mainAxisSize: MainAxisSize.min, children: [
        if (outerPrefix != null) outerPrefix,
        expand ? Expanded(child: current) : current,
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

  Widget get buildInner {
    final innerHeader =
        buildDecoratorPendant(headers, DecoratorPendantPosition.inner);
    final innerPrefix =
        buildDecoratorPendant(prefixes, DecoratorPendantPosition.inner);
    final innerSuffix =
        buildDecoratorPendant(suffixes, DecoratorPendantPosition.inner);
    final innerFooter =
        buildDecoratorPendant(footers, DecoratorPendantPosition.inner);
    Widget current = child;

    if (innerPrefix != null || innerSuffix != null) {
      current = Row(mainAxisSize: MainAxisSize.min, children: [
        if (innerPrefix != null) innerPrefix,
        expand ? Expanded(child: current) : current,
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
    Decoration? boxDecoration;
    final border = decoration.borderType.toBorder(
        hasFocus ? decoration.focusedBorderSide : decoration.borderSide);
    if (decoration.fillColor != null ||
        decoration.gradient != null ||
        decoration.boxShadow != null ||
        border != null) {
      boxDecoration = BoxDecoration(
          color: decoration.fillColor,
          border: border,
          borderRadius: decoration.borderType == BorderType.outline
              ? decoration.borderRadius
              : null,
          gradient: decoration.gradient,
          boxShadow: decoration.boxShadow);
    }
    current = Container(
        decoration: boxDecoration,
        constraints: decoration.constraints,
        padding: decoration.padding,
        child: current);

    if (decoration.borderRadius != null) {
      current =
          ClipRRect(borderRadius: decoration.borderRadius!, child: current);
    }
    return current;
  }
}

typedef DecoratorBoxStateCallback = bool Function();

class DecoratorBoxState extends StatelessWidget {
  const DecoratorBoxState(
      {super.key,
      required this.listenable,
      required this.child,
      this.onFocus,
      this.onEditing,
      this.headers = const [],
      this.footers = const [],
      this.suffixes = const [],
      this.prefixes = const [],
      this.decoration = const BoxDecorative(),
      this.expand = true});

  final Widget child;

  /// [Listenable] 监听
  final Listenable listenable;

  /// 是否有焦点监听
  final DecoratorBoxStateCallback? onFocus;

  /// 是否在编辑中
  final DecoratorBoxStateCallback? onEditing;

  /// [child] 头部
  final List<DecoratorPendant> headers;

  /// [child] 尾部
  final List<DecoratorPendant> footers;

  /// [child] 前缀
  final List<DecoratorPendant> suffixes;

  /// [child] 后缀
  final List<DecoratorPendant> prefixes;

  /// [DecoratorBox] 样式
  final BoxDecorative decoration;

  /// 是否 expand
  final bool expand;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: listenable,
      builder: (BuildContext context, Widget? child) => DecoratorBox(
          hasFocus: onFocus?.call() ?? false,
          isEditing: onEditing?.call() ?? false,
          decoration: decoration,
          footers: footers,
          headers: headers,
          prefixes: prefixes,
          suffixes: suffixes,
          expand: expand,
          child: child!),
      child: child);
}
