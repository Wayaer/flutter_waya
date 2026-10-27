import 'dart:async';

import 'package:flutter/material.dart';

/// 示例内置的轻量工具层。
///
/// 这里只实现示例所需的少量能力，避免依赖在 Flutter 3.47 / Dart 3.13 下
/// 无法编译到 Web 的第三方 UI 库。
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void log(String message) => debugPrint('[Waya] $message');

void showToast(String message) => appScaffoldMessengerKey.currentState?.showSnackBar(
  SnackBar(content: Text(message), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating),
);

void push(Widget page) => appNavigatorKey.currentState?.push(MaterialPageRoute<void>(builder: (_) => page));

/// 强制弹出当前路由。
///
/// 示例页面由 `PopScope(canPop: false)` 包裹，若这里使用 `maybePop`，会再次触发
/// `onPopInvokedWithResult` 并形成无限递归，导致界面卡死。
void pop() => appNavigatorKey.currentState?.pop();

extension IntDurationExtension on int {
  Duration get seconds => Duration(seconds: this);

  Duration get milliseconds => Duration(milliseconds: this);
}

extension DurationExtension on Duration {
  Future<T> delayed<T>([FutureOr<T> Function()? callback]) => Future<T>.delayed(this, callback);
}

extension NumBoxExtension on num {
  SizedBox get widthBox => SizedBox(width: toDouble());

  SizedBox get heightBox => SizedBox(height: toDouble());
}

extension WidgetExtension on Widget {
  Expanded get expanded => Expanded(child: this);

  Widget setSize(Size size) => SizedBox.fromSize(size: size, child: this);
}

extension ListBuilderExtension<T> on List<T> {
  List<R> builder<R>(R Function(T item) builder) => map(builder).toList();
}

extension MapEntriesExtension<K, V> on Map<K, V> {
  List<R> entriesMapToList<R>(R Function(MapEntry<K, V> entry) builder) => entries.map(builder).toList();
}

typedef ValueBuilderCallback<T> = Widget Function(BuildContext context, T? value, void Function(T value) update);

/// 简化版状态值 Builder：内部保存值，`update` 后自动刷新。
class ValueBuilder<T> extends StatefulWidget {
  const ValueBuilder({super.key, required this.builder, this.initial});

  final ValueBuilderCallback<T> builder;

  final T? initial;

  @override
  State<ValueBuilder<T>> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends State<ValueBuilder<T>> {
  late T? value;

  @override
  void initState() {
    super.initState();
    value = widget.initial;
  }

  void update(T newValue) => setState(() => value = newValue);

  @override
  Widget build(BuildContext context) => widget.builder(context, value, update);
}

/// 简化版通用布局组件，覆盖示例中用到的常见参数。
class Universal extends StatelessWidget {
  const Universal({
    super.key,
    this.child,
    this.children = const <Widget>[],
    this.direction = Axis.vertical,
    this.isWrap = false,
    this.spacing = 0,
    this.runSpacing = 0,
    this.wrapAlignment = WrapAlignment.start,
    this.alignment,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.width,
    this.height,
    this.onTap,
    this.onTapDown,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isScroll = false,
    this.scrollDirection,
    this.isStack = false,
    this.expand = false,
    this.isOval = false,
    this.safeLeft = false,
    this.safeTop = false,
    this.safeRight = false,
    this.safeBottom = false,
  });

  final Widget? child;
  final List<Widget> children;
  final Axis direction;
  final bool isWrap;
  final double spacing;
  final double runSpacing;
  final WrapAlignment wrapAlignment;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Color? color;
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool isScroll;
  final Axis? scrollDirection;
  final bool isStack;
  final bool expand;
  final bool isOval;
  final bool safeLeft;
  final bool safeTop;
  final bool safeRight;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    Widget current;
    if (isStack) {
      current = Stack(children: children);
    } else if (isWrap) {
      current = Wrap(alignment: wrapAlignment, spacing: spacing, runSpacing: runSpacing, children: children);
    } else if (children.isNotEmpty) {
      current = direction == Axis.horizontal
          ? Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              spacing: spacing,
              children: children,
            )
          : Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              spacing: spacing,
              children: children,
            );
    } else {
      current = child ?? const SizedBox.shrink();
    }

    if (isScroll) {
      current = SingleChildScrollView(scrollDirection: scrollDirection ?? direction, child: current);
    }
    if (expand) current = SizedBox.expand(child: current);
    if (safeLeft || safeTop || safeRight || safeBottom) {
      current = SafeArea(left: safeLeft, top: safeTop, right: safeRight, bottom: safeBottom, child: current);
    }

    current = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration:
          decoration ??
          (color == null ? null : BoxDecoration(color: color, shape: isOval ? BoxShape.circle : BoxShape.rectangle)),
      child: current,
    );

    if (onTap == null && onTapDown == null) return current;
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, onTapDown: onTapDown, child: current);
  }
}
