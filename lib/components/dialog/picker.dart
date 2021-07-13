import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class PickerOptions {
  PickerOptions(
      {EdgeInsetsGeometry? titlePadding,
      Widget? sure,
      Widget? title,
      Widget? cancel,
      double? height,
      Color? backgroundColor,
      TextStyle? contentStyle,
      this.titleBottom,
      this.cancelTap,
      this.sureTap,
      this.sureIndexTap})
      : sure = sure ?? BText('sure', color: Colors.black),
        title = title ?? BText('title', color: Colors.black),
        cancel = cancel ?? BText('cancel', color: Colors.black),
        height = height ?? ConstConstant.pickerHeight,
        backgroundColor = backgroundColor ?? ConstColors.white,
        contentStyle = contentStyle ??
            const BTextStyle(
                backgroundColor: Colors.transparent, color: Colors.black),
        titlePadding =
            titlePadding ?? const EdgeInsets.symmetric(horizontal: 10);

  ///  容器属性
  ///  整个Picker的背景色
  final Color backgroundColor;

  ///  整个Picker的高度
  final double height;

  ///  [title]底部内容
  final Widget? titleBottom;
  final Widget sure;
  final Widget cancel;
  final Widget title;
  final EdgeInsetsGeometry titlePadding;

  ///  字体样式
  final TextStyle contentStyle;

  ///  点击事件
  GestureTapCallback? cancelTap;
  ValueChanged<String>? sureTap;
  ValueChanged<int>? sureIndexTap;
}

class PickerWheel {
  PickerWheel(
      {this.itemHeight = 22,
      this.isCupertino = false,
      this.itemWidth,
      this.diameterRatio = 1,
      this.offAxisFraction = 0,
      this.perspective = 0.01,
      this.magnification = 1.1,
      this.useMagnifier = false,
      this.squeeze = 1,
      this.physics = const FixedExtentScrollPhysics()});

  ///  以下为ListWheel属性
  ///  高度
  final double? itemHeight;
  final double? itemWidth;

  ///  半径大小,越大则越平面,越小则间距越大
  final double? diameterRatio;

  ///  选中item偏移
  final double? offAxisFraction;

  ///  表示ListWheel水平偏离中心的程度  范围[0,0.01]
  final double? perspective;

  ///  放大倍率
  final double? magnification;

  /// 使用ios Cupertino 风格
  final bool? isCupertino;

  ///  是否启用放大镜
  final bool? useMagnifier;

  /// 上下间距默认为1 数越小 间距越大
  final double? squeeze;
  final ScrollPhysics? physics;
}

abstract class _PickerConfig extends StatefulWidget {
  const _PickerConfig({Key? key, required this.options, required this.wheel})
      : super(key: key);

  final PickerOptions options;
  final PickerWheel wheel;
}

class _PickerOptions extends StatelessWidget {
  const _PickerOptions(
      {Key? key, this.options, required this.child, required this.onTap})
      : super(key: key);

  final PickerOptions? options;
  final Widget child;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[];
    columnChildren.add(Universal(
        direction: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Universal(child: options?.cancel, onTap: options?.cancelTap),
          Container(child: options?.title),
          Universal(child: options?.sure, onTap: onTap)
        ]));
    if (options?.titleBottom != null) columnChildren.add(options!.titleBottom!);
    columnChildren.add(Expanded(child: child));
    return Universal(
        onTap: () {},
        mainAxisSize: MainAxisSize.min,
        height: options?.height,
        color: options?.backgroundColor,
        children: columnChildren);
  }
}

class _PickerListWheel extends StatelessWidget {
  const _PickerListWheel(
      {Key? key,
      this.wheel,
      this.controller,
      this.initialIndex,
      this.childDelegateType = ListWheelChildDelegateType.builder,
      this.onChanged,
      required this.itemCount,
      this.children,
      this.itemBuilder,
      this.onScrollEnd})
      : super(key: key);

  final PickerWheel? wheel;
  final FixedExtentScrollController? controller;
  final int? initialIndex;
  final ListWheelChildDelegateType childDelegateType;
  final ValueChanged<int>? onChanged;
  final int itemCount;
  final List<Widget>? children;
  final IndexedWidgetBuilder? itemBuilder;
  final ValueChanged<int>? onScrollEnd;

  @override
  Widget build(BuildContext context) => ListWheel(
      controller: controller,
      initialIndex: initialIndex ?? 0,
      isCupertino: wheel?.isCupertino,
      itemExtent: wheel?.itemHeight,
      diameterRatio: wheel?.diameterRatio,
      offAxisFraction: wheel?.offAxisFraction,
      perspective: wheel?.perspective,
      magnification: wheel?.magnification,
      useMagnifier: wheel?.useMagnifier,
      squeeze: wheel?.squeeze,
      physics: wheel?.physics,
      childDelegateType: childDelegateType,
      children: children,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      onScrollEnd: onScrollEnd,
      onChanged: onChanged);
}

///  省市区三级联动
class AreaPicker extends _PickerConfig {
  const AreaPicker({
    Key? key,
    this.defaultProvince,
    this.defaultCity,
    this.defaultDistrict,
    required PickerOptions options,
    required PickerWheel wheel,
  }) : super(key: key, options: options, wheel: wheel);

  /// 默认选择的省
  final String? defaultProvince;

  /// 默认选择的市
  final String? defaultCity;

  /// 默认选择的区
  final String? defaultDistrict;

  @override
  _AreaPickerState createState() => _AreaPickerState();
}

class _AreaPickerState extends State<AreaPicker> {
  List<String> province = <String>[];
  List<String> city = <String>[];
  List<String> district = <String>[];

  ///  List<String> street = <String>[];
  late Map<String, dynamic> areaData = area;

  late TextStyle contentStyle;

  int provinceIndex = 0;
  int cityIndex = 0;
  int districtIndex = 0;
  int streetIndex = 0;

  late FixedExtentScrollController controllerCity, controllerDistrict;

  late StateSetter cityState;
  late StateSetter districtState;

  @override
  void initState() {
    super.initState();

    ///  样式设置
    contentStyle = widget.options.contentStyle;

    ///  省
    province = areaData.keys.toList();
    if (province.contains(widget.defaultProvince))
      provinceIndex = province.indexOf(widget.defaultProvince!);
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;

    ///  市
    city = provinceData.keys.toList() as List<String>;
    if (city.contains(widget.defaultCity))
      cityIndex = city.indexOf(widget.defaultCity!);
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;

    ///  区
    district = cityData.keys.toList() as List<String>;
    if (district.contains(widget.defaultDistrict))
      districtIndex = district.indexOf(widget.defaultDistrict!);

    ///    var districtData = cityData[districtIndex];

    ///  街道
    ///    street = districtData[districtIndex];

    controllerCity = FixedExtentScrollController(initialItem: cityIndex);
    controllerDistrict =
        FixedExtentScrollController(initialItem: districtIndex);
  }

  ///  点击确定返回选择的地区
  void sureTapVoid() {
    if (widget.options.sureTap == null) return;
    final String areaString =
        '${province[provinceIndex]} ${city[cityIndex]} ${district[districtIndex]}';
    widget.options.sureTap!(areaString);
  }

  void refreshCity() {
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;
    city = provinceData.keys.toList() as List<String>;
    cityState(() {});
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;
    district = cityData.keys.toList() as List<String>;
    districtState(() {});
    controllerCity.jumpTo(0);
    controllerDistrict.jumpTo(0);
  }

  void refreshDistrict() {
    final Map<dynamic, dynamic> cityData = areaData[province[provinceIndex]]
        [city[cityIndex]] as Map<dynamic, dynamic>;
    district = cityData.keys.toList() as List<String>;
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
      })),
      Expanded(child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        cityState = setState;
        return wheelItem(city,
            childDelegateType: ListWheelChildDelegateType.list,
            controller: controllerCity, onChanged: (int newIndex) {
          cityIndex = newIndex;
          refreshDistrict();
        });
      })),
      Expanded(child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        districtState = setState;
        return wheelItem(district,
            childDelegateType: ListWheelChildDelegateType.list,
            controller: controllerDistrict,
            onChanged: (int newIndex) => districtIndex = newIndex);
      })),
    ]);
    return _PickerOptions(
        options: widget.options, child: row, onTap: sureTapVoid);
  }

  Widget wheelItem(List<String> list,
          {FixedExtentScrollController? controller,
          int? initialIndex,
          ListWheelChildDelegateType childDelegateType =
              ListWheelChildDelegateType.builder,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
          initialIndex: initialIndex,
          wheel: widget.wheel,
          childDelegateType: childDelegateType,
          children: list.builder((String value) => item(value)),
          itemBuilder: (BuildContext context, int index) => item(list[index]),
          onChanged: onChanged,
          itemCount: list.length);

  Widget item(String value) => Container(
      alignment: Alignment.center,
      child: BText(value,
          fontSize: 12, overflow: TextOverflow.ellipsis, style: contentStyle));

  void jumpToIndex(int index, FixedExtentScrollController controller,
          {Duration? duration}) =>
      controller.jumpToItem(index);
}

///  单列选择
class MultipleChoicePicker extends StatelessWidget {
  MultipleChoicePicker({
    Key? key,
    this.initialIndex,
    required this.itemCount,
    required this.itemBuilder,
    this.options,
    this.wheel,
    FixedExtentScrollController? controller,
  })  : controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex ?? 0),
        super(key: key);
  final PickerOptions? options;
  final PickerWheel? wheel;

  final int? initialIndex;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  final FixedExtentScrollController? controller;

  @override
  Widget build(BuildContext context) => _PickerOptions(
      options: options,
      child: _PickerListWheel(
          wheel: wheel,
          controller: controller,
          itemBuilder: itemBuilder,
          itemCount: itemCount),
      onTap: () {
        if (options?.sureIndexTap != null)
          options?.sureIndexTap!(controller?.selectedItem ?? 0);
      });
}

///  日期时间选择器
class DateTimePicker extends _PickerConfig {
  DateTimePicker({
    Key? key,
    bool? dual,
    bool? showUnit,
    DateTimePickerUnit? unit,
    this.unitStyle,
    this.startDate,
    this.defaultDate,
    this.endDate,
    required PickerOptions options,
    required PickerWheel wheel,
  })  : unit = unit ?? DateTimePickerUnit().getDefaultUnit,
        showUnit = showUnit ?? true,
        dual = dual ?? true,
        super(key: key, options: options, wheel: wheel);

  ///  补全双位数
  final bool dual;

  ///  单位是否显示
  final bool showUnit;

  ///  时间选择器单位
  ///  通过单位参数确定是否显示对应的年月日时分秒
  final DateTimePickerUnit unit;

  ///  字体样式
  final TextStyle? unitStyle;

  ///  时间
  final DateTime? startDate;
  final DateTime? defaultDate;
  final DateTime? endDate;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late List<int> yearData = <int>[],
      monthData = <int>[],
      dayData = <int>[],
      hourData = <int>[],
      minuteData = <int>[],
      secondData = <int>[];

  late FixedExtentScrollController controllerDay;
  late FixedExtentScrollController controllerMonth;

  ///  字体样式
  late TextStyle contentStyle;
  late TextStyle unitStyle;

  ///  时间
  late DateTime startDate;
  late DateTime defaultDate;
  late DateTime endDate;

  late DateTimePickerUnit unit;
  late double itemWidth;

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
    itemWidth = widget.wheel.itemWidth ?? (deviceWidth - 20) / unit.getLength();

    ///  样式设置
    contentStyle = widget.options.contentStyle;
    unitStyle = widget.unitStyle ?? contentStyle;
    startDate = widget.startDate ?? DateTime.now();
    endDate = initEndDate;
    defaultDate = initDefaultDate();
    if (unit.year != null) {
      ///  初始化每个Wheel数组
      final int year = (endDate.year - startDate.year) + 1;
      yearData = year.generate((int index) => startDate.year + index);
      yearIndex = defaultDate.year - startDate.year;
    }
    if (unit.month != null) {
      monthData = addList(12);
      monthIndex = defaultDate.month - 1;
      controllerMonth = FixedExtentScrollController(initialItem: monthIndex);
    }
    if (unit.day != null) {
      dayData = calculateDayNumber(isFirst: true);
      dayIndex = defaultDate.day - 1;
      controllerDay = FixedExtentScrollController(initialItem: dayIndex);
    }
    if (unit.hour != null) {
      hourData = addList(24);
      hourIndex = defaultDate.hour;
    }
    if (unit.minute != null) {
      minuteData = addList(60);
      minuteIndex = defaultDate.minute;
    }
    if (unit.second != null) {
      secondData = addList(60);
      secondIndex = defaultDate.second;
    }
  }

  DateTime initDefaultDate() {
    if (widget.defaultDate == null) return startDate;
    if (widget.defaultDate!.isBefore(startDate)) return startDate;
    if (widget.defaultDate!.isAfter(endDate)) return endDate;
    return widget.defaultDate!;
  }

  DateTime get initEndDate =>
      (widget.endDate != null && startDate.isBefore(widget.endDate!))
          ? widget.endDate!
          : startDate.add(const Duration(days: 3650));

  ///  显示双数还是单数
  String valuePadLeft(int value) =>
      widget.dual ? value.toString().padLeft(2, '0') : value.toString();

  ///  wheel数组添加数据
  List<int> addList(int maxNumber) => maxNumber.generate((int index) => index);

  ///  计算每月day的数量
  List<int> calculateDayNumber({bool isFirst = false}) {
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
      return addList(31);
    }
    return selectMonthItem == 2
        ? addList(DateTime(yearData[selectYearItem], 3)
            .difference(DateTime(yearData[selectYearItem], 2))
            .inDays)
        : addList(30);
  }

  void sureTapVoid() {
    if (widget.options.sureTap == null) return;
    String dateTime = '';
    if (unit.year != null) dateTime = yearData[yearIndex].toString() + '-';
    if (unit.month != null)
      dateTime += valuePadLeft(monthData[monthIndex] + 1) + '-';
    if (unit.day != null) dateTime += valuePadLeft(dayData[dayIndex] + 1) + ' ';
    if (unit.hour != null) dateTime += valuePadLeft(hourData[hourIndex]);
    if (unit.minute != null)
      dateTime += ':' + valuePadLeft(minuteData[minuteIndex]);
    if (unit.second != null)
      dateTime += ':' + valuePadLeft(secondData[secondIndex]);
    widget.options.sureTap!(dateTime.trim());
  }

  void refreshDay() {
    int oldDayIndex = dayIndex;
    final List<int> newDayList = calculateDayNumber();
    if (newDayList.length != dayData.length) {
      dayData = newDayList;
      if (oldDayIndex > 25) {
        jumpToIndex(25, controllerDay);
        final int newDayIndex = newDayList.length - 1;
        if (oldDayIndex > newDayIndex) oldDayIndex = newDayIndex;
      }
      dayState(() {});
      jumpToIndex(oldDayIndex, controllerDay);
    }
  }

  void checkMonthAndDay() {
    if (yearData[yearIndex] == startDate.year) {
      if (monthIndex < startDate.month - 1) {
        jumpToIndex(startDate.month - 1, controllerMonth);
        if (dayIndex < startDate.day - 1)
          jumpToIndex(startDate.day - 1, controllerDay);
      } else {
        if (dayIndex < startDate.day - 1)
          jumpToIndex(startDate.day - 1, controllerDay);
      }
    } else if (yearData[yearIndex] == endDate.year) {
      if (monthIndex > endDate.month - 1) {
        jumpToIndex(endDate.month - 1, controllerMonth);
        if (dayIndex > endDate.day - 1)
          jumpToIndex(endDate.day - 1, controllerDay);
      } else {
        if (dayIndex > endDate.day - 1)
          jumpToIndex(endDate.day - 1, controllerDay);
      }
    }
  }

  late StateSetter dayState;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = <Widget>[];
    if (unit.year != null)
      rowChildren.add(wheelItem(yearData,
          initialIndex: yearIndex, unit: unit.year, onChanged: (int newIndex) {
        yearIndex = newIndex;
        if (unit.month != null) checkMonthAndDay();
        if (unit.day != null) refreshDay();
      }));

    if (unit.month != null)
      rowChildren.add(wheelItem(monthData,
          startZero: false,
          controller: controllerMonth,
          unit: unit.month, onChanged: (int newIndex) {
        monthIndex = newIndex;
        const Duration(milliseconds: 100).timer(() => checkMonthAndDay());
        if (unit.day != null) refreshDay();
      }));

    if (unit.day != null)
      rowChildren.add(StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        dayState = setState;
        return wheelItem(dayData,
            startZero: false,
            controller: controllerDay,
            unit: unit.day, onChanged: (int newIndex) {
          dayIndex = newIndex;
          const Duration(milliseconds: 200).timer(() => checkMonthAndDay());
        });
      }));

    if (unit.hour != null)
      rowChildren.add(wheelItem(hourData,
          unit: unit.hour,
          initialIndex: hourIndex,
          onChanged: (int newIndex) => hourIndex = newIndex));

    if (unit.minute != null)
      rowChildren.add(wheelItem(minuteData,
          initialIndex: minuteIndex,
          unit: unit.minute,
          onChanged: (int newIndex) => minuteIndex = newIndex));

    if (unit.second != null)
      rowChildren.add(wheelItem(secondData,
          initialIndex: secondIndex,
          unit: unit.second,
          onChanged: (int newIndex) => secondIndex = newIndex));
    return _PickerOptions(
        options: widget.options,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: rowChildren),
        onTap: sureTapVoid);
  }

  Widget wheelItem(List<int> list,
          {FixedExtentScrollController? controller,
          String? unit,
          int? initialIndex,
          bool? startZero,
          ValueChanged<int>? onChanged}) =>
      Universal(
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
                          startZero: startZero,
                          initialIndex: initialIndex,
                          controller: controller,
                          onChanged: onChanged)),
                  Container(
                      margin: const EdgeInsets.only(left: 2),
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: BText(unit!, style: unitStyle))
                ],
          child: widget.showUnit
              ? null
              : listWheel(
                  list: list,
                  startZero: startZero,
                  initialIndex: initialIndex,
                  controller: controller,
                  onChanged: onChanged));

  Widget listWheel(
          {List<int>? list,
          bool? startZero,
          int? initialIndex,
          FixedExtentScrollController? controller,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
          initialIndex: initialIndex,
          itemBuilder: (_, int index) => Container(
                alignment: Alignment.center,
                child: BText(
                    padLeft(
                        startZero ?? true ? list![index] : list![index] + 1),
                    fontSize: 12,
                    style: contentStyle),
              ),
          itemCount: list!.length,
          onScrollEnd: onChanged,
          wheel: widget.wheel);

  String padLeft(int value) => value.toString().padLeft(2, '0');

  void jumpToIndex(int index, FixedExtentScrollController controller,
      {Duration? duration}) {
    controller.jumpToItem(index);
  }
}
