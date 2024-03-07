part of 'picker.dart';

extension ExtensionDatePicker on DatePicker {
  Future<DateTime?> show({BottomSheetOptions? options}) async {
    final position = await popupBottomSheet<List<int>?>(options: options);
    if (position == null || key == null) return null;
    return (key as GlobalKey<_DatePickerState>)
        .currentState
        ?.indexToDatetime(position);
  }
}

typedef DatePickerContentBuilder = Widget Function(String content);

typedef DatePickerUnitBuilder = Widget Function(String? unit);

class DatePicker extends PickerStatefulWidget<DateTime> {
  DatePicker({
    Key? key,
    super.options,
    super.wheelOptions,
    super.height = kPickerDefaultHeight,
    super.width = double.infinity,
    super.itemWidth,
    this.unit = const DatePickerUnit.yd(),
    this.dual = true,
    this.itemBuilder,
    this.onChanged,
    DateTime? startDate,
    DateTime? defaultDate,
    DateTime? endDate,
  })  : startDate =
            startDate ?? DateTime.now().subtract(const Duration(days: 1)),
        defaultDate = defaultDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        super(key: key ?? GlobalKey<_DatePickerState>());

  /// 补全双位数
  final bool dual;

  /// 选择器单位
  /// 通过单位参数确定是否显示对应的年月日
  final DatePickerUnit unit;

  final DatePickerContentBuilder? itemBuilder;

  /// 开始时间
  final DateTime startDate;

  /// 默认选中时间
  final DateTime defaultDate;

  /// 结束时间
  final DateTime endDate;

  /// onChanged
  final DateTimePickerChanged? onChanged;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DateValue {
  _DateValue(this.value, this.dateTime);

  final String value;
  final DateTime dateTime;
}

class _DatePickerState extends State<DatePicker> {
  /// 时间
  late DateTime startDate, defaultDate, endDate;
  bool isScrolling = false;

  late DatePickerUnit unit;
  late List<PickerLinkageItem<_DateValue>> items;
  late List<int> position = [];

  late bool hasYear;
  late bool hasMonth;
  late bool hasDay;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  DateTime get initDefaultDate {
    if (widget.defaultDate.isBefore(startDate)) return startDate;
    if (widget.defaultDate.isAfter(endDate)) return endDate;
    return widget.defaultDate;
  }

  DateTime get initEndDate => startDate.isBefore(widget.endDate)
      ? widget.endDate
      : startDate.add(const Duration(days: 1));

  void initialize() {
    items = [];
    unit = widget.unit;
    startDate = widget.startDate;
    endDate = initEndDate;
    defaultDate = initDefaultDate;
    final rangeDate = startDate.getDaysForRange(endDate);
    int yI = 0;
    int mI = 0;
    hasMonth = unit.month != null;
    hasYear = unit.year != null;
    hasDay = unit.day != null;

    for (int i = 0; i < rangeDate.length; i++) {
      final current = rangeDate[i];
      DateTime? previous;
      if (i > 0) previous = rangeDate[i - 1];
      if (hasYear) {
        if (previous != null && current.year == previous.year) {
          if (current.month == previous.month) {
            if (!hasDay) continue;
            addDay(current, items[yI].children[mI].children, 2);
          } else {
            mI += 1;
            if (!hasMonth) continue;
            addMonth(current, items[yI].children, 1);
          }
        } else {
          if (previous != null) {
            mI = 0;
            yI += 1;
          }
          final entry = buildEntry(current, current.year, unit.year,
              hasMonth ? buildEntry(current, current.month, unit.month) : null);
          items.add(entry);
          if (current.year == defaultDate.year && position.isEmpty) {
            final i = items.indexOf(entry);
            position.add(i >= 0 ? i : 0);
          }
        }
      } else {
        if (previous != null && current.month == previous.month) {
          if (!hasDay) continue;
          addDay(current, items[mI].children, 1);
        } else {
          if (previous != null) mI += 1;
          if (!hasMonth) continue;
          addMonth(current, items, 0);
        }
      }
    }
  }

  void addDay(
      DateTime current, List<PickerLinkageItem<_DateValue>> items, int length) {
    final entry = buildEntry(current, current.day, unit.day);
    items.add(entry);
    if (current.format(DateTimeDist.yearDay) ==
            defaultDate.format(DateTimeDist.yearDay) &&
        position.length == length) {
      final i = items.indexOf(entry);
      position.add(i >= 0 ? i : 0);
    }
  }

  void addMonth(
      DateTime current, List<PickerLinkageItem<_DateValue>> items, int length) {
    final entry = buildEntry(current, current.month, unit.month,
        hasDay ? buildEntry(current, current.day, unit.day) : null);
    items.add(entry);
    if (current.format(DateTimeDist.yearMonth) ==
            defaultDate.format(DateTimeDist.yearMonth) &&
        position.length == length) {
      final i = items.indexOf(entry);
      position.add(i >= 0 ? i : 0);
    }
  }

  PickerLinkageItem<_DateValue> buildEntry(
      DateTime dateTime, int value, String? unit,
      [PickerLinkageItem<_DateValue>? secondary]) {
    String text = '';
    text = widget.dual ? value.toString().padLeft(2, '0') : value.toString();
    Widget buildText() {
      text += unit ?? '';
      return widget.itemBuilder?.call(text) ?? Text(text);
    }

    return PickerLinkageItem<_DateValue>(
        value: _DateValue(text, dateTime),
        child: buildText(),
        children: [if (secondary != null) secondary]);
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiListWheelLinkagePicker<_DateValue>(
        items: items,
        value: position,
        options: widget.options == null
            ? null
            : PickerOptions<List<int>>(
                top: widget.options!.top,
                title: widget.options!.title,
                backgroundColor: widget.options!.backgroundColor,
                background: widget.options!.background,
                bottom: widget.options!.bottom,
                contentPadding: widget.options!.contentPadding,
                padding: widget.options!.padding,
                decoration: widget.options!.decoration,
                confirm: widget.options!.confirm,
                cancel: widget.options!.cancel),
        wheelOptions: widget.wheelOptions,
        onChanged: (List<int> index) {
          if (widget.onChanged != null) {
            final datetime = indexToDatetime(index);
            if (datetime != null) widget.onChanged!(datetime);
          }
        },
        width: widget.width,
        isScrollable: false,
        height: widget.height,
        itemWidth: widget.itemWidth);
  }

  DateTime? indexToDatetime(List<int> index) {
    List<_DateValue> value = [];
    List<PickerLinkageItem<_DateValue>> resultList = items;
    for (var element in index) {
      if (element < resultList.length) {
        value.add(resultList[element].value);
        resultList = resultList[element].children;
      } else {
        value.add(resultList.last.value);
        resultList = resultList.last.children;
      }
    }
    if (value.isEmpty) return null;
    String? year;
    String? month;
    String? day;
    if (hasYear) {
      year = value.first.value;
      month = value[1].value;
      if (hasDay) day = value.last.value;
    } else {
      year = value.first.dateTime.year.toString();
      month = value.first.value;
      if (hasDay) day = value.last.value;
    }
    final now = DateTime.now();
    return DateTime.tryParse('$year-$month-${day ?? now.day}');
  }
}

class DatePickerUnit {
  const DatePickerUnit.none()
      : year = '',
        month = '',
        day = '';

  const DatePickerUnit.yd(
      {this.year = ' Y', this.month = ' M', this.day = ' D'});

  const DatePickerUnit.ym({
    this.year = ' Y',
    this.month = ' M',
  }) : day = null;

  const DatePickerUnit.md({
    this.month = ' M',
    this.day = ' D',
  }) : year = null;

  final String? year;
  final String? month;
  final String? day;

  int getLength() {
    int i = 0;
    if (year != null) i += 1;
    if (month != null) i += 1;
    if (day != null) i += 1;
    return i;
  }
}
