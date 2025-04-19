import 'package:flutter/material.dart';

enum FlPageViewItemBuilderStyle { scale, zoom }

/// [PageView.builder]itemBuilder
class FlPageViewItemScaleBuilder extends StatelessWidget {
  const FlPageViewItemScaleBuilder(
      {super.key,
      required this.child,
      required this.controller,
      required this.index,
      this.scrollDirection = Axis.horizontal,
      this.scaleFactor = 0.3,
      this.style = FlPageViewItemBuilderStyle.scale})
      : assert(scaleFactor > 0 && scaleFactor < 1);

  /// widget
  final Widget child;

  /// current index
  final int index;

  /// page controller
  final PageController controller;

  /// scroll direction
  final Axis scrollDirection;

  /// style
  final FlPageViewItemBuilderStyle style;

  /// scale factor
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        child: child,
        builder: (BuildContext context, child) {
          double scale = 1.0;
          double itemOffset = 0;
          final position = controller.position;
          final page = controller.page ?? controller.initialPage.toDouble();
          if (position.hasPixels && position.hasContentDimensions) {
            itemOffset = page - index;
          } else {
            final storageContext = controller.position.context.storageContext;
            final previousSavedPosition = PageStorage.of(storageContext)
                .readState(storageContext) as double?;
            if (previousSavedPosition != null) {
              itemOffset = previousSavedPosition - index.toDouble();
            } else {
              itemOffset = page.toDouble() - index.toDouble();
            }
          }
          final ratio = (1 - (itemOffset.abs() * scaleFactor)).clamp(0.0, 1.0);
          scale = Curves.easeOut.transform(ratio);
          switch (style) {
            case FlPageViewItemBuilderStyle.scale:
              return Transform.scale(scale: scale, child: child);
            case FlPageViewItemBuilderStyle.zoom:
              Alignment alignment;
              final bool horizontal = scrollDirection == Axis.horizontal;
              if (itemOffset > 0) {
                alignment =
                    horizontal ? Alignment.centerRight : Alignment.bottomCenter;
              } else {
                alignment =
                    horizontal ? Alignment.centerLeft : Alignment.topCenter;
              }
              return Transform.scale(
                  scale: scale, alignment: alignment, child: child);
          }
        });
  }
}
