import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

// void sendSimpleRefreshType(RefreshType refresh) =>
//     eventBus.emit(refreshEvent, refresh);

// enum RefreshType {
//   /// 下拉可以刷新
//   pullDown,
//
//   /// 上拉加载更多
//   pullUp,
//
//   /// 释放立即刷新
//   release,
//
//   /// 正在刷新
//   refreshing,
//
//   /// 正在加载
//   loading,
//
//   /// 完成
//   finish,
//
//   /// 失败
//   failed,
// }

typedef HeaderCallback = Widget Function(RefreshState refreshStatus);
typedef FooterCallback = Widget Function(LoadingState loadStatus);

typedef RefreshLoadingCallback = Future<bool> Function();

class SimpleRefresh extends StatefulWidget {
  const SimpleRefresh(
      {super.key,
      required this.child,
      this.onRefresh,
      this.onLoading,
      this.header,
      this.footer,
      this.controller});

  final Widget child;
  final RefreshLoadingCallback? onRefresh;
  final RefreshLoadingCallback? onLoading;
  final HeaderCallback? header;
  final FooterCallback? footer;
  final RefreshController? controller;

  @override
  State<SimpleRefresh> createState() => _RefreshState();
}

class _RefreshState extends State<SimpleRefresh> {
  late RefreshController controller;

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    double initialScrollOffset = 100;
    final double widgetInitialScrollOffset =
        widget.controller?.initialScrollOffset ?? 0;
    if (widgetInitialScrollOffset < 100) {
      initialScrollOffset += widgetInitialScrollOffset;
    }
    controller = RefreshController(
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        initialScrollOffset: initialScrollOffset,
        keepScrollOffset: widget.controller?.keepScrollOffset ?? true);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = _buildSliversByChild();
    if (widget.onRefresh != null) {
      slivers.insert(0, SliverToBoxAdapter(child: _header));
    }
    if (widget.onLoading != null) {
      slivers.add(SliverToBoxAdapter(child: _footer));
    }
    Widget scrollView = ScrollNotificationListener(
        onNotification: (ScrollNotification notification, bool focus) {
          if (notification is ScrollStartNotification && focus) {
            if (controller.offset < 1) {
              controller.refreshPullDown();
            } else if (controller.offset > controller.scrollHeight + 1) {
              controller.loadingPullUp();
            }
          } else if (notification is ScrollUpdateNotification && focus) {
            if (controller.offset < 10 &&
                controller.header.value != RefreshState.release) {
              controller.refreshRelease();
            }
            if (controller.offset > controller.scrollHeight + 10 &&
                controller.footer.value != LoadingState.release) {
              controller.loadingRelease();
            }
          } else if (notification is ScrollEndNotification && !focus) {
            if (controller.offset < 100 &&
                controller.header.value != RefreshState.release) {
              controller.refreshPullDown();
            } else if (controller.offset < 10) {
              controller.refreshing();
            } else if (controller.header.value == RefreshState.refreshing) {
            } else if (controller.offset > (controller.scrollHeight - 100) &&
                controller.offset < (controller.scrollHeight - 10)) {
              controller.loadingPullUp();
            } else if (controller.offset >= (controller.scrollHeight - 10)) {
              controller.loading();
            }
          } else if (notification is ScrollStartNotification && !focus) {
            if (controller.offset < 90) {
              controller.refreshPullDown();
            } else if (controller.offset > controller.scrollHeight - 90) {
              controller.loadingPullUp();
            }
          }
          return false;
        },
        child: CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            slivers: slivers));
    if (isScrollListPadding != null) {
      scrollView = Padding(padding: isScrollListPadding!, child: scrollView);
    }
    return scrollView;
  }

  EdgeInsetsGeometry? get isScrollListPadding {
    final Widget child = widget.child;
    if ((child is ScrollList) && child.padding != null) return child.padding;
    if (child is BoxScrollView && child.padding != null) return child.padding;
    return null;
  }

  Widget get _header => ValueListenableBuilder<RefreshState>(
      valueListenable: controller.header,
      builder: (_, RefreshState status, __) {
        Widget? child;
        if (widget.header != null) {
          child = widget.header!(status);
        } else {
          switch (status) {
            case RefreshState.pullDown:
              child = const Text('请尽情拉我');
              break;
            case RefreshState.release:
              child = const Text('松手刷新');
              break;
            case RefreshState.refreshing:
              child =
                  const SpinKit(SpinKitStyle.squareCircle, color: Colors.blue);
              break;
            case RefreshState.finish:
              child = const Text('刷新完成了');
              break;
            case RefreshState.failed:
              child = const Text('刷新失败了');
              break;
          }
        }
        return Universal(
            color: Colors.red.withOpacity(0.3),
            alignment: Alignment.center,
            height: 100,
            child: child);
      });

  Widget get _footer => ValueListenableBuilder<LoadingState>(
      valueListenable: controller.footer,
      builder: (_, LoadingState status, __) {
        Widget? child;
        if (widget.footer != null) {
          child = widget.footer!(status);
        } else {
          switch (status) {
            case LoadingState.pullUp:
              child = const Text('请尽情上拉');
              break;
            case LoadingState.release:
              child = const Text('松手加载更多');
              break;
            case LoadingState.loading:
              child = const SpinKitSquareCircle(color: Colors.blue);
              break;
            case LoadingState.finish:
              child = const Text('加载成功了');
              break;
            case LoadingState.failed:
              child = const Text('加载失败了');
              break;
          }
        }
        return Universal(
            color: Colors.red.withOpacity(0.3),
            alignment: Alignment.center,
            height: 100,
            child: child);
      });

  List<Widget> _buildSliversByChild() {
    final Widget child = widget.child;
    late List<Widget> slivers = <Widget>[];
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        slivers = child.buildSlivers(context);
      } else if (child is RefreshScrollView) {
        slivers = (child as RefreshScrollView).buildSlivers();
      } else if (child is CustomScrollView) {
        slivers = child.slivers;
      }
    } else if (child is SingleChildScrollView) {
      if (child.child != null) {
        slivers = <Widget>[SliverToBoxAdapter(child: child.child!)];
      }
    } else if (child is! Scrollable) {
      slivers = <Widget>[SliverToBoxAdapter(child: child)];
    }
    // slivers.add(_SliverFillViewport());
    return slivers;
  }

  @override
  void didUpdateWidget(covariant SimpleRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      initController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

// class _SliverFillViewport extends SliverFillViewport {
//   _SliverFillViewport()
//       : super(
//             viewportFraction: 1,
//             delegate: SliverChildBuilderDelegate(
//                 (_, int index) => const SizedBox(height: 1),
//                 childCount: 1));
// }

class RefreshController extends ScrollController {
  RefreshController(
      {this.onRefresh,
      this.onLoading,
      super.initialScrollOffset = 0,
      super.keepScrollOffset = true});

  RefreshLoadingCallback? onRefresh;

  RefreshLoadingCallback? onLoading;

  ValueNotifier<RefreshState> header =
      ValueNotifier<RefreshState>(RefreshState.pullDown);

  ValueNotifier<LoadingState> footer =
      ValueNotifier<LoadingState>(LoadingState.pullUp);

  /// 滚动高度
  double get scrollHeight => position.maxScrollExtent;

  Duration animateDuration = const Duration(milliseconds: 100);

  set setAnimateDuration(Duration duration) => animateDuration = duration;

  /// 松手刷新
  void refreshRelease() {
    if (header.value != RefreshState.pullDown && footerDefault) return;
    header.value = RefreshState.release;
  }

  /// 开始刷新
  void refreshing() {
    if (header.value != RefreshState.release && footerDefault) return;
    header.value = RefreshState.refreshing;
    if (onRefresh != null) {
      onRefresh!.call().then((bool value) {
        if (value) {
          refreshFinish();
        } else {
          refreshFailed();
        }
      });
    }
  }

  /// 刷新完成
  void refreshFinish() {
    if (header.value != RefreshState.refreshing && footerDefault) return;
    header.value = RefreshState.finish;
    animateDuration.delayed(() => refreshPullDown());
  }

  /// 刷新失败
  void refreshFailed() {
    if (header.value != RefreshState.refreshing && footerDefault) return;
    header.value = RefreshState.failed;
    animateDuration.delayed(() => refreshPullDown());
  }

  /// 重置刷新 至默认状态
  Future<void> refreshPullDown() async {
    if (!footerDefault) return;
    await animateToOffset(100);
    header.value = RefreshState.pullDown;
  }

  /// 松手加载
  void loadingRelease() {
    if (footer.value == LoadingState.pullUp && headerDefault) return;
    footer.value = LoadingState.release;
  }

  /// 加载中
  void loading() {
    if (footer.value == LoadingState.loading && headerDefault) return;
    footer.value = LoadingState.loading;
    if (onLoading != null) {
      onLoading!.call().then((bool value) {
        if (value) {
          loadingFinish();
        } else {
          loadingFailed();
        }
      });
    }
  }

  /// 加载完成
  void loadingFinish() {
    if (footer.value == LoadingState.finish && headerDefault) return;
    footer.value = LoadingState.finish;
    animateDuration.delayed(() => loadingPullUp());
  }

  /// 加载失败
  void loadingFailed() {
    if (footer.value == LoadingState.failed && headerDefault) return;
    footer.value = LoadingState.failed;
    animateDuration.delayed(() => loadingPullUp());
  }

  /// 重置加载 至默认状态
  Future<void> loadingPullUp() async {
    if (!headerDefault) return;
    await animateToOffset(scrollHeight - 100);
    footer.value = LoadingState.pullUp;
  }

  bool get headerDefault => header.value == RefreshState.pullDown;

  bool get footerDefault => footer.value == LoadingState.pullUp;

  void jumpToOffset(double offset) => jumpTo(offset);

  Future<void> animateToOffset(double offset) async {
    await 100.milliseconds.delayed(() {});
    await position.animateTo(offset,
        duration: animateDuration, curve: Curves.linear);
  }

  @override
  void dispose() {
    super.dispose();
    header.dispose();
    footer.dispose();
  }
}

enum RefreshState {
  /// 默认状态
  pullDown,

  /// 松手后 刷新
  release,

  /// 刷新中
  refreshing,

  /// 刷新完成
  finish,

  /// 刷新失败
  failed,
}

enum LoadingState {
  /// 默认状态
  pullUp,

  /// 松手后 加载
  release,

  /// 加载中
  loading,

  /// 加载完成
  finish,

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
    super.key,
    required this.child,
    required this.onNotification,
    this.onFocus,
  });

  final Widget child;

  /// 通知回调
  final NotificationListenerScrollCallback onNotification;

  /// 滚动焦点回调
  final ScrollFocusCallback? onFocus;

  @override
  State<ScrollNotificationListener> createState() =>
      _ScrollNotificationListenerState();
}

class _ScrollNotificationListenerState
    extends State<ScrollNotificationListener> {
  /// 焦点状态
  bool _focusState = false;

  set _focus(bool focus) {
    _focusState = focus;
    if (widget.onFocus != null) widget.onFocus!(_focusState);
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
