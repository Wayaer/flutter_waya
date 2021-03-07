import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void sendRefreshType([RefreshCompletedType? refresh]) =>
    eventBus.emit(refreshEvent, refresh ?? RefreshCompletedType.refresh);

typedef OnOffsetChange = void Function(bool up, double offset);

class Refreshed extends StatefulWidget {
  Refreshed({
    Key? key,
    bool? enablePullUp,
    bool? enableTwoLevel,
    bool? enablePullDown,
    Widget? header,
    this.child,
    this.onLoading,
    this.onRefresh,
    this.footer,
    this.controller,
    this.onOffsetChange,
    this.scrollDirection,
    this.reverse,
    this.scrollController,
    this.primary,
    this.physics,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior,
    this.onTwoLevel,
  })  : enablePullUp = enablePullUp ?? false,
        enableTwoLevel = enableTwoLevel ?? false,
        enablePullDown = enablePullDown ?? false,
        header = header ?? Container(),
        // header =
        //     header ?? BezierCircleHeader(bezierColor: ConstColors.transparent),
        super(key: key);

  ///  可不传controller，
  ///  若想关闭刷新组件可以通过发送消息
  ///  sendRefreshType(RefreshCompletedType.refresh);
  final RefreshController? controller;

  /// 下拉刷新回调
  final VoidCallback? onRefresh;

  /// 上拉加载回调
  final VoidCallback? onLoading;

  /// 二楼开启回调
  final VoidCallback? onTwoLevel;

  /// 要刷新的子组件
  final Widget? child;

  /// 开启下拉刷新
  final bool enablePullDown;

  /// 开启上拉加载
  final bool enablePullUp;

  /// 下拉二楼
  final bool enableTwoLevel;

  /// CustomHeader
  final Widget header;

  /// CustomFooter
  final Widget? footer;

  final OnOffsetChange? onOffsetChange;
  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior? dragStartBehavior;

  @override
  _RefreshedState createState() => _RefreshedState();
}

class _RefreshedState extends State<Refreshed> {
  late RefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? RefreshController(initialRefresh: false);
    addPostFrameCallback(
        (Duration callback) => eventBus.add(refreshEvent, (dynamic data) {
              if (data == null) return;
              if (data != null && data is RefreshCompletedType) {
                switch (data) {
                  case RefreshCompletedType.refresh:
                    controller.refreshCompleted();
                    break;
                  case RefreshCompletedType.refreshFailed:
                    controller.refreshFailed();
                    break;
                  case RefreshCompletedType.refreshToIdle:
                    controller.refreshToIdle();
                    break;
                  case RefreshCompletedType.onLoading:
                    controller.loadComplete();
                    break;
                  case RefreshCompletedType.loadFailed:
                    controller.loadFailed();
                    break;
                  case RefreshCompletedType.loadNoData:
                    controller.loadNoData();
                    break;
                  case RefreshCompletedType.twoLevel:
                    controller.twoLevelComplete();
                    break;
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
    return SmartRefresher(
        child: widget.child,
        controller: controller,
        enablePullDown: widget.enablePullDown,
        enablePullUp: widget.enablePullUp,
        enableTwoLevel: widget.enableTwoLevel,
        header: widget.header,
        footer: widget.footer ?? customFooter,
        onRefresh: widget.onRefresh ?? onRefresh,
        onLoading: widget.onLoading ?? onLoading,
        onTwoLevel: widget.onTwoLevel ?? onTwoLevel,
        onOffsetChange: widget.onOffsetChange,
        dragStartBehavior: widget.dragStartBehavior,
        primary: widget.primary,
        cacheExtent: widget.cacheExtent,
        semanticChildCount: widget.semanticChildCount,
        reverse: widget.reverse,
        physics: widget.physics,
        scrollDirection: widget.scrollDirection,
        scrollController: widget.scrollController);
  }

  Widget get customFooter =>
      CustomFooter(builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = footerText('pull loading');
        } else if (mode == LoadStatus.loading) {
          body = footerText('loading');
        } else if (mode == LoadStatus.failed) {
          body = footerText('load failed');
        } else if (mode == LoadStatus.canLoading) {
          body = footerText('load data');
        } else {
          body = footerText('load not data');
        }
        return Container(height: 40, alignment: Alignment.center, child: body);
      });

  Widget footerText(String text) => BasisText(text,
      style: const BasisTextStyle(fontSize: 13, color: ConstColors.black70));

  void onTwoLevel() {
    log('onTwoLevel');
    const Duration(seconds: 2).timer(() => controller.twoLevelComplete());
  }

  void onRefresh() {
    log('onRefresh');
    const Duration(seconds: 2).timer(() => controller.refreshCompleted());
  }

  void onLoading() {
    log('onLoading');
    const Duration(seconds: 2).timer(() => controller.loadNoData());
  }
}

// class RefreshController {
//   RefreshController({required this.initialRefresh});
//
//   final bool initialRefresh;
// }
