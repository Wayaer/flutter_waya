import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/widgets/carousel/transformer.dart';

class _ColorPainter extends CustomPainter {
  _ColorPainter(this.info, this.colors);

  final TransformInfo info;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _paint = Paint();
    final int index = info.fromIndex;
    _paint.color = colors[index];
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
    if (info.done) return;
    int alpha;
    int color;
    double opacity;
    final double position = info.position;
    if (info.forward) {
      if (index < colors.length - 1) {
        color = colors[index + 1].value & 0x00ffffff;
        opacity = position <= 0
            ? (-position / info.viewportFraction)
            : 1 - position / info.viewportFraction;
        if (opacity > 1) opacity -= 1.0;
        if (opacity < 0) opacity += 1.0;
        alpha = (0xff * opacity).toInt();
        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    } else {
      if (index > 0) {
        color = colors[index - 1].value & 0x00ffffff;
        opacity = position > 0
            ? position / info.viewportFraction
            : (1 + position / info.viewportFraction);
        if (opacity > 1) opacity -= 1.0;
        if (opacity < 0) opacity += 1.0;
        alpha = (0xff * opacity).toInt();
        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ColorPainter oldDelegate) => oldDelegate.info != info;
}

class ParallaxColor extends StatelessWidget {
  const ParallaxColor({
    @required this.colors,
    @required this.info,
    @required this.child,
  });

  final Widget child;
  final List<Color> colors;
  final TransformInfo info;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ColorPainter(info, colors), child: child);
}

class ParallaxContainer extends StatelessWidget {
  const ParallaxContainer(
      {@required this.child,
      @required this.position,
      this.translationFactor = 100.0,
      this.opacityFactor = 1.0})
      : assert(position != null),
        assert(translationFactor != null);
  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  @override
  Widget build(BuildContext context) => Opacity(
      opacity:
          ((1 - position.abs()).clamp(0.0, 1.0) * opacityFactor).toDouble(),
      child: Transform.translate(
          offset: Offset(position * translationFactor, 0.0), child: child));
}

class ParallaxImage extends Image {
  ParallaxImage(
    ImageProvider image, {
    double imageFactor = 0.3,
    @required double position,
    Key key,
    ImageFrameBuilder frameBuilder,
    ImageLoadingBuilder loadingBuilder,
    ImageErrorWidgetBuilder errorBuilder,
    String semanticLabel,
    bool excludeFromSemantics,
    double width,
    double height,
    Color color,
    BlendMode colorBlendMode,
    ImageRepeat repeat,
    Rect centerSlice,
    bool matchTextDirection,
    bool gapLessPlayback,
    bool isAntiAlias,
    FilterQuality filterQuality,
  })  : assert(imageFactor != null),
        super(
            key: key,
            image: image,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics ?? false,
            width: width,
            height: height,
            color: color,
            colorBlendMode: colorBlendMode,
            fit: BoxFit.cover,
            alignment: FractionalOffset(0.5 + position * imageFactor, 0.5),
            repeat: repeat ?? ImageRepeat.noRepeat,
            centerSlice: centerSlice ?? centerSlice,
            matchTextDirection: matchTextDirection ?? false,
            gaplessPlayback: gapLessPlayback ?? false,
            isAntiAlias: isAntiAlias ?? false,
            filterQuality: filterQuality ?? FilterQuality.low);
}
