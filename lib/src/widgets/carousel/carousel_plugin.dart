import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

abstract class CarouselPlugin {
  const CarouselPlugin();

  Widget build(BuildContext context, CarouselPluginConfig config);
}

class CarouselPluginConfig {
  final int activeIndex;
  final int itemCount;
  final IndicatorType indicatorLayout;
  final Axis scrollDirection;
  final bool loop;
  final bool outer;
  final PageController pageController;
  final CarouselController controller;
  final CarouselLayout layout;

  const CarouselPluginConfig(
      {this.activeIndex,
      this.itemCount,
      this.indicatorLayout,
      this.outer,
      this.scrollDirection,
      this.controller,
      this.pageController,
      this.layout,
      this.loop})
      : assert(scrollDirection != null),
        assert(controller != null);
}

class CarouselPluginView extends StatelessWidget {
  final CarouselPlugin plugin;
  final CarouselPluginConfig config;

  const CarouselPluginView(this.plugin, this.config);

  @override
  Widget build(BuildContext context) => plugin.build(context, config);
}

///Control
class CarouselControl extends CarouselPlugin {
  ///IconData for previous
  ///上一页的IconData
  final IconData iconPrevious;

  ///iconData for next
  ///下一页的IconData
  final IconData iconNext;

  ///icon size
  ///控制按钮的大小
  final double size;

  ///Icon normal color, The theme's [ThemeData.primaryColor] by default.
  ///控制按钮颜色
  final Color color;

  ///if set loop=false on Carousel, this color will be used when carousel goto the last slide.
  ///The theme's [ThemeData.disabledColor] by default.
  final Color disableColor;

  ///控制按钮与容器的距离
  final EdgeInsetsGeometry padding;

  final Key key;

  const CarouselControl(
      {this.iconPrevious: Icons.arrow_back_ios,
      this.iconNext: Icons.arrow_forward_ios,
      this.color,
      this.disableColor,
      this.key,
      this.size: 30.0,
      this.padding: const EdgeInsets.all(5.0)});

  Widget buildButton(CarouselPluginConfig config, Color color, IconData iconData, int quarterTurns, bool previous) =>
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
            child: Icon(iconData, semanticLabel: previous ? "Previous" : "Next", size: size, color: color)),
      );

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    ThemeData themeData = Theme.of(context);

    Color color = this.color ?? themeData.primaryColor;
    Color disableColor = this.disableColor ?? themeData.disabledColor;
    Color prevColor;
    Color nextColor;

    if (config.loop) {
      prevColor = nextColor = color;
    } else {
      bool next = config.activeIndex < config.itemCount - 1;
      bool prev = config.activeIndex > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }

    Widget child;
    if (config.scrollDirection == Axis.horizontal) {
      child = Row(key: key, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        buildButton(config, prevColor, iconPrevious, 0, true),
        buildButton(config, nextColor, iconNext, 0, false)
      ]);
    } else {
      child = Column(key: key, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        buildButton(config, prevColor, iconPrevious, -3, true),
        buildButton(config, nextColor, iconNext, -3, false)
      ]);
    }
    return Container(height: double.infinity, child: child, width: double.infinity);
  }
}

class CarouselController extends IndexController {
  // AutoPlay started
  static const int START_AUTOPLAY = 2;

  // AutoPlay stopped.
  static const int STOP_AUTOPLAY = 3;

  // Indicate that the user is swiping
  static const int SWIPE = 4;

  // Indicate that the `Carousel` has changed it's index and is building it's ui ,so that the
  // `CarouselPluginConfig` is available.
  static const int BUILD = 5;

  // available when `event` == CarouselController.BUILD
  CarouselPluginConfig config;

  // available when `event` == CarouselController.SWIPE
  // this value is PageViewController.pos
  double pos;

  int index;
  bool animation;
  bool autoPlay;

  CarouselController();

  ///开始自动播放
  void startAutoPlay() {
    event = CarouselController.START_AUTOPLAY;
    this.autoPlay = true;
    notifyListeners();
  }

  ///停止自动播放
  void stopAutoPlay() {
    event = CarouselController.STOP_AUTOPLAY;
    this.autoPlay = false;
    notifyListeners();
  }
}

///底部指示器
class FractionPaginationBuilder extends CarouselPlugin {
  ///color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///color when active,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ////font size
  final double fontSize;

  ///font size when active
  final double activeFontSize;

  final Key key;

  const FractionPaginationBuilder(
      {this.color, this.fontSize: 20.0, this.key, this.activeColor, this.activeFontSize: 35.0});

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    if (Axis.vertical == config.scrollDirection) {
      return Column(key: key, mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text("${config.activeIndex + 1}", style: TextStyle(color: activeColor, fontSize: activeFontSize)),
        Text("/", style: TextStyle(color: color, fontSize: fontSize)),
        Text("${config.itemCount}", style: TextStyle(color: color, fontSize: fontSize))
      ]);
    } else {
      return Row(key: key, mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text("${config.activeIndex + 1}", style: TextStyle(color: activeColor, fontSize: activeFontSize)),
        Text(" / ${config.itemCount}", style: TextStyle(color: color, fontSize: fontSize))
      ]);
    }
  }
}

///底部指示器
class RectCarouselPaginationBuilder extends CarouselPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rect
  final double space;

  final Key key;

  const RectCarouselPaginationBuilder(
      {this.activeColor,
      this.color,
      this.key,
      this.size: const Size(10.0, 2.0),
      this.activeSize: const Size(10.0, 2.0),
      this.space: 3.0});

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    List<Widget> list = [];

    if (config.itemCount > 20) {
      print(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotCarouselPaginationBuilder in this sitituation");
    }

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      Size size = active ? this.activeSize : this.size;
      list.add(SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: active ? activeColor : color,
          key: Key("pagination_$i"),
          margin: EdgeInsets.all(space),
        ),
      ));
    }
    return Universal(key: key, direction: config.scrollDirection, mainAxisSize: MainAxisSize.min, children: list);
  }
}

///底部指示器
class DotCarouselPaginationBuilder extends CarouselPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///Size of the dot when activate
  final double activeSize;

  ///Size of the dot
  final double size;

  /// Space between dots
  final double space;

  final Key key;

  const DotCarouselPaginationBuilder(
      {this.activeColor, this.color, this.key, this.size: 10.0, this.activeSize: 10.0, this.space: 3.0});

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) {
    if (config.itemCount > 20) {
      print(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotCarouselPaginationBuilder in this sitituation");
    }
    Color activeColor = this.activeColor;
    Color color = this.color;

    if (activeColor == null || color == null) {
      ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.primaryColor;
      color = this.color ?? themeData.scaffoldBackgroundColor;
    }

    if (config.indicatorLayout != IndicatorType.none && config.layout == CarouselLayout.none) {
      return Indicator(
          count: config.itemCount,
          controller: config.pageController,
          layout: config.indicatorLayout,
          size: size,
          activeColor: activeColor,
          color: color,
          space: space);
    }

    List<Widget> list = [];

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      list.add(Container(
          key: Key("pagination_$i"),
          margin: EdgeInsets.all(space),
          child: ClipOval(
            child: Container(
                color: active ? activeColor : color,
                width: active ? activeSize : size,
                height: active ? activeSize : size),
          )));
    }
    return Universal(key: key, direction: config.scrollDirection, mainAxisSize: MainAxisSize.min, children: list);
  }
}

///底部指示器组件
class CarouselPagination extends CarouselPlugin {
  /// dot style pagination
  static const CarouselPlugin dots = const DotCarouselPaginationBuilder();

  /// fraction style pagination
  static const CarouselPlugin fraction = const FractionPaginationBuilder();

  static const CarouselPlugin rect = const RectCarouselPaginationBuilder();

  /// Alignment.bottomCenter by default when scrollDirection== Axis.horizontal
  /// Alignment.centerRight by default when scrollDirection== Axis.vertical
  final Alignment alignment;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  /// Build the wide
  final CarouselPlugin builder;

  final Key key;

  const CarouselPagination(
      {this.alignment, this.key, this.margin: const EdgeInsets.all(10.0), this.builder: CarouselPagination.dots});

  Widget build(BuildContext context, CarouselPluginConfig config) {
    Alignment alignment =
        this.alignment ?? (config.scrollDirection == Axis.horizontal ? Alignment.bottomCenter : Alignment.centerRight);
    Widget child = Container(margin: margin, child: this.builder.build(context, config));
    if (!config.outer) child = Align(key: key, alignment: alignment, child: child);
    return child;
  }
}

typedef Widget CarouselPaginationBuilder(BuildContext context, CarouselPluginConfig config);

class CarouselCustomPagination extends CarouselPlugin {
  final CarouselPaginationBuilder builder;

  CarouselCustomPagination({@required this.builder}) : assert(builder != null);

  @override
  Widget build(BuildContext context, CarouselPluginConfig config) => builder(context, config);
}
