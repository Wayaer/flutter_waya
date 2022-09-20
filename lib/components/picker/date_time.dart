part of 'picker.dart';

/// 日期时间选择器
class DateTimePicker extends _PickerConfig<DateTime> {
  DateTimePicker({
    super.key,
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
  State<DateTimePicker> createState() => _DateTimePickerState();
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
          itemCount: list!.length,
          itemBuilder: (_, int index) => Container(
              alignment: Alignment.center,
              child: BText(
                  valuePadLeft(startZero ? list[index] : list[index] + 1),
                  fontSize: 12,
                  style: widget.options.contentStyle ??
                      context.textTheme.bodyText1)),
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
