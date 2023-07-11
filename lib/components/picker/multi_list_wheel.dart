part of 'picker.dart';

class PickerEntry {
  const PickerEntry({required this.itemCount, required this.itemBuilder});

  /// 渲染子组件
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
}

extension ExtensionMultiListWheelPicker on MultiListWheelPicker {
  Future<List<int>?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<List<int>?>(options: options);
}

/// 多列滚轮选择 不联动
class MultiListWheelPicker extends PickerStatelessWidget<List<int>> {
  MultiListWheelPicker({
    super.key,
    required this.entry,
    this.isScrollable = false,
    this.onChanged,
    this.height = kPickerDefaultHeight,
    this.width = double.infinity,
    this.value = const [],
    this.itemWidth = kPickerDefaultWidth,
    super.options = const PickerOptions<List<int>>(),
    WheelOptions? wheelOptions,
  }) : super(wheelOptions: wheelOptions ?? GlobalOptions().wheelOptions);

  /// 要渲染的数据
  final List<PickerEntry> entry;

  /// 初始默认显示的位置
  final List<int> value;

  /// 是否可以横向滚动
  /// [isScrollable]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [isScrollable]==false 使用[Row] 创建每个滚动，居中显示
  final bool isScrollable;

  /// onIndexChanged
  final PickerPositionIndexChanged? onChanged;

  /// height
  final double height;

  /// width
  final double width;

  /// wheel width
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    List<int> position = [...value];
    String lastPosition = '';
    void onChanged() {
      if (position.length > entry.length) {
        position.removeRange(entry.length, position.length);
      }
      if (position.toString() != lastPosition) {
        lastPosition = position.toString();
        this.onChanged?.call(position);
      }
    }

    final multi = Universal(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        width: width,
        isScroll: isScrollable,
        height: height,
        children: entry.builderEntry((item) {
          if (entry.length > position.length) position.add(0);
          final value = item.value;
          final location = item.key;
          ListWheel buildWheel([FixedExtentScrollController? controller]) =>
              _PickerListWheel(
                  controller: controller,
                  options: wheelOptions,
                  itemBuilder: value.itemBuilder,
                  itemCount: value.itemCount,
                  onChanged: (int index) {
                    position[location] = index;
                  },
                  onScrollEnd: (_) => onChanged());

          return Universal(
              width: itemWidth,
              expanded: !isScrollable,
              child: this.value.isEmpty
                  ? buildWheel()
                  : ListWheelState(
                      initialItem: position[item.key],
                      builder: buildWheel,
                      count: value.itemCount));
        }));

    if (options == null) return multi;
    return PickerSubject<List<int>>(
        options: options!, child: multi, confirmTap: () => position);
  }
}

class PickerLinkageEntry<T> {
  const PickerLinkageEntry(
      {required this.value, required this.child, this.children = const []});

  final Widget child;

  final T value;

  final List<PickerLinkageEntry<T>> children;

  Map<String, dynamic> toMap() => {
        'child': child.runtimeType.toString(),
        'value': value.toString(),
        'children': children.builder((item) => item.toMap()),
      };
}

extension ExtensionMultiListWheelLinkagePicker on MultiListWheelLinkagePicker {
  Future<List<int>?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<List<int>?>(options: options);
}

/// 多列滚轮选择 联动
class MultiListWheelLinkagePicker<T> extends PickerStatefulWidget<List<int>> {
  MultiListWheelLinkagePicker({
    super.key,
    required this.entry,
    this.value = const [],
    this.isScrollable = false,
    this.onChanged,
    this.onValueChanged,
    this.height = kPickerDefaultHeight,
    this.width = double.infinity,
    this.itemWidth = kPickerDefaultWidth,
    super.options = const PickerOptions<List<int>>(),
    WheelOptions? wheelOptions,
  }) : super(wheelOptions: wheelOptions ?? GlobalOptions().wheelOptions);

  /// 要渲染的数据
  final List<PickerLinkageEntry<T>> entry;

  /// 是否可以横向滚动
  /// [isScrollable]==true 使用[SingleChildScrollView]创建,[wheelOptions]中的[itemWidth]控制宽度，如果不设置则为[kPickerDefaultWidth]
  /// [isScrollable]==false 使用[Row] 创建每个滚动，居中显示
  final bool isScrollable;

  /// 初始默认显示的位置
  final List<int> value;

  /// onChanged
  final PickerPositionIndexChanged? onChanged;

  /// onValueChanged
  final PickerPositionValueChanged<T>? onValueChanged;

  /// height
  final double height;

  /// width
  final double width;

  /// wheel item width
  final double itemWidth;

  @override
  State<MultiListWheelLinkagePicker<T>> createState() =>
      _MultiListWheelLinkagePickerState<T>();
}

class _MultiListWheelLinkagePickerState<T>
    extends ExtendedState<MultiListWheelLinkagePicker<T>> {
  List<PickerLinkageEntry<T>> entry = [];
  List<int> position = [];

  @override
  void initState() {
    super.initState();
    position = [...widget.value];
    entry = [...widget.entry];
  }

  int calculateDimension(List<PickerLinkageEntry> list) {
    int highest = 0;
    if (list.isEmpty) return highest;
    for (var element in list) {
      int dimension = calculateDimension(element.children);
      if (dimension > highest) {
        highest = dimension;
      }
    }
    return highest + 1;
  }

  List<Widget> get buildWheels {
    final dimension = calculateDimension(entry);
    List<Widget> list = [];
    List<PickerLinkageEntry> entryList = entry;
    if (dimension > position.length) {
      (dimension - position.length).generate((index) => position.add(0));
    }
    for (int i = 0; i < position.length; i++) {
      int e = position[i];
      if (entryList.isNotEmpty) {
        if (e >= entryList.length) {
          e = entryList.length - 1;
        }
        position[i] = e;
        list.add(listStateWheel(list: entryList, location: i));
        entryList = entryList[e].children;
      } else {
        break;
      }
    }
    return list;
  }

  @override
  void didUpdateWidget(covariant MultiListWheelLinkagePicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    entry = widget.entry;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final multi = Universal(
        width: widget.width,
        height: widget.height,
        direction: Axis.horizontal,
        isScroll: widget.isScrollable,
        children: buildWheels.builder((item) => Universal(
            expanded: !widget.isScrollable,
            width: widget.itemWidth,
            child: Center(child: item))));
    if (widget.options == null) return multi;
    return PickerSubject<List<int>>(
        options: widget.options!,
        confirmTap: () => calculatePosition,
        child: multi);
  }

  String lastPosition = '';

  List<int> get calculatePosition {
    final p = [...position];
    List<PickerLinkageEntry> resultList = entry;
    p.removeWhere((element) {
      if (resultList.isEmpty) {
        return true;
      } else {
        resultList = (element >= resultList.length
                ? resultList.last
                : resultList[element])
            .children;
        return false;
      }
    });
    return p;
  }

  void onChanged() {
    final p = calculatePosition;
    if (p.toString() != lastPosition) {
      lastPosition = p.toString();
      widget.onChanged?.call(p);
      if (widget.onValueChanged != null) {
        List<T> value = [];
        List<PickerLinkageEntry> resultList = entry;
        p.builder((index) {
          if (index < resultList.length) {
            value.add(resultList[index].value);
            resultList = resultList[index].children;
          }
        });
        widget.onValueChanged!(value);
      }
    }
  }

  Widget listStateWheel(
          {required List<PickerLinkageEntry> list, required int location}) =>
      ListWheelState(
          count: list.length,
          initialItem: position[location],
          builder: (_) => _PickerListWheel(
              controller: _,
              onChanged: (int index) {
                position[location] = index;
              },
              onScrollEnd: (int index) async {
                final builder =
                    list.length > index && list[index].children.isNotEmpty;
                if (location != position.length - 1 || builder) {
                  await 50.milliseconds.delayed();
                  setState(() {});
                }
                onChanged();
              },
              itemBuilder: (_, int index) => Center(
                  child: index > list.length
                      ? list.last.child
                      : list[index].child),
              itemCount: list.length,
              options: widget.wheelOptions));
}
