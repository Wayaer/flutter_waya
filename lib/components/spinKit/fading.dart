part of 'spin_kit.dart';

class SpinKitFadingFour extends StatefulWidget {
  const SpinKitFadingFour({
    super.key,
    this.color,
    this.shape = BoxShape.circle,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color');

  final Color? color;
  final BoxShape shape;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitFadingFour> createState() => _SpinKitFadingFourState();
}

class _SpinKitFadingFourState extends ExtendedState<SpinKitFadingFour>
    with SingleTickerProviderStateMixin {
  final List<double> delays = <double>[.0, -0.9, -0.6, -0.3];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
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
              children: 4.generate((int i) {
            final double position = widget.size * .5;
            return Positioned.fill(
                left: position,
                top: position,
                child: Transform(
                    transform: Matrix4.rotationZ(30.0 * (i * 3) * 0.0174533),
                    child: Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                            opacity: _DelayTween(
                                    begin: 0.0, end: 1.0, delay: delays[i])
                                .animate(_controller),
                            child: SizedBox.fromSize(
                                size: Size.square(widget.size * 0.25),
                                child: _itemBuilder(i))))));
          }))));

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
              color: widget.color ??
                  context.theme.progressIndicatorTheme.color ??
                  context.theme.primaryColor,
              shape: widget.shape));
}

class SpinKitWanderingCubes extends StatefulWidget {
  const SpinKitWanderingCubes({
    super.key,
    this.color,
    this.shape = BoxShape.rectangle,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1800),
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        offset = size * 0.75;

  final Color? color;
  final BoxShape shape;
  final double offset;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;

  @override
  State<SpinKitWanderingCubes> createState() => _SpinKitWanderingCubesState();
}

class _SpinKitWanderingCubesState extends ExtendedState<SpinKitWanderingCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale1, _scale2, _scale3, _scale4, _rotate;
  late Animation<double> _translate1, _translate2, _translate3, _translate4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat();

    final CurvedAnimation animation1 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOut));
    _translate1 =
        Tween<double>(begin: 0.0, end: widget.offset).animate(animation1);
    _scale1 = Tween<double>(begin: 1.0, end: 0.5).animate(animation1);

    final CurvedAnimation animation2 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.5, curve: Curves.easeInOut));
    _translate2 =
        Tween<double>(begin: 0.0, end: widget.offset).animate(animation2);
    _scale2 = Tween<double>(begin: 1.0, end: 2.0).animate(animation2);

    final CurvedAnimation animation3 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.75, curve: Curves.easeInOut));
    _translate3 =
        Tween<double>(begin: 0.0, end: -widget.offset).animate(animation3);
    _scale3 = Tween<double>(begin: 1.0, end: 0.5).animate(animation3);

    final CurvedAnimation animation4 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOut));
    _translate4 =
        Tween<double>(begin: 0.0, end: -widget.offset).animate(animation4);
    _scale4 = Tween<double>(begin: 1.0, end: 2.0).animate(animation4);

    _rotate = Tween<double>(begin: 0.0, end: 360.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
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
          child: Stack(children: [_cube(0), _cube(1, true)])));

  Widget _cube(int index, [bool offset = false]) {
    Matrix4 tTranslate;
    if (offset == true) {
      tTranslate = Matrix4.identity()
        ..translate(_translate3.value, 0.0)
        ..translate(0.0, _translate2.value)
        ..translate(0.0, _translate4.value)
        ..translate(_translate1.value, 0.0);
    } else {
      tTranslate = Matrix4.identity()
        ..translate(0.0, _translate3.value)
        ..translate(-_translate2.value, 0.0)
        ..translate(-_translate4.value, 0.0)
        ..translate(0.0, _translate1.value);
    }

    return Positioned(
      top: 0.0,
      left: offset == true ? 0.0 : widget.offset,
      child: Transform(
        transform: tTranslate,
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
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
              color: widget.color ??
                  context.theme.progressIndicatorTheme.color ??
                  context.theme.primaryColor,
              shape: widget.shape));
}
