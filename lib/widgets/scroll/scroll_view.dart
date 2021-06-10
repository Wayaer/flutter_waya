import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 配合 sliver 家族组件 无需设置高度  自适应高度
class ExtendScrollView extends StatefulWidget {
  const ExtendScrollView(
      {Key? key,
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
      this.semanticChildCount})
      : isNestedScrollView = false,
        floatHeaderSlivers = true,
        body = null,
        headerSliverBuilder = null,
        super(key: key);

  const ExtendScrollView.nested({
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
  })  : isNestedScrollView = true,
        primary = null,
        shrinkWrap = false,
        center = null,
        anchor = 0.0,
        cacheExtent = null,
        semanticChildCount = null,
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

  @override
  _ExtendScrollViewState createState() => _ExtendScrollViewState();
}

class _ExtendScrollViewState extends State<ExtendScrollView> {
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
      body: widget.body!,
      restorationId: widget.restorationId,
      controller: widget.controller,
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
        } else if (element is ExtendSliverPersistentHeader) {
          return _ExtendSliverPersistentHeader(
              header: element, maxHeight: sliver.size.height);
        }
        return element;
      });
}

/// 初始化 delegate
class ExtendSliverPersistentHeader extends SliverPersistentHeader {
  ExtendSliverPersistentHeader(
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
/// 配合 [ExtendScrollView] 使用 无需设置 [expandedHeight]
class ExtendSliverAppBar extends SliverAppBar {
  ExtendSliverAppBar({
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
    Size? bottomSize,

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

    /// 文字主题
    TextTheme? textTheme,

    /// action图标主题
    IconThemeData? actionsIconTheme,

    /// 如果希望title占用所有可用空间，请将此值设置为0.0。
    double titleSpacing = NavigationToolbar.kMiddleSpacing,

    /// 是否显示在状态栏的下面,false就会占领状态栏的高度
    bool primary = true,

    /// 状态栏主题，默认Brightness.dark
    Brightness? brightness,
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
  }) : super(
            key: key,
            title: title,
            actions: actions,
            forceElevated: forceElevated,
            backgroundColor: backgroundColor,
            iconTheme: iconTheme,
            textTheme: textTheme,
            actionsIconTheme: actionsIconTheme,
            titleSpacing: titleSpacing,
            primary: primary,
            centerTitle: centerTitle,
            stretch: stretch,
            stretchTriggerOffset: stretchTriggerOffset,
            brightness: brightness,
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
            bottom: bottom == null
                ? null
                : PreferredSize(child: bottom, preferredSize: bottomSize!),
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
class ExtendFlexibleSpaceBar extends FlexibleSpaceBar {
  const ExtendFlexibleSpaceBar({
    Widget? title,
    Widget? background,
    bool centerTitle = true,
    EdgeInsetsGeometry? titlePadding,
    CollapseMode collapseMode = CollapseMode.parallax,
    List<StretchMode> stretchModes = const <StretchMode>[
      StretchMode.zoomBackground
    ],
  }) : super(
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
        } else if (element is ExtendSliverPersistentHeader) {
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

class _ExtendSliverPersistentHeader extends SliverPersistentHeader {
  _ExtendSliverPersistentHeader(
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

  final ExtendSliverPersistentHeader header;
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
            textTheme: sliverAppBar.textTheme,
            primary: sliverAppBar.primary,
            centerTitle: sliverAppBar.centerTitle,
            titleSpacing: sliverAppBar.titleSpacing,
            snap: sliverAppBar.snap,
            stretch: sliverAppBar.stretch,
            stretchTriggerOffset: sliverAppBar.stretchTriggerOffset,
            onStretchTrigger: sliverAppBar.onStretchTrigger,
            elevation: sliverAppBar.elevation,
            brightness: sliverAppBar.brightness,
            leading: sliverAppBar.leading,
            pinned: sliverAppBar.pinned,
            floating: sliverAppBar.floating,
            expandedHeight: sliverAppBar.expandedHeight ?? expandedHeight,
            shape: sliverAppBar.shape,
            toolbarHeight: sliverAppBar.toolbarHeight,
            leadingWidth: sliverAppBar.leadingWidth,
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

/// 可刷新的滚动组件
/// 嵌套 sliver 家族组件
class RefreshScrollView extends ScrollView {
  RefreshScrollView({
    this.refreshConfig,
    bool? noScrollBehavior = false,
    this.padding,
    Key? key,
    Axis? scrollDirection = Axis.vertical,
    bool? reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap = false,
    Key? center,
    double anchor = 0.0,
    double? cacheExtent,
    this.slivers = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior? dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip? clipBehavior = Clip.hardEdge,
  })  : noScrollBehavior = noScrollBehavior ?? false,
        super(
            key: key,
            controller: controller,
            scrollDirection: scrollDirection ?? Axis.vertical,
            shrinkWrap: _shrinkWrap(shrinkWrap, physics),
            reverse: reverse ?? false,
            clipBehavior: clipBehavior ?? Clip.hardEdge,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary,
            center: center,
            anchor: anchor,
            semanticChildCount: semanticChildCount,
            keyboardDismissBehavior: keyboardDismissBehavior ??
                ScrollViewKeyboardDismissBehavior.manual);

  static bool _shrinkWrap(bool? shrinkWrap, ScrollPhysics? physics) {
    if (physics == const NeverScrollableScrollPhysics()) return true;
    return shrinkWrap ?? false;
  }

  final List<Widget> slivers;
  final bool noScrollBehavior;
  final EdgeInsetsGeometry? padding;
  final RefreshConfig? refreshConfig;

  @override
  Widget build(BuildContext context) {
    Widget widget = super.build(context);
    if (refreshConfig != null)
      widget = EasyRefreshed(
          slivers: buildSlivers(context),
          scrollDirection: scrollDirection,
          reverse: reverse,
          scrollController: controller,
          controller: refreshConfig!.controller,
          onLoading: refreshConfig!.onLoading,
          onRefresh: refreshConfig!.onRefresh,
          header: refreshConfig!.header,
          footer: refreshConfig!.footer,
          primary: primary,
          shrinkWrap: shrinkWrap,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior);
    if (padding != null) widget = Padding(padding: padding!, child: widget);
    if (noScrollBehavior)
      widget = ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
    return widget;
  }

  @override
  List<Widget> buildSlivers(BuildContext context) => slivers;
}

class ScrollList extends RefreshScrollView {
  /// 滑动类型设置 [physics]
  /// AlwaysScrollableScrollPhysics() 总是可以滑动
  /// NeverScrollableScrollPhysics() 禁止滚动
  /// BouncingScrollPhysics()  内容超过一屏 上拉有回弹效果
  /// ClampingScrollPhysics()  包裹内容 不会有回弹

  ScrollList({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,
    required this.sliver,
    this.header,
    this.footer,
  }) : super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection ?? Axis.vertical,
            shrinkWrap: shrinkWrap,
            reverse: reverse ?? false,
            clipBehavior: clipBehavior ?? Clip.hardEdge,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.builder({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    double? itemExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    ChildIndexGetter? findChildIndexCallback,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    int? crossAxisCount = 1,

    /// 水平子Widget之间间距
    double? mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    double? crossAxisSpacing = 0,

    /// 子 Widget 宽高比例 [crossAxisCount]>1是 有效
    double? childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    bool? crossAxisFlex = false,

    /// 单个子Widget的水平最大宽度
    double? maxCrossAxisExtent,
    double? mainAxisExtent,
    Widget? placeholder,
    this.header,
    this.footer,
  })  : sliver = <SliverListGrid>[
          SliverListGrid(
              placeholder: placeholder,
              mainAxisExtent: mainAxisExtent,
              maxCrossAxisExtent: maxCrossAxisExtent,
              crossAxisFlex: crossAxisFlex,
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              findChildIndexCallback: findChildIndexCallback,
              itemBuilder: itemBuilder,
              itemCount: itemCount,
              itemExtent: itemExtent)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.separated({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    double? itemExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required IndexedWidgetBuilder separatorBuilder,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,
    Widget? placeholder,
    this.header,
    this.footer,
  })  : sliver = <SliverListGrid>[
          SliverListGrid(
              placeholder: placeholder,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              itemBuilder: itemBuilder,
              separatorBuilder: separatorBuilder,
              itemCount: itemCount,
              itemExtent: itemExtent)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  ScrollList.count({
    Key? key,
    Clip? clipBehavior,
    bool? reverse,
    double? cacheExtent,
    bool? primary,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    ScrollController? controller,
    String? restorationId,
    bool? shrinkWrap = false,
    double? itemExtent,
    required List<Widget> children,
    bool addAutomaticKeepALives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    RefreshConfig? refreshConfig,
    bool? noScrollBehavior = false,
    EdgeInsetsGeometry? padding,

    /// 多列最大列数 [crossAxisCount]>1 固定列
    int? crossAxisCount = 1,

    /// 水平子Widget之间间距
    double? mainAxisSpacing = 0,

    /// 垂直子Widget之间间距
    double? crossAxisSpacing = 0,

    /// 子 Widget 宽高比例 [crossAxisCount]>1是 有效
    double? childAspectRatio = 1,

    /// 是否开启列数自适应
    /// [crossAxisFlex]=true 为多列 且宽度自适应
    /// [maxCrossAxisExtent]设置最大宽度
    bool? crossAxisFlex = false,

    /// 单个子Widget的水平最大宽度
    double? maxCrossAxisExtent,
    double? mainAxisExtent,
    Widget? placeholder,
    this.header,
    this.footer,
  })  : sliver = <SliverListGrid>[
          SliverListGrid(
              placeholder: placeholder,
              mainAxisExtent: mainAxisExtent,
              maxCrossAxisExtent: maxCrossAxisExtent,
              crossAxisFlex: crossAxisFlex,
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              addSemanticIndexes: addSemanticIndexes,
              addRepaintBoundaries: addRepaintBoundaries,
              addAutomaticKeepALives: addAutomaticKeepALives,
              children: children,
              itemExtent: itemExtent)
        ],
        super(
            key: key,
            padding: padding,
            refreshConfig: refreshConfig,
            noScrollBehavior: noScrollBehavior,
            controller: controller,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
            clipBehavior: clipBehavior,
            dragStartBehavior: dragStartBehavior,
            cacheExtent: cacheExtent,
            restorationId: restorationId,
            physics: physics,
            primary: primary);

  /// 添加多个 [SliverListGrid]
  final List<SliverListGrid> sliver;

  /// 添加头部 Sliver 组件
  final Widget? header;

  /// 添加底部 Sliver 组件
  final Widget? footer;

  @override
  List<Widget> buildSlivers(BuildContext context) {
    final List<Widget> slivers = <Widget>[];
    if (sliver.isNotEmpty) slivers.addAll(sliver);
    if (header != null) slivers.insert(0, header!);
    if (footer != null) slivers.add(footer!);
    return slivers;
  }
}
