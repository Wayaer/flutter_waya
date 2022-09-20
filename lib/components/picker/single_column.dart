part of 'picker.dart';

/// 单列选择
class SingleColumnPicker extends StatelessWidget {
  SingleColumnPicker({
    super.key,
    int initialIndex = 0,
    required this.itemCount,
    required this.itemBuilder,
    PickerOptions<int>? options,
    this.wheelOptions,
    FixedExtentScrollController? controller,
  })  : controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex),
        options = options ?? PickerOptions<int>();

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

/// list 单多项选择器
class SingleListPicker extends StatelessWidget {
  SingleListPicker({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    PickerOptions<List<int>>? options,
  }) : options = options ?? PickerOptions<List<int>>();

  /// 头部和背景色配置
  final PickerOptions<List<int>> options;

  /// 渲染子组件
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) => PickerSubject<List<int>>(
      options: options,
      child: _SingleListPickerContent(
          itemBuilder: itemBuilder, itemCount: itemCount),
      sureTap: () {
        return [0];
      });
}

class _SingleListPickerContent extends StatefulWidget {
  const _SingleListPickerContent(
      {required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<_SingleListPickerContent> createState() =>
      _SingleListPickerContentState();
}

class _SingleListPickerContentState extends State<_SingleListPickerContent> {
  @override
  Widget build(BuildContext context) {
    return ScrollList.builder(
        itemBuilder: widget.itemBuilder, itemCount: widget.itemCount);
  }
}
