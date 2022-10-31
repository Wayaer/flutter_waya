part of 'popup.dart';

class ModalWindowsOptions {
  const ModalWindowsOptions(
      {this.top,
      this.left,
      this.right,
      this.bottom,
      this.alignment = Alignment.center,
      this.gaussian = false,
      this.addMaterial = false,
      this.ignoring = false,
      this.absorbing = false,
      this.fuzzyDegree = 4,
      this.mainAxisSize = MainAxisSize.min,
      this.color,
      this.behavior = HitTestBehavior.opaque,
      this.onTap,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.direction = Axis.vertical,
      this.isScroll = false,
      this.isStack = false,
      this.blendMode = BlendMode.srcOver,
      this.filter,
      this.constraints});

  /// 背景点击事件
  final GestureTapCallback? onTap;

  /// HitTestBehavior.opaque 自己处理事件
  /// HitTestBehavior.deferToChild child处理事件
  /// HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  /// 背景色
  final Color? color;

  /// 是否忽略子组件点击事件响应背景点击事件 默认 false
  final bool ignoring;

  /// 是否吸收子组件的点击事件且不响应背景点击事件 默认 false
  /// [onTap] != null 时  无效
  final bool absorbing;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  /// [filter]!=null 时 [fuzzyDegree] 无效
  /// [gaussian] 必须为 true
  final ImageFilter? filter;

  /// 是否开始背景模糊
  final bool gaussian;

  /// 模糊程度 0-100
  /// [gaussian] 必须为 true
  final double fuzzyDegree;
  final BlendMode blendMode;

  /// 底层子组件定位
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final AlignmentGeometry? alignment;

  //// [children] 不为null 时以下参数有效
  /// ****** Flex ******  ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final MainAxisSize mainAxisSize;

  /// ****** SingleChildScrollView ******  ///
  final bool isScroll;

  /// ****** Stack ******  ///
  final bool isStack;

  final BoxConstraints? constraints;

  ModalWindowsOptions copyWith({
    GestureTapCallback? onTap,
    HitTestBehavior? behavior,
    Color? color,
    bool? ignoring,
    bool? absorbing,
    bool? addMaterial,
    ImageFilter? filter,
    bool? gaussian,
    double? fuzzyDegree,
    double? left,
    double? top,
    double? right,
    double? bottom,
    AlignmentGeometry? alignment,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    Axis? direction,
    MainAxisSize? mainAxisSize,
    bool? isScroll,
    bool? isStack,
    BoxConstraints? constraints,
  }) =>
      ModalWindowsOptions(
          constraints: constraints ?? this.constraints,
          onTap: onTap ?? this.onTap,
          behavior: behavior ?? this.behavior,
          color: color ?? this.color,
          ignoring: ignoring ?? this.ignoring,
          absorbing: absorbing ?? this.absorbing,
          addMaterial: addMaterial ?? this.addMaterial,
          filter: filter ?? this.filter,
          gaussian: gaussian ?? this.gaussian,
          fuzzyDegree: fuzzyDegree ?? this.fuzzyDegree,
          left: left ?? this.left,
          top: top ?? this.top,
          right: right ?? this.right,
          bottom: bottom ?? this.bottom,
          alignment: alignment ?? this.alignment,
          mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
          direction: direction ?? this.direction,
          mainAxisSize: mainAxisSize ?? this.mainAxisSize,
          isScroll: isScroll ?? this.isScroll,
          isStack: isStack ?? this.isStack);
}

/// 模态框背景
class PopupModalWindows extends StatelessWidget {
  PopupModalWindows(
      {super.key,
      this.onWillPop,
      this.children,
      this.child,
      ModalWindowsOptions? options})
      : options = options ?? GlobalOptions().modalWindowsOptions;

  /// 顶层组件
  final Widget? child;
  final List<Widget>? children;

  /// Android 监听物理返回按键
  final WillPopCallback? onWillPop;

  /// 弹框最底层配置
  final ModalWindowsOptions options;

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget;
    if (options.gaussian) child = backdropFilter(child);
    if (options.addMaterial) {
      child = Material(
          color: Colors.transparent,
          child: MediaQuery(
              data: MediaQueryData.fromWindow(window), child: child));
    }
    if (options.ignoring) {
      child = IgnorePointer(child: child);
    } else if (options.onTap == null && options.absorbing) {
      child = AbsorbPointer(child: child);
    }
    if (onWillPop != null) WillPopScope(onWillPop: onWillPop, child: child);
    return child;
  }

  Widget backdropFilter(Widget child) => BackdropFilter(
      blendMode: options.blendMode,
      filter: options.filter ??
          ImageFilter.blur(
              sigmaX: options.fuzzyDegree, sigmaY: options.fuzzyDegree),
      child: child);

  Widget get childWidget => Universal(
      color: options.color,
      onTap: options.onTap,
      behavior: options.behavior,
      alignment: options.alignment,
      left: options.isStack ? options.left : null,
      top: options.isStack ? options.top : null,
      right: options.isStack ? options.right : null,
      bottom: options.isStack ? options.bottom : null,
      padding: edgeInsets,
      constraints: options.constraints,
      direction: options.direction,
      isScroll: options.isScroll,
      isStack: options.isStack,
      mainAxisSize: options.mainAxisSize,
      mainAxisAlignment: options.mainAxisAlignment,
      crossAxisAlignment: options.crossAxisAlignment,
      child: child,
      children: children);

  EdgeInsets? get edgeInsets {
    if (options.isStack == false &&
        (options.left != null ||
            options.top != null ||
            options.right != null ||
            options.bottom != null)) {
      return EdgeInsets.fromLTRB(options.left ?? 0, options.top ?? 0,
          options.right ?? 0, options.bottom ?? 0);
    }
    return null;
  }
}

class PopupDoubleChooseWindows extends StatelessWidget {
  const PopupDoubleChooseWindows({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    required this.content,
    this.padding,
    this.left,
    this.right,
    this.decoration,
    this.options,
  });

  /// 弹框内容
  final Widget content;

  /// 弹框背景色
  final Color? backgroundColor;

  /// 弹框 padding
  final EdgeInsetsGeometry? padding;

  /// 左边按钮
  final Widget? left;

  /// 右边按钮
  final Widget? right;

  final double? width;
  final double? height;

  /// 弹框样式
  final Decoration? decoration;

  /// 底层模态框配置
  final ModalWindowsOptions? options;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [content];
    if (left != null && right != null) widgets.add(leftAndRight);
    var options = this.options ?? GlobalOptions().modalWindowsOptions;
    if (context.mediaQuery.size.width > 400) {
      options =
          options.copyWith(constraints: const BoxConstraints(maxWidth: 350));
    } else {
      options = options.copyWith(
          left: options.left ?? 30, right: options.right ?? 30);
    }
    options = options.copyWith(
        isScroll: false,
        isStack: false,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min);
    return PopupModalWindows(options: options, children: [
      Universal(
          width: width,
          height: height,
          constraints: options.constraints,
          onTap: () {},
          decoration: decoration ??
              BoxDecoration(
                  color:
                      backgroundColor ?? context.theme.dialogBackgroundColor),
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: widgets)
    ]);
  }

  Widget get leftAndRight =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(child: left!),
        Expanded(child: right!),
      ]);
}
