import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

class CarouselPluginConfig {
  const CarouselPluginConfig({
    int activeIndex,
    this.controller,
    int itemCount,
    Axis scrollDirection,
    bool loop,
  })  : itemCount = itemCount ?? 0,
        activeIndex = activeIndex ?? 0,
        loop = loop ?? true,
        scrollDirection = scrollDirection ?? Axis.horizontal;
  final int activeIndex;
  final int itemCount;
  final Axis scrollDirection;
  final bool loop;
  final CarouselController controller;
}

abstract class CarouselPlugin {
  const CarouselPlugin();

  Widget build(BuildContext context, CarouselPluginConfig config);
}

class ArrowPagination extends CarouselPlugin {
  const ArrowPagination(
      {this.iconPrevious = Icons.arrow_back_ios,
      this.iconNext = Icons.arrow_forward_ios,
      this.color,
      this.disableColor,
      this.key,
      this.size = 20.0,
      this.padding = const EdgeInsets.all(5.0)});

  ///  IconData for previous
  ///  上一页的IconData
  final IconData iconPrevious;

  ///  iconData for next
  ///  下一页的IconData
  final IconData iconNext;

  ///  icon size
  ///  控制按钮的大小
  final double size;

  ///  Icon normal color, The theme's [ThemeData.primaryColor] by default.
  ///  控制按钮颜色
  final Color color;

  ///  if set loop=false on Carousel, this color will be used when carousel goto the last slide.
  ///  The theme's [ThemeData.disabledColor] by default.
  final Color disableColor;

  ///  控制按钮与容器的距离
  final EdgeInsetsGeometry padding;

  final Key key;

  Widget buildButton(CarouselPluginConfig config, Color color,
          IconData iconData, int quarterTurns, bool previous) =>
      Universal(
          behavior: HitTestBehavior.opaque,
          onTap: () => previous
              ? config.controller.previous(animation: true)
              : config.controller.next(animation: true),
          padding: padding,
          child: RotatedBox(
              quarterTurns: quarterTurns,
              child: Icon(iconData,
                  semanticLabel: previous ? 'Previous' : 'Next',
                  size: size,
                  color: color)));

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    final ThemeData themeData = Theme.of(context);
    final Color color = this.color ?? themeData.primaryColor;
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
        sizedBoxExpand: true,
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

///  底部指示器
class FractionPagination extends CarouselPlugin {
  const FractionPagination(
      {this.color,
      this.fontSize = 20.0,
      this.key,
      this.activeColor,
      this.activeFontSize = 35.0});

  ///  color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///  color when active,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///  /font size
  final double fontSize;

  ///  font size when active
  final double activeFontSize;

  final Key key;

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    final ThemeData themeData = Theme.of(context);
    final Color activeColor = this.activeColor ?? themeData.primaryColor;
    final Color color = this.color ?? themeData.scaffoldBackgroundColor;
    return Flex(
        key: key,
        direction: config.scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('${config.activeIndex + 1}',
              style: TextStyle(color: activeColor, fontSize: activeFontSize)),
          Text('/', style: TextStyle(color: color, fontSize: fontSize)),
          Text('${config.itemCount}',
              style: TextStyle(color: color, fontSize: fontSize))
        ]);
  }
}

///  底部指示器
class DotCarouselPagination extends CarouselPlugin {
  const DotCarouselPagination(
      {this.activeColor,
      this.color,
      this.key,
      this.size = 10.0,
      this.activeSize = 10.0,
      this.space = 3.0});

  ///  color when current index,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///  ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///  Size of the dot when activate
  final double activeSize;

  ///  Size of the dot
  final double size;

  ///  Space between dots
  final double space;

  final Key key;

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    if (config.itemCount > 20) {
      print(
          'The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotCarouselPaginationBuilder in this sitituation');
    }
    Color activeColor = this.activeColor;
    Color color = this.color;

    if (activeColor == null || color == null) {
      final ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.primaryColor;
      color = this.color ?? themeData.scaffoldBackgroundColor;
    }

    return Flex(
        key: key,
        direction: config.scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(config.itemCount, (int i) {
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

///  底部指示器组件
class CarouselPagination extends CarouselPlugin {
  const CarouselPagination(
      {this.alignment,
      this.key,
      this.margin = const EdgeInsets.all(10.0),
      this.builder = const DotCarouselPagination()});

  ///  Alignment.bottomCenter by default when scrollDirection== Axis.horizontal
  ///  Alignment.centerRight by default when scrollDirection== Axis.vertical
  final Alignment alignment;

  ///  Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  ///  Build the wide
  final CarouselPlugin builder;

  final Key key;

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
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

typedef CarouselPaginationBuilder = Widget Function(
    BuildContext context, CarouselPluginConfig config);

class CarouselCustomPagination extends CarouselPlugin {
  CarouselCustomPagination({@required this.builder}) : assert(builder != null);

  final CarouselPaginationBuilder builder;

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) =>
      builder(context, config);
}
