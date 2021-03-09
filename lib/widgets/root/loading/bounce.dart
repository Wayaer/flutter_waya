part of 'loading.dart';

class SpinKitDoubleBounce extends StatefulWidget {
  const SpinKitDoubleBounce({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2000),
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
  _SpinKitDoubleBounceState createState() => _SpinKitDoubleBounceState();
}

class _SpinKitDoubleBounceState extends State<SpinKitDoubleBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: -1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
          child: Stack(
        children: 2.generate((int i) => Transform.scale(
              scale: (1.0 - i - _animation.value.abs()).abs(),
              child: SizedBox.fromSize(
                  size: Size.square(widget.size), child: _itemBuilder(i)),
            )),
      ));

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: widget.color!.withOpacity(0.6)));
}

class SpinKitThreeBounce extends StatefulWidget {
  const SpinKitThreeBounce({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
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
  _SpinKitThreeBounceState createState() => _SpinKitThreeBounceState();
}

class _SpinKitThreeBounceState extends State<SpinKitThreeBounce>
    with SingleTickerProviderStateMixin {
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
    return SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: 3.generate((int i) => ScaleTransition(
                  scale: DelayTween(begin: 0.0, end: 1.0, delay: i * .2)
                      .animate(_controller),
                  child: SizedBox.fromSize(
                      size: Size.square(widget.size * 0.5),
                      child: _itemBuilder(i)),
                )))).center();
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

class SpinKitPulse extends StatefulWidget {
  const SpinKitPulse({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(seconds: 1),
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
  _SpinKitPulseState createState() => _SpinKitPulseState();
}

class _SpinKitPulseState extends State<SpinKitPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation = CurveTween(curve: Curves.easeInOut).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0 - _animation.value,
      child: Transform.scale(
        scale: _animation.value,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: _itemBuilder(0),
        ),
      ),
    ).center();
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget.color));
}

class SpinKitRipple extends StatefulWidget {
  const SpinKitRipple({
    Key? key,
    this.color,
    this.size = 50.0,
    this.borderWidth = 6.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1800),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final double borderWidth;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitRippleState createState() => _SpinKitRippleState();
}

class _SpinKitRippleState extends State<SpinKitRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1, _animation2;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.linear)));
    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.linear)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: <Widget>[
      Opacity(
        opacity: 1.0 - _animation1.value,
        child:
            Transform.scale(scale: _animation1.value, child: _itemBuilder(0)),
      ),
      Opacity(
        opacity: 1.0 - _animation2.value,
        child:
            Transform.scale(scale: _animation2.value, child: _itemBuilder(1)),
      )
    ]));
  }

  Widget _itemBuilder(int index) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: widget.itemBuilder != null
          ? widget.itemBuilder!(context, index)
          : DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: widget.color!, width: widget.borderWidth))),
    );
  }
}
