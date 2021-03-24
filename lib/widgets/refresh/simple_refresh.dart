import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/widgets/spinKit/spinKit.dart';

void sendSimpleRefreshType(RefreshType refresh) =>
    eventBus.emit(refreshEvent, refresh);

enum RefreshType {
  /// 开始刷新  显示刷新动画
  startRefresh,

  /// 刷新完成
  refreshCompleted,

  /// 刷新失败
  refreshFailed,

  /// 开始加载  显示加载动画
  startLoading,

  /// 加载完成后 显示没有更多
  loadNoMore,

  /// 加载失败
  loadFailed,
}

typedef HeaderCallback = Widget Function(RefreshStatus refreshStatus);
typedef FooterCallback = Widget Function(LoadStatus loadStatus);

class SimpleRefresh extends StatefulWidget {
  const SimpleRefresh(
      {Key? key,
      required this.child,
      this.onRefresh,
      this.onLoading,
      this.header,
      this.footer,
      this.controller})
      : super(key: key);

  final Widget child;
  final Function? onRefresh;
  final Function? onLoading;
  final HeaderCallback? header;
  final FooterCallback? footer;
  final RefreshController? controller;

  @override
  _RefreshState createState() => _RefreshState();
}

class _RefreshState extends State<SimpleRefresh> {
  late RefreshController controller;

  void addEvent() {
    eventBus.add(refreshEvent, (dynamic data) {
      if (data != null && data is RefreshType) {
        switch (data) {
          case RefreshType.startRefresh:
            controller.startRefresh();
            break;
          case RefreshType.refreshCompleted:
            controller.refreshCompleted;
            break;
          case RefreshType.refreshFailed:
            controller.refreshFailed;
            break;
          case RefreshType.startLoading:
            controller.startLoading();
            break;
          case RefreshType.loadNoMore:
            controller.loadNoMore;
            break;
          case RefreshType.loadFailed:
            controller.loadFailed;
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initController();
    controller.addListener(listener);
    addPostFrameCallback((Duration callback) => addEvent());
  }

  void initController() {
    double initialScrollOffset = 100;
    final double widgetInitialScrollOffset =
        widget.controller?.initialScrollOffset ?? 0;
    if (widgetInitialScrollOffset < 100) {
      initialScrollOffset += widgetInitialScrollOffset;
    }
    controller = RefreshController(
        initialScrollOffset: initialScrollOffset,
        keepScrollOffset: widget.controller?.keepScrollOffset ?? true);
  }

  void listener() {
    if (controller.header.value != RefreshStatus.defaultStatus) {
      if (controller.header.value == RefreshStatus.refreshing) {
        if (widget.onRefresh != null) widget.onRefresh!.call();
      }
    }
    if (controller.footer.value != LoadStatus.defaultStatus) {
      if (controller.footer.value == LoadStatus.loading) {
        if (widget.onLoading != null) widget.onLoading!.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = _buildSliversByChild();
    if (widget.onRefresh != null)
      slivers.insert(0, SliverToBoxAdapter(child: _header));
    if (widget.onLoading != null)
      slivers.add(SliverToBoxAdapter(child: _footer));
    Widget scrollView = ScrollNotificationListener(
        onNotification: (ScrollNotification notification, bool focus) {
          if (notification is ScrollUpdateNotification && focus) {
            if (controller.offset < 10) {
              controller.canRefresh;
            } else if (controller.header.value != RefreshStatus.defaultStatus) {
              controller.resetRefresh(resetStart: false);
            }
            if (controller.offset > controller.scrollHeight + 10) {
              controller.canLoading;
            } else if (controller.footer.value != LoadStatus.defaultStatus) {
              controller.resetLoad(resetEnd: false);
            }
          }
          return true;
        },
        onFocus: (bool focus) {
          if (!focus) {
            if (controller.offset < 100 && controller.offset > 10) {
              controller.resetRefresh(hasJump: true);
            } else if (controller.offset <= 10) {
              controller.startRefresh();
            } else if (controller.offset > (controller.scrollHeight - 100) &&
                controller.offset < (controller.scrollHeight - 10)) {
              controller.resetLoad(hasJump: true);
            } else if (controller.offset >= (controller.scrollHeight - 10)) {
              controller.startLoading();
            }
          }
        },
        child: CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            slivers: slivers));
    if (isScrollListPadding != null)
      scrollView = Padding(child: scrollView, padding: isScrollListPadding!);
    return scrollView;
  }

  EdgeInsetsGeometry? get isScrollListPadding {
    final Widget child = widget.child;
    if (child is ScrollList && child.padding != null) return child.padding;
    return null;
  }

  Widget get _header => ValueListenableBuilder<RefreshStatus>(
      valueListenable: controller.header,
      builder: (_, RefreshStatus status, __) {
        Widget? child;
        if (widget.header != null) {
          child = widget.header!(status);
        } else {
          switch (status) {
            case RefreshStatus.defaultStatus:
              child = const Text('请尽情拉我');
              break;
            case RefreshStatus.canRefresh:
              child = const Text('麻烦松手了');
              break;
            case RefreshStatus.refreshing:
              child =
                  const SpinKit(SpinKitStyle.squareCircle, color: Colors.blue);
              break;
            case RefreshStatus.completed:
              child = const Text('刷新完了');
              break;
            case RefreshStatus.failed:
              child = const Text('刷新失败了');
              break;
          }
        }
        return Universal(
            alignment: Alignment.center, height: 100, child: child);
      });

  Widget get _footer => ValueListenableBuilder<LoadStatus>(
      valueListenable: controller.footer,
      builder: (_, LoadStatus status, __) {
        Widget? child;
        if (widget.footer != null) {
          child = widget.footer!(status);
        } else {
          switch (status) {
            case LoadStatus.defaultStatus:
              child = const Text('请尽情拉我');
              break;
            case LoadStatus.canLoading:
              child = const Text('麻烦松手了');
              break;
            case LoadStatus.loading:
              child = const SpinKitSquareCircle(color: Colors.blue);
              break;
            case LoadStatus.noMore:
              child = const Text('没有更多数据了');
              break;
            case LoadStatus.failed:
              child = const Text('加载失败了');
              break;
          }
        }
        return Universal(
            alignment: Alignment.center, height: 100, child: child);
      });

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

  @override
  void didUpdateWidget(covariant SimpleRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      initController();
      controller.removeListener(listener);
      controller.addListener(listener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    eventBus.remove(refreshEvent);
    controller.removeListener(listener);
    controller.dispose();
  }
}

class RefreshController extends ScrollController {
  RefreshController({double? initialScrollOffset, bool keepScrollOffset = true})
      : super(
            initialScrollOffset: initialScrollOffset ?? 0,
            keepScrollOffset: keepScrollOffset);

  ValueNotifier<RefreshStatus> header =
      ValueNotifier<RefreshStatus>(RefreshStatus.defaultStatus);

  ValueNotifier<LoadStatus> footer =
      ValueNotifier<LoadStatus>(LoadStatus.defaultStatus);

  /// 滚动高度
  double get scrollHeight => position.maxScrollExtent;

  Duration animateDuration = const Duration(milliseconds: 500);

  set setAnimateDuration(Duration duration) => animateDuration = duration;

  /// 松手刷新
  void get canRefresh {
    if (header.value == RefreshStatus.canRefresh) return;
    header.value = RefreshStatus.canRefresh;
    notify();
  }

  /// 开始刷新
  void startRefresh() {
    if (header.value == RefreshStatus.refreshing) return;
    header.value = RefreshStatus.refreshing;
    notify();
  }

  /// 刷新完成
  void get refreshCompleted {
    if (header.value == RefreshStatus.completed) return;
    header.value = RefreshStatus.completed;
    animateDuration.delayed(() => resetRefresh());
    notify();
  }

  /// 刷新失败
  void get refreshFailed {
    if (header.value == RefreshStatus.failed) return;
    header.value = RefreshStatus.failed;
    animateDuration.delayed(() => resetRefresh());
    notify();
  }

  /// 重置刷新 至默认状态
  void resetRefresh({bool resetStart = true, bool hasJump = false}) {
    if (resetStart) {
      if (hasJump)
        jumpToOffset(100);
      else
        animateToOffset(100);
    }
    header.value = RefreshStatus.defaultStatus;
    notify();
  }

  /// 松手加载
  void get canLoading {
    if (footer.value == LoadStatus.canLoading) return;
    footer.value = LoadStatus.canLoading;
    notify();
  }

  /// 加载中
  void startLoading() {
    if (footer.value == LoadStatus.loading) return;
    footer.value = LoadStatus.loading;
    notify();
  }

  /// 加载完成 没有更多
  void get loadNoMore {
    if (footer.value == LoadStatus.noMore) return;
    footer.value = LoadStatus.noMore;
    animateDuration.delayed(() => resetLoad());
    notify();
  }

  /// 加载失败
  void get loadFailed {
    if (footer.value == LoadStatus.failed) return;
    footer.value = LoadStatus.failed;
    animateDuration.delayed(() => resetLoad());
    notify();
  }

  /// 重置加载 至默认状态
  void resetLoad({bool resetEnd = true, bool hasJump = false}) {
    if (footer.value == LoadStatus.defaultStatus) return;
    if (resetEnd) {
      if (hasJump) {
        jumpToOffset(scrollHeight);
      } else
        animateToOffset(scrollHeight - 100);
    }
    footer.value = LoadStatus.defaultStatus;
    notify();
  }

  void notify() {
    notifyListeners();
  }

  void jumpToOffset(double offset) => jumpTo(offset);

  Future<void> animateToOffset(double offset) => position.animateTo(offset,
      duration: animateDuration, curve: Curves.linear);

  @override
  void dispose() {
    super.dispose();
    footer.value = LoadStatus.defaultStatus;
    header.value = RefreshStatus.defaultStatus;
    header.dispose();
    footer.dispose();
  }
}

enum RefreshStatus {
  /// 默认状态
  defaultStatus,

  /// 可以刷新 松手后 刷新
  canRefresh,

  /// 刷新中
  refreshing,

  /// 刷新完成
  completed,

  /// 刷新失败
  failed,
}
enum LoadStatus {
  /// 默认状态
  defaultStatus,

  /// 可以加载 松手后 加载
  canLoading,

  /// 加载更多
  loading,

  /// 加载完成 没有更多数据
  noMore,

  /// 加载失败
  failed,
}

/// 滚动焦点回调
/// focus为是否存在焦点(手指按下放开状态)
typedef ScrollFocusCallback = void Function(bool focus);

typedef NotificationListenerScrollCallback = bool Function(
    ScrollNotification notification, bool focus);

/// 滚动事件监听器
class ScrollNotificationListener extends StatefulWidget {
  const ScrollNotificationListener({
    Key? key,
    required this.child,
    required this.onNotification,
    required this.onFocus,
  }) : super(key: key);

  final Widget child;

  /// 通知回调
  final NotificationListenerScrollCallback onNotification;

  /// 滚动焦点回调
  final ScrollFocusCallback onFocus;

  @override
  _ScrollNotificationListenerState createState() =>
      _ScrollNotificationListenerState();
}

class _ScrollNotificationListenerState
    extends State<ScrollNotificationListener> {
  /// 焦点状态
  bool _focusState = false;

  set _focus(bool focus) {
    _focusState = focus;
    widget.onFocus(_focusState);
  }

  /// 处理滚动通知
  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      if (notification.dragDetails != null) _focus = true;
    } else if (notification is ScrollUpdateNotification) {
      if (_focusState && notification.dragDetails == null) _focus = false;
    } else if (notification is ScrollEndNotification) {
      if (_focusState) _focus = false;
    }
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _handleScrollNotification(notification);
          return widget.onNotification(notification, _focusState);
        },
        child: widget.child,
      );
}
