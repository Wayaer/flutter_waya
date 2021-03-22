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

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((Duration callback) {
      jumpToOffset(100);
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
      if (footer.value != controller.loadStatus) {
        if (controller.loadStatus == LoadStatus.loading) {
          if (widget.onLoading != null) widget.onLoading!.call();
        }
      }
    });
  }

  void animateToOffset(double offset) {
    controller.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
    scroll = false;
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
  }
}

class RefreshController extends ScrollController {
  RefreshStatus refreshStatus = RefreshStatus.canRefresh;
  LoadStatus loadStatus = LoadStatus.canLoading;

  /// 刷新中
  void get refreshIng {
    refreshStatus = RefreshStatus.refreshing;
    notifyListeners();
  }

  /// 刷新完成
  void get refreshCompleted {
    refreshStatus = RefreshStatus.completed;
    notifyListeners();
  }

  /// 刷新失败
  void get refreshFailed {
    refreshStatus = RefreshStatus.failed;
    notifyListeners();
  }

  /// 重置刷新
  void get refreshReset {
    refreshStatus = RefreshStatus.canRefresh;
    jumpTo(100);
    notifyListeners();
  }

  /// 加载中
  void get loading {
    loadStatus = LoadStatus.loading;
    notifyListeners();
  }

  /// 加载完成 没有更多
  void get loadNoMore {
    loadStatus = LoadStatus.noMore;
    notifyListeners();
  }

  /// 加载失败
  void get loadFailed {
    loadStatus = LoadStatus.failed;
    notifyListeners();
  }

  /// 重置加载
  void get loadReset {
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
