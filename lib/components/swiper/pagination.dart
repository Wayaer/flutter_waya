import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum FlSwiperEvent { next, previous, start, stop }

class FlSwiperController extends ChangeNotifier {
  late Completer<dynamic> _completer;

  int index = 0;
  bool animation = false;
  late FlSwiperEvent event;

  bool autoPlay = false;

  /// 开始自动播放
  void startAutoPlay() {
    event = FlSwiperEvent.start;
    autoPlay = true;
    notifyListeners();
  }

  /// 停止自动播放
  void stopAutoPlay() {
    event = FlSwiperEvent.stop;
    autoPlay = false;
    notifyListeners();
  }

  /// 下一页
  Future<void> next({bool animation = true}) {
    event = FlSwiperEvent.next;
    this.animation = animation;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }

  /// 上一页
  Future<void> previous({bool animation = true}) {
    event = FlSwiperEvent.previous;
    this.animation = animation;
    _completer = Completer<dynamic>();
    notifyListeners();
    return _completer.future;
  }
}

class FlSwiperPluginConfig {
  const FlSwiperPluginConfig({
    this.activeIndex = 0,
    this.controller,
    this.itemCount = 0,
    this.scrollDirection = Axis.horizontal,
    this.loop = true,
  });

  final int activeIndex;
  final int itemCount;
  final Axis scrollDirection;
  final bool loop;
  final FlSwiperController? controller;
}

abstract class FlSwiperPlugin {
  const FlSwiperPlugin();

  Widget build(BuildContext context, FlSwiperPluginConfig config);
}

class ArrowPagination extends FlSwiperPlugin {
  const ArrowPagination(
      {this.iconPrevious = Icons.arrow_back_ios,
      this.iconNext = Icons.arrow_forward_ios,
      this.color,
      this.disableColor,
      this.key,
      this.size = 20.0,
      this.padding = const EdgeInsets.all(5.0)});

  /// IconData for previous
  /// 上一页的IconData
  final IconData iconPrevious;

  /// iconData for next
  /// 下一页的IconData
  final IconData iconNext;

  /// icon size
  /// 控制按钮的大小
  final double size;

  /// Icon normal color, The theme's [ThemeData.primaryColor] by default.
  /// 控制按钮颜色
  final Color? color;

  /// if set loop=false on FlSwiper, this color will be used when swiper goto the last slide.
  /// The theme's [ThemeData.disabledColor] by default.
  final Color? disableColor;

  /// 控制按钮与容器的距离
  final EdgeInsetsGeometry padding;

  final Key? key;

  Widget buildButton(FlSwiperPluginConfig config, Color color,
          IconData iconData, int quarterTurns, bool previous) =>
      Universal(
          behavior: HitTestBehavior.opaque,
          onTap: () => previous
              ? config.controller!.previous(animation: true)
              : config.controller!.next(animation: true),
          padding: padding,
          child: RotatedBox(
              quarterTurns: quarterTurns,
              child: Icon(iconData,
                  semanticLabel: previous ? 'Previous' : 'Next',
                  size: size,
                  color: color)));

  @override
  Widget build(BuildContext context, FlSwiperPluginConfig config) {
    final ThemeData themeData = Theme.of(context);
    final Color color =
        this.color ?? themeData.iconTheme.color ?? themeData.primaryColor;
    final Color disableColor = this.disableColor ?? themeData.disabledColor;
    Color prevColor;
    Color nextColor;
    if (config.loop) {
      prevColor = nextColor = color;
    } else {
      final bool next = config.activeIndex < config.itemCount - 1;
      final bool prev = config.activeIndex > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }
    return Universal(
        key: key,
        expand: true,
        direction: config.scrollDirection,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(config, prevColor, iconPrevious,
              config.scrollDirection == Axis.horizontal ? 0 : -3, true),
          buildButton(config, nextColor, iconNext,
              config.scrollDirection == Axis.horizontal ? 0 : -3, false)
        ]);
  }
}

/// 底部指示器
class FractionPagination extends FlSwiperPlugin {
  const FractionPagination(
      {this.color,
      this.fontSize = 20.0,
      this.key,
      this.activeColor,
      this.activeFontSize = 35.0});

  /// color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  /// color when active,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  /// font size
  final double fontSize;

  /// font size when active
  final double activeFontSize;

  final Key? key;

  @override
  Widget build(BuildContext context, FlSwiperPluginConfig config) {
    final ThemeData themeData = Theme.of(context);
    final Color activeColor = this.activeColor ?? themeData.primaryColor;
    final Color color = this.color ?? themeData.scaffoldBackgroundColor;
    return Flex(
        key: key,
        direction: config.scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BText('${config.activeIndex + 1}',
              style: BTextStyle(color: activeColor, fontSize: activeFontSize)),
          BText('/', style: BTextStyle(color: color, fontSize: fontSize)),
          BText('${config.itemCount}',
              style: BTextStyle(color: color, fontSize: fontSize))
        ]);
  }
}

/// 底部指示器
class DotFlSwiperPagination extends FlSwiperPlugin {
  const DotFlSwiperPagination(
      {this.activeColor,
      this.color,
      this.key,
      this.size = 10.0,
      this.activeSize = 10.0,
      this.space = 3.0});

  /// color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  /// if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  /// Size of the dot when activate
  final double activeSize;

  /// Size of the dot
  final double size;

  /// Space between dots
  final double space;

  final Key? key;

  @override
  Widget build(BuildContext context, FlSwiperPluginConfig config) {
    if (config.itemCount > 20) {
      log('The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotFlSwiperPaginationBuilder in this sitituation');
    }
    Color? activeColor = this.activeColor;
    Color? color = this.color;

    if (activeColor == null || color == null) {
      final ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.selectedRowColor;
      color = this.color ?? themeData.unselectedWidgetColor;
    }

    return Flex(
        key: key,
        direction: config.scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: config.itemCount.generate((int i) {
          final bool active = i == config.activeIndex;
          return Container(
              key: Key('pagination_$i'),
              margin: EdgeInsets.all(space),
              child: ClipOval(
                child: Container(
                    color: active ? activeColor : color,
                    width: active ? activeSize : size,
                    height: active ? activeSize : size),
              ));
        }));
  }
}

/// 底部指示器组件
class FlSwiperPagination extends FlSwiperPlugin {
  const FlSwiperPagination(
      {this.alignment,
      this.key,
      this.margin = const EdgeInsets.all(10.0),
      this.builder = const DotFlSwiperPagination()});

  /// Alignment.bottomCenter by default when scrollDirection== Axis.horizontal
  /// Alignment.centerRight by default when scrollDirection== Axis.vertical
  final Alignment? alignment;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  /// Build the wide
  final FlSwiperPlugin builder;

  final Key? key;

  @override
  Widget build(BuildContext context, FlSwiperPluginConfig config) {
    final Alignment alignment = this.alignment ??
        (config.scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight);
    return Container(
        margin: margin,
        key: key,
        alignment: alignment,
        child: builder.build(context, config));
  }
}

typedef FlSwiperPaginationBuilder = Widget Function(
    BuildContext context, FlSwiperPluginConfig config);

class FlSwiperCustomPagination extends FlSwiperPlugin {
  FlSwiperCustomPagination({required this.builder});

  final FlSwiperPaginationBuilder builder;

  @override
  Widget build(BuildContext context, FlSwiperPluginConfig config) =>
      builder(context, config);
}
