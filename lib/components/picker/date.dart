part of 'picker.dart';

extension ExtensionDatePicker on DatePicker {
  Future<DateTime?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<DateTime?>(options: options);
}

typedef DatePickerContentBuilder = Widget Function(String content);

typedef DatePickerUnitBuilder = Widget Function(String? unit);

class DatePicker extends PickerStatefulWidget<DateTime> {
  DatePicker({
    super.key,
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
        endDate = endDate ?? DateTime.now();

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

class _DatePickerState extends State<DatePicker> {
  /// 时间
  late DateTime startDate, defaultDate, endDate;
  bool isScrolling = false;

  late DatePickerUnit unit;
  late List<PickerLinkageItem<String>> items;
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
          final entry = buildEntry(current.year, unit.year,
              hasMonth ? buildEntry(current.month, unit.month) : null);
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
      DateTime current, List<PickerLinkageItem<String>> items, int length) {
    final entry = buildEntry(current.day, unit.day);
    items.add(entry);
    if (current.day == defaultDate.day && position.length == length) {
      final i = items.indexOf(entry);
      position.add(i >= 0 ? i : 0);
    }
  }

  void addMonth(
      DateTime current, List<PickerLinkageItem<String>> items, int length) {
    final entry = buildEntry(current.month, unit.month,
        hasDay ? buildEntry(current.day, unit.day) : null);
    items.add(entry);
    if (current.month == defaultDate.month && position.length == length) {
      final i = items.indexOf(entry);
      position.add(i >= 0 ? i : 0);
    }
  }

  PickerLinkageItem<String> buildEntry(int value, String? unit,
      [PickerLinkageItem<String>? secondary]) {
    String text = '';
    text = widget.dual ? value.toString().padLeft(2, '0') : value.toString();
    Widget buildText() {
      text += unit ?? '';
      return widget.itemBuilder?.call(text) ?? Text(text);
    }

    return PickerLinkageItem<String>(
        value: text,
        child: buildText(),
        children: [if (secondary != null) secondary]);
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiListWheelLinkagePicker<String>(
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
        onChanged: onChanged,
        width: widget.width,
        isScrollable: false,
        height: widget.height,
        itemWidth: widget.itemWidth);
  }

  void onChanged(List<int> index) {
    if (widget.onChanged != null) {
      List<String> value = [];
      List<PickerLinkageItem> resultList = items;
      for (var element in index) {
        if (element < resultList.length) {
          value.add(resultList[element].value);
          resultList = resultList[element].children;
        }
      }
      if (value.isEmpty) return;
      String? year;
      String? month;
      String? day;
      if (hasYear) {
        year = value.first;
        month = value[1];
        if (hasDay) day = value.last;
      } else {
        month = value.first;
        if (hasDay) day = value.last;
      }
      final now = DateTime.now();
      final dateTime =
          DateTime.tryParse('${year ?? now.year}-$month-${day ?? now.day}');
      if (dateTime != null) widget.onChanged!(dateTime);
    }
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
