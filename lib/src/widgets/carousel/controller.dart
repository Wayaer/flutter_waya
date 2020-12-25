import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class TransformerPageController extends PageController {
  TransformerPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    this.loop = false,
    this.itemCount,
    this.reverse = false,
  }) : super(
            initialPage: TransformerPageController._getRealIndexFromRenderIndex(
                initialPage ?? 0, loop, itemCount, reverse),
            keepPage: keepPage,
            viewportFraction: viewportFraction);

  final bool loop;
  final int itemCount;
  final bool reverse;

  int getRenderIndexFromRealIndex(int index) =>
      _getRenderIndexFromRealIndex(index, loop, itemCount, reverse);

  int getRealItemCount() {
    if (itemCount == 0) return 0;
    return loop ? itemCount + kMaxValue : itemCount;
  }

  static int _getRenderIndexFromRealIndex(
      int index, bool loop, int itemCount, bool reverse) {
    if (itemCount == 0) return 0;
    int renderIndex;
    if (loop) {
      renderIndex = index - kMiddleValue;
      renderIndex = renderIndex % itemCount;
      if (renderIndex < 0) {
        renderIndex += itemCount;
      }
    } else {
      renderIndex = index;
    }
    if (reverse) renderIndex = itemCount - renderIndex - 1;
    return renderIndex;
  }

  double get realPage =>
      (position.maxScrollExtent == null || position.minScrollExtent == null)
          ? 0.0
          : super.page;

  static double _getRenderPageFromRealPage(
      double page, bool loop, int itemCount, bool reverse) {
    double renderPage;
    if (loop) {
      renderPage = page - kMiddleValue;
      renderPage = renderPage % itemCount;
      if (renderPage < 0) renderPage += itemCount;
    } else {
      renderPage = page;
    }
    if (reverse) renderPage = itemCount - renderPage - 1;
    return renderPage;
  }

  @override
  double get page => loop
      ? _getRenderPageFromRealPage(realPage, loop, itemCount, reverse)
      : realPage;

  int getRealIndexFromRenderIndex(num index) =>
      _getRealIndexFromRenderIndex(index, loop, itemCount, reverse);

  static int _getRealIndexFromRenderIndex(
      num index, bool loop, int itemCount, bool reverse) {
    int result = (reverse ? (itemCount - index - 1) : index) as int;
    if (loop) {
      result += kMiddleValue;
    }
    return result;
  }
}

class IndexController extends ChangeNotifier {
  Completer<dynamic> _completer;

  static const int NEXT = 1;
  static const int PREVIOUS = -1;
  static const int MOVE = 0;

  int index;
  bool animation;
  int event;

  ///  移动到指定下标
  Future<void> move(int index, {bool animation = true}) {
    this.animation = animation ?? true;
    this.index = index;
    event = MOVE;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  ///  下一页
  Future<void> next({bool animation = true}) {
    event = NEXT;
    this.animation = animation ?? true;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  ///  	上一页
  Future<void> previous({bool animation = true}) {
    event = PREVIOUS;
    this.animation = animation ?? true;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  void complete() {
    if (!_completer.isCompleted) _completer.complete();
  }
}

class CarouselController extends IndexController {
  CarouselController();

  ///  AutoPlay started
  static const int START_AUTOPLAY = 2;

  ///  AutoPlay stopped.
  static const int STOP_AUTOPLAY = 3;

  ///  Indicate that the user is swiping
  static const int SWIPE = 4;

  ///  Indicate that the `Carousel` has changed it's index and is building it's ui ,so that the
  ///  `CarouselPluginConfig` is available.
  static const int BUILD = 5;

  ///  available when `event` == CarouselController.BUILD
  CarouselPluginConfig config;

  ///  available when `event` == CarouselController.SWIPE
  ///  this value is PageViewController.pos
  double pos;

  bool autoPlay;

  ///  开始自动播放
  void startAutoPlay() {
    event = CarouselController.START_AUTOPLAY;
    autoPlay = true;
    notifyListeners();
  }

  ///  停止自动播放
  void stopAutoPlay() {
    event = CarouselController.STOP_AUTOPLAY;
    autoPlay = false;
    notifyListeners();
  }
}
