part of 'picker.dart';

extension ExtensionSingleListWheelPicker on SingleListWheelPicker {
  Future<int?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<int?>(options: options);
}

typedef SingleListWheelPickerChanged = void Function(int index);

/// 单列滚轮选择
class SingleListWheelPicker extends PickerStatelessWidget<int> {
  SingleListWheelPicker({
    super.key,
    super.options,
    super.wheelOptions,
    super.height,
    super.width,
    int initialIndex = 0,
    required this.itemCount,
    required this.itemBuilder,
    FixedExtentScrollController? controller,
    this.onChanged,
  }) : controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex);

  /// 渲染子组件
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// 控制器
  final FixedExtentScrollController? controller;

  /// onChanged
  final SingleListWheelPickerChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    int? index;
    final single = SizedBox(
        width: width,
        height: height,
        child: _PickerListWheel(
            onChanged: (int i) {
              if (index == i) return;
              index = i;
            },
            onScrollEnd: onChanged,
            options: wheelOptions,
            controller: controller,
            itemBuilder: itemBuilder,
            itemCount: itemCount));
    if (options == null) return single;
    return PickerSubject<int>(
        options: options!,
        child: single,
        confirmTap: () => controller?.selectedItem ?? 0);
  }
}
