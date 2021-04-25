import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/flutter_waya.dart';

class Universal extends StatelessWidget {
  const Universal({
    Key? key,
    bool? isScroll = false,
    bool? useSingleChildScrollView = true,
    bool? isStack = false,
    bool? isWrap = false,
    bool? enabled = false,
    bool? addInkWell = false,
    bool? addCard = false,
    bool? expanded = false,
    bool? expand = false,
    bool? shrink = false,
    bool? visible = true,
    bool? offstage = false,
    bool? reverse = false,
    bool? isOval = false,
    bool? isClipRRect = false,
    bool? isClipRect = false,
    bool? isCircleAvatar = false,
    bool? intrinsicHeight = false,
    bool? intrinsicWidth = false,
    bool? gaussian = false,
    bool? canRequestFocus,
    bool? enableFeedback,
    bool? excludeFromSemantics,
    bool? autoFocus,
    bool? maintainState,
    bool? maintainAnimation,
    bool? maintainSize,
    bool? maintainSemantics,
    bool? maintainInteractivity,
    bool? transitionOnUserGestures,
    bool? noScrollBehavior,
    double? fuzzyDegree,
    DragStartBehavior? dragStartBehavior,
    Color? shadowColor,
    Widget? replacement,
    StackFit? stackFit,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    WrapAlignment? wrapAlignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? wrapCrossAlignment,
    Axis? direction,
    Axis? scrollDirection,
    VerticalDirection? verticalDirection,
    MainAxisSize? mainAxisSize,
    HitTestBehavior? behavior,
    BorderRadius? borderRadius,
    double? wrapSpacing = 0.0,
    double? runSpacing = 0.0,
    this.color,
    this.alignment,
    this.child,
    this.children,
    this.padding,
    this.physics,
    this.scrollController,
    this.primary,
    this.foregroundDecoration,
    this.transform,
    this.origin,
    this.constraints,
    this.width,
    this.height,
    this.margin,
    this.decoration,
    this.textBaseline,
    this.textDirection,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.shape,
    this.onHighlightChanged,
    this.onHover,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.splashFactory,
    this.radius,
    this.customBorder,
    this.focusNode,
    this.onFocusChange,
    this.heroTag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.backgroundImage,
    this.onBackgroundImageError,
    this.foregroundColor,
    this.minRadius,
    this.maxRadius,
    this.clipper,
    this.size,
    this.onSecondaryTap,
    this.onSecondaryLongPressMoveUpdate,
    this.onSecondaryLongPressUp,
    this.onSecondaryLongPress,
    this.onSecondaryLongPressEnd,
    this.onSecondaryLongPressStart,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.flex,
    this.elevation,
    this.opacity,
    this.clipBehavior,
    this.refreshConfig,
    this.widthFactor,
    this.heightFactor,
    this.filter,
    this.builder,
  })  : addCard = addCard ?? false,
        addInkWell = addInkWell ?? false,
        isScroll = isScroll ?? false,
        useSingleChildScrollView = useSingleChildScrollView ?? true,
        isStack = isStack ?? false,
        isWrap = isWrap ?? false,
        expanded = expanded ?? false,
        expand = expand ?? false,
        shrink = shrink ?? false,
        intrinsicHeight = intrinsicHeight ?? false,
        intrinsicWidth = intrinsicWidth ?? false,
        isOval = isOval ?? false,
        isClipRRect = isClipRRect ?? false,
        isClipRect = isClipRect ?? false,
        visible = visible ?? true,
        offstage = offstage ?? false,
        enabled = enabled ?? false,
        reverse = reverse ?? false,
        autoFocus = autoFocus ?? false,
        maintainState = maintainState ?? false,
        transitionOnUserGestures = transitionOnUserGestures ?? false,
        isCircleAvatar = isCircleAvatar ?? false,
        maintainAnimation = maintainAnimation ?? false,
        maintainSize = maintainSize ?? false,
        maintainSemantics = maintainSemantics ?? false,
        maintainInteractivity = maintainInteractivity ?? false,
        excludeFromSemantics = excludeFromSemantics ?? false,
        enableFeedback = enableFeedback ?? true,
        canRequestFocus = canRequestFocus ?? true,
        noScrollBehavior = noScrollBehavior ?? true,
        gaussian = gaussian ?? false,
        fuzzyDegree = fuzzyDegree ?? 4,
        wrapSpacing = wrapSpacing ?? 0.0,
        runSpacing = runSpacing ?? 0.0,
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        shadowColor = shadowColor ?? Colors.transparent,
        replacement = replacement ?? const SizedBox.shrink(),
        stackFit = stackFit ?? StackFit.loose,
        mainAxisSize = mainAxisSize ?? MainAxisSize.max,
        mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        wrapAlignment = wrapAlignment ?? WrapAlignment.start,
        runAlignment = runAlignment ?? WrapAlignment.start,
        wrapCrossAlignment = wrapCrossAlignment ?? WrapCrossAlignment.start,
        crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        verticalDirection = verticalDirection ?? VerticalDirection.down,
        direction = direction ?? Axis.vertical,
        scrollDirection = scrollDirection ?? Axis.vertical,
        behavior = behavior ?? HitTestBehavior.opaque,
        borderRadius = borderRadius ?? BorderRadius.zero,
        assert(!((addCard ?? false) && (addInkWell ?? false))),
        super(key: key);

  ///  [GestureDetector]、[SingleChildScrollView] 使用
  final DragStartBehavior dragStartBehavior;

  ///  ****** [IntrinsicHeight]、[IntrinsicWidth] ******  ///
  final bool intrinsicHeight;
  final bool intrinsicWidth;

  /// 控制剪辑方式
  /// [Clip.none]没有剪辑        最快
  /// [Clip.hardEdge]不抗锯齿    快
  /// [Clip.antiAlias]抗锯齿     慢
  /// [Clip.antiAliasWithSaveLayer]抗锯齿和saveLayer  很慢
  /// 使用到的组件[Stack]、[ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval]
  /// 、[Container]、[Material]、[Card]、[Stack]、[SingleChildScrollView]
  final Clip? clipBehavior;

  ///  ****** [Align] ******  ///
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  ///  [InkWell]飞溅半径
  ///  [Material]圆角半径
  ///  [ClipRRect]剪辑半径
  final BorderRadius borderRadius;

  ///  ****** [child]、[children]、[builder] ******  ///
  ///  child < children < builder
  ///  三个只有一个有效
  final Widget? child;
  final List<Widget>? children;

  /// ****** [StatefulBuilder]、[Builder]、[LayoutBuilder] ****** ///
  /// builder types [LayoutWidgetBuilder]、[WidgetBuilder]、[StatefulWidgetBuilder]
  final dynamic? builder;

  ///  ****** [Wrap] ******  ///
  final bool isWrap;
  final WrapAlignment wrapAlignment;
  final double wrapSpacing;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final WrapCrossAlignment wrapCrossAlignment;

  ///  ****** [Flexible] ******  ///
  final int? flex;

  /// [expanded]=true [flex]=1 相当于添加[Expanded]组件
  final bool expanded;

  ///  ****** [Transform] ******  ///
  final Matrix4? transform;
  final Offset? origin;

  ///  ****** [ConstrainedBox] ******  ///
  final BoxConstraints? constraints;

  ///  ****** [ColoredBox]||[DecoratedBox] ******  ///
  final Color? color;

  ///  ****** [Padding] ******  ///
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  ///  ****** [DecoratedBox] ******  ///
  final Decoration? decoration;
  final Decoration? foregroundDecoration;

  ///  ****** [Positioned] ******  ///
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  ///  ****** [Card] ******  ///
  final bool addCard;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;

  ///  ****** [Flex]=[Column]+[Row] ******  ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final MainAxisSize mainAxisSize;

  ///  ****** [ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval] ******  ///
  /// [RRect]、[Path]、[Rect]
  final CustomClipper<dynamic>? clipper;
  final bool isOval;
  final bool isClipRRect;
  final bool isClipRect;

  ///  ****** [CircleAvatar] ******  ///
  final bool isCircleAvatar;
  final ImageProvider? backgroundImage;
  final ImageErrorListener? onBackgroundImageError;
  final Color? foregroundColor;
  final double? minRadius;
  final double? maxRadius;

  ///  ****** 开始滚动 ******  ///
  final bool isScroll;
  final Axis scrollDirection;

  /// 是否使用 [SingleChildScrollView]创建滚动组件
  final bool useSingleChildScrollView;

  ///  移出头部和底部蓝色阴影
  final bool noScrollBehavior;

  ///  ****** [SingleChildScrollView] ******  ///
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final bool reverse;
  final bool? primary;

  ///  ****** [SizedBox] ******  ///
  final bool expand;
  final bool shrink;
  final Size? size;
  final double? width;
  final double? height;

  ///  ****** [Visibility] ******  ///
  final Widget replacement;
  final bool visible;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;
  final bool offstage;

  ///  ****** [Opacity] ******  ///
  final double? opacity;

  ///  ****** 点击事件相关 ******  ///
  ///  ****** [InkWell] ******  ///
  ///  高亮变化回调
  ///  当材料的这一部分突出显示或停止突出显示时调用
  final ValueChanged<bool>? onHighlightChanged;

  ///  当指针进入或退出墨水响应区域时调用
  final ValueChanged<bool>? onHover;

  ///  获取焦点颜色
  final Color? focusColor;

  ///  指针悬停时颜色
  final Color? hoverColor;

  ///  点击时的颜色
  final Color? highlightColor;

  ///  水波纹颜色
  final Color? splashColor;

  ///  自定义水波纹
  final InteractiveInkFeatureFactory? splashFactory;

  ///  水波纹半径
  final double? radius;

  /// 覆盖borderRadius的自定义剪辑边框
  final ShapeBorder? customBorder;

  /// 检测到的手势是否应该提供声音和/或触觉反馈，默认true
  final bool? enableFeedback;

  /// 焦点管理
  final FocusNode? focusNode;
  final bool canRequestFocus;

  /// 焦点变化回调
  final ValueChanged<bool>? onFocusChange;

  /// 自动获取焦点
  final bool autoFocus;

  /// [addInkWell]添加[InkWell] 有水波纹效果
  final bool addInkWell;

  /// [enabled]默认为false [addInkWell]默认为false
  /// ([enabled]=false || [addInkWell]=true ) 除[onTap]外[GestureDetector]属性无效
  /// ([enabled]=true && [addInkWell]=false ) [GestureDetector]属性全部有效
  final bool enabled;

  ///  短暂触摸屏幕时触发
  final GestureTapCallback? onTap;

  ///  用户在短时间内触摸了屏幕两次
  final GestureTapCallback? onDoubleTap;

  ///  用户触摸屏幕时间超过500ms时触发
  final GestureLongPressCallback? onLongPress;

  ///  用户每次和屏幕交互时都会被调用
  final GestureTapDownCallback? onTapDown;

  ///  短暂触摸屏幕时触发取消
  final GestureTapCancelCallback? onTapCancel;

  final bool excludeFromSemantics;

  ///  ****** [GestureDetector] ******  ///
  ///  点击抬起
  final GestureTapUpCallback? onTapUp;

  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;

  ///  用户触摸屏幕时间超过500ms时触发开始
  final GestureLongPressStartCallback? onLongPressStart;

  ///  用户触摸屏幕时间超过500ms时移动触摸
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  ///  用户触摸屏幕时间超过500ms时抬起触发
  final GestureLongPressUpCallback? onLongPressUp;

  ///  用户触摸屏幕时间超过500ms时触发结束
  final GestureLongPressEndCallback? onLongPressEnd;

  ///  当一个触摸点开始跟屏幕交互，同时在垂直方向上移动时触发
  final GestureDragDownCallback? onVerticalDragDown;

  ///  当触摸点开始在垂直方向上移动时触发
  final GestureDragStartCallback? onVerticalDragStart;

  ///  屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback? onVerticalDragUpdate;

  /// 当用户停止移动，这个拖拽操作就被认为是完成了，就会触发这个回调
  final GestureDragEndCallback? onVerticalDragEnd;

  ///  用户突然停止拖拽时触发
  final GestureDragCancelCallback? onVerticalDragCancel;

  ///  当一个触摸点开始跟屏幕交互，同时在水平方向上移动时触发
  final GestureDragDownCallback? onHorizontalDragDown;

  ///  当触摸点开始在水平方向上移动时触发
  final GestureDragStartCallback? onHorizontalDragStart;

  ///  屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  ///  水平拖拽结束时触发
  final GestureDragEndCallback? onHorizontalDragEnd;

  ///  onHorizontalDragDown没有成功完成时触发
  final GestureDragCancelCallback? onHorizontalDragCancel;

  ///  当触摸点开始跟屏幕交互时触发
  final GestureDragDownCallback? onPanDown;

  ///  当触摸点开始移动时触发
  final GestureDragStartCallback? onPanStart;

  ///  屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback? onPanUpdate;

  ///  pan操作完成时触发
  final GestureDragEndCallback? onPanEnd;

  ///  用户触摸了屏幕，但是没有完成Tap的动作时触发
  final GestureDragCancelCallback? onPanCancel;

  ///  触摸点开始跟屏幕交互时触发，同时会建立一个焦点为1.0
  final GestureScaleStartCallback? onScaleStart;

  ///  跟屏幕交互时触发，同时会标示一个新的焦点
  final GestureScaleUpdateCallback? onScaleUpdate;

  ///  	触摸点不再跟屏幕有任何交互，同时也表示这个scale手势完成
  final GestureScaleEndCallback? onScaleEnd;
  final GestureForcePressStartCallback? onForcePressStart;
  final GestureForcePressPeakCallback? onForcePressPeak;
  final GestureForcePressUpdateCallback? onForcePressUpdate;
  final GestureForcePressEndCallback? onForcePressEnd;
  final GestureTapCallback? onSecondaryTap;
  final GestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate;
  final GestureLongPressCallback? onSecondaryLongPressUp;
  final GestureLongPressCallback? onSecondaryLongPress;
  final GestureLongPressEndCallback? onSecondaryLongPressEnd;
  final GestureLongPressStartCallback? onSecondaryLongPressStart;

  ///  HitTestBehavior.opaque 自己处理事件
  ///  HitTestBehavior.deferToChild child处理事件
  ///  HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  ///  ****** [Hero] ******  ///
  final String? heroTag;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final bool transitionOnUserGestures;
  final HeroPlaceholderBuilder? placeholderBuilder;

  ///  ****** [Stack] ******  ///
  final bool isStack;
  final StackFit stackFit;

  ///  ****** [Refreshed] ******  ///
  final RefreshConfig? refreshConfig;

  ///  ****** [ImageFilter] ******  ///
  ///  [filter]!=null 时 [fuzzyDegree] 无效
  final ImageFilter? filter;

  /// 模糊程度 0-100
  final double fuzzyDegree;

  /// 是否开始背景模糊 [ImageFilter]
  final bool gaussian;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    if (decoration == null || decoration!.padding == null) return padding;
    final EdgeInsetsGeometry decorationPadding = decoration!.padding!;
    if (padding == null) return decorationPadding;
    return padding!.add(decorationPadding);
  }

  @override
  Widget build(BuildContext context) {
    Widget current = const SizedBox();
    if (child != null) current = child!;
    if (children != null && children!.isNotEmpty) {
      current = isStack ? stackWidget(children!) : flexWidget(children!);
      if (isWrap) current = wrapWidget(children!);
    }
    if (builder != null) current = builderWidget(current);

    if (isScroll || refreshConfig != null) {
      if (refreshConfig == null && useSingleChildScrollView) {
        current = noScrollBehavior
            ? ScrollConfiguration(
                behavior: NoScrollBehavior(),
                child: singleChildScrollViewWidget(current))
            : singleChildScrollViewWidget(current);

        /// 添加padding
        current = paddingWidget(current);
      } else {
        if (child != null || builder != null) if (child != null ||
            builder != null)
          current = refreshedWidget(
              <Widget>[SliverToBoxAdapter(child: current)],
              _paddingIncludingDecoration);
        if (children != null && children!.isNotEmpty && !isStack && !isWrap)
          current = refreshedWidget(
              children!
                  .builder((Widget item) => SliverToBoxAdapter(child: item)),
              _paddingIncludingDecoration);
      }
    } else {
      /// 添加padding
      current = paddingWidget(current);
    }

    if (alignment != null || widthFactor != null || heightFactor != null)
      current = Align(
          alignment: alignment!,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: current);
    if (intrinsicWidth) current = IntrinsicWidth(child: current);
    if (intrinsicHeight) current = IntrinsicHeight(child: current);

    if (color != null && decoration == null && !addInkWell && !addCard)
      current = ColoredBox(color: color!, child: current);

    if (decoration != null &&
        clipBehavior != null &&
        clipBehavior != Clip.none) {
      current = clipWidget(current,
          clipper: _DecorationClipper(
              textDirection: Directionality.of(context),
              decoration: decoration!));
    }
    if (decoration != null && !addInkWell)
      current = DecoratedBox(decoration: decoration!, child: current);
    if (foregroundDecoration != null) {
      current = DecoratedBox(
          decoration: foregroundDecoration!,
          position: DecorationPosition.foreground,
          child: current);
    }
    if (transform != null)
      current =
          Transform(transform: transform!, origin: origin, child: current);
    if (enabled ||
        onTap != null ||
        onDoubleTap != null ||
        onLongPress != null) {
      current =
          addInkWell ? inkWellWidget(current) : gestureDetectorWidget(current);
    }
    if (shrink) current = SizedBox.shrink(child: current);
    if (expand) current = SizedBox.expand(child: current);
    if (width != null || height != null)
      current = SizedBox(width: width, height: height, child: current);
    if (size != null) current = SizedBox.fromSize(size: size, child: current);

    if (heroTag != null) current = heroWidget(current);
    if (addCard) current = cardWidget(current, context);
    if (isCircleAvatar) current = circleAvatarWidget(current);
    if (clipper != null || isOval || isClipRRect)
      current = clipWidget(current, clipper: clipper);

    if (constraints != null)
      current = ConstrainedBox(constraints: constraints!, child: current);

    if (margin != null) current = Padding(padding: margin!, child: current);
    if (expanded || flex != null) current = flexibleWidget(current);
    if (left != null || top != null || right != null || bottom != null)
      current = Positioned(
          left: left, top: top, right: right, bottom: bottom, child: current);
    if (gaussian) backdropFilter(current);
    if (opacity != null && opacity! > 0)
      current = Opacity(opacity: opacity!, child: current);

    if (offstage) current = offstageWidget(current);
    if (!visible) current = visibilityWidget(current);

    return current;
  }

  Widget builderWidget(Widget current) {
    if (builder is StatefulWidgetBuilder) {
      return StatefulBuilder(builder: builder as StatefulWidgetBuilder);
    } else if (builder is WidgetBuilder) {
      return Builder(builder: builder as WidgetBuilder);
    } else if (builder is LayoutWidgetBuilder) {
      return LayoutBuilder(builder: builder as LayoutWidgetBuilder);
    }

    return current;
  }

  Widget paddingWidget(Widget current) => _paddingIncludingDecoration == null
      ? current
      : Padding(padding: _paddingIncludingDecoration!, child: current);

  Widget backdropFilter(Widget current) => BackdropFilter(
      filter:
          filter ?? ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),
      child: current);

  Widget offstageWidget(Widget current) =>
      Offstage(child: current, offstage: offstage);

  /// 裁剪组件
  Widget clipWidget(Widget current, {CustomClipper<dynamic>? clipper}) {
    if (isOval)
      return ClipOval(
          child: current, clipBehavior: clipBehavior ?? Clip.antiAlias);
    if (clipper is CustomClipper<Rect> || isClipRect)
      return ClipRect(
          child: current,
          clipper: clipper is CustomClipper<Rect> ? clipper : null,
          clipBehavior: clipBehavior ?? Clip.hardEdge);
    if (clipper is CustomClipper<Path>)
      return ClipPath(
          child: current,
          clipper: clipper,
          clipBehavior: clipBehavior ?? Clip.antiAlias);
    if (clipper is CustomClipper<RRect> || isClipRRect)
      return ClipRRect(
          child: current,
          borderRadius: borderRadius,
          clipper: clipper is CustomClipper<RRect> ? clipper : null,
          clipBehavior: clipBehavior ?? Clip.antiAlias);
    return current;
  }

  Widget circleAvatarWidget(Widget current) => CircleAvatar(
      child: current,
      backgroundColor: color,
      backgroundImage: backgroundImage,
      onBackgroundImageError: onBackgroundImageError,
      foregroundColor: foregroundColor,
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius);

  Widget heroWidget(Widget current) => Hero(
      tag: heroTag!,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      child: current);

  Widget visibilityWidget(Widget current) => Visibility(
      child: current,
      replacement: replacement,
      visible: visible,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity);

  Widget flexibleWidget(Widget current) => Flexible(
      child: current,
      flex: flex ?? 1,
      fit: expanded ? FlexFit.tight : FlexFit.loose);

  Widget cardWidget(Widget current, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CardTheme cardTheme = CardTheme.of(context);
    return material(current,
        mType: MaterialType.card,
        mShadowColor: shadowColor ?? cardTheme.shadowColor ?? theme.shadowColor,
        mColor: color ?? cardTheme.color ?? theme.cardColor,
        mElevation: elevation ?? cardTheme.elevation ?? 10,
        mShape: shape ??
            cardTheme.shape ??
            RoundedRectangleBorder(
                borderRadius: borderRadius == BorderRadius.zero
                    ? BorderRadius.circular(4)
                    : borderRadius),
        mClipBehavior: clipBehavior ?? cardTheme.clipBehavior ?? Clip.none,
        mBorderOnForeground: true);
  }

  Material material(Widget current,
          {required MaterialType mType,
          Color? mShadowColor,
          Color? mColor,
          TextStyle? mTextStyle,
          required double mElevation,
          BorderRadiusGeometry? mBorderRadius,
          ShapeBorder? mShape,
          required bool mBorderOnForeground,
          required Clip mClipBehavior}) =>
      Material(
          child: current,
          color: mColor,
          type: mType,
          elevation: mElevation,
          shadowColor: mShadowColor,
          textStyle: mTextStyle,
          borderRadius: (mShape != null || shape != null) ? null : borderRadius,
          shape: mShape ?? shape,
          borderOnForeground: mBorderOnForeground,
          clipBehavior: mClipBehavior);

  Widget inkWellWidget(Widget current) => Ink(
      decoration: decoration,
      child: InkWell(
          child: current,
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onHighlightChanged: onHighlightChanged,
          onHover: onHover,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: splashColor,
          splashFactory: splashFactory,
          radius: radius,
          borderRadius: borderRadius,
          customBorder: customBorder,
          enableFeedback: enableFeedback,
          excludeFromSemantics: excludeFromSemantics,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          onFocusChange: onFocusChange,
          autofocus: autoFocus));

  Widget singleChildScrollViewWidget(Widget current) => SingleChildScrollView(
      physics: physics,
      reverse: reverse,
      primary: primary,
      dragStartBehavior: dragStartBehavior,
      controller: scrollController,
      scrollDirection: scrollDirection,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: current);

  Widget refreshedWidget(List<Widget> slivers, EdgeInsetsGeometry? padding) =>
      RefreshScrollView(
          controller: scrollController,
          slivers: slivers,
          padding: padding,
          noScrollBehavior: noScrollBehavior,
          reverse: reverse,
          primary: primary,
          scrollDirection: scrollDirection,
          refreshConfig: refreshConfig);

  Widget flexWidget(List<Widget> children) => Flex(
      children: children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      direction: direction,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      mainAxisSize: mainAxisSize);

  Widget wrapWidget(List<Widget> children) => Wrap(
      children: children,
      direction: direction,
      alignment: wrapAlignment,
      spacing: wrapSpacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: wrapCrossAlignment,
      clipBehavior: clipBehavior ?? Clip.none,
      verticalDirection: verticalDirection,
      textDirection: textDirection);

  Widget stackWidget(List<Widget> children) => Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      textDirection: textDirection,
      fit: stackFit,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      children: children);

  Widget gestureDetectorWidget(Widget current) => GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTap: onTap,
      onTapCancel: onTapCancel,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
      onSecondaryLongPressMoveUpdate: onSecondaryLongPressMoveUpdate,
      onSecondaryLongPressUp: onSecondaryLongPressUp,
      onSecondaryLongPress: onSecondaryLongPress,
      onSecondaryLongPressEnd: onSecondaryLongPressEnd,
      onSecondaryLongPressStart: onSecondaryLongPressStart,
      onLongPress: onLongPress,
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPressUp: onLongPressUp,
      onLongPressEnd: onLongPressEnd,
      onVerticalDragDown: onVerticalDragDown,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragCancel: onVerticalDragCancel,
      onHorizontalDragDown: onHorizontalDragDown,
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragCancel: onHorizontalDragCancel,
      onForcePressStart: onForcePressStart,
      onForcePressPeak: onForcePressPeak,
      onForcePressUpdate: onForcePressUpdate,
      onForcePressEnd: onForcePressEnd,
      onPanDown: onPanDown,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanCancel: onPanCancel,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: current);
}

/// A clipper that uses [Decoration.getClipPath] to clip.
class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({TextDirection? textDirection, required this.decoration})
      : textDirection = textDirection ?? TextDirection.ltr;

  final TextDirection textDirection;
  final Decoration decoration;

  @override
  Path getClip(Size size) =>
      decoration.getClipPath(Offset.zero & size, textDirection);

  @override
  bool shouldReclip(_DecorationClipper oldClipper) =>
      oldClipper.decoration != decoration ||
      oldClipper.textDirection != textDirection;
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    Key? key,
    String? text,
    bool? isElastic,
    bool? addInkWell,
    TextOverflow? overflow,
    this.textStyle,
    this.visible,
    this.constraints,
    this.onTap,
    this.heroTag,
    this.padding,
    this.margin,
    this.width,
    this.color,
    this.height,
    this.decoration,
    this.alignment,
    this.maxLines,
    this.child,
    this.withOpacity,
    this.useCache,
    this.scaleCoefficient,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.borderRadius,
  })  : text = text ?? 'Button',
        isElastic = isElastic ?? false,
        addInkWell = addInkWell ?? false,
        overflow = overflow ?? TextOverflow.ellipsis,
        super(key: key);

  final Widget? child;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? height;
  final double? width;
  final Decoration? decoration;
  final GestureTapCallback? onTap;
  final AlignmentGeometry? alignment;
  final int? maxLines;
  final TextOverflow overflow;
  final String text;

  final bool? visible;
  final String? heroTag;
  final BoxConstraints? constraints;
  final bool? withOpacity;
  final bool isElastic;
  final bool? useCache;
  final double? scaleCoefficient;

  /// 是否添加水波纹效果
  final bool addInkWell;

  ///  获取焦点颜色 [addInkWell] = true
  final Color? focusColor;

  ///  指针悬停时颜色 [addInkWell] = true
  final Color? hoverColor;

  ///  点击时的颜色 [addInkWell] = true
  final Color? highlightColor;

  ///  水波纹颜色 [addInkWell] = true
  final Color? splashColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget current = child ??
        BasisText(text,
            textAlign: TextAlign.start,
            style: textStyle,
            maxLines: maxLines,
            overflow: overflow);
    if (isElastic && onTap != null)
      return ElasticButton(
          child: universal(current),
          onTap: onTap,
          withOpacity: withOpacity,
          scaleCoefficient: scaleCoefficient,
          useCache: useCache);
    return universal(current, onTap: onTap);
  }

  Widget universal(Widget current, {GestureTapCallback? onTap}) => Universal(
      heroTag: heroTag,
      visible: visible,
      constraints: constraints,
      addInkWell: onTap != null && addInkWell,
      borderRadius: borderRadius,
      highlightColor: highlightColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusColor: focusColor,
      mainAxisSize: MainAxisSize.min,
      child: current,
      onTap: onTap,
      width: width,
      height: height,
      margin: margin,
      decoration: decoration ?? BoxDecoration(color: color),
      padding: padding,
      alignment: alignment);
}
