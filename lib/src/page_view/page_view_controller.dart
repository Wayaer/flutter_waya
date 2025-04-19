import 'dart:async';

import 'package:flutter/material.dart';

/// 自动播放 [PageController]
class PageAutoPlayController extends PageController {
  PageAutoPlayController({
    super.initialPage = 0,
    super.keepPage = true,
    super.viewportFraction = 1.0,
    super.onAttach,
    super.onDetach,
  });

  Timer? _timer;

  void startAutoPlay({
    Curve curve = Curves.linear,
    Duration duration = const Duration(milliseconds: 300),

    /// 自动播放间隔
    Duration interval = const Duration(seconds: 3),

    /// 是否反向
    bool reverse = false,

    /// 当滚动到末尾时自动跳转起始位置
    bool isLoop = true,

    /// 末尾滚动起始位置是否使用动画
    bool isAnimate = true,
  }) {
    stopAutoPlay();
    _timer = Timer.periodic(interval, (timer) {
      if (reverse) {
        if (_isStarted()) {
          if (isLoop) {
            if (isAnimate) {
              animateTo(maxScrollExtent, duration: duration, curve: curve);
            } else {
              jumpTo(maxScrollExtent);
            }
          } else {
            stopAutoPlay();
          }
          return;
        }
        previousPage(duration: duration, curve: curve);
      } else {
        if (_isEnded()) {
          if (isLoop) {
            if (isAnimate) {
              animateTo(0, duration: duration, curve: curve);
            } else {
              jumpTo(0);
            }
          } else {
            stopAutoPlay();
          }
          return;
        }

        nextPage(duration: duration, curve: curve);
      }
    });
  }

  double get maxScrollExtent => position.maxScrollExtent;

  bool _isStarted() => offset == 0;

  bool _isEnded() => offset >= maxScrollExtent;

  void stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopAutoPlay();
    super.dispose();
  }
}
