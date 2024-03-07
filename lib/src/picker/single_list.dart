part of 'picker.dart';

extension ExtensionSingleListPicker on SingleListPicker {
  Future<List<int>?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<List<int>?>(
          options: FlExtended()
              .bottomSheetOptions
              .copyWith(isScrollControlled: false)
              .merge(options));
}

/// list 单多项选择器
class SingleListPicker extends StatelessWidget {
  const SingleListPicker({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.initialIndex = const [],
    this.height = kPickerDefaultHeight,
    this.width = double.infinity,
    this.options,
    this.singleListPickerOptions = const SingleListPickerOptions(),
    this.builder,
    this.onChanged,
  });

  /// 头部和背景色配置
  final PickerOptions<List<int>>? options;

  /// 初始默认选择的位置
  final List<int> initialIndex;

  /// height
  final double height;

  /// width
  final double width;

  /// 渲染子组件
  final int itemCount;
  final SelectIndexedWidgetBuilder itemBuilder;

  /// 可选配置项
  final SingleListPickerOptions singleListPickerOptions;

  /// 自定义渲染 list
  final SelectScrollListBuilder? builder;

  /// onChanged
  final PickerPositionIndexChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    List<int> position = [];
    String lastPosition = '';
    void onChanged() {
      if (position.toString() != lastPosition) {
        lastPosition = position.toString();
        this.onChanged?.call(position);
      }
    }

    final single = SizedBox(
        width: width,
        height: height,
        child: _SingleListPickerContent(
            initialIndex: initialIndex,
            builder: builder,
            singleListPickerOptions: singleListPickerOptions,
            onChanged: (List<int> index) {
              position = index;
              onChanged();
            },
            itemBuilder: itemBuilder,
            itemCount: itemCount));
    if (options == null) return single;
    return PickerSubject<List<int>>(
        options: options!, child: single, confirmTap: () => position);
  }
}

class SingleListPickerOptions {
  const SingleListPickerOptions(
      {this.isCustomGestureTap = false, this.allowedMultipleChoice = true});

  ///
  final bool isCustomGestureTap;

  /// 允许多项选择
  final bool allowedMultipleChoice;
}

typedef SelectIndexedWidgetBuilder = Widget Function(BuildContext context,
    int index, bool isSelect, SelectIndexedChangedFunction changeFunc);

typedef SelectIndexedChangedFunction = void Function([int? index]);

typedef SelectIndexedChanged = void Function(List<int> index);

typedef SelectScrollListBuilder = Widget Function(
    int itemCount, IndexedWidgetBuilder itemBuilder);

class _SingleListPickerContent extends StatefulWidget {
  const _SingleListPickerContent(
      {required this.itemCount,
      required this.itemBuilder,
      required this.onChanged,
      required this.singleListPickerOptions,
      this.initialIndex = const [],
      this.builder});

  final int itemCount;
  final SelectIndexedWidgetBuilder itemBuilder;
  final SelectIndexedChanged onChanged;
  final SelectScrollListBuilder? builder;
  final SingleListPickerOptions singleListPickerOptions;
  final List<int> initialIndex;

  @override
  State<_SingleListPickerContent> createState() =>
      _SingleListPickerContentState();
}

class _SingleListPickerContentState extends State<_SingleListPickerContent> {
  List<int> selectIndex = [];

  void changeSelect([int? index]) {
    if (index != null) {
      if (widget.singleListPickerOptions.allowedMultipleChoice) {
        if (selectIndex.contains(index)) {
          selectIndex.remove(index);
        } else {
          selectIndex.add(index);
        }
      } else {
        selectIndex = [index];
      }
      widget.onChanged(selectIndex);
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectIndex = List.from(widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant _SingleListPickerContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectIndex = List.from(widget.initialIndex);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget itemBuilder(_, int index) {
      final entry = widget.itemBuilder(
          context, index, selectIndex.contains(index), changeSelect);
      if (widget.singleListPickerOptions.isCustomGestureTap) return entry;
      return Universal(onTap: () => changeSelect(index), child: entry);
    }

    return widget.builder?.call(widget.itemCount, itemBuilder) ??
        ScrollList.builder(
            itemBuilder: itemBuilder, itemCount: widget.itemCount);
  }
}
