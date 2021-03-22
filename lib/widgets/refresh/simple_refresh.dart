import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef HeaderCallback = Widget Function(RefreshStatus refreshStatus);
typedef FooterCallback = Widget Function(LoadStatus loadStatus);

class SimpleRefresh extends StatefulWidget {
  const SimpleRefresh(
      {Key? key,
      required this.child,
      this.onRefresh,
      this.onLoading,
      this.header,
      this.footer})
      : super(key: key);

  final Widget child;
  final Function? onRefresh;
  final Function? onLoading;
  final HeaderCallback? header;
  final FooterCallback? footer;

  @override
  _RefreshState createState() => _RefreshState();
}

class _RefreshState extends State<SimpleRefresh> {
  RefreshController controller = RefreshController();
  ValueNotifier<RefreshStatus> header =
      ValueNotifier<RefreshStatus>(RefreshStatus.canRefresh);
  ValueNotifier<LoadStatus> footer =
      ValueNotifier<LoadStatus>(LoadStatus.canLoading);

  bool scroll = false;

  GlobalKey keyHeight = GlobalKey();
  double scrollHeight = 0;
  int i = 0;
  Timer? timer;

  void addEvent() {
    eventBus.add(refreshEvent, (dynamic data) {
      if (data == null) return;
      if (data != null && data is RefreshCompletedType) {
        timer = 1.seconds.timerPeriodic((Timer t) {
          i += 1;
          if (i >= 3) {
            i = 0;
            if (timer != null) {
              timer!.cancel();
              timer = null;
            }
          }
        });
        switch (data) {
          case RefreshCompletedType.refresh:
            controller.refreshIng;
            break;
          case RefreshCompletedType.refreshSuccess:
            controller.refreshCompleted;
            break;
          case RefreshCompletedType.refreshFailed:
            controller.refreshFailed;
            break;
          case RefreshCompletedType.loading:
            controller.loading;
            break;
          case RefreshCompletedType.loadingSuccess:
            controller.loadNoMore;
            break;
          case RefreshCompletedType.loadFailed:
            controller.loadFailed;
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((Duration callback) {
      jumpToOffset(100);
      addEvent();
    });

    schedulerBinding!.addPostFrameCallback((Duration timestamp) {
      final Size size = keyHeight.currentContext!.size!;
      scrollHeight = size.height;
    });

    controller.addListener(() {
      if (header.value != controller.refreshStatus) {
        header.value = controller.refreshStatus;
        if (controller.refreshStatus == RefreshStatus.refreshing) {
          if (widget.onRefresh != null) widget.onRefresh!.call();
        }
      }
      if (footer.value == LoadStatus.canLoading) {
        if (controller.loadStatus == LoadStatus.loading) {
          if (widget.onLoading != null) widget.onLoading!.call();
        }
      }
    });
  }

  void jumpToOffset(double offset) {
    controller.jumpTo(offset);
    scroll = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = _buildSliversByChild();
    if (widget.onRefresh != null)
      slivers.insert(0, SliverToBoxAdapter(child: _header));
    if (widget.onLoading != null)
      slivers.add(SliverToBoxAdapter(child: _footer));
    Widget scrollView = NotificationListener<ScrollNotification>(
        key: keyHeight,
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {}

          if (notification is ScrollUpdateNotification) {
            if (controller.offset < 100) controller.refreshIng;
            if (controller.offset > scrollHeight - 10) controller.loading;
          }

          if (notification is ScrollEndNotification) {
            if (!scroll) {
              scroll = true;
              if (controller.offset < 100 && controller.offset > 0)
                jumpToOffset(100);
            }
          }
          return true;
        },
        child: CustomScrollView(controller: controller, slivers: slivers));
    if (isScrollListPadding != null)
      scrollView = Padding(child: scrollView, padding: isScrollListPadding!);
    return scrollView;
  }

  EdgeInsetsGeometry? get isScrollListPadding {
    final Widget child = widget.child;
    if (child is ScrollList && child.padding != null) return child.padding;
    return null;
  }

  List<Widget> _buildSliversByChild() {
    final Widget child = widget.child;
    List<Widget>? slivers;
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        slivers = child.buildSlivers(context);
      } else if (child is ScrollList) {
        slivers = child.buildSlivers(context);
      } else {
        slivers = <Widget>[SliverToBoxAdapter(child: child.build(context))];
      }
    } else if (child is SingleChildScrollView) {
      if (child.child != null)
        slivers = <Widget>[SliverToBoxAdapter(child: child.child!)];
    } else if (child is! Scrollable) {
      slivers = <Widget>[SliverToBoxAdapter(child: child)];
    }
    return slivers ?? <Widget>[];
  }

  Widget get _header => ValueListenableBuilder<RefreshStatus>(
      valueListenable: header,
      builder: (_, RefreshStatus status, __) {
        Widget? child;
        double height = 100;
        if (widget.header != null) {
          child = widget.header!(status);
        } else {
          log(status);
          switch (status) {
            case RefreshStatus.canRefresh:
              child = const Text('可以刷新');
              break;
            case RefreshStatus.refreshing:
              child = const SpinKitSquareCircle(color: Colors.blue);
              height = 100;
              break;
            case RefreshStatus.completed:
              child = const Text('刷新完成');
              break;
            case RefreshStatus.failed:
              child = const Text('刷新失败');
              break;
          }
        }
        return Universal(
            height: height, alignment: Alignment.center, child: child);
      });

  Widget get _footer => ValueListenableBuilder<LoadStatus>(
      valueListenable: footer,
      builder: (_, LoadStatus status, __) {
        Widget? child;
        bool visible = false;
        if (widget.footer != null) {
          child = widget.footer!(status);
          visible = status != LoadStatus.loading;
        } else {
          log(status);
          switch (status) {
            case LoadStatus.canLoading:
              child = const Text('可以加载更多');
              break;
            case LoadStatus.loading:
              child = const SpinKitSquareCircle(color: Colors.blue);
              visible = true;
              break;
            case LoadStatus.noMore:
              child = const Text('没有更多数据');
              break;
            case LoadStatus.failed:
              child = const Text('加载失败');
              break;
          }
        }
        return Universal(
            visible: visible,
            alignment: Alignment.center,
            height: 100,
            child: child);
      });

  @override
  void dispose() {
    super.dispose();
    header.dispose();
    footer.dispose();
    controller.dispose();
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }
}

class RefreshController extends ScrollController {
  RefreshStatus refreshStatus = RefreshStatus.canRefresh;
  LoadStatus loadStatus = LoadStatus.canLoading;

  /// 刷新中
  void get refreshIng {
    if (refreshStatus == RefreshStatus.refreshing) return;
    refreshStatus = RefreshStatus.refreshing;
    notifyListeners();
  }

  /// 刷新完成
  void get refreshCompleted {
    if (refreshStatus == RefreshStatus.completed) return;
    refreshStatus = RefreshStatus.completed;
    jumpTo(100);
    notifyListeners();
  }

  /// 刷新失败
  void get refreshFailed {
    if (refreshStatus == RefreshStatus.failed) return;
    refreshStatus = RefreshStatus.failed;
    jumpTo(100);
    notifyListeners();
  }

  /// 重置刷新
  void get refreshReset {
    if (refreshStatus == RefreshStatus.canRefresh) return;
    refreshStatus = RefreshStatus.canRefresh;
    jumpTo(100);
    notifyListeners();
  }

  /// 加载中
  void get loading {
    if (loadStatus == LoadStatus.loading) return;
    loadStatus = LoadStatus.loading;
    notifyListeners();
  }

  /// 加载完成 没有更多
  void get loadNoMore {
    if (loadStatus == LoadStatus.noMore) return;
    loadStatus = LoadStatus.noMore;
    notifyListeners();
  }

  /// 加载失败
  void get loadFailed {
    if (loadStatus == LoadStatus.failed) return;
    loadStatus = LoadStatus.failed;
    notifyListeners();
  }

  /// 重置加载
  void get loadReset {
    if (loadStatus == LoadStatus.canLoading) return;
    loadStatus = LoadStatus.canLoading;
    notifyListeners();
  }
}

enum RefreshStatus {
  canRefresh,
  refreshing,
  completed,
  failed,
}
enum LoadStatus {
  canLoading,
  loading,
  noMore,
  failed,
}
