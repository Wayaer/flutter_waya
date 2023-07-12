part of 'picker.dart';

typedef PickerListLinkageEntryBuilder = Widget Function(bool selected);

class PickerListLinkageEntry<T> {
  const PickerListLinkageEntry(
      {required this.value, required this.child, this.children = const []});

  final PickerListLinkageEntryBuilder child;

  final T value;

  final List<PickerListLinkageEntry<T>> children;
}

extension ExtensionMultiListLinkagePicker on MultiListLinkagePicker {
  Future<List<int>?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<List<int>?>(options: options);
}

/// 多列选择 联动
class MultiListLinkagePicker<T> extends PickerStatefulWidget<List<int>> {
  const MultiListLinkagePicker({
    super.key,
    super.options,
    super.height = kPickerDefaultHeight,
    super.width = double.infinity,
    super.itemWidth,
    required this.items,
    this.value = const [],
    this.isScrollable = true,
    this.onChanged,
    this.onValueChanged,
  }) : super(wheelOptions: null);

  /// 要渲染的数据
  final List<PickerListLinkageEntry<T>> items;

  /// 是否可以横向滚动
  /// [isScrollable]==true 使用[SingleChildScrollView]创建
  /// [isScrollable]==false 使用[Row] 创建每个滚动，居中显示
  final bool isScrollable;

  /// 初始默认显示的位置
  final List<int> value;

  /// onChanged
  final PickerPositionIndexChanged? onChanged;

  /// onValueChanged
  final PickerPositionValueChanged<T>? onValueChanged;

  @override
  State<MultiListLinkagePicker<T>> createState() =>
      _MultiListLinkagePickerState<T>();
}

class _MultiListLinkagePickerState<T>
    extends ExtendedState<MultiListLinkagePicker<T>> {
  List<PickerListLinkageEntry<T>> items = [];
  List<int?> position = [null];
  int currentListLength = 0;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  void didUpdateWidget(covariant MultiListLinkagePicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    items = widget.items;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log(!widget.isScrollable);
    final multiList = Universal(
        width: widget.width,
        height: widget.height,
        direction: Axis.horizontal,
        isScroll: widget.isScrollable,
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildList.builder((item) => Universal(
            expanded: !widget.isScrollable && widget.itemWidth == null,
            width: widget.isScrollable && widget.itemWidth == null
                ? kPickerDefaultItemWidth
                : widget.itemWidth,
            child: item)));
    if (widget.options == null) return multiList;
    return PickerSubject<List<int>>(
        options: widget.options!,
        confirmTap: () => getPosition,
        child: multiList);
  }

  String lastPosition = '';

  List<int> get getPosition {
    List<int> list = [];
    for (var element in position) {
      if (element == null) continue;
      list.add(element);
    }
    return list;
  }

  void onChanged() {
    if (getPosition.toString() != lastPosition) {
      lastPosition = getPosition.toString();
      widget.onChanged?.call(getPosition);
      if (widget.onValueChanged != null) {
        List<T> value = [];
        List<PickerListLinkageEntry> resultList = items;
        getPosition.builder((index) {
          if (index < resultList.length) {
            value.add(resultList[index].value);
            resultList = resultList[index].children;
          }
        });
        widget.onValueChanged!(value);
      }
    }
  }

  List<Widget> get buildList {
    List<Widget> list = [];
    List<PickerListLinkageEntry> currentEntry = items;
    position.length.generate((index) {
      var itemPosition = position[index] ?? 0;
      if (currentEntry.isNotEmpty) {
        list.add(scrollList(
            positionIndex: index,
            positionValue: itemPosition,
            list: currentEntry));
        if (itemPosition < currentEntry.length) {
          currentEntry = currentEntry[itemPosition].children;
        } else {
          currentEntry = currentEntry.last.children;
        }
      }
    });
    return list;
  }

  Widget scrollList(
          {required List<PickerListLinkageEntry> list,
          required int positionIndex,
          required int? positionValue}) =>
      ScrollList.builder(
          itemCount: list.length,
          itemBuilder: (_, int index) {
            bool selected = position[positionIndex] == index;
            return Universal(
                onTap: () {
                  if (selected) return;
                  position[positionIndex] = index;
                  if (positionIndex < position.length - 1) {
                    position.removeRange(positionIndex + 1, position.length);
                    position.add(null);
                  } else {
                    position.add(null);
                  }
                  setState(() {});
                  onChanged();
                },
                child: index > list.length
                    ? list.last.child(selected)
                    : list[index].child(selected));
          });
}
