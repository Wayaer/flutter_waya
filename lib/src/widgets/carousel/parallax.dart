import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef PaintCallback = void Function(Canvas canvas, Size siz);

class ColorPainter extends CustomPainter {
  ColorPainter(this._paint, this.info, this.colors);

  final Paint _paint;
  final TransformInfo info;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final int index = info.fromIndex;
    _paint.color = colors[index];
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
    if (info.done) {
      return;
    }
    int alpha;
    int color;
    double opacity;
    final double position = info.position;
    if (info.forward) {
      if (index < colors.length - 1) {
        color = colors[index + 1].value & 0x00ffffff;
        opacity = position <= 0 ? (-position / info.viewportFraction) : 1 - position / info.viewportFraction;
        if (opacity > 1) opacity -= 1.0;
        if (opacity < 0) opacity += 1.0;
        alpha = (0xff * opacity).toInt();
        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    } else {
      if (index > 0) {
        color = colors[index - 1].value & 0x00ffffff;
        opacity = position > 0 ? position / info.viewportFraction : (1 + position / info.viewportFraction);
        if (opacity > 1) opacity -= 1.0;
        if (opacity < 0) opacity += 1.0;
        alpha = (0xff * opacity).toInt();
        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    }
  }

  @override
  bool shouldRepaint(ColorPainter oldDelegate) => oldDelegate.info != info;
}

class ParallaxColor extends StatefulWidget {
  const ParallaxColor({
    @required this.colors,
    @required this.info,
    @required this.child,
  });

  final Widget child;

  final List<Color> colors;

  final TransformInfo info;

  @override
  _ParallaxColorState createState() => _ParallaxColorState();
}

class _ParallaxColorState extends State<ParallaxColor> {
  Paint paint = Paint();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: ColorPainter(paint, widget.info, widget.colors), child: widget.child);
}

class ParallaxContainer extends StatelessWidget {
  const ParallaxContainer(
      {@required this.child, @required this.position, this.translationFactor = 100.0, this.opacityFactor = 1.0})
      : assert(position != null),
        assert(translationFactor != null);
  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: ((1 - position.abs()).clamp(0.0, 1.0) * opacityFactor).toDouble(),
        child: Transform.translate(offset: Offset(position * translationFactor, 0.0), child: child));
  }
}

class ParallaxImage extends StatelessWidget {
  ParallaxImage.asset(String name, {double position, this.imageFactor = 0.3})
      : assert(imageFactor != null),
        image = Image.asset(name, fit: BoxFit.cover, alignment: FractionalOffset(0.5 + position * imageFactor, 0.5));

  final Image image;
  final double imageFactor;

  @override
  Widget build(BuildContext context) => image;
}
