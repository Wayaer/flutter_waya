part of 'spinKit.dart';

class SpinKitCircle extends StatefulWidget {
  const SpinKitCircle({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitCircleState createState() => _SpinKitCircleState();
}

class _SpinKitCircleState extends State<SpinKitCircle>
    with SingleTickerProviderStateMixin {
  final List<double> delays = <double>[
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1
  ];
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
          child: Stack(children: delays.length.generate((int index) {
            final double _position = widget.size * .5;
            return Positioned.fill(
                left: _position,
                top: _position,
                child: Transform(
                    transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
                    child: Align(
                        alignment: Alignment.center,
                        child: ScaleTransition(
                          scale: _DelayTween(
                                  begin: 0.0, end: 1.0, delay: delays[index])
                              .animate(_controller),
                          child: SizedBox.fromSize(
                              size: Size.square(widget.size * 0.15),
                              child: _itemBuilder(index)),
                        ))));
          }))));

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

class SpinKitFadingCircle extends StatefulWidget {
  const SpinKitFadingCircle({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitFadingCircleState createState() => _SpinKitFadingCircleState();
}

class _SpinKitFadingCircleState extends State<SpinKitFadingCircle>
    with SingleTickerProviderStateMixin {
  final List<double> delays = <double>[
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1
  ];
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
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.fromSize(
            size: Size.square(widget.size),
            child: Stack(
                children: 12.generate((int i) {
              final double _position = widget.size * .5;
              return Positioned.fill(
                left: _position,
                top: _position,
                child: Transform(
                    transform: Matrix4.rotationZ(30.0 * i * 0.0174533),
                    child: Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                          opacity: _DelayTween(
                                  begin: 0.0, end: 1.0, delay: delays[i])
                              .animate(_controller),
                          child: SizedBox.fromSize(
                              size: Size.square(widget.size * 0.15),
                              child: _itemBuilder(i)),
                        ))),
              );
            }))));
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

class SpinKitSquareCircle extends StatefulWidget {
  const SpinKitSquareCircle({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 500),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitSquareCircleState createState() => _SpinKitSquareCircleState();
}

class _SpinKitSquareCircleState extends State<SpinKitSquareCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animationCurve;
  late Animation<double> animationSize;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    final CurvedAnimation animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    animationCurve = Tween<double>(begin: 1.0, end: 0.0).animate(animation);
    animationSize = Tween<double>(begin: 0.5, end: 1.0).animate(animation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeValue = widget.size * animationSize.value;
    return Center(
      child: Transform(
        transform: Matrix4.identity()..rotateZ(animationCurve.value * pi),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
            size: Size.square(sizeValue),
            child: _itemBuilder(0, 0.5 * sizeValue * animationCurve.value)),
      ),
    );
  }

  Widget _itemBuilder(int index, double curveValue) =>
      widget.itemBuilder != null
          ? widget.itemBuilder!(context, index)
          : DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(curveValue)),
              ),
            );
}
