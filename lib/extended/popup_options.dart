import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    SnackBar snackBar) {
  assert(GlobalWayUI().scaffoldMessengerKey.currentState != null,
      'Set GlobalWayUI().scaffoldMessengerKey to the MaterialApp');
  return GlobalWayUI()
      .scaffoldMessengerKey
      .currentState
      ?.showSnackBar(snackBar);
}

Future<T?> showMenuPopup<T>({
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) {
  assert(GlobalWayUI().navigatorKey.currentContext != null);
  return showMenu(
      context: GlobalWayUI().navigatorKey.currentContext!,
      position: position,
      useRootNavigator: useRootNavigator,
      initialValue: initialValue,
      elevation: elevation,
      semanticLabel: semanticLabel,
      shape: shape,
      color: color,
      items: items);
}

/// 关闭弹窗
/// 也可以通过 Navigator.of(context).maybePop()
Future<bool> closePopup([dynamic value]) => maybePop(value);

/// 弹窗进入方向属性
enum PopupFromStyle {
  /// 从左边进入
  fromLeft,

  /// 从右边进入
  fromRight,

  /// 从头部进入
  fromTop,

  /// 从底部进入
  fromBottom,

  /// 默认渐变显示
  fromCenter,
}

abstract class GeneralModalOptions {
  const GeneralModalOptions({
    this.useRootNavigator = true,
    this.barrierColor = kCupertinoModalBarrierColor,
    this.barrierDismissible = true,
    this.anchorPoint,
    this.routeSettings,
  });

  final bool useRootNavigator;
  final RouteSettings? routeSettings;

  /// 背景颜色
  final Color barrierColor;

  /// [barrierDismissible] = true  默认为 true 可关闭
  final bool barrierDismissible;

  final Offset? anchorPoint;
}

/// 关闭 [closePopup]
class DialogOptions extends GeneralModalOptions {
  const DialogOptions({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.barrierLabel = '',
    this.useSafeArea = true,
    this.startOffset,
    this.transitionBuilder,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.fromStyle = PopupFromStyle.fromCenter,
  });

  const DialogOptions.cupertino({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.barrierLabel = '',
  })  : useSafeArea = true,
        startOffset = null,
        fromStyle = PopupFromStyle.fromCenter,
        transitionDuration = const Duration(milliseconds: 200),
        transitionBuilder = null;

  const DialogOptions.material({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.anchorPoint,
    this.barrierLabel = '',
    this.useSafeArea = true,
  })  : startOffset = null,
        fromStyle = PopupFromStyle.fromCenter,
        transitionDuration = const Duration(milliseconds: 200),
        transitionBuilder = null,
        super(barrierColor: kCupertinoModalBarrierColor);

  /// 语义化
  final String barrierLabel;

  final bool useSafeArea;

  /// 进入方向的距离
  final double? startOffset;

  /// popup 进入的方向
  final PopupFromStyle fromStyle;

  /// 这个是从开始到完全显示的时间
  final Duration transitionDuration;

  /// 路由显示和隐藏的过程 这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  final RouteTransitionsBuilder? transitionBuilder;

  DialogOptions copyWith({
    double? startOffset,
    PopupFromStyle? fromStyle,
    bool? barrierDismissible,
    String? barrierLabel,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionBuilder,
    bool? useRootNavigator,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    bool? useSafeArea,
  }) =>
      DialogOptions(
          useSafeArea: useSafeArea ?? this.useSafeArea,
          anchorPoint: anchorPoint ?? this.anchorPoint,
          startOffset: startOffset ?? this.startOffset,
          fromStyle: fromStyle ?? this.fromStyle,
          barrierDismissible: barrierDismissible ?? this.barrierDismissible,
          barrierLabel: barrierLabel ?? this.barrierLabel,
          barrierColor: barrierColor ?? this.barrierColor,
          transitionDuration: transitionDuration ?? this.transitionDuration,
          transitionBuilder: transitionBuilder ?? this.transitionBuilder,
          useRootNavigator: useRootNavigator ?? this.useRootNavigator,
          routeSettings: routeSettings ?? this.routeSettings);

  DialogOptions merge([DialogOptions? options]) => DialogOptions(
      useSafeArea: options?.useSafeArea ?? useSafeArea,
      anchorPoint: options?.anchorPoint ?? anchorPoint,
      startOffset: options?.startOffset ?? startOffset,
      fromStyle: options?.fromStyle ?? fromStyle,
      barrierDismissible: options?.barrierDismissible ?? barrierDismissible,
      barrierLabel: options?.barrierLabel ?? barrierLabel,
      barrierColor: options?.barrierColor ?? barrierColor,
      transitionDuration: options?.transitionDuration ?? transitionDuration,
      transitionBuilder: options?.transitionBuilder ?? transitionBuilder,
      useRootNavigator: options?.useRootNavigator ?? useRootNavigator,
      routeSettings: options?.routeSettings ?? routeSettings);
}

class BottomSheetOptions extends GeneralModalOptions {
  const BottomSheetOptions({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.transitionAnimationController,
    this.enableDrag = true,
    this.isScrollControlled = true,
    this.constraints,
  });

  /// BottomSheet 背景色
  final Color? backgroundColor;

  /// 底部阴影
  final double? elevation;

  final ShapeBorder? shape;

  final Clip? clipBehavior;

  /// 开启滑动关闭 默认[true]
  final bool enableDrag;

  /// [isScrollControlled] = true 可全屏显示 默认 [true]
  final bool isScrollControlled;

  final BoxConstraints? constraints;

  final AnimationController? transitionAnimationController;

  BottomSheetOptions copyWith({
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? barrierDismissible,
    bool? enableDrag,
    bool? isScrollControlled,
    RouteSettings? routeSettings,
    bool? useRootNavigator,
    AnimationController? transitionAnimationController,
    BoxConstraints? constraints,
    Offset? anchorPoint,
  }) =>
      BottomSheetOptions(
          anchorPoint: anchorPoint ?? this.anchorPoint,
          constraints: constraints ?? this.constraints,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          elevation: elevation ?? this.elevation,
          shape: shape ?? this.shape,
          clipBehavior: clipBehavior ?? this.clipBehavior,
          barrierColor: barrierColor ?? this.barrierColor,
          barrierDismissible: barrierDismissible ?? this.barrierDismissible,
          enableDrag: enableDrag ?? this.enableDrag,
          isScrollControlled: isScrollControlled ?? this.isScrollControlled,
          routeSettings: routeSettings ?? this.routeSettings,
          useRootNavigator: useRootNavigator ?? this.useRootNavigator,
          transitionAnimationController: transitionAnimationController ??
              this.transitionAnimationController);

  BottomSheetOptions merge([BottomSheetOptions? options]) => BottomSheetOptions(
      anchorPoint: options?.anchorPoint ?? anchorPoint,
      constraints: options?.constraints ?? constraints,
      backgroundColor: options?.backgroundColor ?? backgroundColor,
      elevation: options?.elevation ?? elevation,
      shape: options?.shape ?? shape,
      clipBehavior: options?.clipBehavior ?? clipBehavior,
      barrierColor: options?.barrierColor ?? barrierColor,
      barrierDismissible: options?.barrierDismissible ?? barrierDismissible,
      enableDrag: options?.enableDrag ?? enableDrag,
      isScrollControlled: options?.isScrollControlled ?? isScrollControlled,
      routeSettings: options?.routeSettings ?? routeSettings,
      useRootNavigator: options?.useRootNavigator ?? useRootNavigator,
      transitionAnimationController: options?.transitionAnimationController ??
          transitionAnimationController);
}

class CupertinoModalPopupOptions extends GeneralModalOptions {
  const CupertinoModalPopupOptions({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.filter,
    this.semanticsDismissible = false,
  });

  final ImageFilter? filter;

  final bool semanticsDismissible;

  CupertinoModalPopupOptions copyWith({
    Color? barrierColor,
    bool? barrierDismissible,
    RouteSettings? routeSettings,
    bool? useRootNavigator,
    Offset? anchorPoint,
    ImageFilter? filter,
    bool? semanticsDismissible,
  }) =>
      CupertinoModalPopupOptions(
          barrierDismissible: barrierDismissible ?? this.barrierDismissible,
          useRootNavigator: useRootNavigator ?? this.useRootNavigator,
          routeSettings: routeSettings ?? this.routeSettings,
          barrierColor: barrierColor ?? this.barrierColor,
          anchorPoint: anchorPoint ?? this.anchorPoint,
          filter: filter ?? this.filter,
          semanticsDismissible:
              semanticsDismissible ?? this.semanticsDismissible);

  CupertinoModalPopupOptions merge([CupertinoModalPopupOptions? options]) =>
      CupertinoModalPopupOptions(
          barrierDismissible: options?.barrierDismissible ?? barrierDismissible,
          useRootNavigator: options?.useRootNavigator ?? useRootNavigator,
          routeSettings: options?.routeSettings ?? routeSettings,
          barrierColor: options?.barrierColor ?? barrierColor,
          anchorPoint: options?.anchorPoint ?? anchorPoint,
          filter: options?.filter ?? filter,
          semanticsDismissible:
              options?.semanticsDismissible ?? semanticsDismissible);
}

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

  /// [children] 不为null 时以下参数有效
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

  ModalWindowsOptions merge([ModalWindowsOptions? options]) =>
      ModalWindowsOptions(
          constraints: options?.constraints ?? constraints,
          onTap: options?.onTap ?? onTap,
          behavior: options?.behavior ?? behavior,
          color: options?.color ?? color,
          ignoring: options?.ignoring ?? ignoring,
          absorbing: options?.absorbing ?? absorbing,
          addMaterial: options?.addMaterial ?? addMaterial,
          filter: options?.filter ?? filter,
          gaussian: options?.gaussian ?? gaussian,
          fuzzyDegree: options?.fuzzyDegree ?? fuzzyDegree,
          left: options?.left ?? left,
          top: options?.top ?? top,
          right: options?.right ?? right,
          bottom: options?.bottom ?? bottom,
          alignment: options?.alignment ?? alignment,
          mainAxisAlignment: options?.mainAxisAlignment ?? mainAxisAlignment,
          crossAxisAlignment: options?.crossAxisAlignment ?? crossAxisAlignment,
          direction: options?.direction ?? direction,
          mainAxisSize: options?.mainAxisSize ?? mainAxisSize,
          isScroll: options?.isScroll ?? isScroll,
          isStack: options?.isStack ?? isStack);
}

/// 模态框背景
class ModalWindows extends StatelessWidget {
  ModalWindows(
      {super.key,
      this.onWillPop,
      this.children,
      this.child,
      ModalWindowsOptions? options})
      : options = options ?? GlobalWayUI().modalWindowsOptions;

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
          child: MediaQuery(data: context.mediaQuery, child: child));
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

extension ExtensionDoubleChooseWindows on DoubleChooseWindows {
  Future<T?> show<T>({DialogOptions? options}) => popupDialog<T>(
      options: const DialogOptions(fromStyle: PopupFromStyle.fromCenter)
          .merge(options));
}

class DoubleChooseWindows extends StatelessWidget {
  const DoubleChooseWindows({
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
    var options = this.options ?? GlobalWayUI().modalWindowsOptions;
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
    return ModalWindows(options: options, children: [
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
