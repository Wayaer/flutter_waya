import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/flutter_waya.dart';

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
    bool enable = true;
    return () {
      if (enable == true) {
        enable = false;
        this.call();
        delay.delayed(() => enable = true);
      }
    };
  }
}

extension ExtensionT<T> on T {
  /// let是做了操作后返回新的类型
  ReturnType let<ReturnType>(ReturnType Function(T it) operation) {
    return operation(this);
  }

  /// 做了某个操作后还返回本身啊
  T also(void Function(T it) operation) {
    operation(this);
    return this;
  }

  List<T> convertToList() => [this];

  /// Check if the T is null
  bool get isNull => this == null;

  /// Check if the T is not null
  bool get isNotNull => this != null;

  /// 转为 ValueNotifier
  ValueNotifier<T> get notifier => ValueNotifier<T>(this);
}

extension ExtensionBool on bool {
  bool toggle() => !this;
}
