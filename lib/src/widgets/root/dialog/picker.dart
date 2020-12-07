import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/area.dart';
import 'package:flutter_waya/src/constant/way.dart';

///  省市区三级联动
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
  })  : sure = sure ?? TextDefault('sure'),
        title = title ?? TextDefault('title'),
        cancel = cancel ?? TextDefault('cancel'),
        height = height ?? ConstConstant.pickerHeight,
        super(key: key);

  ///  容器属性
  final Color backgroundColor;
  final double height;

  ///  [title]底部内容
  final Widget titleBottom;
  final Widget sure;
  final Widget cancel;
  final Widget title;

  ///  字体样式
  final TextStyle contentStyle;

  ///  点击事件
  final GestureTapCallback cancelTap;
  final ValueChanged<String> sureTap;

  ///  以下为ListWheel属性
  ///  高度
  final double itemHeight;

  ///  半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  ///  选中item偏移
  final double offAxisFraction;

  ///  表示ListWheel水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  ///  放大倍率
  final double magnification;

  ///  是否启用放大镜
  final bool useMagnifier;

  ///  1或者2
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

  ///  List<String> street = <String>[];
  Map<String, dynamic> areaData = area;
  double itemHeight;

  ///  字体样式
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
    ///  样式设置
    contentStyle = widget.contentStyle ??
        TextStyle(
            fontSize: 13,
            color: getColors(black),
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.dashed);
    itemHeight = widget.itemHeight ?? 18;

    ///  省
    province = areaData?.keys?.toList();
    if (province.contains(widget.defaultProvince))
      provinceIndex = province.indexOf(widget.defaultProvince);
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;

    ///  市
    city = provinceData?.keys?.toList() as List<String>;
    if (city.contains(widget.defaultCity))
      cityIndex = city.indexOf(widget.defaultCity);
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;

    ///  区
    district = cityData?.keys?.toList() as List<String>;
    if (district.contains(widget.defaultDistrict))
      districtIndex = district.indexOf(widget.defaultDistrict);

    ///    var districtData = cityData[districtIndex];

    ///  街道
    ///    street = districtData[districtIndex];
  }

  ///  点击确定返回选择的地区
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
        child: TextSmall(value,
            overflow: TextOverflow.ellipsis, style: contentStyle));
  }

  void jumpToIndex(int index, FixedExtentScrollController controller,
      {Duration duration}) {
    if (controller != null) controller.jumpToItem(index);
  }
}

///  单列选择
class MultipleChoicePicker extends StatelessWidget {
  MultipleChoicePicker({
    Key key,
    Color color,
    double height,
    this.cancelTap,
    this.sureTap,
    this.itemHeight,
    this.itemWidth,
    this.diameterRatio,
    this.offAxisFraction,
    this.perspective,
    this.magnification,
    this.useMagnifier,
    this.squeeze,
    this.physics,
    this.initialIndex,
    @required this.itemCount,
    @required this.itemBuilder,
    Widget sure,
    Widget cancel,
    Widget title,
    this.titleBottom,
  })  : height = height ?? ConstConstant.pickerHeight,
        sure = sure ?? TextDefault('sure'),
        title = title ?? TextDefault('title'),
        cancel = cancel ?? TextDefault('cancel'),
        color = color ?? getColors(white),
        controller =
            FixedExtentScrollController(initialItem: initialIndex ?? 0),
        super(key: key);

  ///  点击事件
  final GestureTapCallback cancelTap;
  final ValueChanged<int> sureTap;

  ///  [title]底部内容
  final Widget titleBottom;
  final Widget sure;
  final Widget cancel;
  final Widget title;

  final Color color;
  final double height;

  ///  以下为ListWheel属性
  final int initialIndex;
  final double itemHeight;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double itemWidth;

  ///  半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  ///  选中item偏移
  final double offAxisFraction;

  ///  表示ListWheel水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  ///  放大倍率
  final double magnification;

  ///  是否启用放大镜
  final bool useMagnifier;

  ///  1或者2
  final double squeeze;
  final ScrollPhysics physics;
  final FixedExtentScrollController controller;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    children.add(Universal(
        direction: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Universal(child: cancel, onTap: cancelTap),
          Universal(child: title),
          Universal(
              child: sure,
              onTap: () {
                if (sureTap != null) sureTap(controller.selectedItem ?? 0);
              })
        ]));
    if (titleBottom != null) children.add(titleBottom);
    children.add(Expanded(
        child: ListWheel(
            controller: controller,
            itemExtent: itemHeight,
            diameterRatio: diameterRatio,
            offAxisFraction: offAxisFraction,
            perspective: perspective,
            magnification: magnification,
            useMagnifier: useMagnifier,
            squeeze: squeeze,
            physics: physics,
            itemBuilder: itemBuilder,
            itemCount: itemCount)));
    return Universal(
        mainAxisSize: MainAxisSize.min,
        height: height,
        decoration: BoxDecoration(color: color ?? getColors(white)),
        children: children);
  }
}

///  日期时间选择器
class DateTimePicker extends StatefulWidget {
  DateTimePicker({
    Key key,
    bool dual,
    bool showUnit,
    double height,
    this.itemWidth,
    Widget sure,
    Widget cancel,
    Widget title,
    this.diameterRatio,
    this.offAxisFraction,
    this.perspective,
    this.magnification,
    this.useMagnifier,
    this.squeeze,
    this.itemHeight,
    this.physics,
    this.backgroundColor,
    this.cancelTap,
    this.sureTap,
    DateTimePickerUnit unit,
    this.unitStyle,
    this.contentStyle,
    this.startDate,
    this.defaultDate,
    this.endDate,
    this.titleBottom,
  })  : unit = unit ?? DateTimePickerUnit().getDefaultUnit(),
        sure = sure ?? TextDefault('sure'),
        title = title ?? TextDefault('title'),
        cancel = cancel ?? TextDefault('cancel'),
        height = height ?? ConstConstant.pickerHeight,
        showUnit = showUnit ?? true,
        dual = dual ?? true,
        super(key: key);

  ///  补全双位数
  final bool dual;

  ///  单位是否显示
  final bool showUnit;

  ///  点击事件
  final GestureTapCallback cancelTap;
  final ValueChanged<String> sureTap;

  ///  [title]底部内容
  final Widget titleBottom;
  final Widget sure;
  final Widget cancel;
  final Widget title;

  ///  容器属性
  final Color backgroundColor;
  final double height;

  ///  时间选择器单位
  final DateTimePickerUnit unit;

  ///  字体样式
  final TextStyle unitStyle;
  final TextStyle contentStyle;

  ///  时间
  final DateTime startDate;
  final DateTime defaultDate;
  final DateTime endDate;

  ///  以下为ListWheel属性
  ///  高度
  final double itemHeight;
  final double itemWidth;

  ///  半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  ///  选中item偏移
  final double offAxisFraction;

  ///  表示ListWheel水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  ///  放大倍率
  final double magnification;

  ///  是否启用放大镜
  final bool useMagnifier;

  ///  1或者2
  final double squeeze;
  final ScrollPhysics physics;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  List<String> yearData = <String>[],
      monthData = <String>[],
      dayData = <String>[],
      hourData = <String>[],
      minuteData = <String>[],
      secondData = <String>[];
  FixedExtentScrollController controllerDay;

  ///  字体样式
  TextStyle contentStyle;
  TextStyle unitStyle;

  ///  时间
  DateTime startDate;
  DateTime defaultDate;
  DateTime endDate;

  DateTimePickerUnit unit;
  double itemWidth;
  int yearIndex = 0;
  int monthIndex = 0;
  int dayIndex = 0;
  int hourIndex = 0;
  int minuteIndex = 0;
  int secondIndex = 0;

  @override
  void initState() {
    super.initState();
    unit = widget.unit;
    itemWidth =
        widget.itemWidth ?? (getWidth(0) - getWidth(20)) / unit.getLength();

    ///  样式设置
    contentStyle = widget.contentStyle ?? textStyleVoid();
    unitStyle = widget.unitStyle ?? textStyleVoid();
    startDate = widget.startDate ?? DateTime.now();
    endDate = initEndDate();
    defaultDate = initDefaultDate();

    ///  初始化每个Wheel数组
    final int year = (endDate.year - startDate.year) + 1;
    for (int i = 0; i < year; i++) {
      yearData.add((startDate.year + i).toString());
    }

    yearIndex = defaultDate.year - startDate.year;
    monthIndex = defaultDate.month - 1;
    dayIndex = defaultDate.day - 1;
    hourIndex = defaultDate.hour;
    minuteIndex = defaultDate.minute;
    secondIndex = defaultDate.second;

    monthData = addList(12, startNumber: 1).cast<String>();
    dayData = calculateDayNumber(isFirst: true).cast<String>();
    hourData = addList(24).cast<String>();
    minuteData = addList(60).cast<String>();
    secondData = addList(60).cast<String>();
    controllerDay = FixedExtentScrollController(initialItem: dayIndex);
  }

  DateTime initDefaultDate() {
    if (widget.defaultDate == null) return startDate;
    if (widget.defaultDate.isBefore(startDate)) return startDate;
    if (widget.defaultDate.isAfter(endDate)) return endDate;
    return widget.defaultDate;
  }

  DateTime initEndDate() {
    if (widget.endDate != null && startDate.isBefore(widget.endDate))
      return widget.endDate;
    return startDate.add(const Duration(days: 3650));
  }

  TextStyle textStyleVoid() => TextStyle(
      fontSize: 14,
      color: getColors(black),
      decoration: TextDecoration.none,
      decorationStyle: TextDecorationStyle.dashed);

  ///  显示双数还是单数
  String valuePadLeft(String value) =>
      widget.dual ? value.padLeft(2, '0') : value;

  ///  wheel数组添加数据
  List<String> addList(int maxNumber, {int startNumber = 0}) {
    final List<String> list = <String>[];
    for (int i = startNumber;
        i < (startNumber == 0 ? maxNumber : maxNumber + 1);
        i++) {
      list.add(valuePadLeft(i.toString()));
    }
    return list;
  }

  ///  计算每月day的数量
  List<String> calculateDayNumber({bool isFirst = false}) {
    final int selectYearItem =
        isFirst ? (defaultDate.year - startDate.year) : yearIndex;
    final int selectMonthItem = isFirst ? defaultDate.month : monthIndex + 1;
    if (selectMonthItem == 1 ||
        selectMonthItem == 3 ||
        selectMonthItem == 5 ||
        selectMonthItem == 7 ||
        selectMonthItem == 8 ||
        selectMonthItem == 10 ||
        selectMonthItem == 12) {
      return addList(31, startNumber: 1);
    }
    if (selectMonthItem == 2) {
      return addList(
          DateTime(int.parse(yearData[selectYearItem]), 3)
              .difference(DateTime(int.parse(yearData[selectYearItem]), 2))
              .inDays,
          startNumber: 1);
    } else {
      return addList(30, startNumber: 1);
    }
  }

  ///  刷新day数
  void refreshDay() {
    int oldDayIndex = dayIndex;
    final List<String> newDayList = calculateDayNumber().cast<String>();
    if (newDayList.length != dayData.length) {
      dayData = newDayList;
      if (oldDayIndex > 25) {
        jumpToIndex(25, controllerDay);
        final int newDayIndex = newDayList.length - 1;
        if (oldDayIndex > newDayIndex) oldDayIndex = newDayIndex;
      }
      datState(() {});
      jumpToIndex(oldDayIndex, controllerDay);
    }
  }

  ///  点击确定返回日期
  void sureTapVoid() {
    if (widget.sureTap == null) return;
    String dateTime = '';
    if (unit?.year != null) dateTime = yearData[yearIndex] + '-';
    if (unit?.month != null) dateTime += monthData[monthIndex] + '-';
    if (unit?.day != null) dateTime += dayData[dayIndex] + ' ';
    if (unit?.hour != null) dateTime += hourData[hourIndex];
    if (unit?.minute != null) dateTime += ':' + minuteData[minuteIndex];
    if (unit?.second != null) dateTime += ':' + secondData[secondIndex];
    widget.sureTap(dateTime.trim());
  }

  StateSetter datState;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = <Widget>[];
    if (unit.year != null)
      rowChildren.add(wheelItem(yearData,
          initialIndex: yearIndex, unit: unit?.year, onChanged: (int newIndex) {
        yearIndex = newIndex;
        if (unit.day != null) refreshDay();
        limitStartAndEnd();
      }));

    if (unit.month != null)
      rowChildren.add(wheelItem(monthData,
          initialIndex: monthIndex,
          unit: unit?.month, onChanged: (int newIndex) {
        monthIndex = newIndex;
        if (unit.day != null) refreshDay();
        limitStartAndEnd();
      }));

    if (unit.day != null)
      rowChildren.add(StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        datState = setState;
        return wheelItem(dayData, controller: controllerDay, unit: unit?.day,
            onChanged: (int newIndex) {
          dayIndex = newIndex;
          limitStartAndEnd();
        });
      }));

    if (unit.hour != null)
      rowChildren.add(wheelItem(hourData,
          unit: unit?.hour, initialIndex: hourIndex, onChanged: (int newIndex) {
        hourIndex = newIndex;
        limitStartAndEnd();
      }));

    if (unit.minute != null)
      rowChildren.add(wheelItem(minuteData,
          initialIndex: minuteIndex,
          unit: unit?.minute, onChanged: (int newIndex) {
        minuteIndex = newIndex;
        limitStartAndEnd();
      }));

    if (unit.second != null)
      rowChildren.add(wheelItem(secondData,
          initialIndex: secondIndex,
          unit: unit?.second, onChanged: (int newIndex) {
        secondIndex = newIndex;
        limitStartAndEnd();
      }));

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
    columnChildren.add(Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren)));
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
      String unit,
      int initialIndex,
      ValueChanged<int> onChanged}) {
    return Universal(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        width: itemWidth,
        children: !widget.showUnit
            ? null
            : <Widget>[
                Expanded(
                    child: listWheel(
                        list: list,
                        initialIndex: initialIndex,
                        controller: controller,
                        onChanged: onChanged)),
                Container(
                    margin: const EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: Text(unit, style: unitStyle))
              ],
        child: widget.showUnit
            ? null
            : listWheel(
                list: list,
                initialIndex: initialIndex,
                controller: controller,
                onChanged: onChanged));
  }

  Widget listWheel(
      {List<String> list,
      int initialIndex,
      FixedExtentScrollController controller,
      ValueChanged<int> onChanged}) {
    return ListWheel(
        controller: controller,
        itemExtent: widget.itemHeight,
        diameterRatio: widget.diameterRatio,
        offAxisFraction: widget.offAxisFraction,
        perspective: widget.perspective,
        magnification: widget.magnification,
        useMagnifier: widget.useMagnifier,
        squeeze: widget.squeeze,
        physics: widget.physics,
        initialIndex: initialIndex,
        itemBuilder: (_, int index) =>
            TextSmall(list[index].toString(), style: contentStyle),
        itemCount: list.length,
        onChanged: onChanged);
  }

  bool limitStartAndEnd() {
    final DateTime selectDateTime = DateTime.parse(
        '${yearData[yearIndex]}-${monthData[monthIndex]}-${dayData[dayIndex]} ${hourData[hourIndex]}:${minuteData[minuteIndex]}:${secondData[dayIndex]}');
    if (selectDateTime.isBefore(startDate)) {
      return true;
    } else if (selectDateTime.isAfter(endDate)) {
      return false;
    } else {
      return null;
    }
  }

  void jumpToIndex(int index, FixedExtentScrollController controller,
      {Duration duration}) {
    if (controller != null) controller.jumpToItem(index);
  }
}
