import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef PinBoxTextFieldBuilder = Widget Function(
    TextEditingController? controller,
    InputDecoration decoration,
    ValueChanged<String> onChanged,
    FocusNode focusNode,
    bool showCursor,
    TextStyle style,
    List<TextInputFormatter>? textInputFormatter);

class PinBox extends StatefulWidget {
  const PinBox({
    super.key,
    this.onTap,
    this.onChanged,
    this.onDone,
    this.autoFocus = true,
    this.enabled = true,
    this.disposeController = true,
    this.needKeyBoard = true,
    this.controller,
    this.maxLength = 4,
    this.inputFormatter,
    this.focusNode,
    this.decoration,
    this.pinDecoration,
    this.hasFocusPinDecoration,
    this.textStyle,
    this.boxSize = const Size(40, 40),
    this.spaces = const <Widget>[],
    this.keyboardType,
    this.textFieldBuilder,
    this.inputLimitFormatter = TextInputLimitFormatter.text,
  });

  final GestureTapCallback? onTap;

  /// 输入内容监听
  final ValueCallback<String>? onChanged;

  /// 输入完成后回调
  final ValueCallback<String>? onDone;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 开启输入
  final bool enabled;

  /// [dispose] 时自动销户 controller
  final bool disposeController;

  /// 是否需要自动弹出键盘
  final bool needKeyBoard;

  /// 输入框控制器
  final TextEditingController? controller;

  /// 输入框数量
  final int maxLength;

  /// 输入框焦点管理
  final FocusNode? focusNode;

  /// 整个组件装饰器
  final Decoration? decoration;

  /// 默认输入框装饰器
  final Decoration? pinDecoration;

  /// 有文字后的输入框装饰器
  final Decoration? hasFocusPinDecoration;

  /// box 内文字样式
  final TextStyle? textStyle;

  /// box 方框的大小
  final Size boxSize;

  /// box 中间添加 东西
  final List<Widget?> spaces;

  /// 键盘弹出类型  限制输入类型
  final TextInputType? keyboardType;

  /// 限制文本输入类型
  final TextInputLimitFormatter inputLimitFormatter;

  /// 输入框内容限制
  final List<TextInputFormatter>? inputFormatter;

  final PinBoxTextFieldBuilder? textFieldBuilder;

  @override
  State<PinBox> createState() => _PinBoxState();
}

class _PinBoxState extends State<PinBox> {
  late FocusNode focusNode;
  List<Widget?> spaces = <Widget?>[];

  ValueNotifier<String> text = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    spaces = widget.spaces;
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant PinBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spaces != widget.spaces ||
        oldWidget.focusNode != widget.focusNode) {
      initialize();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Universal(
          isStack: true,
          height: widget.boxSize.height,
          decoration: widget.decoration,
          onTap: onTap,
          children: <Widget>[
            SizedBox(height: widget.boxSize.height, child: pinTextInput),
            ValueListenableBuilder(
                valueListenable: text,
                builder: (_, String text, __) => boxRow(text)),
          ]);

  Widget boxRow(String text) {
    final List<Widget> box = <Widget>[];
    List<String> texts = text.trim().split('');
    (widget.maxLength - texts.length).generate((index) => texts.add(''));
    bool hasFocus = false;
    for (int i = 0; i < widget.maxLength; i++) {
      if (texts[i].isEmpty) hasFocus = true;
      box.add(Container(
          height: widget.boxSize.height,
          width: widget.boxSize.width,
          decoration:
              hasFocus ? widget.pinDecoration : widget.hasFocusPinDecoration,
          alignment: Alignment.center,
          child: BText(texts[i], style: widget.textStyle)));
    }
    final List<Widget> children = <Widget>[];
    if (spaces.isNotEmpty) {
      (box.length + 1).generate((int index) {
        if (index < spaces.length) {
          final Widget? space = spaces[index];
          if (space != null) children.add(space);
        }
        if (index < box.length) children.add(box[index]);
      });
    }
    return Universal(
        direction: Axis.horizontal,
        onTap: onTap,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: spaces.isNotEmpty ? children : box);
  }

  void onTap() {
    if (widget.needKeyBoard) {
      if (focusNode.hasFocus) focusNode.unfocus();
      100.milliseconds.delayed(() {
        context.focusNode(focusNode);
      });
    }
    widget.onTap?.call();
  }

  Widget get pinTextInput {
    const inputDecoration = InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: false,
        counterText: '',
        border: InputBorder.none);
    void onChanged(String value) {
      widget.onChanged?.call(value);
      text.value = value;
      if (value.length == widget.maxLength) {
        widget.onDone?.call(value);
      }
    }

    final inputFormatter = ExtendedTextField.limitFormatterToTextInputFormatter(
            widget.inputLimitFormatter)
        .addAllT(widget.inputFormatter ?? []);
    TextStyle style = const BTextStyle(color: Colors.transparent);
    return widget.textFieldBuilder?.call(widget.controller, inputDecoration,
            onChanged, focusNode, false, style, inputFormatter) ??
        TextField(
            focusNode: focusNode,
            decoration: inputDecoration,
            autofocus: widget.autoFocus,
            maxLines: 1,
            onChanged: onChanged,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            controller: widget.controller,
            style: style,
            showCursor: false,
            inputFormatters: inputFormatter,
            textAlign: TextAlign.center);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    if (widget.disposeController) widget.controller?.dispose();
    text.dispose();
  }
}
