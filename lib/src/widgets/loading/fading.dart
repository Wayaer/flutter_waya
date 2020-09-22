import 'package:flutter/widgets.dart';
import 'package:flutter_waya/src/widgets/loading/tweens/delay_tween.dart';

class SpinKitFadingFour extends StatefulWidget {
  const SpinKitFadingFour({
    Key key,
    this.color,
    this.shape = BoxShape.circle,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(shape != null),
        assert(size != null),
        super(key: key);

  final Color color;
  final BoxShape shape;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _SpinKitFadingFourState createState() => _SpinKitFadingFourState();
}

class _SpinKitFadingFourState extends State<SpinKitFadingFour> with SingleTickerProviderStateMixin {
  final List<double> delays = [.0, -0.9, -0.6, -0.3];
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: Stack(
              children: List.generate(4, (i) {
            final _position = widget.size * .5;
            return Positioned.fill(
                left: _position,
                top: _position,
                child: Transform(
                    transform: Matrix4.rotationZ(30.0 * (i * 3) * 0.0174533),
                    child: Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                            opacity: DelayTween(begin: 0.0, end: 1.0, delay: delays[i]).animate(_controller),
                            child: SizedBox.fromSize(size: Size.square(widget.size * 0.25), child: _itemBuilder(i))))));
          }))));

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color, shape: widget.shape));
}
class SpinKitWanderingCubes extends StatefulWidget {
  const SpinKitWanderingCubes({
    Key key,
    this.color,
    this.shape = BoxShape.rectangle,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1800),
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
        assert(shape != null),
        assert(size != null),
        offset = size * 0.75,
        super(key: key);

  final Color color;
  final BoxShape shape;
  final double offset;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;

  @override
  _SpinKitWanderingCubesState createState() => _SpinKitWanderingCubesState();
}

class _SpinKitWanderingCubesState extends State<SpinKitWanderingCubes> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scale1, _scale2, _scale3, _scale4, _rotate;
  Animation<double> _translate1, _translate2, _translate3, _translate4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat();

    final animation1 = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.25, curve: Curves.easeInOut));
    _translate1 = Tween(begin: 0.0, end: widget.offset).animate(animation1);
    _scale1 = Tween(begin: 1.0, end: 0.5).animate(animation1);

    final animation2 = CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.5, curve: Curves.easeInOut));
    _translate2 = Tween(begin: 0.0, end: widget.offset).animate(animation2);
    _scale2 = Tween(begin: 1.0, end: 2.0).animate(animation2);

    final animation3 = CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.75, curve: Curves.easeInOut));
    _translate3 = Tween(begin: 0.0, end: -widget.offset).animate(animation3);
    _scale3 = Tween(begin: 1.0, end: 0.5).animate(animation3);

    final animation4 = CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0, curve: Curves.easeInOut));
    _translate4 = Tween(begin: 0.0, end: -widget.offset).animate(animation4);
    _scale4 = Tween(begin: 1.0, end: 2.0).animate(animation4);

    _rotate = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: SizedBox.fromSize(
          size: Size.square(widget.size), child: Stack(children: <Widget>[_cube(0), _cube(1, true)])));

  Widget _cube(int index, [bool offset = false]) {
    Matrix4 _tTranslate;
    if (offset == true) {
      _tTranslate = Matrix4.identity()
        ..translate(_translate3.value, 0.0)
        ..translate(0.0, _translate2.value)
        ..translate(0.0, _translate4.value)
        ..translate(_translate1.value, 0.0);
    } else {
      _tTranslate = Matrix4.identity()
        ..translate(0.0, _translate3.value)
        ..translate(-_translate2.value, 0.0)
        ..translate(-_translate4.value, 0.0)
        ..translate(0.0, _translate1.value);
    }

    return Positioned(
      top: 0.0,
      left: offset == true ? 0.0 : widget.offset,
      child: Transform(
        transform: _tTranslate,
        child: Transform.rotate(
          angle: _rotate.value * 0.0174533,
          child: Transform(
            transform: Matrix4.identity()
              ..scale(_scale2.value)
              ..scale(_scale3.value)
              ..scale(_scale4.value)
              ..scale(_scale1.value),
            child: SizedBox.fromSize(
              size: Size.square(widget.size * 0.25),
              child: _itemBuilder(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color, shape: widget.shape));
}
