import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/widgets/scroll_view/sliver/element.dart';
import 'package:flutter_waya/widgets/scroll_view/sliver/render.dart';

/// 配合 sliver 家族组件 无需设置高度  自适应高度
class ExtendedScrollView extends StatefulWidget {
  const ExtendedScrollView({
    Key? key,
    this.expanded = false,
    this.flex = 1,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.dragStartBehavior = DragStartBehavior.start,
    this.controller,
    this.restorationId,
    this.slivers = const <Widget>[],
    this.primary,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.scrollBehavior,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  })  : isNestedScrollView = false,
        floatHeaderSlivers = true,
        body = null,
        headerSliverBuilder = null,
        super(key: key);

  const ExtendedScrollView.nested({
    Key? key,
    this.expanded = false,
    this.flex = 1,
    this.headerSliverBuilder,
    this.floatHeaderSlivers = true,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.dragStartBehavior = DragStartBehavior.start,
    this.body,
    this.controller,
    this.restorationId,
    this.slivers = const <Widget>[],
    this.scrollBehavior,
  })  : isNestedScrollView = true,
        primary = null,
        shrinkWrap = false,
        center = null,
        anchor = 0.0,
        cacheExtent = null,
        semanticChildCount = null,
        keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
        assert(body != null),
        super(key: key);

  /// 是否使用 [NestedScrollView]
  final bool isNestedScrollView;

  /// [ScrollView] 外嵌套 [Expanded]
  final bool expanded;
  final int flex;

  /// **** ScrollView **** ///
  final ScrollController? controller;
  final String? restorationId;
  final Clip clipBehavior;
  final bool reverse;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final DragStartBehavior dragStartBehavior;

  /// **** [NestedScrollView] **** ///
  final bool floatHeaderSlivers;
  final Widget? body;
  final NestedScrollViewHeaderSliversBuilder? headerSliverBuilder;

  /// **** [CustomScrollView] **** ///
  final List<Widget> slivers;
  final bool? primary;
  final bool shrinkWrap;
  final Key? center;
  final double anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final ScrollBehavior? scrollBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  _ExtendedScrollViewState createState() => _ExtendedScrollViewState();
}

class _ExtendedScrollViewState extends State<ExtendedScrollView> {
  bool showScrollView = false;
  late List<Widget> slivers;
  List<_SliverModel> sliverModel = <_SliverModel>[];

  @override
  void initState() {
    slivers = widget.slivers;
    super.initState();
    addPostFrameCallback((Duration duration) {
      _calculate(slivers, sliverModel);
      showScrollView = true;
      setState(() {});
    });
  }

  void _calculate(List<Widget> slivers, List<_SliverModel> sliver) {
    sliver.builderEntry((MapEntry<int, _SliverModel> entry) {
      final _SliverModel value = entry.value;
      final int i = entry.key;
      if (value.key != null) {
        sliver[i].size = value.key?.currentContext?.size ?? const Size(0, 0);
        if (value.extraKey != null) {
          sliver[i].extraSize =
              value.extraKey?.currentContext?.size ?? const Size(0, 0);
          if (sliver[i].extraSize.height > kToolbarHeight) {
            sliver[i].extraSize =
                Size(sliver[i].extraSize.width, kToolbarHeight);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget current = const SizedBox();
    if (showScrollView) {
      current = widget.isNestedScrollView ? nestedScrollView : customScrollView;
      if (widget.expanded) current = expanded(current);
    } else {
      current = _Calculate(slivers: slivers, sliverModel: sliverModel);
    }
    return current;
  }

  Widget expanded(Widget child) => Expanded(flex: widget.flex, child: child);

  NestedScrollView get nestedScrollView => NestedScrollView(
      floatHeaderSlivers: widget.floatHeaderSlivers,
      clipBehavior: widget.clipBehavior,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      physics: widget.physics,
      dragStartBehavior: widget.dragStartBehavior,
      body: widget.body ?? const SizedBox(),
      restorationId: widget.restorationId,
      controller: widget.controller,
      scrollBehavior: widget.scrollBehavior,
      headerSliverBuilder: widget.headerSliverBuilder ??
          (BuildContext context, bool innerBoxIsScrolled) =>
              _sliverBuilder(slivers, sliverModel));

  CustomScrollView get customScrollView => CustomScrollView(
      slivers: _sliverBuilder(slivers, sliverModel),
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      center: widget.center,
      anchor: widget.anchor,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      restorationId: widget.restorationId,
      scrollBehavior: widget.scrollBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      clipBehavior: widget.clipBehavior);

  List<Widget> _sliverBuilder(
          List<Widget> slivers, List<_SliverModel> _sliver) =>
      slivers.builderEntry<Widget>((MapEntry<int, Widget> entry) {
        final Widget element = entry.value;
        final int index = entry.key;
        final _SliverModel sliver = _sliver[index];
        if (element is SliverAppBar) {
          return _SliverAppBar(
              sliverAppBar: element,
              bottomSize: sliver.extraSize,
              expandedHeight: math.max(sliver.size.height,
                  kToolbarHeight + sliver.extraSize.height));
        } else if (element is ExtendedSliverPersistentHeader) {
          return _ExtendedSliverPersistentHeader(
              header: element, maxHeight: sliver.size.height);
        }
        return element;
      });
}

/// 初始化 delegate
class ExtendedSliverPersistentHeader extends SliverPersistentHeader {
  ExtendedSliverPersistentHeader(
      {Key? key,
      bool pinned = true,
      bool floating = true,
      this.minHeight,
      this.maxHeight,
      required this.child})
      : super(
            key: key,
            pinned: pinned,
            floating: floating,
            delegate: pinned
                ? _PinnedPersistentHeaderDelegate(
                    height: maxHeight, child: child)
                : _NoPinnedPersistentHeaderDelegate(
                    minHeight: minHeight, maxHeight: maxHeight, child: child));

  /// 默认为 [kToolbarHeight]
  final double? minHeight;

  /// 默认为 [kToolbarHeight]
  final double? maxHeight;

  /// header 内容
  final Widget child;
}

/// 组合使用 [FlexibleSpaceBar]、[SliverAppBar]
/// bottom 添加PreferredSize
/// 配合 [ExtendedScrollView] 使用 无需设置 [expandedHeight]
class ExtendedSliverAppBar extends SliverAppBar {
  ExtendedSliverAppBar({
    Key? key,

    /// 是否提供控件占位。
    bool automaticallyImplyLeading = true,

    /// 左侧的图标或文字，多为返回箭头
    Widget? leading,
    double? leadingWidth,

    /// 已被显示最高为 [kToolbarHeight]
    Widget? title,

    /// 标题是否居中显示
    bool centerTitle = true,

    /// 标题右侧的操作
    List<Widget>? actions,

    /// 已被限制显示最高为 [kToolbarHeight]
    /// SliverAppBar的底部区
    Widget? bottom,
    Size bottomSize = const Size(double.infinity, kToolbarHeight),

    /// 阴影
    double? elevation,

    /// 是否显示阴影
    bool forceElevated = false,

    /// FlexibleSpaceBar
    /// 可以理解为SliverAppBar的背景内容区
    Widget? flexibleSpaceTitle,
    Widget? flexibleSpace,
    Widget? background,
    bool flexibleCenterTitle = true,
    EdgeInsetsGeometry? titlePadding,
    CollapseMode collapseMode = CollapseMode.pin,
    List<StretchMode> stretchModes = const <StretchMode>[
      StretchMode.zoomBackground
    ],
    double? expandedHeight,

    /// 背景颜色
    Color? backgroundColor,

    /// SliverAppBar图标主题
    IconThemeData? iconTheme,
    TextStyle? titleTextStyle,
    TextStyle? toolbarTextStyle,

    /// action图标主题
    IconThemeData? actionsIconTheme,

    /// 如果希望title占用所有可用空间，请将此值设置为0.0。
    double titleSpacing = NavigationToolbar.kMiddleSpacing,

    /// 是否显示在状态栏的下面,false就会占领状态栏的高度
    bool primary = true,

    /// 状态栏主题
    SystemUiOverlayStyle? systemOverlayStyle,
    AsyncCallback? onStretchTrigger,

    /// [pinned]=true AppBar[title]不消失
    bool pinned = false,

    /// [floating]=true，AppBar下拉手势时立即展开（即使下面滚动组件不在顶部）
    bool floating = false,

    /// [floating]&&[snap] is true，AppBar下拉手势时立即全部展开
    bool snap = false,
    bool stretch = true,
    double stretchTriggerOffset = 100,
    ShapeBorder? shape,
    double toolbarHeight = kToolbarHeight,
    double? collapsedHeight,
    Color? foregroundColor,
    Color? shadowColor,
    bool excludeHeaderSemantics = false,
  }) : super(
            key: key,
            title: title,
            actions: actions,
            forceElevated: forceElevated,
            backgroundColor: backgroundColor,
            iconTheme: iconTheme,
            toolbarTextStyle: toolbarTextStyle,
            titleTextStyle: titleTextStyle,
            actionsIconTheme: actionsIconTheme,
            titleSpacing: titleSpacing,
            primary: primary,
            centerTitle: centerTitle,
            stretch: stretch,
            stretchTriggerOffset: stretchTriggerOffset,
            systemOverlayStyle: systemOverlayStyle,
            onStretchTrigger: onStretchTrigger,
            elevation: elevation,
            leading: leading,
            leadingWidth: leadingWidth,
            pinned: pinned,
            floating: floating,
            snap: snap,
            shape: shape,
            expandedHeight: expandedHeight,
            toolbarHeight: toolbarHeight,
            collapsedHeight: collapsedHeight,
            automaticallyImplyLeading: automaticallyImplyLeading,
            foregroundColor: foregroundColor,
            excludeHeaderSemantics: excludeHeaderSemantics,
            shadowColor: shadowColor,
            bottom: bottom == null
                ? null
                : PreferredSize(child: bottom, preferredSize: bottomSize),
            flexibleSpace: flexibleSpace ??
                (flexibleSpaceTitle != null || background != null
                    ? FlexibleSpaceBar(
                        title: flexibleSpaceTitle,
                        centerTitle: flexibleCenterTitle,
                        titlePadding: titlePadding,
                        collapseMode: collapseMode,
                        stretchModes: stretchModes,
                        background: background)
                    : null));
}

/// 简化部分参数 [FlexibleSpaceBar]
class ExtendedFlexibleSpaceBar extends FlexibleSpaceBar {
  const ExtendedFlexibleSpaceBar({
    Key? key,
    Widget? title,
    Widget? background,
    bool centerTitle = true,
    EdgeInsetsGeometry? titlePadding,
    CollapseMode collapseMode = CollapseMode.parallax,
    List<StretchMode> stretchModes = const <StretchMode>[
      StretchMode.zoomBackground
    ],
  }) : super(
            key: key,
            title: title,
            centerTitle: centerTitle,
            titlePadding: titlePadding,
            collapseMode: collapseMode,
            stretchModes: stretchModes,
            background: background);
}

class _SliverModel {
  _SliverModel(
      {this.sliver,
      this.key,
      this.size = const Size(0, 0),
      this.extraKey,
      this.extraSize = const Size(0, 0)});

  Widget? sliver;
  GlobalKey? key;
  Size size;
  GlobalKey? extraKey;
  Size extraSize;
}

class _Calculate extends StatelessWidget {
  const _Calculate({
    Key? key,
    required this.slivers,
    required this.sliverModel,
  }) : super(key: key);
  final List<Widget> slivers;
  final List<_SliverModel> sliverModel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> column = <Widget>[];
    if (slivers.isNotEmpty) {
      for (final Widget element in slivers) {
        final _SliverModel _sliver = _SliverModel();
        _sliver.sliver = element;
        if (element is SliverAppBar) {
          final Widget flexibleSpace = element.flexibleSpace!;
          final GlobalKey flexibleSpaceKey = GlobalKey();
          if (flexibleSpace is FlexibleSpaceBar) {
            final List<Widget> stack = <Widget>[];
            final FlexibleSpaceBar space = flexibleSpace;
            if (space.title != null) stack.add(space.title!);
            if (space.background != null) stack.add(space.background!);
            column.add(Stack(key: flexibleSpaceKey, children: stack));
          } else {
            column.add(Container(key: flexibleSpaceKey, child: flexibleSpace));
          }
          _sliver.key = flexibleSpaceKey;
          if (element.bottom != null) {
            final GlobalKey bottomKey = GlobalKey();
            column.add(Container(key: bottomKey, child: element.bottom));
            _sliver.extraKey = bottomKey;
          }
        } else if (element is ExtendedSliverPersistentHeader) {
          final GlobalKey persistentHeaderKey = GlobalKey();
          column.add(Container(key: persistentHeaderKey, child: element.child));
          _sliver.key = persistentHeaderKey;
        }
        sliverModel.add(_sliver);
      }
    }
    return Column(children: column);
  }
}

/// [SliverPersistentHeader] 固定
class _PinnedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedPersistentHeaderDelegate({
    required this.child,
    double? height,
  }) : height = height ?? kToolbarHeight;

  final Widget child;
  final double? height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => height!;

  @override
  double get minExtent => height!;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

/// [SliverPersistentHeader] 不固定
class _NoPinnedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _NoPinnedPersistentHeaderDelegate({
    double? minHeight = 0,
    double? maxHeight = kToolbarHeight,
    required this.child,
  })  : minHeight = minHeight ?? 0,
        maxHeight = maxHeight ?? kToolbarHeight;

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  bool shouldRebuild(_NoPinnedPersistentHeaderDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}

class _ExtendedSliverPersistentHeader extends SliverPersistentHeader {
  _ExtendedSliverPersistentHeader(
      {Key? key, required this.header, required this.maxHeight})
      : super(
            key: key,
            pinned: header.pinned,
            floating: header.floating,
            delegate: header.pinned
                ? _PinnedPersistentHeaderDelegate(
                    height: header.maxHeight ?? maxHeight, child: header.child)
                : _NoPinnedPersistentHeaderDelegate(
                    child: header.child,
                    minHeight: header.minHeight ?? maxHeight,
                    maxHeight: header.maxHeight ?? maxHeight,
                  ));

  final ExtendedSliverPersistentHeader header;
  final double maxHeight;
}

class _SliverAppBar extends SliverAppBar {
  _SliverAppBar({
    Key? key,
    required this.sliverAppBar,
    double? expandedHeight,
    Size? bottomSize,
  }) : super(
            key: key,
            automaticallyImplyLeading: sliverAppBar.automaticallyImplyLeading,
            title: sliverAppBar.title,
            actions: sliverAppBar.actions,
            forceElevated: sliverAppBar.forceElevated,
            backgroundColor: sliverAppBar.backgroundColor,
            iconTheme: sliverAppBar.iconTheme,
            actionsIconTheme: sliverAppBar.actionsIconTheme,
            toolbarTextStyle: sliverAppBar.toolbarTextStyle,
            titleTextStyle: sliverAppBar.titleTextStyle,
            primary: sliverAppBar.primary,
            centerTitle: sliverAppBar.centerTitle,
            titleSpacing: sliverAppBar.titleSpacing,
            snap: sliverAppBar.snap,
            stretch: sliverAppBar.stretch,
            stretchTriggerOffset: sliverAppBar.stretchTriggerOffset,
            onStretchTrigger: sliverAppBar.onStretchTrigger,
            elevation: sliverAppBar.elevation,
            systemOverlayStyle: sliverAppBar.systemOverlayStyle,
            leading: sliverAppBar.leading,
            pinned: sliverAppBar.pinned,
            floating: sliverAppBar.floating,
            expandedHeight: sliverAppBar.expandedHeight ?? expandedHeight,
            shape: sliverAppBar.shape,
            toolbarHeight: sliverAppBar.toolbarHeight,
            leadingWidth: sliverAppBar.leadingWidth,
            collapsedHeight: sliverAppBar.collapsedHeight,
            foregroundColor: sliverAppBar.foregroundColor,
            excludeHeaderSemantics: sliverAppBar.excludeHeaderSemantics,
            shadowColor: sliverAppBar.shadowColor,
            bottom: sliverAppBar.bottom == null
                ? null
                : PreferredSize(
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: bottomSize!.height),
                        child: sliverAppBar.bottom),
                    preferredSize: bottomSize),
            flexibleSpace: sliverAppBar.flexibleSpace);

  final SliverAppBar sliverAppBar;
}

typedef OnSliverPinnedPersistentHeaderDelegateBuild = void Function(
  BuildContext context,
  double shrinkOffset,
  double? minExtent,
  double maxExtent,
  bool overlapsContent,
);

abstract class SliverPinnedPersistentHeaderDelegate {
  SliverPinnedPersistentHeaderDelegate({
    required this.minExtentProtoType,
    required this.maxExtentProtoType,
  });

  final Widget minExtentProtoType;

  final Widget maxExtentProtoType;

  Widget build(BuildContext context, double shrinkOffset, double? minExtent,
      double maxExtent, bool overlapsContent);

  bool shouldRebuild(
      covariant SliverPinnedPersistentHeaderDelegate oldDelegate);
}

class SliverPinnedPersistentHeader extends StatelessWidget {
  const SliverPinnedPersistentHeader({Key? key, required this.delegate})
      : super(key: key);

  final SliverPinnedPersistentHeaderDelegate delegate;

  @override
  Widget build(BuildContext context) =>
      SliverPinnedPersistentHeaderRenderObjectWidget(delegate);
}

class SliverPinnedPersistentHeaderRenderObjectWidget
    extends RenderObjectWidget {
  const SliverPinnedPersistentHeaderRenderObjectWidget(this.delegate,
      {Key? key})
      : super(key: key);

  final SliverPinnedPersistentHeaderDelegate delegate;

  @override
  RenderObjectElement createElement() =>
      SliverPinnedPersistentHeaderElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverPinnedPersistentHeader();
}

class SliverPinnedToBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedToBoxAdapter({Key? key, Widget? child})
      : super(key: key, child: child);

  @override
  RenderSliverPinnedToBoxAdapter createRenderObject(BuildContext context) =>
      RenderSliverPinnedToBoxAdapter();
}

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.background,
    this.toolBarColor,
    this.onBuild,
    this.statusBarHeight,
    this.toolbarHeight,
    this.isOpacityFadeWithToolbar = true,
    this.isOpacityFadeWithTitle = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  final Widget? leading;

  final Widget? title;

  final Widget? actions;

  final Widget? background;

  final Color? toolBarColor;

  final OnSliverPinnedPersistentHeaderDelegateBuild? onBuild;

  final double? toolbarHeight;

  final double? statusBarHeight;

  final bool isOpacityFadeWithToolbar;

  final bool isOpacityFadeWithTitle;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final SafeArea? safeArea =
        context.findAncestorWidgetOfExactType<SafeArea>();
    double? height = statusBarHeight;
    final double toolbarHeight = this.toolbarHeight ?? kToolbarHeight;
    if (height == null && (safeArea == null || !safeArea.top)) {
      height = MediaQuery.of(context).padding.top;
    }
    height ??= 0;
    final Widget toolbar = SizedBox(height: toolbarHeight + height);
    return SliverPinnedPersistentHeader(
        delegate: _CustomSliverAppbarDelegate(
            minExtentProtoType: toolbar,
            maxExtentProtoType: background ?? toolbar,
            title: title,
            leading: leading,
            actions: actions,
            background: background,
            statusBarHeight: height,
            toolbarHeight: toolbarHeight,
            toolBarColor: toolBarColor,
            onBuild: onBuild,
            isOpacityFadeWithToolbar: isOpacityFadeWithToolbar,
            isOpacityFadeWithTitle: isOpacityFadeWithTitle,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment));
  }
}

class _CustomSliverAppbarDelegate extends SliverPinnedPersistentHeaderDelegate {
  _CustomSliverAppbarDelegate({
    required Widget minExtentProtoType,
    required Widget maxExtentProtoType,
    this.leading,
    this.title,
    this.actions,
    this.background,
    this.toolBarColor,
    this.onBuild,
    this.statusBarHeight,
    this.toolbarHeight,
    this.isOpacityFadeWithToolbar = true,
    this.isOpacityFadeWithTitle = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(
            minExtentProtoType: minExtentProtoType,
            maxExtentProtoType: maxExtentProtoType);

  final Widget? leading;

  final Widget? title;

  final Widget? actions;

  final Widget? background;

  final Color? toolBarColor;

  final OnSliverPinnedPersistentHeaderDelegateBuild? onBuild;

  final double? toolbarHeight;

  final double? statusBarHeight;

  final bool isOpacityFadeWithToolbar;

  final bool isOpacityFadeWithTitle;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context, double shrinkOffset, double? minExtent,
      double maxExtent, bool overlapsContent) {
    onBuild?.call(context, shrinkOffset, minExtent, maxExtent, overlapsContent);
    final double opacity =
        (shrinkOffset / (maxExtent - minExtent!)).clamp(0.0, 1.0);
    Widget? titleWidget = title;
    if (titleWidget != null) {
      if (isOpacityFadeWithTitle) {
        titleWidget = Opacity(opacity: opacity, child: titleWidget);
      }
    } else {
      titleWidget = Container();
    }
    final ThemeData theme = Theme.of(context);

    Color toolBarColor = this.toolBarColor ?? theme.primaryColor;
    if (isOpacityFadeWithToolbar) {
      toolBarColor = toolBarColor.withOpacity(opacity);
    }

    final Widget toolbar = Universal(
        height: toolbarHeight! + statusBarHeight!,
        padding: EdgeInsets.only(top: statusBarHeight!),
        color: toolBarColor,
        direction: Axis.horizontal,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          leading ?? const BackButton(onPressed: null),
          titleWidget,
          actions ?? Container(width: 100)
        ]);

    return Material(
        child: Universal(isClipRect: true, isStack: true, children: <Widget>[
      Positioned(
          child: maxExtentProtoType,
          top: -shrinkOffset,
          bottom: 0,
          left: 0,
          right: 0),
      Positioned(child: toolbar, top: 0, left: 0, right: 0),
    ]));
  }

  @override
  bool shouldRebuild(SliverPinnedPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) return true;

    return oldDelegate is _CustomSliverAppbarDelegate &&
        (oldDelegate.minExtentProtoType != minExtentProtoType ||
            oldDelegate.maxExtentProtoType != maxExtentProtoType ||
            oldDelegate.leading != leading ||
            oldDelegate.title != title ||
            oldDelegate.actions != actions ||
            oldDelegate.background != background ||
            oldDelegate.statusBarHeight != statusBarHeight ||
            oldDelegate.toolBarColor != toolBarColor ||
            oldDelegate.toolbarHeight != toolbarHeight ||
            oldDelegate.onBuild != onBuild ||
            oldDelegate.isOpacityFadeWithTitle != isOpacityFadeWithTitle ||
            oldDelegate.isOpacityFadeWithToolbar != isOpacityFadeWithToolbar ||
            oldDelegate.mainAxisAlignment != mainAxisAlignment ||
            oldDelegate.crossAxisAlignment != crossAxisAlignment);
  }
}
