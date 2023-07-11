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
    this.unit = const DatePickerUnit.yd(),
    this.dual = true,
    this.contentBuilder,
    this.onChanged,
    this.height = kPickerDefaultHeight,
    this.width = double.infinity,
    this.itemWidth = kPickerDefaultWidth,
    super.options = const PickerOptions<DateTime>(),
    DateTime? startDate,
    DateTime? defaultDate,
    DateTime? endDate,
    WheelOptions? wheelOptions,
  })  : startDate =
            startDate ?? DateTime.now().subtract(const Duration(days: 1)),
        defaultDate = defaultDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        super(wheelOptions: wheelOptions ?? GlobalOptions().wheelOptions);

  /// 补全双位数
  final bool dual;

  /// 选择器单位
  /// 通过单位参数确定是否显示对应的年月日
  final DatePickerUnit unit;

  final DatePickerContentBuilder? contentBuilder;

  /// 开始时间
  final DateTime startDate;

  /// 默认选中时间
  final DateTime defaultDate;

  /// 结束时间
  final DateTime endDate;

  /// onChanged
  final DateTimePickerChanged? onChanged;

  /// height
  final double height;

  /// width
  final double width;

  /// wheel width
  final double itemWidth;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  /// 时间
  late DateTime startDate, defaultDate, endDate;
  bool isScrolling = false;

  late WheelOptions wheelOptions;

  late DatePickerUnit unit;
  late List<PickerLinkageEntry<String>> entry = [];

  @override
  void initState() {
    super.initState();
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
    entry = [];
    wheelOptions = widget.wheelOptions;
    unit = widget.unit;
    startDate = widget.startDate;
    endDate = initEndDate;
    defaultDate = initDefaultDate;
    final rangeDate = startDate.getDaysForRange(endDate);
    int yI = 0;
    int mI = 0;
    bool hasMonth = unit.month != null;
    bool hasYear = unit.year != null;
    bool hasDay = unit.day != null;
    for (int i = 0; i < rangeDate.length; i++) {
      final current = rangeDate[i];
      DateTime? previous;
      if (i > 0) previous = rangeDate[i - 1];
      if (hasYear) {
        if (previous != null && current.year == previous.year) {
          if (current.month == previous.month) {
            if (!hasDay) continue;
            entry[yI]
                .children[mI]
                .children
                .add(buildPickerLinkageEntry(current.day));
          } else {
            mI += 1;
            if (!hasMonth) continue;
            entry[yI].children.add(buildPickerLinkageEntry(
                current.month, hasDay ? current.day : null));
          }
        } else {
          if (previous != null) {
            mI = 0;
            yI += 1;
          }
          entry.add(buildPickerLinkageEntry(
              current.year, hasMonth ? current.month : null));
        }
      } else {
        if (previous != null && current.month == previous.month) {
          if (!hasDay) continue;
          entry[mI].children.add(buildPickerLinkageEntry(current.day));
        } else {
          if (previous != null) mI += 1;
          if (!hasMonth) continue;
          entry.add(buildPickerLinkageEntry(
              current.month, hasDay ? current.day : null));
        }
      }
    }
  }

  PickerLinkageEntry<String> buildPickerLinkageEntry(int primary,
      [int? secondary]) {
    /// 显示双数还是单数
    String valuePadLeft(int value) =>
        widget.dual ? value.toString().padLeft(2, '0') : value.toString();

    return PickerLinkageEntry<String>(
        value: valuePadLeft(primary),
        child: buildContent(valuePadLeft(primary)),
        children: [
          if (secondary != null)
            PickerLinkageEntry<String>(
                value: valuePadLeft(secondary),
                child: buildContent(valuePadLeft(secondary)),
                children: [])
        ]);
  }

  Widget buildContent(String value) =>
      widget.contentBuilder?.call(value) ??
      Text(value, style: context.textTheme.bodyLarge);

  @override
  Widget build(BuildContext context) {
    initialize();
    return MultiListWheelLinkagePicker<String>(
        entry: entry,
        options: widget.options == null
            ? null
            : PickerOptions<List<int>>(
                top: widget.options!.top,
                title: widget.options!.title,
                backgroundColor: widget.options!.backgroundColor,
                bottom: widget.options!.bottom,
                contentPadding: widget.options!.contentPadding,
                padding: widget.options!.padding,
                decoration: widget.options!.decoration,
                confirm: widget.options!.confirm,
                cancel: widget.options!.cancel,
              ),
        wheelOptions: widget.wheelOptions,
        width: widget.width,
        height: widget.height,
        itemWidth: widget.itemWidth);
  }
}

class DatePickerUnit {
  const DatePickerUnit.none()
      : year = null,
        month = null,
        builder = null,
        day = null;

  const DatePickerUnit.yd(
      {this.builder, this.year = 'Y', this.month = 'M', this.day = 'D'});

  const DatePickerUnit.ym({
    this.builder,
    this.year = 'Y',
    this.month = 'M',
  }) : day = null;

  const DatePickerUnit.md({
    this.builder,
    this.month = 'M',
    this.day = 'D',
  }) : year = null;

  final String? year;
  final String? month;
  final String? day;

  final DatePickerUnitBuilder? builder;

  int getLength() {
    int i = 0;
    if (year != null) i += 1;
    if (month != null) i += 1;
    if (day != null) i += 1;
    return i;
  }
}
