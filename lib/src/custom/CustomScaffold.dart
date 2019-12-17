import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/utils/Utils.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Widget bottomNavigationBar;
  final AppBar appBar;
  final EdgeInsets padding;
  final bool isScroll;
  final bool expandedBody;
  final bool paddingStatusBar;
  final Color backgroundColor;

  //isScroll  和expandedBody  不可同时使用
  CustomScaffold(
      {Key key,
      this.appBar,
      this.bottomNavigationBar,
      this.isScroll: false,
      this.expandedBody: false,
      this.body,
      this.backgroundColor,
      this.paddingStatusBar: false,
      this.padding})
      : super(key: key);

  Size preferredSize;
  double bottom = 0;

  @override
  Widget build(BuildContext context) {
    if (appBar != null && appBar.title != null) {
      bottom = appBar.bottom?.preferredSize?.height ?? 0.0;
      preferredSize = Size.fromHeight(kToolbarHeight - 8 + bottom);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? getColors(background),
      appBar: appBar != null
          ? PreferredSize(
              //自定义导航栏高度
              preferredSize: Size.fromHeight(preferredSize?.height ?? 0),
              child: AppBar(
                  leading: appBar.leading,
                  iconTheme: IconThemeData(color: getColors(iconBlack)),
                  elevation: appBar.elevation ?? 0,
                  title: appBar.title,
                  centerTitle: true,
                  bottom: appBar.bottom,
                  brightness: appBar.brightness ?? Brightness.dark,
                  backgroundColor: appBar.backgroundColor ??
                      getColors(appBarBackgroundColor),
                  actions: appBar.actions))
          : null,
      bottomNavigationBar: bottomNavigationBar,
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Container(
      color: backgroundColor,
      margin: expandedBody
          ? EdgeInsets.only(top: Utils.getHeight(10))
          : EdgeInsets.zero,
      padding: paddingStatusBar
          ? EdgeInsets.only(top: MediaQueryUtils.getStatusBarHeight())
          : padding,
      width: double.infinity,
      height: double.infinity,
      child: isScroll ? SingleChildScrollView(child: body) : body,
    );
  }
}
