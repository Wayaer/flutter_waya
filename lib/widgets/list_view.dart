// class SimpleList extends StatelessWidget {
//   const SimpleList.count({
//     Key? key,
//     this.noScrollBehavior = false,
//     this.crossAxisFlex = false,
//     this.crossAxisCount = 1,
//     this.childAspectRatio = 1,
//     this.mainAxisSpacing = 0,
//     this.crossAxisSpacing = 0,
//     this.scrollDirection = Axis.vertical,
//     this.reverse = false,
//     this.controller,
//     this.primary,
//     this.physics,
//     this.shrinkWrap = false,
//     this.padding,
//     this.cacheExtent,
//     this.children,
//     this.clipBehavior = Clip.hardEdge,
//     this.itemExtent,
//     this.placeholder,
//     this.refreshConfig,
//     this.maxCrossAxisExtent,
//   })  : assert(!crossAxisFlex ||
//             (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
//         itemBuilder = null,
//         separatorBuilder = null,
//         itemCount = 0,
//         super(key: key);
//
//   const SimpleList.builder({
//     Key? key,
//     this.noScrollBehavior = false,
//     this.crossAxisFlex = false,
//     this.crossAxisCount = 1,
//     this.childAspectRatio = 1,
//     this.mainAxisSpacing = 0,
//     this.crossAxisSpacing = 0,
//     required this.itemBuilder,
//     required this.itemCount,
//     this.scrollDirection = Axis.vertical,
//     this.reverse = false,
//     this.controller,
//     this.primary,
//     this.physics,
//     this.shrinkWrap = false,
//     this.padding,
//     this.itemExtent,
//     this.cacheExtent,
//     this.clipBehavior = Clip.hardEdge,
//     this.maxCrossAxisExtent,
//     this.placeholder,
//     this.refreshConfig,
//   })  : assert(itemCount >= 0),
//         separatorBuilder = null,
//         children = null,
//         assert(!crossAxisFlex ||
//             (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
//         super(key: key);
//
//   const SimpleList.separated({
//     Key? key,
//     this.noScrollBehavior = false,
//     this.crossAxisFlex = false,
//     this.scrollDirection = Axis.vertical,
//     this.reverse = false,
//     this.controller,
//     this.primary,
//     this.physics,
//     this.shrinkWrap = false,
//     this.padding,
//     required this.itemBuilder,
//     required this.itemCount,
//     required this.separatorBuilder,
//     this.cacheExtent,
//     this.clipBehavior = Clip.hardEdge,
//     this.placeholder,
//     this.refreshConfig,
//   })  : assert(itemBuilder != null),
//         assert(separatorBuilder != null),
//         assert(itemCount >= 0),
//         children = null,
//         itemExtent = null,
//         crossAxisCount = 1,
//         mainAxisSpacing = 0,
//         crossAxisSpacing = 0,
//         maxCrossAxisExtent = 1,
//         childAspectRatio = 1,
//         super(key: key);
//
//   /// [itemCount]==0 || [children].length==0 显示此组件
//   final Widget? placeholder;
//   final IndexedWidgetBuilder? itemBuilder;
//   final IndexedWidgetBuilder? separatorBuilder;
//   final int itemCount;
//   final List<Widget>? children;
//
//   final Clip clipBehavior;
//   final Axis scrollDirection;
//
//   ///  刷新组件相关
//   final RefreshConfig? refreshConfig;
//
//   /// 是否倒置列表
//   final bool reverse;
//
//   /// 当嵌套在无限长的组件里时必须设置为true
//   final bool shrinkWrap;
//
//   /// 滑动类型设置
//   /// AlwaysScrollableScrollPhysics() 总是可以滑动
//   /// NeverScrollableScrollPhysics() 禁止滚动
//   /// BouncingScrollPhysics()  内容超过一屏 上拉有回弹效果
//   /// ClampingScrollPhysics()  包裹内容 不会有回弹
//   final ScrollPhysics? physics;
//
//   /// 是否显示头部和底部蓝色阴影
//   final bool noScrollBehavior;
//
//   final ScrollController? controller;
//   final EdgeInsetsGeometry? padding;
//
//   /// 是否开启列数自适应
//   /// [crossAxisFlex]=true 为多列 且宽度自适应
//   final bool crossAxisFlex;
//
//   /// 多列最大列数 [crossAxisCount]>1 固定列
//   final int crossAxisCount;
//
//   /// ***** GridView ***** ///
//   ///  水平子Widget之间间距
//   final double mainAxisSpacing;
//
//   ///  垂直子Widget之间间距
//   final double crossAxisSpacing;
//
//   ///  单个子Widget的水平最大宽度
//   final double? maxCrossAxisExtent;
//
//   ///  子 Widget 宽高比例 [crossAxisCount]>1是 有效
//   final double childAspectRatio;
//
//   /// 确定每一个item的高度 会让item加载更加高效
//   final double? itemExtent;
//
//   /// 设置预加载的区域
//   final double? cacheExtent;
//
//   /// 如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
//   final bool? primary;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget widget = Container();
//     if (children != null)
//       widget = children!.isNotEmpty
//           ? count
//           : (placeholder ?? const PlaceholderChild());
//     if (itemBuilder != null) {
//       if (itemCount < 1) {
//         widget = placeholder ?? const PlaceholderChild();
//       } else {
//         widget = separatorBuilder == null ? builder : separated;
//       }
//     }
//     // if (refreshConfig != null) widget = refresherListView(widget);
//     return widget;
//   }
//
//   ScrollList get count => ScrollList.count(
//       children: children!,
//       scrollDirection: scrollDirection,
//       reverse: reverse,
//       controller: controller,
//       primary: primary,
//       physics: physics,
//       shrinkWrap: shrinkWrap,
//       padding: padding,
//       cacheExtent: cacheExtent,
//       clipBehavior: clipBehavior,
//       crossAxisFlex: crossAxisFlex,
//       crossAxisCount: crossAxisCount,
//       mainAxisSpacing: mainAxisSpacing,
//       crossAxisSpacing: crossAxisSpacing,
//       maxCrossAxisExtent: maxCrossAxisExtent,
//       childAspectRatio: childAspectRatio,
//       noScrollBehavior: noScrollBehavior);
//
//   ScrollList get separated => ScrollList.separated(
//       itemBuilder: itemBuilder!,
//       itemCount: itemCount,
//       separatorBuilder: separatorBuilder!,
//       scrollDirection: scrollDirection,
//       reverse: reverse,
//       controller: controller,
//       primary: primary,
//       physics: physics,
//       shrinkWrap: shrinkWrap,
//       padding: padding,
//       cacheExtent: cacheExtent,
//       clipBehavior: clipBehavior,
//       noScrollBehavior: noScrollBehavior);
//
//   ScrollList get builder => ScrollList.builder(
//       itemBuilder: itemBuilder!,
//       itemCount: itemCount,
//       scrollDirection: scrollDirection,
//       reverse: reverse,
//       controller: controller,
//       primary: primary,
//       physics: physics,
//       shrinkWrap: shrinkWrap,
//       padding: padding,
//       cacheExtent: cacheExtent,
//       itemExtent: itemExtent,
//       clipBehavior: clipBehavior,
//       crossAxisFlex: crossAxisFlex,
//       crossAxisCount: crossAxisCount,
//       mainAxisSpacing: mainAxisSpacing,
//       crossAxisSpacing: crossAxisSpacing,
//       maxCrossAxisExtent: maxCrossAxisExtent,
//       childAspectRatio: childAspectRatio,
//       noScrollBehavior: noScrollBehavior);
//
//   Widget refresherListView(Widget child) => PullRefreshed(
//       controller: refreshConfig?.controller,
//       child: child,
//       onRefresh: refreshConfig?.onRefresh,
//       onLoading: refreshConfig?.onLoading,
//       header: refreshConfig?.header,
//       footer: refreshConfig?.footer);
// }
//
// /// 自定义List Grid  List
// class ScrollList extends BoxScrollView {
//   ScrollList.count({
//     Key? key,
//     bool addAutomaticKeepALives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     bool reverse = false,
//     bool? primary,
//     bool shrinkWrap = false,
//     Axis scrollDirection = Axis.vertical,
//     ScrollController? controller,
//     ScrollPhysics? physics,
//     EdgeInsetsGeometry? padding = EdgeInsets.zero,
//     double? cacheExtent,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//     this.itemExtent,
//     this.noScrollBehavior = false,
//     this.crossAxisCount = 1,
//     this.crossAxisFlex = false,
//     this.mainAxisSpacing = 0,
//     this.crossAxisSpacing = 0,
//     this.childAspectRatio = 1,
//     this.maxCrossAxisExtent,
//     required List<Widget> children,
//   })   : childrenDelegate = SliverChildListDelegate(children,
//             addAutomaticKeepAlives: addAutomaticKeepALives,
//             addRepaintBoundaries: addRepaintBoundaries,
//             addSemanticIndexes: addSemanticIndexes),
//         assert(!crossAxisFlex ||
//             (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
//         super(
//             key: key,
//             scrollDirection: scrollDirection,
//             reverse: reverse,
//             controller: controller,
//             primary: primary,
//             physics: physics,
//             shrinkWrap: shrinkWrap,
//             padding: padding,
//             cacheExtent: cacheExtent,
//             semanticChildCount: children.length,
//             dragStartBehavior: dragStartBehavior,
//             keyboardDismissBehavior: keyboardDismissBehavior,
//             restorationId: restorationId,
//             clipBehavior: clipBehavior);
//
//   ScrollList.builder({
//     Key? key,
//     bool addAutomaticKeepALives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     bool reverse = false,
//     bool? primary,
//     bool shrinkWrap = false,
//     Axis scrollDirection = Axis.vertical,
//     ScrollController? controller,
//     ScrollPhysics? physics,
//     EdgeInsetsGeometry? padding = EdgeInsets.zero,
//     double? cacheExtent,
//     int? semanticChildCount,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//     this.itemExtent,
//     this.noScrollBehavior = false,
//     this.crossAxisCount = 1,
//     this.crossAxisFlex = false,
//     this.mainAxisSpacing = 0,
//     this.crossAxisSpacing = 0,
//     this.childAspectRatio = 1,
//     this.maxCrossAxisExtent,
//     required IndexedWidgetBuilder itemBuilder,
//     required int itemCount,
//   })   : assert(itemCount >= 0),
//         assert(semanticChildCount == null || semanticChildCount <= itemCount),
//         assert(!crossAxisFlex ||
//             (maxCrossAxisExtent != null && maxCrossAxisExtent > 0)),
//         childrenDelegate = SliverChildBuilderDelegate(itemBuilder,
//             childCount: itemCount,
//             addAutomaticKeepAlives: addAutomaticKeepALives,
//             addRepaintBoundaries: addRepaintBoundaries,
//             addSemanticIndexes: addSemanticIndexes),
//         super(
//             key: key,
//             scrollDirection: scrollDirection,
//             reverse: reverse,
//             controller: controller,
//             primary: primary,
//             physics: physics,
//             shrinkWrap: shrinkWrap,
//             padding: padding,
//             cacheExtent: cacheExtent,
//             semanticChildCount: semanticChildCount ?? itemCount,
//             dragStartBehavior: dragStartBehavior,
//             keyboardDismissBehavior: keyboardDismissBehavior,
//             restorationId: restorationId,
//             clipBehavior: clipBehavior);
//
//   ScrollList.separated({
//     Key? key,
//     Axis scrollDirection = Axis.vertical,
//     bool reverse = false,
//     ScrollController? controller,
//     bool? primary,
//     ScrollPhysics? physics,
//     bool shrinkWrap = false,
//     EdgeInsetsGeometry? padding = EdgeInsets.zero,
//     bool addAutomaticKeepALives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     double? cacheExtent,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//     this.noScrollBehavior = false,
//     required IndexedWidgetBuilder itemBuilder,
//     required int itemCount,
//     required IndexedWidgetBuilder separatorBuilder,
//   })   : assert(itemCount >= 0),
//         itemExtent = null,
//         crossAxisFlex = false,
//         crossAxisCount = 1,
//         mainAxisSpacing = 0,
//         crossAxisSpacing = 0,
//         maxCrossAxisExtent = 1,
//         childAspectRatio = 1,
//         childrenDelegate = SliverChildBuilderDelegate(
//             (BuildContext context, int index) {
//           final int itemIndex = index ~/ 2;
//           Widget? widget;
//           if (index.isEven) {
//             widget = itemBuilder(context, itemIndex);
//           } else {
//             widget = separatorBuilder(context, itemIndex);
//             assert(() {
//               if (widget == null)
//                 throw FlutterError('separatorBuilder cannot return null.');
//               return true;
//             }());
//           }
//           return widget;
//         },
//             childCount: _computeActualChildCount(itemCount),
//             addAutomaticKeepAlives: addAutomaticKeepALives,
//             addRepaintBoundaries: addRepaintBoundaries,
//             addSemanticIndexes: addSemanticIndexes,
//             semanticIndexCallback: (Widget _, int index) =>
//                 index.isEven ? index ~/ 2 : null),
//         super(
//             key: key,
//             scrollDirection: scrollDirection,
//             reverse: reverse,
//             controller: controller,
//             primary: primary,
//             physics: physics,
//             shrinkWrap: shrinkWrap,
//             padding: padding,
//             cacheExtent: cacheExtent,
//             semanticChildCount: itemCount,
//             dragStartBehavior: dragStartBehavior,
//             keyboardDismissBehavior: keyboardDismissBehavior,
//             restorationId: restorationId,
//             clipBehavior: clipBehavior);
//
//   /// 是否显示头部和底部蓝色阴影
//   final bool noScrollBehavior;
//
//   /// 是否开启列数自适应
//   /// [crossAxisFlex]=true 为多列 且宽度自适应
//   final bool crossAxisFlex;
//
//   /// 多列最大列数 [crossAxisCount]>1 固定列
//   final int crossAxisCount;
//
//   ///  水平子Widget之间间距
//   final double mainAxisSpacing;
//
//   ///  垂直子Widget之间间距
//   final double crossAxisSpacing;
//
//   ///  单个子Widget的水平最大宽度
//   final double? maxCrossAxisExtent;
//
//   ///  子 Widget 宽高比例 [crossAxisCount]>1是 有效
//   final double childAspectRatio;
//
//   /// 确定每一个item的高度 会让item加载更加高效
//   final double? itemExtent;
//
//   /// ***** 自定义Delegate ***** ///
//   /// [SliverChildBuilderDelegate]、[SliverChildListDelegate]
//   final SliverChildDelegate? childrenDelegate;
//
//   @override
//   Widget buildChildLayout(BuildContext context) {
//     RenderObjectWidget widget = SliverToBoxAdapter(child: Container());
//
//     if (crossAxisCount > 1 || crossAxisFlex) {
//       /// [SliverGridDelegateWithMaxCrossAxisExtent]、[SliverGridDelegateWithFixedCrossAxisCount]
//       final SliverGridDelegate gridDelegate = crossAxisFlex
//           ? SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: maxCrossAxisExtent!,
//               mainAxisSpacing: mainAxisSpacing,
//               crossAxisSpacing: crossAxisSpacing)
//           : SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: childAspectRatio,
//               crossAxisCount: crossAxisCount,
//               mainAxisSpacing: mainAxisSpacing,
//               crossAxisSpacing: crossAxisSpacing);
//       widget =
//           SliverGrid(delegate: childrenDelegate!, gridDelegate: gridDelegate);
//     } else {
//       widget = itemExtent == null
//           ? SliverList(delegate: childrenDelegate!)
//           : SliverFixedExtentList(
//               delegate: childrenDelegate!, itemExtent: itemExtent!);
//     }
//     if (noScrollBehavior)
//       return ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
//     return widget;
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//         .add(DoubleProperty('itemExtent', itemExtent, defaultValue: null));
//   }
//
//   static int _computeActualChildCount(int itemCount) =>
//       math.max(0, itemCount * 2 - 1);
// }
//
