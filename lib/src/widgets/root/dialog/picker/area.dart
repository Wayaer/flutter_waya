import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/area.dart';
import 'package:flutter_waya/src/constant/way.dart';

class AreaPicker extends StatefulWidget {
  AreaPicker({
    Key key,
    Widget sure,
    Widget title,
    Widget cancel,
    double height,
    this.titleBottom,
    this.backgroundColor,
    this.cancelTap,
    this.sureTap,
    this.contentStyle,
    this.itemHeight,
    this.diameterRatio,
    this.offAxisFraction,
    this.perspective,
    this.magnification,
    this.useMagnifier,
    this.squeeze,
    this.physics,
    this.defaultProvince,
    this.defaultCity,
    this.defaultDistrict,
  })  : sure = sure ?? WayWidgets.textDefault('sure'),
        title = title ?? WayWidgets.textDefault('title'),
        cancel = cancel ?? WayWidgets.textDefault('cancel'),
        height = height ?? ConstConstant.pickerHeight,
        super(key: key);

  ///容器属性
  final Color backgroundColor;
  final double height;

  ///[title]底部内容
  final Widget titleBottom;
  final Widget sure;
  final Widget cancel;
  final Widget title;

  ///字体样式
  final TextStyle contentStyle;

  ///点击事件
  final GestureTapCallback cancelTap;
  final ValueChanged<String> sureTap;

  ///以下为ListWheel属性
  ///高度
  final double itemHeight;

  /// 半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  /// 选中item偏移
  final double offAxisFraction;

  ///表示ListWheel水平偏离中心的程度  范围[0,0.01]
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

  @override
  _AreaPickerState createState() => _AreaPickerState();
}

class _AreaPickerState extends State<AreaPicker> {
  List<String> province = <String>[];
  List<String> city = <String>[];
  List<String> district = <String>[];

//  List<String> street = <String>[];
  Map<String, dynamic> areaData = area;
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

  void initData() {
    ///样式设置
    contentStyle = widget.contentStyle ??
        TextStyle(
            fontSize: 13,
            color: getColors(black),
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.dashed);
    itemHeight = widget.itemHeight ?? 18;

    ///省
    province = areaData?.keys?.toList();
    if (province.contains(widget.defaultProvince))
      provinceIndex = province.indexOf(widget.defaultProvince);
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;

    ///市
    city = provinceData?.keys?.toList() as List<String>;
    if (city.contains(widget.defaultCity))
      cityIndex = city.indexOf(widget.defaultCity);
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;

    ///区
    district = cityData?.keys?.toList() as List<String>;
    if (district.contains(widget.defaultDistrict))
      districtIndex = district.indexOf(widget.defaultDistrict);
//    var districtData = cityData[districtIndex];

    ///街道
//    street = districtData[districtIndex];
  }

  ///点击确定返回选择的地区
  void sureTapVoid() {
    if (widget.sureTap == null) return;
    final String areaString =
        '${province[provinceIndex]} ${city[cityIndex]} ${district[districtIndex]}';
    widget.sureTap(areaString);
  }

  void refreshCity() {
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;
    city = provinceData?.keys?.toList() as List<String>;
    cityState(() {});
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;
    district = cityData?.keys?.toList() as List<String>;
    districtState(() {});
    controllerCity.jumpTo(0);
    controllerDistrict.jumpTo(0);
  }

  void refreshDistrict() {
    final Map<dynamic, dynamic> cityData = areaData[province[provinceIndex]]
        [city[cityIndex]] as Map<dynamic, dynamic>;
    district = cityData?.keys?.toList() as List<String>;
    districtState(() {});
    controllerDistrict.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final Row row =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(
        child: wheelItem(province, initialIndex: provinceIndex,
            onChanged: (int newIndex) {
          provinceIndex = newIndex;
          refreshCity();
        }),
      ),
      Expanded(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          cityState = setState;
          return wheelItem(city,
              childDelegateType: ListWheelChildDelegateType.list,
              controller: controllerCity, onChanged: (int newIndex) {
            cityIndex = newIndex;
            refreshDistrict();
          });
        }),
      ),
      Expanded(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          districtState = setState;
          return wheelItem(district,
              childDelegateType: ListWheelChildDelegateType.list,
              controller: controllerDistrict,
              onChanged: (int newIndex) => districtIndex = newIndex);
        }),
      )
    ]);

    final List<Widget> columnChildren = <Widget>[];
    columnChildren.add(Universal(
        direction: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Universal(child: widget.cancel, onTap: widget.cancelTap),
          Container(child: widget.title),
          Universal(child: widget.sure, onTap: sureTapVoid)
        ]));
    if (widget.titleBottom != null) columnChildren.add(widget.titleBottom);
    columnChildren.add(Expanded(child: row));
    return Universal(
        onTap: () {},
        mainAxisSize: MainAxisSize.min,
        height: widget.height,
        decoration:
            BoxDecoration(color: widget.backgroundColor ?? getColors(white)),
        children: columnChildren);
  }

  Widget wheelItem(List<String> list,
      {FixedExtentScrollController controller,
      int initialIndex,
      ListWheelChildDelegateType childDelegateType,
      ValueChanged<int> onChanged}) {
    return ListWheel(
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
        children: list.map((String value) => item(value)).toList(),
        itemBuilder: (BuildContext context, int index) => item(list[index]),
        itemCount: list.length,
        onChanged: onChanged);
  }

  Widget item(String value) {
    return Container(
        alignment: Alignment.center,
        child: WayWidgets.textSmall(value,
            overflow: TextOverflow.ellipsis, style: contentStyle));
  }

  void jumpToIndex(int index, FixedExtentScrollController controller,
      {Duration duration}) {
    if (controller != null) controller.jumpToItem(index);
  }
}
