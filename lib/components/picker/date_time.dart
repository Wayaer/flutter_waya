part of 'picker.dart';

extension ExtensionDateTimePicker on DateTimePicker {
  Future<DateTime?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<DateTime?>(options: options);
}

typedef DateTimePickerChanged = void Function(DateTime dateTime);

/// 日期时间选择器
class DateTimePicker extends PickerStatefulWidget<DateTime> {
  DateTimePicker({
    super.key,
    this.unit = const DateTimePickerUnit.all(),
    this.showUnit = true,
    this.dual = true,
    this.unitStyle,
    this.contentStyle,
    this.startDate,
    this.defaultDate,
    this.endDate,
    this.onChanged,
    this.height = kPickerDefaultHeight,
    this.width = double.infinity,
    this.itemWidth,
    super.options = const PickerOptions<DateTime>(),
    WheelOptions? wheelOptions,
  }) : super(wheelOptions: wheelOptions ?? GlobalOptions().wheelOptions);

  /// 补全双位数
  final bool dual;

  /// 是否显示单位
  final bool showUnit;

  /// 时间选择器单位
  /// 通过单位参数确定是否显示对应的年月日时分秒
  final DateTimePickerUnit unit;

  /// 选择框内单位文字样式
  final TextStyle? unitStyle;

  /// 内容字体样式
  final TextStyle? contentStyle;

  /// 开始时间
  final DateTime? startDate;

  /// 默认选中时间
  final DateTime? defaultDate;

  /// 结束时间
  final DateTime? endDate;

  /// onChanged
  final DateTimePickerChanged? onChanged;

  /// height
  final double height;

  /// width
  final double width;

  /// wheel width
  final double? itemWidth;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends ExtendedState<DateTimePicker> {
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

  late WheelOptions wheelOptions;

  StateSetter? dayState;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  DateTime get initDefaultDate {
    if (widget.defaultDate == null) return startDate;
    if (widget.defaultDate!.isBefore(startDate)) return startDate;
    if (widget.defaultDate!.isAfter(endDate)) return endDate;
    return widget.defaultDate!;
  }

  DateTime get initEndDate =>
      (widget.endDate != null && startDate.isBefore(widget.endDate!))
          ? widget.endDate!
          : startDate.add(const Duration(seconds: 1));

  void initialize() {
    wheelOptions = widget.wheelOptions;
    unit = widget.unit;
    startDate = widget.startDate ?? DateTime.now();
    endDate = initEndDate;
    defaultDate = initDefaultDate;
    final int year = (endDate.year - startDate.year) + 1;
    yearData = year.generate((int index) => startDate.year + index);
    yearIndex = defaultDate.year - startDate.year;
    if (unit.year != null && controllerYear == null) {
      controllerYear = FixedExtentScrollController(initialItem: yearIndex);
    }
    monthData = addList(12);
    monthIndex = defaultDate.month - 1;
    if (unit.month != null && controllerMonth == null) {
      controllerMonth = FixedExtentScrollController(initialItem: monthIndex);
    }
    dayData = calculateDayNumber(isFirst: true);
    dayIndex = defaultDate.day - 1;
    if (unit.day != null && controllerDay == null) {
      controllerDay = FixedExtentScrollController(initialItem: dayIndex);
    }
    hourData = addList(24);
    hourIndex = defaultDate.hour;
    if (unit.hour != null && controllerHour == null) {
      controllerHour = FixedExtentScrollController(initialItem: hourIndex);
    }
    minuteData = addList(60);
    minuteIndex = defaultDate.minute;
    if (unit.minute != null && controllerMinute == null) {
      controllerMinute = FixedExtentScrollController(initialItem: minuteIndex);
    }
    secondData = addList(60);
    secondIndex = defaultDate.second;
    if (unit.second != null && controllerSecond == null) {
      controllerSecond = FixedExtentScrollController(initialItem: secondIndex);
    }
    onChanged();
  }

  @override
  void didUpdateWidget(covariant DateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
    setState(() {});
    jumpToIndex(yearIndex, controllerYear);
    jumpToIndex(monthIndex, controllerMonth);
    jumpToIndex(dayIndex, controllerDay);
    jumpToIndex(hourIndex, controllerHour);
    jumpToIndex(minuteIndex, controllerMinute);
    jumpToIndex(secondIndex, controllerSecond);
  }

  int lastDateTime = 0;

  void onChanged() {
    final current = currentDateTime();
    final microseconds = current.microsecondsSinceEpoch;
    if ((current.isAfter(startDate) ||
            microseconds == startDate.microsecondsSinceEpoch) &&
        (current.isBefore(endDate) ||
            microseconds == endDate.microsecondsSinceEpoch) &&
        microseconds != lastDateTime) {
      lastDateTime = microseconds;
      widget.onChanged?.call(current);
    }
  }

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
    return addList(DateTime(yearData[selectYearItem], selectMonthItem + 1)
        .difference(DateTime(yearData[selectYearItem], selectMonthItem))
        .inDays);
  }

  void refreshPosition() {
    if (isScrolling) return;
    isScrolling = true;
    final DateTime currentDate = currentDateTime();
    final milliseconds = currentDate.millisecondsSinceEpoch;
    if (milliseconds < startDate.millisecondsSinceEpoch) {
      if (startDate.month - 1 != monthIndex) {
        jumpToIndex(startDate.month - 1, controllerMonth);
      }
      if (startDate.day - 1 != dayIndex) {
        jumpToIndex(startDate.day - 1, controllerDay);
      }
      if (startDate.hour != hourIndex) {
        jumpToIndex(startDate.hour, controllerHour);
      }
      if (startDate.minute != minuteIndex) {
        jumpToIndex(startDate.minute, controllerMinute);
      }
      if (startDate.second != secondIndex) {
        jumpToIndex(startDate.second, controllerSecond);
      }
    } else if (milliseconds > endDate.millisecondsSinceEpoch) {
      if (startDate.month - 1 != monthIndex) {
        jumpToIndex(endDate.month - 1, controllerMonth);
      }
      if (startDate.day - 1 != dayIndex) {
        jumpToIndex(endDate.day - 1, controllerDay);
      }
      if (startDate.hour != hourIndex) {
        jumpToIndex(endDate.hour, controllerHour);
      }
      if (startDate.minute != minuteIndex) {
        jumpToIndex(endDate.minute, controllerMinute);
      }
      if (startDate.second != secondIndex) {
        jumpToIndex(endDate.second, controllerSecond);
      }
    }
    isScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = [];
    if (unit.year != null) {
      rowChildren.add(wheelItem(yearData,
          controller: controllerYear,
          unit: unit.year, onChanged: (int newIndex) {
        yearIndex = newIndex;
        if (monthIndex == 1) {
          dayData = calculateDayNumber();
          dayState?.call(() {});
        }
      }));
    }

    if (unit.month != null) {
      rowChildren.add(wheelItem(monthData,
          startZero: false,
          controller: controllerMonth,
          unit: unit.month, onChanged: (int newIndex) {
        monthIndex = newIndex;
        dayData = calculateDayNumber();
        dayState?.call(() {});
      }));
    }

    if (unit.day != null) {
      rowChildren.add(StatefulBuilder(builder: (_, StateSetter setState) {
        dayState = setState;
        return wheelItem(dayData,
            startZero: false,
            controller: controllerDay,
            unit: unit.day, onChanged: (int newIndex) {
          dayIndex = newIndex;
        });
      }));
    }

    if (unit.hour != null) {
      rowChildren.add(wheelItem(hourData,
          unit: unit.hour,
          controller: controllerHour, onChanged: (int newIndex) {
        hourIndex = newIndex;
      }));
    }

    if (unit.minute != null) {
      rowChildren.add(wheelItem(minuteData,
          unit: unit.minute,
          controller: controllerMinute, onChanged: (int newIndex) {
        minuteIndex = newIndex;
      }));
    }

    if (unit.second != null) {
      rowChildren.add(wheelItem(secondData,
          unit: unit.second,
          controller: controllerSecond, onChanged: (int newIndex) {
        secondIndex = newIndex;
      }));
    }
    final dateTime = Universal(
        width: widget.width,
        direction: Axis.horizontal,
        height: widget.height,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren);
    if (widget.options == null) return dateTime;
    return PickerSubject<DateTime>(
        options: widget.options!, confirmTap: currentDateTime, child: dateTime);
  }

  DateTime currentDateTime() => DateTime(
        unit.year == null ? defaultDate.year : yearData[yearIndex],
        unit.month == null ? defaultDate.month : (monthData[monthIndex] + 1),
        unit.day == null
            ? defaultDate.day
            : (dayIndex >= dayData.length
                ? dayData.last
                : dayData[dayIndex] + 1),
        unit.hour == null ? defaultDate.hour : (hourData[hourIndex]),
        unit.minute == null ? defaultDate.minute : (minuteData[minuteIndex]),
        unit.second == null ? defaultDate.second : (secondData[secondIndex]),
        defaultDate.millisecond,
        defaultDate.microsecond,
      );

  Widget wheelItem(List<int> list,
      {FixedExtentScrollController? controller,
      String? unit,
      bool startZero = true,
      ValueChanged<int>? onChanged}) {
    final wheel = listWheel(
        list: list,
        startZero: startZero,
        // initialIndex: initialIndex,
        controller: controller,
        onChanged: (_) {
          onChanged?.call(_);
          refreshPosition();
        });
    return Universal(
        expanded: widget.itemWidth == null,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        width: widget.itemWidth,
        children: !widget.showUnit
            ? null
            : [
                wheel.expandedNull,
                Container(
                    margin: const EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: BText(unit!,
                        style: widget.unitStyle ??
                            widget.contentStyle ??
                            context.textTheme.bodyLarge))
              ],
        child: widget.showUnit ? null : wheel);
  }

  Widget listWheel(
          {List<int>? list,
          bool startZero = true,
          FixedExtentScrollController? controller,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
          itemCount: list!.length,
          onChanged: (_) {},
          itemBuilder: (_, int index) => Container(
              alignment: Alignment.center,
              child: BText(
                  valuePadLeft(startZero ? list[index] : list[index] + 1),
                  fontSize: 12,
                  style: widget.contentStyle ?? context.textTheme.bodyLarge)),
          onScrollEnd: (int index) {
            onChanged?.call(index);
            this.onChanged();
          },
          options: wheelOptions);

  void jumpToIndex(int index, FixedExtentScrollController? controller) {
    if (index != controller?.selectedItem) {
      controller?.jumpToItem(index);
    }
  }

  @override
  void dispose() {
    controllerYear?.dispose();
    controllerMonth?.dispose();
    controllerDay?.dispose();
    controllerHour?.dispose();
    controllerMinute?.dispose();
    controllerSecond?.dispose();
    super.dispose();
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
