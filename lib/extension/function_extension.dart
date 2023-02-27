import 'dart:async';

import 'package:flutter_waya/flutter_waya.dart';

Map<int, bool> _funcThrottle = {};

extension ExtensionFutureFunction on Future Function() {
  /// 截流函数
  /// 在触发事件时，当即执行目标操做，直到异步方法执行完成后再响应事件
  Function throttle() {
    bool enable = _funcThrottle[hashCode] ?? true;
    void func() {
      if (enable) {
        _funcThrottle[hashCode] = false;
        this.call().then((_) {
          _funcThrottle[hashCode] = false;
        }).whenComplete(() {
          _funcThrottle.remove(hashCode);
        });
      }
    }

    func();
    return func;
  }
}

extension ExtensionFunction on Function {
  /// 函数防抖
  /// 在触发事件时，不当即执行目标操做，而是给出一个延迟的时间，在该时间范围内若是再次触发了事件，则重置延迟时间，直到延迟时间结束才会执行目标操做
  /// 如设定延迟时间为 1000ms
  /// 若是在 1000ms 内没有再次触发事件，则执行目标操做
  /// 若是在 1000ms 内再次触发了事件，则重置延迟时间，从新开始 1000ms 的延迟，直到 1000ms 结束执行目标操做
  Function() debounce([Duration delay = const Duration(seconds: 1)]) {
    Timer? timer;
    return () {
      if (timer?.isActive ?? false) timer?.cancel();
      timer = Timer(delay, () => this.call());
    };
  }

  /// 截流函数
  /// 在触发事件时，当即执行目标操做，同时给出一个延迟的时间，在该时间范围内若是再次触发了事件，该次事件会被忽略，直到超过该时间范围后触发事件才会被处理。
  /// 如设定延迟时间为 1000ms ，
  /// 若是在 1000ms 内再次触发事件，该事件会被忽略
  /// 若是 1000ms 延迟结束，则事件不会被忽略，触发事件会当即执行目标操做，并再次开启 1000ms 延迟
  Function() throttle([Duration delay = const Duration(seconds: 1)]) {
    bool enable = _funcThrottle[hashCode] ?? true;
    return () {
      if (enable) {
        _funcThrottle[hashCode] = false;
        this.call();
        delay.delayed(() {
          _funcThrottle.remove(hashCode);
        });
      }
    };
  }
}
