import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 返回 false 不关闭弹窗;
typedef PickerTapSureCallback<T> = bool Function(T? value);
typedef PickerTapCancelCallback<T> = bool Function(T? value);

const double kPickerDefaultHeight = 180;

class PickerOptions<T> {
  PickerOptions({
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.sure = const BText('sure'),
    this.cancel = const BText('cancel'),
    this.backgroundColor,
    this.contentStyle,
    PickerTapSureCallback<T>? sureTap,
    PickerTapCancelCallback<T>? cancelTap,
    this.titleBottom,
    this.title,
  })  : sureTap = sureTap ?? ((T? value) => true),
        cancelTap = cancelTap ?? ((T? value) => true);

  /// 容器属性
  /// 整个Picker的背景色
  Color? backgroundColor;

  /// [title]底部内容
  Widget? titleBottom;
  EdgeInsetsGeometry titlePadding;

  /// right
  Widget sure;

  /// left
  Widget cancel;

  /// center
  Widget? title;

  /// 字体样式
  TextStyle? contentStyle;

  /// 确定点击事件 picker 关闭前，返回 false 不关闭弹窗
  /// 默认 为 true;
  PickerTapSureCallback<T> sureTap;

  /// 取消点击事件 picker 关闭前，返回 false 不关闭弹窗
  /// 默认 为 true;
  PickerTapCancelCallback<T> cancelTap;

  PickerOptions copyWith({
    Color? backgroundColor,
    Widget? titleBottom,
    EdgeInsetsGeometry? titlePadding,
    Widget? sure,
    Widget? cancel,
    Widget? title,
    TextStyle? contentStyle,
    PickerTapSureCallback<T>? sureTap,
    PickerTapCancelCallback<T>? cancelTap,
  }) {
    if (backgroundColor != null) this.backgroundColor = backgroundColor;
    if (titleBottom != null) this.titleBottom = titleBottom;
    if (titlePadding != null) this.titlePadding = titlePadding;
    if (sure != null) this.sure = sure;
    if (cancel != null) this.cancel = cancel;
    if (title != null) this.title = title;
    if (contentStyle != null) this.contentStyle = contentStyle;
    if (sureTap != null) this.sureTap = sureTap;
    if (cancelTap != null) this.cancelTap = cancelTap;
    return this;
  }

  PickerOptions merge(PickerOptions? options) => copyWith(
      backgroundColor: options?.backgroundColor,
      titleBottom: options?.titleBottom,
      titlePadding: options?.titlePadding,
      sure: options?.sure,
      cancel: options?.cancel,
      title: options?.title,
      contentStyle: options?.contentStyle,
      sureTap: options?.sureTap,
      cancelTap: options?.cancelTap);
}

class PickerWheelOptions extends WheelOptions {
  const PickerWheelOptions({
    /// 高度
    double itemHeight = 22,

    /// 半径大小,越大则越平面,越小则间距越大
    double diameterRatio = 1.3,

    /// 选中item偏移
    double offAxisFraction = 0,

    /// 表示ListWheel水平偏离中心的程度  范围[0,0.01]
    double perspective = 0.01,

    /// 是否启用放大
    bool useMagnifier = true,

    /// 放大倍率
    double magnification = 1.1,

    /// 上下间距默认为1 数越小 间距越大
    double squeeze = 1,

    /// 使用ios Cupertino 风格
    bool isCupertino = true,

    /// [isCupertino]=true生效
    Color? backgroundColor,
    ScrollPhysics physics = const FixedExtentScrollPhysics(),
    this.itemWidth,
  }) : super(
            backgroundColor: backgroundColor,
            itemExtent: itemHeight,
            isCupertino: isCupertino,
            diameterRatio: diameterRatio,
            offAxisFraction: offAxisFraction,
            perspective: perspective,
            magnification: magnification,
            useMagnifier: useMagnifier,
            squeeze: squeeze);

  /// 不设置 [itemWidth] 默认均分
  final double? itemWidth;

  @override
  PickerWheelOptions copyWith({
    double? itemExtent,
    double? diameterRatio,
    double? offAxisFraction,
    double? perspective,
    double? magnification,
    bool? useMagnifier,
    double? squeeze,
    bool? isCupertino,
    ScrollPhysics? physics,
    Color? backgroundColor,
    double? itemWidth,
    bool? looping,
    ValueChanged<int>? onChanged,
  }) =>
      PickerWheelOptions(
          diameterRatio: diameterRatio ?? this.diameterRatio,
          offAxisFraction: offAxisFraction ?? this.offAxisFraction,
          perspective: perspective ?? this.perspective,
          magnification: magnification ?? this.magnification,
          useMagnifier: useMagnifier ?? this.useMagnifier,
          squeeze: squeeze ?? this.squeeze,
          isCupertino: isCupertino ?? this.isCupertino,
          physics: physics ?? this.physics,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          itemWidth: itemWidth ?? this.itemWidth);
}

abstract class _PickerConfig<T> extends StatefulWidget {
  const _PickerConfig(
      {Key? key, required this.options, required this.wheelOptions})
      : super(key: key);

  final PickerOptions<T> options;
  final PickerWheelOptions wheelOptions;
}

typedef PickerSubjectTapCallback<T> = T Function();

class PickerSubject<T> extends StatelessWidget {
  const PickerSubject({
    Key? key,
    required this.options,
    required this.child,
    required this.sureTap,
    this.cancelTap,
  }) : super(key: key);

  final PickerOptions<T> options;
  final Widget child;
  final PickerSubjectTapCallback<T>? sureTap;
  final PickerSubjectTapCallback<T>? cancelTap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[];
    columnChildren.add(Universal(
        direction: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          options.cancel.onTap(() {
            final T? value = cancelTap?.call();
            final bool isPop = options.cancelTap.call(value);
            if (isPop) closePopup(value);
          }),
          if (options.title != null) options.title!.expandedNull,
          options.sure.onTap(() {
            final T? value = sureTap?.call();
            final bool isPop = options.sureTap.call(value);
            if (isPop) closePopup(value);
          }),
        ]));
    if (options.titleBottom != null) columnChildren.add(options.titleBottom!);
    columnChildren.add(child);
    return Universal(
        onTap: () {},
        safeBottom: true,
        mainAxisSize: MainAxisSize.min,
        color: options.backgroundColor,
        children: columnChildren);
  }
}

class _PickerListWheel extends ListWheel {
  _PickerListWheel({
    Key? key,
    required PickerWheelOptions wheel,
    FixedExtentScrollController? controller,
    int? initialIndex,
    ListWheelChildDelegateType childDelegateType =
        ListWheelChildDelegateType.builder,
    ValueChanged<int>? onChanged,
    required int itemCount,
    List<Widget>? children,
    IndexedWidgetBuilder? itemBuilder,
    ValueChanged<int>? onScrollEnd,
  }) : super(
            key: key,
            controller: controller,
            initialIndex: initialIndex ?? 0,
            options: WheelOptions(
                backgroundColor: wheel.backgroundColor,
                isCupertino: wheel.isCupertino,
                itemExtent: wheel.itemExtent,
                diameterRatio: wheel.diameterRatio,
                offAxisFraction: wheel.offAxisFraction,
                perspective: wheel.perspective,
                magnification: wheel.magnification,
                useMagnifier: wheel.useMagnifier,
                squeeze: wheel.squeeze,
                physics: wheel.physics,
                onChanged: onChanged),
            childDelegateType: childDelegateType,
            children: children,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            onScrollEnd: onScrollEnd);
}

/// 省市区三级联动
class AreaPicker extends _PickerConfig<String> {
  AreaPicker({
    Key? key,
    this.defaultProvince,
    this.defaultCity,
    this.defaultDistrict,
    PickerOptions<String>? options,
    PickerWheelOptions? wheelOptions,
  }) : super(
            key: key,
            options: options ?? PickerOptions<String>(),
            wheelOptions: wheelOptions ?? GlobalOptions().pickerWheelOptions);

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

  /// List<String> street = <String>[];
  late Map<String, dynamic> areaData = area;

  int provinceIndex = 0;
  int cityIndex = 0;
  int districtIndex = 0;
  int streetIndex = 0;

  late FixedExtentScrollController controllerCity, controllerDistrict;

  late StateSetter cityState;
  late StateSetter districtState;
  late PickerWheelOptions wheelOptions;

  @override
  void initState() {
    super.initState();
    wheelOptions = GlobalOptions().pickerWheelOptions;

    /// 省
    province = areaData.keys.toList();
    if (province.contains(widget.defaultProvince)) {
      provinceIndex = province.indexOf(widget.defaultProvince!);
    }
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;

    /// 市
    city = provinceData.keys.toList() as List<String>;
    if (city.contains(widget.defaultCity)) {
      cityIndex = city.indexOf(widget.defaultCity!);
    }
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;

    /// 区
    district = cityData.keys.toList() as List<String>;
    if (district.contains(widget.defaultDistrict)) {
      districtIndex = district.indexOf(widget.defaultDistrict!);
    }

    ///  var districtData = cityData[districtIndex];

    /// 街道
    ///  street = districtData[districtIndex];

    controllerCity = FixedExtentScrollController(initialItem: cityIndex);
    controllerDistrict =
        FixedExtentScrollController(initialItem: districtIndex);
  }

  /// 点击确定返回选择的地区
  String sureTapVoid() =>
      '${province[provinceIndex]} ${city[cityIndex]} ${district[districtIndex]}';

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
    return PickerSubject<String>(
        options: widget.options,
        child: SizedBox(
            width: double.infinity, height: kPickerDefaultHeight, child: row),
        sureTap: sureTapVoid);
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
          wheel: wheelOptions,
          childDelegateType: childDelegateType,
          children: list.builder((String value) => item(value)),
          itemBuilder: (BuildContext context, int index) => item(list[index]),
          onChanged: onChanged,
          itemCount: list.length);

  Widget item(String value) => Center(
      child: BText(value,
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
          style: widget.options.contentStyle ?? context.textTheme.bodyText1));

  void jumpToIndex(int index, FixedExtentScrollController controller,
          {Duration? duration}) =>
      controller.jumpToItem(index);
}

/// 单列选择
class MultipleChoicePicker extends StatelessWidget {
  MultipleChoicePicker({
    Key? key,
    this.initialIndex,
    required this.itemCount,
    required this.itemBuilder,
    PickerOptions<int>? options,
    this.wheelOptions,
    FixedExtentScrollController? controller,
  })  : controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex ?? 0),
        options = options ?? PickerOptions<int>(),
        super(key: key);
  final PickerOptions<int> options;
  final PickerWheelOptions? wheelOptions;
  final int? initialIndex;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final FixedExtentScrollController? controller;

  @override
  Widget build(BuildContext context) => PickerSubject<int>(
      options: options,
      child: SizedBox(
          width: double.infinity,
          height: kPickerDefaultHeight,
          child: _PickerListWheel(
              wheel: wheelOptions ?? GlobalOptions().pickerWheelOptions,
              controller: controller,
              itemBuilder: itemBuilder,
              itemCount: itemCount)),
      sureTap: () => controller?.selectedItem ?? 0);
}

/// 日期时间选择器
class DateTimePicker extends _PickerConfig<DateTime> {
  DateTimePicker({
    Key? key,
    this.unit = const DateTimePickerUnit(),
    this.showUnit = true,
    this.dual = true,
    this.unitStyle,
    this.startDate,
    this.defaultDate,
    this.endDate,
    PickerOptions<DateTime>? options,
    PickerWheelOptions? wheelOptions,
  }) : super(
            key: key,
            options: options ?? PickerOptions<DateTime>(),
            wheelOptions: wheelOptions ?? GlobalOptions().pickerWheelOptions);

  /// 补全双位数
  final bool dual;

  /// 单位是否显示
  final bool showUnit;

  /// 时间选择器单位
  /// 通过单位参数确定是否显示对应的年月日时分秒
  final DateTimePickerUnit unit;

  /// 字体样式
  final TextStyle? unitStyle;

  /// 时间
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

  FixedExtentScrollController? controllerMonth,
      controllerDay,
      controllerHour,
      controllerMinute,
      controllerSecond;

  /// 时间
  late DateTime startDate, defaultDate, endDate;

  late DateTimePickerUnit unit;
  late double itemWidth;

  int yearIndex = 0,
      monthIndex = 0,
      dayIndex = 0,
      hourIndex = 0,
      minuteIndex = 0,
      secondIndex = 0;
  bool isScrolling = false;
  late PickerWheelOptions wheelOptions;

  @override
  void initState() {
    super.initState();
    unit = widget.unit;
    wheelOptions = widget.wheelOptions;
    itemWidth = wheelOptions.itemWidth ?? (deviceWidth - 20) / unit.getLength();

    startDate = widget.startDate ?? DateTime.now();
    endDate = initEndDate;
    defaultDate = initDefaultDate();
    if (unit.year != null) {
      /// 初始化每个Wheel数组
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
      controllerHour = FixedExtentScrollController(initialItem: hourIndex);
    }
    if (unit.minute != null) {
      minuteData = addList(60);
      minuteIndex = defaultDate.minute;
      controllerMinute = FixedExtentScrollController(initialItem: minuteIndex);
    }
    if (unit.second != null) {
      secondData = addList(60);
      secondIndex = defaultDate.second;
      controllerSecond = FixedExtentScrollController(initialItem: secondIndex);
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

  /// 显示双数还是单数
  String valuePadLeft(int value) =>
      widget.dual ? value.toString().padLeft(2, '0') : value.toString();

  /// wheel数组添加数据
  List<int> addList(int maxNumber) => maxNumber.generate((int index) => index);

  /// 计算每月day的数量
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

  DateTime sureTapVoid() => DateTime(
      unit.year == null ? defaultDate.year : yearData[yearIndex],
      unit.month == null ? defaultDate.month : (monthData[monthIndex] + 1),
      unit.day == null ? defaultDate.day : (dayData[dayIndex] + 1),
      unit.hour == null ? defaultDate.hour : (hourData[hourIndex]),
      unit.minute == null ? defaultDate.minute : (minuteData[minuteIndex]),
      unit.second == null ? defaultDate.second : (secondData[secondIndex]));

  void refreshPosition() {
    if (isScrolling) return;
    isScrolling = true;
    final DateTime currentDate = DateTime(
        yearData.isEmpty ? defaultDate.year : yearData[yearIndex],
        monthData.isEmpty ? (defaultDate.month + 1) : monthData[monthIndex] + 1,
        dayData.isEmpty ? (defaultDate.day + 1) : dayData[dayIndex] + 1,
        hourData.isEmpty ? (defaultDate.hour) : hourData[hourIndex],
        minuteData.isEmpty ? (defaultDate.minute) : minuteData[minuteIndex],
        secondData.isEmpty ? (defaultDate.second) : secondData[secondIndex]);
    if (currentDate.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch) {
      if (currentDate.month < startDate.month) {
        jumpToIndex(startDate.month - 1, controllerMonth);
      }
      if (currentDate.day < startDate.day) {
        jumpToIndex(startDate.day - 1, controllerDay);
      }
      if (currentDate.hour < startDate.hour) {
        jumpToIndex(startDate.hour, controllerHour);
      }
      if (currentDate.minute < startDate.minute) {
        jumpToIndex(startDate.minute, controllerMinute);
      }
      if (currentDate.second < startDate.second) {
        jumpToIndex(startDate.second, controllerSecond);
      }
    } else if (currentDate.millisecondsSinceEpoch >
        endDate.millisecondsSinceEpoch) {
      if (currentDate.month > endDate.month) {
        jumpToIndex(endDate.month - 1, controllerMonth);
      }
      if (currentDate.day > endDate.day) {
        jumpToIndex(endDate.day - 1, controllerDay);
      }
      if (currentDate.hour > endDate.hour) {
        jumpToIndex(endDate.hour, controllerHour);
      }
      if (currentDate.minute > endDate.minute) {
        jumpToIndex(endDate.minute, controllerMinute);
      }
      if (currentDate.second > endDate.second) {
        jumpToIndex(endDate.second, controllerSecond);
      }
    }
    isScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = <Widget>[];
    if (unit.year != null) {
      rowChildren.add(wheelItem(yearData,
          initialIndex: yearIndex, unit: unit.year, onChanged: (int newIndex) {
        yearIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.month != null) {
      rowChildren.add(wheelItem(monthData,
          startZero: false,
          controller: controllerMonth,
          unit: unit.month, onChanged: (int newIndex) {
        monthIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.day != null) {
      rowChildren.add(wheelItem(dayData,
          startZero: false,
          controller: controllerDay,
          unit: unit.day, onChanged: (int newIndex) {
        dayIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.hour != null) {
      rowChildren.add(wheelItem(hourData,
          unit: unit.hour,
          initialIndex: hourIndex,
          controller: controllerHour, onChanged: (int newIndex) {
        hourIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.minute != null) {
      rowChildren.add(wheelItem(minuteData,
          initialIndex: minuteIndex,
          unit: unit.minute,
          controller: controllerMinute, onChanged: (int newIndex) {
        minuteIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.second != null) {
      rowChildren.add(wheelItem(secondData,
          initialIndex: secondIndex,
          unit: unit.second,
          controller: controllerSecond, onChanged: (int newIndex) {
        secondIndex = newIndex;
        refreshPosition();
      }));
    }
    return PickerSubject<DateTime>(
        options: widget.options,
        sureTap: sureTapVoid,
        child: SizedBox(
          width: double.infinity,
          height: kPickerDefaultHeight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowChildren),
        ));
  }

  Widget wheelItem(List<int> list,
          {FixedExtentScrollController? controller,
          String? unit,
          int? initialIndex,
          bool startZero = true,
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
                      child: BText(unit!,
                          style: widget.unitStyle ??
                              widget.options.contentStyle ??
                              context.textTheme.bodyText1))
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
          bool startZero = true,
          int? initialIndex,
          FixedExtentScrollController? controller,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
          initialIndex: initialIndex,
          itemBuilder: (_, int index) => Container(
              alignment: Alignment.center,
              child: BText(
                  valuePadLeft(startZero ? list![index] : list![index] + 1),
                  fontSize: 12,
                  style: widget.options.contentStyle ??
                      context.textTheme.bodyText1)),
          itemCount: list!.length,
          onScrollEnd: onChanged,
          wheel: wheelOptions);

  void jumpToIndex(int index, FixedExtentScrollController? controller,
      {Duration? duration}) {
    controller?.jumpToItem(index);
  }
}
