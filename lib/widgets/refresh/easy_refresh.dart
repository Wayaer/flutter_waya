import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_waya/flutter_waya.dart';

void sendRefreshType([EasyRefreshType? refresh]) {
  eventBus.emit(_eventName, refresh ?? EasyRefreshType.refreshSuccess);
}

class RefreshConfig {
  RefreshConfig(
      {this.header,
      this.controller,
      this.onRefresh,
      this.onLoading,
      this.footer});

  EasyRefreshController? controller;

  /// 下拉刷新回调(null为不开启刷新)
  OnRefreshCallback? onRefresh;

  /// 上拉加载回调(null为不开启加载)
  OnLoadCallback? onLoading;

  /// CustomHeader
  Header? header;

  /// CustomFooter
  Footer? footer;
}

Header globalRefreshHeader = ClassicalHeader(
    refreshText: '请尽情拉我',
    refreshReadyText: '我要开始刷新了',
    refreshingText: '我在拼命刷新中',
    refreshedText: '我已经刷新完成了',
    refreshFailedText: '我刷新失败了唉',
    noMoreText: '没有更多了',
    infoText: '现在时刻 : ' + DateTime.now().format(DateTimeDist.hourMinute));

Footer globalRefreshFooter = ClassicalFooter(
    loadText: '请尽情拉我',
    loadReadyText: '我要准备加载了',
    loadingText: '我在拼命加载中',
    loadedText: '我已经加载完成了',
    loadFailedText: '我加载失败了唉',
    noMoreText: '没有更多了哦',
    infoText: '现在时刻 : ' + DateTime.now().format(DateTimeDist.hourMinute));

EasyRefreshController? _holdController;

String get _eventName => refreshEvent + _holdController.hashCode.toString();

///  刷新类型
enum EasyRefreshType {
  /// 触发刷新
  refresh,

  /// 刷新成功
  refreshSuccess,

  /// 刷新完成 没有数据
  refreshNoMore,

  /// 刷新失败
  refreshFailed,

  /// 触发加载
  loading,

  /// 加载成功
  loadingSuccess,

  /// 加载失败
  loadFailed,

  /// 加载完成 没有数据
  loadNoMore,
}

class EasyRefreshed extends StatefulWidget {
  const EasyRefreshed({
    Key? key,
    bool? reverse,
    bool? shrinkWrap,
    Axis? scrollDirection,
    DragStartBehavior? dragStartBehavior,
    this.controller,
    this.onRefresh,
    this.onLoading,
    this.header,
    this.footer,
    required this.slivers,
    this.cacheExtent,
    this.primary,
    this.scrollController,
  })  : scrollDirection = scrollDirection ?? Axis.vertical,
        shrinkWrap = shrinkWrap ?? false,
        reverse = reverse ?? false,
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        super(key: key);

  ///  可不传controller，
  ///  若想关闭刷新组件可以通过发送消息
  ///  sendRefreshType(RefreshCompletedType.refresh);
  final EasyRefreshController? controller;
  final OnRefreshCallback? onRefresh;
  final OnLoadCallback? onLoading;

  /// CustomHeader
  final Header? header;

  /// CustomFooter
  final Footer? footer;

  final List<Widget> slivers;

  /// 是否倒置列表
  final bool reverse;

  /// 设置预加载的区域
  final double? cacheExtent;

  /// 如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
  final bool? primary;

  /// 滚动方向
  /// [Axis.vertical] 垂直滚动
  /// [Axis.horizontal] 水平滚动
  final Axis scrollDirection;
  final DragStartBehavior dragStartBehavior;

  /// 整个滚动控制器
  final ScrollController? scrollController;

  /// 当嵌套在无限长的组件里时必须设置为true
  final bool shrinkWrap;

  @override
  _EasyRefreshedState createState() => _EasyRefreshedState();
}

class _EasyRefreshedState extends State<EasyRefreshed> {
  late EasyRefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? EasyRefreshController();
  }

  void initEventBus() {
    eventBus.add(_eventName, (dynamic data) {
      if (data != null && data is EasyRefreshType) {
        switch (data) {
          case EasyRefreshType.refresh:
            _holdController!.callRefresh();
            break;
          case EasyRefreshType.refreshSuccess:
            _holdController!.finishRefresh(success: true);
            break;
          case EasyRefreshType.refreshFailed:
            _holdController!.finishRefresh(success: false);
            break;
          case EasyRefreshType.refreshNoMore:
            _holdController!.finishRefresh(success: true, noMore: true);
            break;
          case EasyRefreshType.loading:
            _holdController!.callLoad();
            break;
          case EasyRefreshType.loadingSuccess:
            _holdController!.finishLoad(success: true);
            break;
          case EasyRefreshType.loadFailed:
            _holdController!.finishLoad(success: false);
            break;
          case EasyRefreshType.loadNoMore:
            _holdController!.finishLoad(success: true, noMore: true);
            break;
        }
      }
      eventBus.remove(_eventName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        controller: controller,
        header: widget.header ?? globalRefreshHeader,
        footer: widget.footer ?? globalRefreshFooter,
        onLoad: widget.onLoading == null
            ? null
            : () async {
                _holdController = controller;
                initEventBus();
                widget.onLoading!.call();
              },
        onRefresh: widget.onRefresh == null
            ? null
            : () async {
                _holdController = controller;
                initEventBus();
                widget.onRefresh!.call();
              },
        slivers: widget.slivers,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        scrollController: widget.scrollController,
        primary: widget.primary,
        shrinkWrap: widget.shrinkWrap,
        cacheExtent: widget.cacheExtent,
        dragStartBehavior: widget.dragStartBehavior);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
