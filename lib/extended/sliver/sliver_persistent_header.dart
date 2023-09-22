import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 初始化 delegate 参数
class ExtendedSliverPersistentHeader extends SliverPersistentHeader {
  ExtendedSliverPersistentHeader(
      {super.key,
      super.pinned = true,
      super.floating = true,
      double minHeight = kToolbarHeight,
      double maxHeight = kToolbarHeight,
      required Widget child})
      : super(
            delegate: ExtendedSliverPersistentHeaderDelegate(
                pinned: pinned,
                minHeight: minHeight,
                maxHeight: maxHeight,
                child: child));
}

/// [SliverPersistentHeader] 固定
class ExtendedSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  ExtendedSliverPersistentHeaderDelegate({
    required this.child,
    this.minHeight = kToolbarHeight,
    this.maxHeight = kToolbarHeight,
    this.pinned = true,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;
  final bool pinned;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => math.min(maxHeight, minHeight);

  @override
  bool shouldRebuild(ExtendedSliverPersistentHeaderDelegate oldDelegate) =>
      pinned
          ? false
          : (maxHeight != oldDelegate.maxHeight ||
              minHeight != oldDelegate.minHeight ||
              child != oldDelegate.child);
}
