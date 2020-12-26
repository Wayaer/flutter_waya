import 'dart:async';

import 'package:flutter/material.dart';

enum CarouselEvent { move, next, previous, start, stop }

class CarouselController extends ChangeNotifier {
  Completer<dynamic> _completer;

  int index;
  bool animation;
  CarouselEvent event;

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

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

class TransformerController extends PageController {
  TransformerController({
    int initialPage = 0,
    bool keepPage,
    double viewportFraction = 1.0,
    bool loop = false,
    int itemCount = 0,
    bool reverse = false,
  })  : _reverse = reverse ?? false,
        _loop = loop ?? false,
        _itemCount = itemCount ?? 0,
        super(
            initialPage: _getRealIndexFromRenderIndex(
                initialPage, loop, itemCount, reverse),
            keepPage: keepPage ?? true,
            viewportFraction: viewportFraction ?? 1.0);

  final bool _loop;

  final bool _reverse;

  int _itemCount;

  void setItemCount(int count) => _itemCount = count;

  int get itemCount => _itemCount;

  bool get reverse => _reverse;

  bool get loop => _loop;

  int getRenderIndexFromRealIndex(int index) {
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

  int getRealItemCount() {
    if (itemCount == 0) return 0;
    return _loop ? itemCount + kMaxValue : itemCount;
  }

  double get realPage =>
      (position?.maxScrollExtent == null || position?.minScrollExtent == null)
          ? 0.0
          : super.page;

  double getRenderPageFromRealPage(
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
  double get page => _loop
      ? getRenderPageFromRealPage(realPage, _loop, itemCount, reverse)
      : realPage;

  int getRealIndexFromRenderIndex(num index) =>
      _getRealIndexFromRenderIndex(index, loop, itemCount, reverse);

  static int _getRealIndexFromRenderIndex(
      num index, bool loop, int itemCount, bool reverse) {
    int result = (reverse ? (itemCount - index - 1) : index) as int;
    if (loop) result += kMiddleValue;
    return result;
  }
}
