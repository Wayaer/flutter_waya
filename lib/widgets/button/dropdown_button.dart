import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 弹出组件每个item样式
typedef IndexedBuilder = Widget Function(int index);

/// 初始化 默认显示的Widget
typedef DefaultBuilder = Widget Function(int? index);

/// DropdownMenuButton(
///   defaultBuilder: (int index) {
///     return Universal(
///         padding:
///         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
///         decoration: BoxDecoration(
///             color: Colors.blue,
///             borderRadius: BorderRadius.circular(4)),
///         direction: Axis.horizontal,
///         mainAxisSize: MainAxisSize.min,
///         children: <Widget>[
///           BasisText(index == null ? '请选择' : _colors[index],
///               color: Colors.white),
///           const Icon(Icons.arrow_drop_down, color: Colors.white),
///         ]);
///   },
///   decoration: BoxDecoration(
///       color: Colors.blue, borderRadius: BorderRadius.circular(4)),
///   margin: const EdgeInsets.only(top: 2),
///   itemCount: _colors.length,
///   onChanged: (int index) {
///     showToast('点击了${_colors[index]}');
///   },
///   itemBuilder: (int index) =>
///       Container(
///           alignment: Alignment.center,
///           padding: const EdgeInsets.symmetric(vertical: 6),
///           decoration: const BoxDecoration(
///               border: Border(bottom: BorderSide(color: Colors.white))),
///           child: BasisText(_colors[index])),
/// )

class DropdownMenuButton extends StatefulWidget {
  const DropdownMenuButton(
      {Key? key,
      required this.defaultBuilder,
      required this.itemBuilder,
      required this.itemCount,
      this.onChanged,
      this.backgroundColor = Colors.black12,
      this.onTap,
      this.decoration,
      this.margin,
      this.padding})
      : super(key: key);

  final DefaultBuilder defaultBuilder;

  final int itemCount;
  final IndexedBuilder itemBuilder;
  final ValueCallback<int>? onChanged;

  /// menu 属性
  final Color backgroundColor;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// button 点击事件
  final GestureTapCallback? onTap;

  @override
  _DropdownMenuButtonState createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState extends State<DropdownMenuButton> {
  int? selectIndex;

  @override
  Widget build(BuildContext context) =>
      Universal(onTap: showItem, child: widget.defaultBuilder(selectIndex));

  void showItem() {
    if (widget.onTap != null) widget.onTap!.call();
    final Offset offset = context.getWidgetLocalToGlobal;
    final Size size = context.size!;
    showDialogPopup<dynamic>(
        widget: PopupBase(
      top: offset.dy + size.height,
      left: offset.dx,
      child: Universal(
          width: size.width,
          margin: widget.margin,
          padding: widget.padding,
          decoration: widget.decoration,
          color: widget.backgroundColor,
          mainAxisSize: MainAxisSize.min,
          constraints: const BoxConstraints(maxHeight: 100),
          children: widget.itemCount.generate((int index) => Universal(
              onTap: () => tapItem(index), child: widget.itemBuilder(index)))),
    ));
  }

  void tapItem(int index) {
    maybePop();
    if (widget.onChanged != null) widget.onChanged!(index);
    selectIndex = index;
    setState(() {});
  }
}
