import 'package:flutter/material.dart';

abstract class ExtendedState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
