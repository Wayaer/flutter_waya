import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/widgets/carousel/controller.dart';

abstract class CarouselPlugin {
  const CarouselPlugin();

  Widget build(BuildContext context, CarouselPluginConfig config);
}

class CarouselPluginConfig {
  const CarouselPluginConfig(
      {this.activeIndex,
      this.itemCount,
      this.indicatorLayout,
      this.outer,
      @required this.scrollDirection,
      @required this.controller,
      this.pageController,
      this.layout,
      this.loop})
      : assert(scrollDirection != null),
        assert(controller != null);
  final int activeIndex;
  final int itemCount;
  final IndicatorType indicatorLayout;
  final Axis scrollDirection;
  final bool loop;
  final bool outer;
  final PageController pageController;
  final CarouselController controller;
  final CarouselLayout layout;
}



// class CarouselPluginView extends StatelessWidget {
//   const CarouselPluginView(this.plugin, this.config);
//
//   final CarouselPlugin plugin;
//   final CarouselPluginConfig config;
//
//   @override
//   Widget build(BuildContext context) => plugin.build(context, config);
// }

///  Control
class CarouselControl extends CarouselPlugin {
  const CarouselControl(
      {this.iconPrevious = Icons.arrow_back_ios,
      this.iconNext = Icons.arrow_forward_ios,
      this.color,
      this.disableColor,
      this.key,
      this.size = 30.0,
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
        onTap: () {
          if (previous) {
            config.controller.previous(animation: true);
          } else {
            config.controller.next(animation: true);
          }
        },
        padding: padding,
        child: RotatedBox(
            quarterTurns: quarterTurns,
            child: Icon(iconData,
                semanticLabel: previous ? 'Previous' : 'Next',
                size: size,
                color: color)),
      );

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

    Widget child;
    if (config.scrollDirection == Axis.horizontal) {
      child = Row(
          key: key,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildButton(config, prevColor, iconPrevious, 0, true),
            buildButton(config, nextColor, iconNext, 0, false)
          ]);
    } else {
      child = Column(
          key: key,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildButton(config, prevColor, iconPrevious, -3, true),
            buildButton(config, nextColor, iconNext, -3, false)
          ]);
    }
    return Container(
        height: double.infinity, child: child, width: double.infinity);
  }
}

///  底部指示器
class FractionPaginationBuilder extends CarouselPlugin {
  const FractionPaginationBuilder(
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

    if (Axis.vertical == config.scrollDirection) {
      return Column(
          key: key,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('${config.activeIndex + 1}',
                style: TextStyle(color: activeColor, fontSize: activeFontSize)),
            Text('/', style: TextStyle(color: color, fontSize: fontSize)),
            Text('${config.itemCount}',
                style: TextStyle(color: color, fontSize: fontSize))
          ]);
    } else {
      return Row(key: key, mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text('${config.activeIndex + 1}',
            style: TextStyle(color: activeColor, fontSize: activeFontSize)),
        Text(' / ${config.itemCount}',
            style: TextStyle(color: color, fontSize: fontSize))
      ]);
    }
  }
}

///  底部指示器
class RectCarouselPaginationBuilder extends CarouselPlugin {
  const RectCarouselPaginationBuilder(
      {this.activeColor,
      this.color,
      this.key,
      this.size = const Size(10.0, 2.0),
      this.activeSize = const Size(10.0, 2.0),
      this.space = 3.0});

  ///  color when current index,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///  ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///  Size of the rect when activate
  final Size activeSize;

  ///  Size of the rect
  final Size size;

  ///  Space between rect
  final double space;

  final Key key;

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    final ThemeData themeData = Theme.of(context);
    final Color activeColor = this.activeColor ?? themeData.primaryColor;
    final Color color = this.color ?? themeData.scaffoldBackgroundColor;
    final List<Widget> list = <Widget>[];
    if (config.itemCount > 20) {
      print(
          'The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotCarouselPaginationBuilder in this sitituation');
    }
    final int itemCount = config.itemCount;
    final int activeIndex = config.activeIndex;
    for (int i = 0; i < itemCount; ++i) {
      final bool active = i == activeIndex;
      final Size size = active ? activeSize : this.size;
      list.add(SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: active ? activeColor : color,
          key: Key('pagination_$i'),
          margin: EdgeInsets.all(space),
        ),
      ));
    }
    return Universal(
        key: key,
        direction: config.scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: list);
  }
}

///  底部指示器
class DotCarouselPaginationBuilder extends CarouselPlugin {
  const DotCarouselPaginationBuilder(
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

    if (config.indicatorLayout != IndicatorType.none &&
        config.layout == CarouselLayout.none) {
      return Indicator(
          count: config.itemCount,
          controller: config.pageController,
          layout: config.indicatorLayout,
          size: size,
          activeColor: activeColor,
          color: color,
          space: space);
    }

    final List<Widget> list = <Widget>[];

    final int itemCount = config.itemCount;
    final int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      final bool active = i == activeIndex;
      list.add(Container(
          key: Key('pagination_$i'),
          margin: EdgeInsets.all(space),
          child: ClipOval(
            child: Container(
                color: active ? activeColor : color,
                width: active ? activeSize : size,
                height: active ? activeSize : size),
          )));
    }
    return Universal(
        key: key,
        direction: config.scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: list);
  }
}

///  底部指示器组件
class CarouselPagination extends CarouselPlugin {
  const CarouselPagination(
      {this.alignment,
      this.key,
      this.margin = const EdgeInsets.all(10.0),
      this.builder = CarouselPagination.dots});

  ///  dot style pagination
  static const CarouselPlugin dots = DotCarouselPaginationBuilder();

  ///  fraction style pagination
  static const CarouselPlugin fraction = FractionPaginationBuilder();

  static const CarouselPlugin rect = RectCarouselPaginationBuilder();

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
    Widget child =
        Container(margin: margin, child: builder.build(context, config));
    if (!config.outer)
      child = Align(key: key, alignment: alignment, child: child);
    return child;
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
