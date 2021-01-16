import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class Universal extends StatelessWidget {
  const Universal({
    Key key,
    bool isScroll,
    bool isStack,
    bool enabled,
    bool addInkWell,
    bool reverse,
    bool canRequestFocus,
    bool borderOnForeground,
    bool enableFeedback,
    bool excludeFromSemantics,
    bool autoFocus,
    bool expand,
    bool shrink,
    bool visible,
    bool offstage,
    bool maintainState,
    bool maintainAnimation,
    bool maintainSize,
    bool maintainSemantics,
    bool maintainInteractivity,
    bool isCircleAvatar,
    bool addCard,
    bool transitionOnUserGestures,
    bool noScrollBehavior,
    bool isOval,
    MaterialType type,
    Clip clipBehavior,
    DragStartBehavior dragStartBehavior,
    Duration animationDuration,
    Color shadowColor,
    Widget replacement,
    StackFit stackFit,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    Axis direction,
    VerticalDirection verticalDirection,
    MainAxisSize mainAxisSize,
    HitTestBehavior behavior,
    BorderRadius borderRadius,
    Color color,
    this.alignment,
    this.child,
    this.children,
    this.builder,
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
    this.textStyle,
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
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
    this.enablePullDown,
    this.enablePullUp,
    this.enableTwoLevel,
    this.header,
    this.footer,
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
    this.expanded,
    this.flex,
    this.elevation,
    this.opacity,
  })  : isScroll = isScroll ?? false,
        addCard = addCard ?? false,
        maintainState = maintainState ?? false,
        transitionOnUserGestures = transitionOnUserGestures ?? false,
        isStack = isStack ?? false,
        isCircleAvatar = isCircleAvatar ?? false,
        maintainAnimation = maintainAnimation ?? false,
        maintainSize = maintainSize ?? false,
        maintainSemantics = maintainSemantics ?? false,
        maintainInteractivity = maintainInteractivity ?? false,
        enabled = enabled ?? false,
        addInkWell = addInkWell ?? false,
        reverse = reverse ?? false,
        autoFocus = autoFocus ?? false,
        expand = expand ?? false,
        shrink = shrink ?? false,
        excludeFromSemantics = excludeFromSemantics ?? false,
        borderOnForeground = borderOnForeground ?? true,
        enableFeedback = enableFeedback ?? true,
        canRequestFocus = canRequestFocus ?? true,
        isOval = isOval ?? false,
        visible = visible ?? true,
        offstage = offstage ?? false,
        noScrollBehavior = noScrollBehavior ?? true,
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        type = type ?? MaterialType.canvas,
        clipBehavior = clipBehavior ?? Clip.none,
        shadowColor = shadowColor ?? Colors.transparent,
        animationDuration = animationDuration ?? kThemeChangeDuration,
        replacement = replacement ?? const SizedBox.shrink(),
        stackFit = stackFit ?? StackFit.loose,
        mainAxisSize = mainAxisSize ?? MainAxisSize.max,
        mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        verticalDirection = verticalDirection ?? VerticalDirection.down,
        direction = direction ?? Axis.vertical,
        behavior = behavior ?? HitTestBehavior.opaque,
        borderRadius = borderRadius ?? BorderRadius.zero,
        color = color ?? Colors.transparent,
        super(key: key);

  ///  public

  final DragStartBehavior dragStartBehavior;

  /// 控制剪辑方式
  /// [Clip.none]没有剪辑        最快
  /// [Clip.hardEdge]不抗锯齿    快
  /// [Clip.antiAlias]抗锯齿     慢
  /// [Clip.antiAliasWithSaveLayer]抗锯齿和saveLayer  很慢
  /// 使用到的组件[Stack]、[ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval]
  /// 、[Container]、[Material]、[Card]、[Stack]、[SingleChildScrollView]
  final Clip clipBehavior;

  ///  ****** [Align] ******  ///
  final AlignmentGeometry alignment;

  ///  [InkWell]飞溅半径
  ///  [Material]圆角半径
  ///  [ClipRRect]剪辑半径
  final BorderRadius borderRadius;

  ///  ****** [child]、[children]、[builder] ******  ///
  ///  child < children < builder
  ///  三个只有一个有效
  final Widget child;
  final List<Widget> children;
  final StatefulWidgetBuilder builder;

  ///  ****** [Flexible] ******  ///
  final int flex;

  /// [expanded]=true [flex]=1 相当于添加[Expanded]组件
  final bool expanded;

  ///  ****** [Transform] ******  ///
  final Matrix4 transform;
  final Offset origin;

  ///  ****** [ConstrainedBox] ******  ///
  final BoxConstraints constraints;

  ///  ****** [ColoredBox]||[DecoratedBox] ******  ///
  final Color color;

  ///  ****** [Padding] ******  ///
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  ///  ****** [DecoratedBox] ******  ///
  final Decoration decoration;
  final Decoration foregroundDecoration;

  ///  ****** [Positioned] ******  ///
  final double left;
  final double top;
  final double right;
  final double bottom;

  ///  ****** [Card] ******  ///
  final bool addCard;

  ///  ****** [Flex]=[Column]+[Row] ******  ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final TextBaseline textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection textDirection;
  final MainAxisSize mainAxisSize;

  ///  ****** [ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval] ******  ///
  /// [RRect]、[Path]、[Rect]
  final CustomClipper<dynamic> clipper;
  final bool isOval;

  ///  ****** [CircleAvatar] ******  ///
  final bool isCircleAvatar;
  final ImageProvider backgroundImage;
  final ImageErrorListener onBackgroundImageError;
  final Color foregroundColor;
  final double minRadius;
  final double maxRadius;

  ///  ****** [SingleChildScrollView] ******  ///
  ///  移出头部和底部蓝色阴影
  final bool noScrollBehavior;
  final bool isScroll;
  final ScrollPhysics physics;
  final ScrollController scrollController;
  final bool reverse;
  final bool primary;

  ///  ****** [SizedBox] ******  ///
  final bool expand;
  final bool shrink;
  final Size size;
  final double width;
  final double height;

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
  final double opacity;

  ///  ****** [Material] ******  ///
  final MaterialType type;
  final double elevation;
  final Color shadowColor;
  final TextStyle textStyle;
  final ShapeBorder shape;
  final bool borderOnForeground;
  final Duration animationDuration;

  ///  ****** 点击事件相关 ******  ///
  ///  ****** [InkWell] ******  ///
  ///  高亮变化回调
  ///  当材料的这一部分突出显示或停止突出显示时调用
  final ValueChanged<bool> onHighlightChanged;

  ///  当指针进入或退出墨水响应区域时调用
  final ValueChanged<bool> onHover;

  ///  获取焦点颜色
  final Color focusColor;

  ///  指针悬停时颜色
  final Color hoverColor;

  ///  点击时的颜色
  final Color highlightColor;

  ///  水波纹颜色
  final Color splashColor;

  ///  自定义水波纹
  final InteractiveInkFeatureFactory splashFactory;

  ///  水波纹半径
  final double radius;

  /// 覆盖borderRadius的自定义剪辑边框
  final ShapeBorder customBorder;

  /// 检测到的手势是否应该提供声音和/或触觉反馈，默认true
  final bool enableFeedback;

  /// 焦点管理
  final FocusNode focusNode;
  final bool canRequestFocus;

  /// 焦点变化回调
  final ValueChanged<bool> onFocusChange;

  /// 自动获取焦点
  final bool autoFocus;

  /// [addInkWell]添加[InkWell] 有水波纹效果
  final bool addInkWell;

  /// [enabled]默认为false [addInkWell]默认为false
  /// ([enabled]=false || [addInkWell]=true ) 除[onTap]外[GestureDetector]属性无效
  /// ([enabled]=true && [addInkWell]=false ) [GestureDetector]属性全部有效
  final bool enabled;

  ///  短暂触摸屏幕时触发
  final GestureTapCallback onTap;

  ///  用户在短时间内触摸了屏幕两次
  final GestureTapCallback onDoubleTap;

  ///  用户触摸屏幕时间超过500ms时触发
  final GestureLongPressCallback onLongPress;

  ///  用户每次和屏幕交互时都会被调用
  final GestureTapDownCallback onTapDown;

  ///  短暂触摸屏幕时触发取消
  final GestureTapCancelCallback onTapCancel;

  final bool excludeFromSemantics;

  ///  ****** [GestureDetector] ******  ///
  ///  点击抬起
  final GestureTapUpCallback onTapUp;

  final GestureTapDownCallback onSecondaryTapDown;
  final GestureTapUpCallback onSecondaryTapUp;
  final GestureTapCancelCallback onSecondaryTapCancel;

  ///  用户触摸屏幕时间超过500ms时触发开始
  final GestureLongPressStartCallback onLongPressStart;

  ///  用户触摸屏幕时间超过500ms时移动触摸
  final GestureLongPressMoveUpdateCallback onLongPressMoveUpdate;

  ///  用户触摸屏幕时间超过500ms时抬起触发
  final GestureLongPressUpCallback onLongPressUp;

  ///  用户触摸屏幕时间超过500ms时触发结束
  final GestureLongPressEndCallback onLongPressEnd;

  ///  当一个触摸点开始跟屏幕交互，同时在垂直方向上移动时触发
  final GestureDragDownCallback onVerticalDragDown;

  ///  当触摸点开始在垂直方向上移动时触发
  final GestureDragStartCallback onVerticalDragStart;

  ///  屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback onVerticalDragUpdate;

  /// 当用户停止移动，这个拖拽操作就被认为是完成了，就会触发这个回调
  final GestureDragEndCallback onVerticalDragEnd;

  ///  用户突然停止拖拽时触发
  final GestureDragCancelCallback onVerticalDragCancel;

  ///  当一个触摸点开始跟屏幕交互，同时在水平方向上移动时触发
  final GestureDragDownCallback onHorizontalDragDown;

  ///  当触摸点开始在水平方向上移动时触发
  final GestureDragStartCallback onHorizontalDragStart;

  ///  屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback onHorizontalDragUpdate;

  ///  水平拖拽结束时触发
  final GestureDragEndCallback onHorizontalDragEnd;

  ///  onHorizontalDragDown没有成功完成时触发
  final GestureDragCancelCallback onHorizontalDragCancel;

  ///  当触摸点开始跟屏幕交互时触发
  final GestureDragDownCallback onPanDown;

  ///  当触摸点开始移动时触发
  final GestureDragStartCallback onPanStart;

  ///  屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback onPanUpdate;

  ///  pan操作完成时触发
  final GestureDragEndCallback onPanEnd;

  ///  用户触摸了屏幕，但是没有完成Tap的动作时触发
  final GestureDragCancelCallback onPanCancel;

  ///  触摸点开始跟屏幕交互时触发，同时会建立一个焦点为1.0
  final GestureScaleStartCallback onScaleStart;

  ///  跟屏幕交互时触发，同时会标示一个新的焦点
  final GestureScaleUpdateCallback onScaleUpdate;

  ///  	触摸点不再跟屏幕有任何交互，同时也表示这个scale手势完成
  final GestureScaleEndCallback onScaleEnd;
  final GestureForcePressStartCallback onForcePressStart;
  final GestureForcePressPeakCallback onForcePressPeak;
  final GestureForcePressUpdateCallback onForcePressUpdate;
  final GestureForcePressEndCallback onForcePressEnd;
  final GestureTapCallback onSecondaryTap;
  final GestureLongPressMoveUpdateCallback onSecondaryLongPressMoveUpdate;
  final GestureLongPressCallback onSecondaryLongPressUp;
  final GestureLongPressCallback onSecondaryLongPress;
  final GestureLongPressEndCallback onSecondaryLongPressEnd;
  final GestureLongPressStartCallback onSecondaryLongPressStart;

  ///  HitTestBehavior.opaque 自己处理事件
  ///  HitTestBehavior.deferToChild child处理事件
  ///  HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  ///  ****** [Hero] ******  ///
  final String heroTag;
  final CreateRectTween createRectTween;
  final HeroFlightShuttleBuilder flightShuttleBuilder;
  final bool transitionOnUserGestures;
  final HeroPlaceholderBuilder placeholderBuilder;

  ///  ****** [Stack] ******  ///
  final bool isStack;
  final StackFit stackFit;

  ///  ****** [Refreshed] ******  ///
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final VoidCallback onTwoLevel;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool enableTwoLevel;
  final Widget header;
  final Widget footer;

  EdgeInsetsGeometry get _paddingIncludingDecoration {
    if (decoration == null || decoration.padding == null) return padding;
    final EdgeInsetsGeometry decorationPadding = decoration.padding;
    if (padding == null) return decorationPadding;
    return padding.add(decorationPadding);
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = const SizedBox();
    if (child != null) widget = child;
    if (children != null && children.isNotEmpty) {
      widget = isStack ? stackWidget(children) : flexWidget(children);
    }
    if (builder != null) widget = statefulBuilder;
    if (isScroll)
      widget = noScrollBehavior
          ? ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: singleChildScrollViewWidget(widget))
          : singleChildScrollViewWidget(widget);

    if (_paddingIncludingDecoration != null)
      widget = Padding(padding: _paddingIncludingDecoration, child: widget);
    if (alignment != null) widget = Align(alignment: alignment, child: widget);

    if (color != null && decoration == null && !addInkWell && !addCard)
      widget = ColoredBox(color: color, child: widget);

    if (decoration != null && clipBehavior != Clip.none) {
      widget = clipWidget(widget,
          clipper: _DecorationClipper(
              textDirection: Directionality.of(context),
              decoration: decoration));
    }
    if (decoration != null && !addInkWell)
      widget = DecoratedBox(decoration: decoration, child: widget);
    if (foregroundDecoration != null) {
      widget = DecoratedBox(
          decoration: foregroundDecoration,
          position: DecorationPosition.foreground,
          child: widget);
    }
    if (transform != null)
      widget = Transform(transform: transform, origin: origin, child: widget);
    if (enabled ||
        onTap != null ||
        onDoubleTap != null ||
        onLongPress != null) {
      widget =
          addInkWell ? inkWellWidget(widget) : gestureDetectorWidget(widget);
    }
    if (shrink) widget = SizedBox.shrink(child: widget);
    if (expand) widget = SizedBox.expand(child: widget);
    if (width != null || height != null)
      widget = SizedBox(width: width, height: height, child: widget);
    if (size != null) widget = SizedBox.fromSize(size: size, child: widget);
    if (heroTag != null) widget = heroWidget(widget);
    if (addCard) widget = cardWidget(widget, context);
    if (isCircleAvatar) widget = circleAvatarWidget(widget);
    if (clipper != null) widget = clipWidget(widget, clipper: clipper);
    if (refreshController != null ||
        onRefresh != null ||
        onLoading != null ||
        onTwoLevel != null ||
        enablePullDown != null ||
        enablePullUp != null ||
        enableTwoLevel != null ||
        footer != null ||
        header != null) {
      widget = refreshedWidget(widget);
    }

    if (constraints != null)
      widget = ConstrainedBox(constraints: constraints, child: widget);

    if (margin != null) widget = Padding(padding: margin, child: widget);
    if (expanded != null || flex != null) widget = flexibleWidget(widget);
    if (left != null || top != null || right != null || bottom != null)
      widget = Positioned(
          left: left, top: top, right: right, bottom: bottom, child: widget);

    if (opacity != null && opacity > 0)
      widget = Opacity(opacity: opacity, child: widget);

    if (offstage) widget = offstageWidget(widget);
    if (!visible) widget = visibilityWidget(widget);
    return widget;
  }

  Widget get statefulBuilder => StatefulBuilder(builder: builder);

  Widget refreshedWidget(Widget widget) => Refreshed(
      controller: refreshController,
      child: widget,
      onRefresh: onRefresh,
      onLoading: onLoading,
      onTwoLevel: onTwoLevel,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      enableTwoLevel: enableTwoLevel,
      header: header,
      footer: footer);

  Widget offstageWidget(Widget widget) =>
      Offstage(child: widget, offstage: offstage);

  Widget clipWidget(Widget widget, {CustomClipper<dynamic> clipper}) {
    if (clipper is Rect) {
      return ClipRect(
          child: widget,
          clipper: clipper as CustomClipper<Rect>,
          clipBehavior: clipBehavior ?? Clip.hardEdge);
    }
    if (clipper is Path) {
      return ClipPath(
          child: widget,
          clipper: clipper as CustomClipper<Path>,
          clipBehavior: clipBehavior ?? Clip.antiAlias);
    }
    if (clipper is RRect)
      return ClipRRect(
          child: widget,
          borderRadius: borderRadius,
          clipper: clipper as CustomClipper<RRect>,
          clipBehavior: clipBehavior ?? Clip.antiAlias);
    if (isOval)
      return ClipOval(
          child: widget, clipBehavior: clipBehavior ?? Clip.antiAlias);
    return widget;
  }

  Widget circleAvatarWidget(Widget widget) => CircleAvatar(
      child: widget,
      backgroundColor: color,
      backgroundImage: backgroundImage,
      onBackgroundImageError: onBackgroundImageError,
      foregroundColor: foregroundColor,
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius);

  Widget stackWidget(List<Widget> children) => Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      textDirection: textDirection,
      fit: stackFit,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      children: children);

  Widget heroWidget(Widget widget) => Hero(
      tag: heroTag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      child: widget);

  Widget visibilityWidget(Widget widget) => Visibility(
      child: widget,
      replacement: replacement,
      visible: visible,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity);

  Widget flexibleWidget(Widget widget) => Flexible(
      child: widget,
      flex: flex ?? 1,
      fit: (expanded ?? false) ? FlexFit.tight : FlexFit.loose);

  Widget cardWidget(Widget widget, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CardTheme cardTheme = CardTheme.of(context);
    return material(widget,
        mType: MaterialType.card,
        mShadowColor: shadowColor ?? cardTheme.shadowColor ?? theme.shadowColor,
        mColor: color ?? cardTheme.color ?? theme.cardColor,
        mElevation: elevation ?? cardTheme.elevation ?? 1,
        mShape: shape ??
            cardTheme.shape ??
            RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(4)),
        mClipBehavior: clipBehavior ?? cardTheme.clipBehavior ?? Clip.none,
        mBorderOnForeground: borderOnForeground ?? true);
  }

  Material material(Widget widget,
          {MaterialType mType,
          Color mShadowColor,
          Color mColor,
          TextStyle mTextStyle,
          double mElevation,
          BorderRadiusGeometry mBorderRadius,
          ShapeBorder mShape,
          bool mBorderOnForeground,
          Clip mClipBehavior}) =>
      Material(
          child: widget,
          color: mColor ?? color,
          type: mType ?? type,
          elevation: mElevation ?? elevation,
          shadowColor: mShadowColor ?? shadowColor,
          textStyle: mTextStyle ?? textStyle,
          borderRadius: (mShape != null || shape != null) ? null : borderRadius,
          shape: mShape ?? shape,
          borderOnForeground: mBorderOnForeground ?? borderOnForeground,
          clipBehavior: mClipBehavior ?? clipBehavior,
          animationDuration: animationDuration);

  Widget inkWellWidget(Widget widget) => Ink(
      decoration: decoration,
      child: InkWell(
          child: widget,
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

  Widget singleChildScrollViewWidget(Widget widget) => SingleChildScrollView(
      physics: physics,
      reverse: reverse,
      primary: primary,
      dragStartBehavior: dragStartBehavior,
      controller: scrollController,
      scrollDirection: direction,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: widget);

  Widget flexWidget(List<Widget> children) => Flex(
      children: children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      direction: direction,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      mainAxisSize: mainAxisSize);

  Widget gestureDetectorWidget(Widget widget) => GestureDetector(
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
      child: widget);
}

/// A clipper that uses [Decoration.getClipPath] to clip.
class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({TextDirection textDirection, @required this.decoration})
      : assert(decoration != null),
        textDirection = textDirection ?? TextDirection.ltr;

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
    Key key,
    String text,
    bool isElastic,
    TextOverflow overflow,
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
    this.addInkWell,
    this.withOpacity,
    this.useCache,
    this.scaleCoefficient,
  })  : text = text ?? 'Button',
        isElastic = isElastic ?? false,
        overflow = overflow ?? TextOverflow.ellipsis,
        super(key: key);

  final Widget child;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final AlignmentGeometry alignment;
  final int maxLines;
  final TextOverflow overflow;
  final String text;
  final bool addInkWell;
  final bool visible;
  final String heroTag;
  final BoxConstraints constraints;
  final bool withOpacity;
  final bool isElastic;
  final bool useCache;
  final double scaleCoefficient;

  @override
  Widget build(BuildContext context) {
    final Widget widget = child ??
        BasisText(text,
            textAlign: TextAlign.start,
            style: textStyle,
            maxLines: maxLines,
            overflow: overflow);
    if (isElastic && onTap != null)
      return ElasticButton(
          child: universal(widget),
          onTap: onTap,
          withOpacity: withOpacity,
          scaleCoefficient: scaleCoefficient,
          useCache: useCache);
    return universal(widget, onTap: onTap);
  }

  Widget universal(Widget widget, {GestureTapCallback onTap}) => Universal(
      heroTag: heroTag,
      visible: visible,
      constraints: constraints,
      addInkWell: addInkWell,
      mainAxisSize: MainAxisSize.min,
      child: widget,
      onTap: onTap,
      width: width,
      height: height,
      margin: margin,
      decoration: decoration ?? BoxDecoration(color: color),
      padding: padding,
      alignment: alignment);
}
