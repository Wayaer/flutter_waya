import 'package:flutter/material.dart';

extension ExtensionWidgetDecoratorBox on Widget {
  DecoratorPendant toDecoratorPendant({
    DecoratorPendantPosition positioned = DecoratorPendantPosition.outer,
    bool maintainSize = false,
    bool? needFocus,
    bool? needEditing,
  }) =>
      DecoratorPendant(
          child: this,
          maintainSize: maintainSize,
          positioned: positioned,
          needEditing: needEditing,
          needFocus: needFocus);
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
    if (borderSide == null) return null;
    switch (this) {
      case BorderType.outline:
        return Border.fromBorderSide(borderSide);
      case BorderType.underline:
        return Border(bottom: borderSide);
      case BorderType.none:
        return null;
    }
  }

  /// BorderType to InputBorder
  InputBorder toInputBorder({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    double gapPadding = 4.0,
  }) {
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

typedef DecoratorPendantBuilder = Widget Function(
    bool hasFocus, bool isEditing);

/// Decorator Pendant
class DecoratorPendant {
  const DecoratorPendant({
    this.child,
    this.builder,
    this.needFocus,
    this.needEditing,
    this.positioned = DecoratorPendantPosition.inner,
    this.maintainSize = false,
  }) : assert(child != null || builder != null);

  /// 显示的位置
  final DecoratorPendantPosition positioned;

  /// 保持占位
  final bool maintainSize;

  /// 要显示的 [builder] 会覆盖 [child]
  final DecoratorPendantBuilder? builder;

  /// 要显示的 widget
  final Widget? child;

  /// 是否需要编辑状态(输入框是否有内容)
  /// [needEditing] == nul 无需判断 是否编辑状态
  final bool? needEditing;

  /// 是否需要焦点
  /// [needFocus] == null 无需判断 是否有焦点
  final bool? needFocus;
}

/// [DecoratorBox] 样式
class BoxDecorative {
  const BoxDecorative({
    this.shape,
    this.borderType = BorderType.none,
    this.borderRadius,
    this.borderSide,
    this.padding,
    this.fillColor,
    this.boxShadow,
    this.gradient,
    this.constraints,
  });

  /// 仅作用于 [DecoratorBox.child]
  final EdgeInsetsGeometry? padding;

  /// [DecoratorBox.child] 边框类型
  final BorderType borderType;

  /// [DecoratorBox.child] 边框样式
  final BorderSide? borderSide;

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

  BoxDecorative copyWith({
    BorderType? borderType,
    BorderSide? borderSide,
    Color? fillColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    BoxShape? shape,
    Gradient? gradient,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
  }) =>
      BoxDecorative(
        borderType: borderType ?? this.borderType,
        borderSide: borderSide ?? this.borderSide,
        fillColor: fillColor ?? this.fillColor,
        borderRadius: borderRadius ?? this.borderRadius,
        boxShadow: boxShadow ?? this.boxShadow,
        shape: shape ?? this.shape,
        gradient: gradient ?? this.gradient,
        constraints: constraints ?? this.constraints,
        padding: padding ?? this.padding,
      );

  BoxDecorative merge(BoxDecorative? other) => copyWith(
        borderType: other?.borderType,
        borderSide: other?.borderSide,
        fillColor: other?.fillColor,
        borderRadius: other?.borderRadius,
        boxShadow: other?.boxShadow,
        shape: other?.shape,
        gradient: other?.gradient,
        constraints: other?.constraints,
        padding: other?.padding,
      );

  /// to [BoxDecoration]
  BoxDecoration toBoxDecoration() => BoxDecoration(
        color: fillColor,
        border: borderType.toBorder(borderSide),
        borderRadius: borderRadius,
        gradient: gradient,
        boxShadow: boxShadow,
      );
}

typedef DecoratorBoxDecorativeBuilder = BoxDecorative Function(
    bool hasFocus, bool isEditing);

/// [Widget] 装饰器
class DecoratorBox extends StatelessWidget {
  const DecoratorBox({
    super.key,
    required this.child,
    this.headers = const [],
    this.footers = const [],
    this.suffixes = const [],
    this.prefixes = const [],
    this.expanded = true,
    this.hasFocus = false,
    this.isEditing = false,
    this.decoration,
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
  final DecoratorBoxDecorativeBuilder? decoration;

  /// 是否 [Expanded]
  final bool expanded;

  /// 是否有焦点
  final bool hasFocus;

  /// 是否编辑中
  final bool isEditing;

  Widget? buildDecoratorPendant(
      List<DecoratorPendant> list, DecoratorPendantPosition positioned) {
    final listPendant =
        list.where((element) => element.positioned == positioned);
    if (listPendant.isEmpty) return null;
    Widget buildVisibilityPendant(DecoratorPendant pendant) {
      if (pendant.builder != null) {
        return Visibility(
            maintainAnimation: pendant.maintainSize,
            maintainState: pendant.maintainSize,
            maintainSize: pendant.maintainSize,
            child: pendant.builder!(hasFocus, isEditing));
      }

      bool isEditingVisible = true;
      bool isHasFocusVisible = true;

      if (pendant.needEditing != null) {
        isEditingVisible = pendant.needEditing == isEditing;
      }
      if (pendant.needFocus != null) {
        isHasFocusVisible = pendant.needFocus == hasFocus;
      }
      return Visibility(
          visible: isEditingVisible && isHasFocusVisible,
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
        children: listPendant.map((e) => buildVisibilityPendant(e)).toList());
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
    return buildDecoration(current);
  }

  Widget buildDecoration(Widget current) {
    final currentDecoration = decoration?.call(hasFocus, isEditing);
    if (currentDecoration != null) {
      current = Container(
          decoration: currentDecoration.toBoxDecoration(),
          constraints: currentDecoration.constraints,
          padding: currentDecoration.padding,
          child: current);
      if (currentDecoration.borderRadius != null) {
        current = ClipRRect(
            borderRadius: currentDecoration.borderRadius!, child: current);
      }
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
      this.decoration,
      this.expanded = true});

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
  final DecoratorBoxDecorativeBuilder? decoration;

  /// 是否 [Expanded]
  final bool expanded;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: listenable,
      builder: (BuildContext context, Widget? child) => DecoratorBox(
          hasFocus: onFocus?.call() ?? false,
          isEditing: onEditing?.call() ?? false,
          decoration: decoration,
          footers: footers,
          headers: headers,
          prefixes: prefixes,
          suffixes: suffixes,
          expanded: expanded,
          child: child!),
      child: child);
}
