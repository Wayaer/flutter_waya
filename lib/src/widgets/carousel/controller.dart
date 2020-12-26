import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum CarouselEvent { move, next, previous, start, stop }

class CarouselController extends PageController {
  Completer<dynamic> _completer;

  int index;
  bool animation;
  CarouselEvent event;
  CarouselPluginConfig config;
  bool autoPlay;

  ///  开始自动播放
  void startAutoPlay() {
    event = CarouselEvent.start;
    autoPlay = true;
    notifyListeners();
  }

  ///  停止自动播放
  void stopAutoPlay() {
    event = CarouselEvent.stop;
    autoPlay = false;
    notifyListeners();
  }

  ///  移动到指定下标
  Future<void> move(int index, {bool animation = true}) {
    this.animation = animation ?? true;
    this.index = index;
    event = CarouselEvent.move;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  ///  下一页
  Future<void> next({bool animation = true}) {
    event = CarouselEvent.next;
    this.animation = animation ?? true;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  ///  	上一页
  Future<void> previous({bool animation = true}) {
    event = CarouselEvent.previous;
    this.animation = animation ?? true;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  void complete() {
    if (!_completer.isCompleted) _completer.complete();
  }
}

class TransformerController extends PageController {
  TransformerController({
    int initialPage,
    bool keepPage = true,
    double viewportFraction = 1.0,
    this.loop = true,
    @required this.itemCount,
    bool reverse,
  })  : reverse = reverse ?? false,
        super(
            initialPage: _getRealIndexFromRenderIndex(
                initialPage ?? 0, loop, itemCount, reverse ?? false),
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
      (position?.maxScrollExtent == null || position?.minScrollExtent == null)
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
