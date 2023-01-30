part of 'picker.dart';

extension ExtensionDateTimePicker on DateTimePicker {
  Future<DateTime?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<DateTime?>(options: options);
}

/// 日期时间选择器
class DateTimePicker extends PickerStatefulWidget<DateTime> {
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

  /// 是否显示单位
  final bool showUnit;

  /// 时间选择器单位
  /// 通过单位参数确定是否显示对应的年月日时分秒
  final DateTimePickerUnit unit;

  /// 选择框内单位文字样式
  final TextStyle? unitStyle;

  /// 开始时间
  final DateTime? startDate;

  /// 默认选中时间
  final DateTime? defaultDate;

  /// 结束时间
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
    wheelOptions = widget.wheelOptions;
    unit = widget.unit;

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

  DateTime confirmTapVoid() => DateTime(
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
        confirmTap: confirmTapVoid,
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
          expanded: wheelOptions.itemWidth == null,
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          width: wheelOptions.itemWidth,
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
                              context.textTheme.bodyLarge))
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
                      context.textTheme.bodyLarge)),
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

class DateTimePickerUnit {
  /// 设置 null 不显示
  /// [year] == null 不显示年
  const DateTimePickerUnit(
      {this.year, this.month, this.day, this.hour, this.minute, this.second});

  const DateTimePickerUnit.md({
    this.month = 'M',
    this.day = 'D',
  })  : year = null,
        hour = null,
        minute = null,
        second = null;

  const DateTimePickerUnit.ym({
    this.year = 'Y',
    this.month = 'M',
  })  : day = null,
        hour = null,
        minute = null,
        second = null;

  const DateTimePickerUnit.date({
    this.year = 'Y',
    this.month = 'M',
    this.day = 'D',
  })  : hour = null,
        minute = null,
        second = null;

  const DateTimePickerUnit.time(
      {this.hour = 'H', this.minute = 'M', this.second = 'S'})
      : year = null,
        month = null,
        day = null;

  const DateTimePickerUnit.hm(
      {this.hour = 'H', this.minute = 'M', this.second = 'S'})
      : year = null,
        month = null,
        day = null;

  const DateTimePickerUnit.all(
      {this.year = 'Y',
      this.month = 'M',
      this.day = 'D',
      this.hour = 'H',
      this.minute = 'M',
      this.second = 'S'});

  const DateTimePickerUnit.yhm({
    this.year = 'Y',
    this.month = 'M',
    this.day = 'D',
    this.hour = 'H',
    this.minute = 'M',
  }) : second = null;

  final String? year;
  final String? month;
  final String? day;
  final String? hour;
  final String? minute;
  final String? second;

  int getLength() {
    int i = 0;
    if (year != null) i += 1;
    if (month != null) i += 1;
    if (day != null) i += 1;
    if (hour != null) i += 1;
    if (minute != null) i += 1;
    if (second != null) i += 1;
    return i;
  }
}
