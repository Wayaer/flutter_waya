import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedToBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedToBoxAdapter({super.key, super.child});

  @override
  RenderSliverPinnedToBoxAdapter createRenderObject(BuildContext context) =>
      RenderSliverPinnedToBoxAdapter();
}

class RenderSliverPinnedToBoxAdapter extends RenderSliverSingleBoxAdapter {
  RenderSliverPinnedToBoxAdapter({super.child});

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    assert(childExtent != null);
    final double effectiveRemainingPaintExtent =
        math.max(0, constraints.remainingPaintExtent - constraints.overlap);
    final double layoutExtent = (childExtent! - constraints.scrollOffset)
        .clamp(0.0, effectiveRemainingPaintExtent);
    geometry = SliverGeometry(
        scrollExtent: childExtent!,
        paintOrigin: constraints.overlap,
        paintExtent: math.min(childExtent!, effectiveRemainingPaintExtent),
        layoutExtent: layoutExtent,
        maxPaintExtent: childExtent!,
        maxScrollObstructionExtent: childExtent!,
        cacheExtent: layoutExtent > 0.0
            ? -constraints.cacheOrigin + layoutExtent
            : layoutExtent,
        hasVisualOverflow: true);
    setChildParentData(child!, constraints, geometry);
  }

  @override
  void setChildParentData(RenderObject child, SliverConstraints constraints,
      SliverGeometry? geometry) {
    final SliverPhysicalParentData? childParentData =
        child.parentData as SliverPhysicalParentData?;
    Offset offset = Offset.zero;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        offset += Offset(
            0.0,
            geometry!.paintExtent -
                childMainAxisPosition(child as RenderBox) -
                childExtent!);
        break;
      case AxisDirection.down:
        offset += Offset(0.0, childMainAxisPosition(child as RenderBox));
        break;
      case AxisDirection.left:
        offset += Offset(
            geometry!.paintExtent -
                childMainAxisPosition(child as RenderBox) -
                childExtent!,
            0.0);
        break;
      case AxisDirection.right:
        offset += Offset(childMainAxisPosition(child as RenderBox), 0.0);
        break;
    }
    childParentData!.paintOffset = offset;
  }

  @override
  double childMainAxisPosition(RenderBox child) => 0.0;

  double? get childExtent => _getChildExtend(child, constraints);
}

double _getChildExtend(RenderBox? child, SliverConstraints constraints) {
  if (child == null) return 0.0;
  assert(child.hasSize);
  switch (constraints.axis) {
    case Axis.vertical:
      return child.size.height;
    case Axis.horizontal:
      return child.size.width;
  }
}
