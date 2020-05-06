import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayEnum.dart';

//例子  自行封装utils
class NavigatorExample {
  static push(Function function, {PushMode pushMode}) {
    return NavigatorTools.getInstance().push(function, pushMode: pushMode);
  }

  static pushReplacement(Function function, {PushMode pushMode}) {
    return NavigatorTools.getInstance().pushReplacement(
        function, pushMode: pushMode);
  }

  static pushAndRemoveUntil(Function function, {PushMode pushMode}) {
    return NavigatorTools.getInstance().pushAndRemoveUntil(
        function, pushMode: pushMode);
  }

  static pop<T extends Object>([T result]) {
    return NavigatorTools.getInstance().pop(result);
  }
}


class NavigatorTools extends NavigatorObserver {
  // ignore: close_sinks
  static StreamController _streamController;

  StreamController get streamController => _streamController;

  /* 单例给出WayNavigatorTools */
  static NavigatorTools _navigatorManager;

  static NavigatorTools getInstance() {
    if (_navigatorManager == null) {
      _navigatorManager = NavigatorTools();
      _streamController = StreamController.broadcast();
    }
    return _navigatorManager;
  }

  // replace 页面(pop and push) 右侧进入
  pushReplacement(Function function, {PushMode pushMode}) {
    return navigator.pushReplacement(pageRoute(function, pushMode));
  }

  // push 页面 右侧进入
  push(Function function, {PushMode pushMode}) {
    return navigator.push(pageRoute(function, pushMode));
  }

  // push一个页面， 移除该页面下面所有页面
  pushAndRemoveUntil(Function function, {PushMode pushMode}) {
    return navigator.pushAndRemoveUntil(
        pageRoute(function, pushMode), (route) => false);
  }

  pageRoute(Function function, PushMode pushMode) {
    if (pushMode == null) pushMode = PushMode.cupertino;
    if (pushMode == PushMode.cupertino) {
      return CupertinoPageRoute(
        builder: (BuildContext context) {
          return function(context);
        },
        // settings: RouteSettings(name: routeName, arguments: arguments),
      );
    }
    if (pushMode == PushMode.material) {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return function(context);
        },
        // settings: RouteSettings(name: routeName, arguments: arguments),
      );
    }
  }

  // pop 页面
  pop<T extends Object>([T result]) {
    navigator.pop(result);
  }

  /* 
    返回当前route传递过来的参数
   */
  static getParams(context) {
    return ModalRoute
        .of(context)
        .settings
        .arguments;
  }
}
