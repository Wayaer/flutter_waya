import 'package:flutter/material.dart';

/// 未挂载时自动忽略 setState 的 State 基类。
abstract class FlExtendedState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
