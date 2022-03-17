import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 返回 false 不关闭弹窗;
typedef PickerTapSureCallback<T> = bool Function(T? value);
typedef PickerTapCancelCallback<T> = bool Function(T? value);

const double kPickerDefaultHeight = 180;
const double kPickerDefaultWidth = 90;

class PickerOptions<T> {
  PickerOptions({
    this.top,
    this.bottom,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.sure = const BText('sure'),
    this.cancel = const BText('cancel'),
    this.backgroundColor,
    this.contentStyle,
    PickerTapSureCallback<T>? sureTap,
    PickerTapCancelCallback<T>? cancelTap,
  })  : sureTap = sureTap ?? ((T? value) => true),
        cancelTap = cancelTap ?? ((T? value) => true);

  /// 容器属性
  /// 整个Picker的背景色
  Color? backgroundColor;

  /// [title]底部内容
  Widget? bottom;

  /// [title]顶部内容
  Widget? top;
  EdgeInsetsGeometry padding;

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
    Widget? bottom,
    Widget? top,
    EdgeInsetsGeometry? padding,
    Widget? sure,
    Widget? cancel,
    Widget? title,
    TextStyle? contentStyle,
    PickerTapSureCallback<T>? sureTap,
    PickerTapCancelCallback<T>? cancelTap,
  }) {
    if (backgroundColor != null) this.backgroundColor = backgroundColor;
    if (bottom != null) this.bottom = bottom;
    if (top != null) this.top = top;
    if (padding != null) this.padding = padding;
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
      top: options?.top,
      bottom: options?.bottom,
      padding: options?.padding,
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
    final List<Widget> column = <Widget>[];
    if (options.top != null) column.add(options.top!);
    column.add(Universal(
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
    if (options.bottom != null) column.add(options.bottom!);
    column.add(child);
    return Universal(
        onTap: () {},
        padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
        mainAxisSize: MainAxisSize.min,
        color: options.backgroundColor,
        children: column);
  }
}

class _PickerListWheel extends ListWheel {
  _PickerListWheel({
    Key? key,
    required PickerWheelOptions wheel,
    FixedExtentScrollController? controller,
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

class _PickerListStateWheel extends ListStateWheel {
  _PickerListStateWheel({
    Key? key,
    required PickerWheelOptions wheel,
    FixedExtentScrollController? controller,
    ListWheelChildDelegateType childDelegateType =
        ListWheelChildDelegateType.builder,
    ValueChanged<int>? onChanged,
    required int itemCount,
    List<Widget>? children,
    IndexedWidgetBuilder? itemBuilder,
    ValueChanged<int>? onScrollEnd,
    int initialItem = 0,
  }) : super(
            key: key,
            initialItem: initialItem,
            controller: controller,
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

  late FixedExtentScrollController controllerProvince,
      controllerCity,
      controllerDistrict;

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

    controllerProvince =
        FixedExtentScrollController(initialItem: provinceIndex);
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
        provinceData[city[city.length < cityIndex ? 0 : cityIndex]]
            as Map<dynamic, dynamic>;
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
          child: wheelItem(province, controller: controllerProvince,
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
          ListWheelChildDelegateType childDelegateType =
              ListWheelChildDelegateType.builder,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
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

  @override
  void dispose() {
    super.dispose();
    controllerProvince.dispose();
    controllerCity.dispose();
    controllerDistrict.dispose();
  }
}

/// 日期时间选择器
class DateTimePicker extends _PickerConfig<DateTime> {
  DateTimePicker({
    Key? key,
    this.unit = const DateTimePickerUnit.all(),
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

  FixedExtentScrollController? controllerYear,
      controllerMonth,
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
      controllerYear = FixedExtentScrollController(initialItem: yearIndex);
    } else {
      yearData = [defaultDate.year];
    }
    monthData = addList(12);
    monthIndex = defaultDate.month - 1;
    if (unit.month != null) {
      controllerMonth = FixedExtentScrollController(initialItem: monthIndex);
    }
    dayData = calculateDayNumber(isFirst: true);
    dayIndex = defaultDate.day - 1;
    if (unit.day != null) {
      controllerDay = FixedExtentScrollController(initialItem: dayIndex);
    }
    hourData = addList(24);
    hourIndex = defaultDate.hour;
    if (unit.hour != null) {
      controllerHour = FixedExtentScrollController(initialItem: hourIndex);
    }
    minuteData = addList(60);
    minuteIndex = defaultDate.minute;
    if (unit.minute != null) {
      controllerMinute = FixedExtentScrollController(initialItem: minuteIndex);
    }
    secondData = addList(60);
    secondIndex = defaultDate.second;
    if (unit.second != null) {
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
        yearData[yearIndex],
        monthData[monthIndex] + 1,
        dayData[dayIndex] + 1,
        hourData[hourIndex],
        minuteData[minuteIndex],
        secondData[secondIndex]);
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
          controller: controllerYear,
          unit: unit.year, onChanged: (int newIndex) {
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
          controller: controllerHour, onChanged: (int newIndex) {
        hourIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.minute != null) {
      rowChildren.add(wheelItem(minuteData,
          unit: unit.minute,
          controller: controllerMinute, onChanged: (int newIndex) {
        minuteIndex = newIndex;
        refreshPosition();
      }));
    }

    if (unit.second != null) {
      rowChildren.add(wheelItem(secondData,
          unit: unit.second,
          controller: controllerSecond, onChanged: (int newIndex) {
        secondIndex = newIndex;
        refreshPosition();
      }));
    }
    return PickerSubject<DateTime>(
        options: widget.options,
        sureTap: sureTapVoid,
        child: Universal(
            width: double.infinity,
            direction: Axis.horizontal,
            height: kPickerDefaultHeight,
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren));
  }

  Widget wheelItem(List<int> list,
          {FixedExtentScrollController? controller,
          String? unit,
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
                          // initialIndex: initialIndex,
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
                  // initialIndex: initialIndex,
                  controller: controller,
                  onChanged: onChanged));

  Widget listWheel(
          {List<int>? list,
          bool startZero = true,
          FixedExtentScrollController? controller,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
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

  @override
  void dispose() {
    super.dispose();
    controllerYear?.dispose();
    controllerMonth?.dispose();
    controllerDay?.dispose();
    controllerHour?.dispose();
    controllerMinute?.dispose();
    controllerSecond?.dispose();
  }
}

/// 单列选择
class SingleColumnPicker extends StatelessWidget {
  SingleColumnPicker({
    Key? key,
    int initialIndex = 0,
    required this.itemCount,
    required this.itemBuilder,
    PickerOptions<int>? options,
    this.wheelOptions,
    FixedExtentScrollController? controller,
  })  : controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex),
        options = options ?? PickerOptions<int>(),
        super(key: key);

  /// 头部和背景色配置
  final PickerOptions<int> options;

  /// Wheel配置信息
  final PickerWheelOptions? wheelOptions;

  /// 渲染子组件
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// 控制器
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

class PickerEntry {
  const PickerEntry({required this.itemCount, required this.itemBuilder});

  /// 渲染子组件
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
}

/// 多列选择 不联动
class MultiColumnPicker extends StatelessWidget {
  MultiColumnPicker({
    Key? key,
    PickerOptions<List<int>>? options,
    this.wheelOptions,
    required this.entry,
    this.horizontalScroll = false,
    this.addExpanded = true,
  })  : options = options ?? PickerOptions<List<int>>(),
        super(key: key);

  /// 头部和背景色配置
  final PickerOptions<List<int>> options;

  /// Wheel配置信息
  final PickerWheelOptions? wheelOptions;

  /// 要渲染的数据
  final List<PickerEntry> entry;

  /// 是否可以横向滚动
  /// [horizontalScroll]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [horizontalScroll]==false 使用[Row] 创建每个滚动，居中显示
  final bool horizontalScroll;

  /// [horizontalScroll]==false
  final bool addExpanded;

  @override
  Widget build(BuildContext context) {
    List<int> position = [];
    return PickerSubject<List<int>>(
        options: options,
        child: Universal(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            width: double.infinity,
            isScroll: horizontalScroll,
            height: kPickerDefaultHeight,
            children: entry.builderEntry((item) {
              position.add(0);
              final value = item.value;
              final location = item.key;
              return Universal(
                  width: wheelOptions?.itemWidth ?? kPickerDefaultWidth,
                  expanded: horizontalScroll ? false : addExpanded,
                  child: _PickerListWheel(
                      wheel: wheelOptions ?? GlobalOptions().pickerWheelOptions,
                      itemBuilder: value.itemBuilder,
                      onChanged: (int index) {
                        position[location] = index;
                      },
                      itemCount: value.itemCount));
            })),
        sureTap: () => position);
  }
}

class PickerLinkageEntry {
  const PickerLinkageEntry({required this.text, this.children = const []});

  final Widget text;

  final List<PickerLinkageEntry> children;
}

/// 多列选择 联动
class MultiColumnLinkagePicker extends StatefulWidget {
  MultiColumnLinkagePicker({
    Key? key,
    PickerOptions<List<int>>? options,
    this.wheelOptions,
    required this.entry,
    this.horizontalScroll = false,
    this.addExpanded = true,
  })  : options = options ?? PickerOptions<List<int>>(),
        super(key: key);

  /// 头部和背景色配置
  final PickerOptions<List<int>> options;

  /// Wheel配置信息
  final PickerWheelOptions? wheelOptions;

  /// 要渲染的数据
  final List<PickerLinkageEntry> entry;

  /// 是否可以横向滚动
  /// [horizontalScroll]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [horizontalScroll]==false 使用[Row] 创建每个滚动，居中显示
  final bool horizontalScroll;

  /// [horizontalScroll]==false
  final bool addExpanded;

  @override
  _MultiColumnLinkagePickerState createState() =>
      _MultiColumnLinkagePickerState();
}

class _MultiColumnLinkagePickerState extends State<MultiColumnLinkagePicker> {
  List<PickerLinkageEntry> entry = [];
  List<int> position = [];
  int currentListLength = 0;

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
  }

  void calculateListLength(List<PickerLinkageEntry> list, bool isFirst) {
    if (isFirst) currentListLength = 0;
    if (list.isNotEmpty) {
      List<PickerLinkageEntry> subsetList = [];
      if (currentListLength >= position.length) {
        position.add(0);
        subsetList = list.first.children;
      } else if (currentListLength < position.length) {
        final index = position[currentListLength];
        if (list.length > index) {
          subsetList = list[index].children;
        } else {
          subsetList = list.first.children;
        }
      }
      currentListLength += 1;
      calculateListLength(subsetList, false);
    } else {
      while (position.length > currentListLength) {
        position.removeLast();
      }
    }
  }

  List<Widget> get buildWheels {
    calculateListLength(entry, true);
    List<Widget> list = [];
    List<PickerLinkageEntry> currentEntry = entry;
    position.length.generate((index) {
      final itemPosition = position[index];
      if (currentEntry.isNotEmpty) {
        list.add(listStateWheel(location: index, list: currentEntry));
        if (itemPosition < currentEntry.length) {
          currentEntry = currentEntry[itemPosition].children;
        } else {
          currentEntry = currentEntry.last.children;
        }
      }
    });
    return list;
  }

  @override
  void didUpdateWidget(covariant MultiColumnLinkagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry != widget.entry) setState(() {});
  }

  @override
  Widget build(BuildContext context) => PickerSubject<List<int>>(
      options: widget.options,
      sureTap: () => position,
      child: Universal(
        width: double.infinity,
        height: kPickerDefaultHeight,
        direction: Axis.horizontal,
        isScroll: widget.horizontalScroll,
        children: buildWheels.builder((item) => Universal(
            expanded: widget.horizontalScroll ? false : widget.addExpanded,
            height: kPickerDefaultHeight,
            child: Center(child: item),
            width: widget.wheelOptions?.itemWidth ?? kPickerDefaultWidth)),
      ));

  Widget listStateWheel(
          {required List<PickerLinkageEntry> list, required int location}) =>
      _PickerListStateWheel(
          initialItem: position[location],
          onChanged: (int index) {
            position[location] = index;
          },
          onScrollEnd: (int index) {
            final builder =
                list.length > index && list[index].children.isNotEmpty;
            if (location != position.length - 1 || builder) {
              50.milliseconds.delayed(() {
                setState(() {});
              });
            }
          },
          itemBuilder: (_, int index) => Center(
              child: index > list.length ? list.last.text : list[index].text),
          itemCount: list.length,
          wheel: widget.wheelOptions ?? GlobalOptions().pickerWheelOptions);
}
