import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/area.dart';
import 'package:flutter_waya/src/constant/colors.dart';
import 'package:flutter_waya/src/constant/widgets.dart';
import 'package:flutter_waya/src/widget/custom/Universal.dart';

class AreaPicker extends StatefulWidget {
  ///容器属性
  final Color backgroundColor;
  final double height;

  ///title底部内容
  final Widget titleBottom;
  final Widget sure;
  final Widget cancel;
  final Widget title;

  ///字体样式
  final TextStyle contentStyle;

  ///点击事件
  final GestureTapCallback cancelTap;
  final ValueChanged<String> sureTap;

  ///以下为滚轮属性
  ///高度
  final double itemHeight;
  final double itemWidth;

  /// 半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  /// 选中item偏移
  final double offAxisFraction;

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  ///放大倍率
  final double magnification;

  ///是否启用放大镜
  final bool useMagnifier;

  ///1或者2
  final double squeeze;
  final ScrollPhysics physics;
  final String defaultProvince;
  final String defaultCity;
  final String defaultDistrict;

  AreaPicker(
      {Key key,
      Widget titleBottom,
      Widget sure,
      Widget title,
      Widget cancel,
      double height,
      this.backgroundColor,
      this.cancelTap,
      this.sureTap,
      this.contentStyle,
      this.itemHeight,
      this.itemWidth,
      this.diameterRatio,
      this.offAxisFraction,
      this.perspective,
      double magnification,
      this.useMagnifier,
      this.squeeze,
      this.physics,
      this.defaultProvince,
      this.defaultCity,
      this.defaultDistrict})
      : this.titleBottom = titleBottom ?? Container(),
        this.sure = sure ?? Widgets.textDefault('sure'),
        this.title = title ?? Widgets.textDefault('title'),
        this.cancel = cancel ?? Widgets.textDefault('cancel'),
        this.height = height ?? Tools.getHeight() / 4,
        this.magnification = magnification ?? 1.3,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AreaPickerState();
  }
}

class AreaPickerState extends State<AreaPicker> {
  List<String> province = [];
  List<String> city = [];
  List<String> district = [];

//  List<String> street = [];
  Map<String, dynamic> areaData = area;
  double itemWidth;
  double itemHeight;

  ///字体样式
  TextStyle contentStyle;

  int provinceIndex = 0;
  int cityIndex = 0;
  int districtIndex = 0;
  int streetIndex = 0;

  FixedExtentScrollController controllerCity, controllerDistrict;

  StateSetter cityState;
  StateSetter districtState;

  @override
  void initState() {
    super.initState();
    initData();
    controllerCity = FixedExtentScrollController(initialItem: cityIndex);
    controllerDistrict =
        FixedExtentScrollController(initialItem: districtIndex);
  }

  initData() {
    ///样式设置
    contentStyle = widget.contentStyle ??
        TextStyle(
            fontSize: 13,
            color: getColors(black),
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.dashed);
    itemWidth = widget.itemWidth ?? (Tools.getWidth() - Tools.getWidth(10)) / 3;
    itemHeight = widget.itemHeight ?? Tools.getWidth(16);

    ///省
    province = areaData?.keys?.toList();
    if (province.contains(widget.defaultProvince))
      provinceIndex = province.indexOf(widget.defaultProvince);
    var provinceData = areaData[province[provinceIndex]];

    ///市
    city = provinceData?.keys?.toList();
    if (city.contains(widget.defaultCity))
      cityIndex = city.indexOf(widget.defaultCity);
    var cityData = provinceData[city[cityIndex]];

    ///区
    district = cityData?.keys?.toList();
    if (district.contains(widget.defaultDistrict))
      districtIndex = district.indexOf(widget.defaultDistrict);
//    var districtData = cityData[districtIndex];

    ///街道
//    street = districtData[districtIndex];
  }

  ///点击确定返回选择的地区
  sureTapVoid() {
    if (widget.sureTap == null) return;
    String areaString =
        '${province[provinceIndex]} ${city[cityIndex]} ${district[districtIndex]}';
    widget.sureTap(areaString);
  }

  refreshCity() {
    var provinceData = areaData[province[provinceIndex]];
    city = provinceData?.keys?.toList();
    cityState(() {});
    var cityData = provinceData[city[cityIndex]];
    district = cityData?.keys?.toList();
    districtState(() {});
    controllerCity.jumpTo(0);
    controllerDistrict.jumpTo(0);
  }

  refreshDistrict() {
    var cityData = areaData[province[provinceIndex]][city[cityIndex]];
    district = cityData?.keys?.toList();
    districtState(() {});
    controllerDistrict.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    children.add(wheelItem(province, initialIndex: provinceIndex,
        onChanged: (int newIndex) {
      provinceIndex = newIndex;
      refreshCity();
    }));

    children.add(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      cityState = setState;
      return wheelItem(city,
          childDelegateType: city.length < 5
              ? ListWheelChildDelegateType.looping
              : ListWheelChildDelegateType.builder,
          controller: controllerCity, onChanged: (int newIndex) {
        cityIndex = newIndex;
        refreshDistrict();
      });
    }));
    children.add(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      districtState = setState;
      return wheelItem(district,
          childDelegateType: district.length < 5
              ? ListWheelChildDelegateType.looping
              : ListWheelChildDelegateType.builder,
          controller: controllerDistrict, onChanged: (int newIndex) {
        districtIndex = newIndex;
      });
    }));
    return Universal(
      onTap: () {},
      mainAxisSize: MainAxisSize.min,
      height: widget.height,
      decoration:
          BoxDecoration(color: widget.backgroundColor ?? getColors(white)),
      children: <Widget>[
        Universal(
          direction: Axis.horizontal,
          padding: EdgeInsets.all(Tools.getWidth(10)),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Universal(child: widget.cancel, onTap: widget.cancelTap),
            Container(child: widget.title),
            Universal(child: widget.sure, onTap: sureTapVoid)
          ],
        ),
        widget.titleBottom,
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ))
      ],
    );
  }

  Widget wheelItem(List<String> list,
      {FixedExtentScrollController controller,
      int initialIndex,
      ListWheelChildDelegateType childDelegateType,
      WheelChangedListener onChanged}) {
    return Universal(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        width: itemWidth,
        child: ListWheel(
            controller: controller,
            initialIndex: initialIndex,
            itemExtent: itemHeight,
            diameterRatio: widget.diameterRatio,
            offAxisFraction: widget.offAxisFraction,
            perspective: widget.perspective,
            magnification: widget.magnification,
            useMagnifier: widget.useMagnifier,
            squeeze: widget.squeeze,
            physics: widget.physics,
            childDelegateType: childDelegateType,
            children: list.map((value) => item(value)).toList(),
            itemBuilder: (BuildContext context, int index) => item(list[index]),
            itemCount: list.length,
            onChanged: onChanged));
  }

  Widget item(String value) {
    return Container(
      width: itemWidth,
      alignment: Alignment.center,
      child: Widgets.textSmall(value,
          overflow: TextOverflow.ellipsis, style: contentStyle),
    );
  }

  jumpToIndex(int index, FixedExtentScrollController controller,
      {Duration duration}) {
    if (controller != null) {
      controller.jumpToItem(index);
    }
  }
}
