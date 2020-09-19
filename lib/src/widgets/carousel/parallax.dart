import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef void PaintCallback(Canvas canvas, Size siz);

class ColorPainter extends CustomPainter {
  final Paint _paint;
  final TransformInfo info;
  final List<Color> colors;

  ColorPainter(this._paint, this.info, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    int index = info.fromIndex;
    _paint.color = colors[index];
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
    if (info.done) {
      return;
    }
    int alpha;
    int color;
    double opacity;
    double position = info.position;
    if (info.forward) {
      if (index < colors.length - 1) {
        color = colors[index + 1].value & 0x00ffffff;
        opacity = (position <= 0 ? (-position / info.viewportFraction) : 1 - position / info.viewportFraction);
        if (opacity > 1) opacity -= 1.0;
        if (opacity < 0) opacity += 1.0;
        alpha = (0xff * opacity).toInt();
        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    } else {
      if (index > 0) {
        color = colors[index - 1].value & 0x00ffffff;
        opacity = (position > 0 ? position / info.viewportFraction : (1 + position / info.viewportFraction));
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
  final Widget child;

  final List<Color> colors;

  final TransformInfo info;

  ParallaxColor({
    @required this.colors,
    @required this.info,
    @required this.child,
  });

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
  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  ParallaxContainer(
      {@required this.child, @required this.position, this.translationFactor: 100.0, this.opacityFactor: 1.0})
      : assert(position != null),
        assert(translationFactor != null);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - position.abs()).clamp(0.0, 1.0) * opacityFactor,
      child: Transform.translate(offset: Offset(position * translationFactor, 0.0), child: child),
    );
  }
}

class ParallaxImage extends StatelessWidget {
  final Image image;
  final double imageFactor;

  ParallaxImage.asset(String name, {double position, this.imageFactor: 0.3})
      : assert(imageFactor != null),
        image = Image.asset(name, fit: BoxFit.cover, alignment: FractionalOffset(0.5 + position * imageFactor, 0.5));

  @override
  Widget build(BuildContext context) => image;
}
