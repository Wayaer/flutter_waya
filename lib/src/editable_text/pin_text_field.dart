import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/extended_state.dart';

typedef PINTextFieldBuilder = Widget Function(PINTextFieldBuilderConfig config);

typedef PINTextFieldTextBuilder = Widget? Function(String text);

typedef PINTextFieldValueChanged = void Function(String text);

class PINTextField extends StatefulWidget {
  const PINTextField({
    super.key,
    required this.controller,
    this.onTap,
    this.onChanged,
    this.onDone,
    this.autoFocus = true,
    this.needKeyBoard = true,
    this.obscureText = false,
    this.maxLength = 4,
    this.inputFormatter,
    this.focusNode,
    this.decoration,
    this.focusedDecoration,
    this.textStyle,
    this.textBuilder,
    this.boxSize = const Size(40, 40),
    this.spaces = const [],
    this.inputLimitFormatter = TextInputLimitFormatter.text,
    this.builder,
  });

  final TextEditingController controller;

  final GestureTapCallback? onTap;

  /// 输入内容监听
  final PINTextFieldValueChanged? onChanged;

  /// 输入完成后回调
  final PINTextFieldValueChanged? onDone;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 是否隐藏文本
  final bool obscureText;

  /// 是否需要自动弹出键盘
  final bool needKeyBoard;

  /// 输入框数量
  final int maxLength;

  /// 输入框焦点管理
  final FocusNode? focusNode;

  /// 默认输入框装饰器
  final Decoration? decoration;

  /// 有文字后的输入框装饰器
  final Decoration? focusedDecoration;

  /// 内文字样式
  final TextStyle? textStyle;

  /// text builder
  final PINTextFieldTextBuilder? textBuilder;

  /// box 方框的大小
  final Size boxSize;

  /// box 中间添加 东西
  final List<Widget?> spaces;

  /// 限制文本输入类型 包括键盘类型
  final TextInputLimitFormatter inputLimitFormatter;

  /// 额外配置输入框内容限制
  final List<TextInputFormatter>? inputFormatter;

  /// 构建 [TextField]
  final PINTextFieldBuilder? builder;

  @override
  State<PINTextField> createState() => _PINTextFieldState();
}

class _PINTextFieldState extends ExtendedState<PINTextField> {
  late FocusNode focusNode;
  List<Widget?> spaces = <Widget?>[];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    spaces = widget.spaces;
    focusNode = widget.focusNode ?? FocusNode();
    widget.controller.addListener(listener);
  }

  void listener() {
    if (widget.controller.text.length == widget.maxLength) {
      widget.onDone?.call(widget.controller.text);
    }
  }

  @override
  void didUpdateWidget(covariant PINTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spaces != widget.spaces ||
        oldWidget.focusNode != widget.focusNode) initialize();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.boxSize.height,
        child: Stack(children: [
          SizedBox(height: widget.boxSize.height, child: pinTextInput),
          AnimatedBuilder(
              animation: Listenable.merge([
                focusNode,
                widget.controller,
              ]),
              builder: (BuildContext context, Widget? child) =>
                  buildRow(widget.controller.text)),
        ]));
  }

  Widget buildRow(String text) {
    final List<Widget> box = [];
    List<String> texts = text.trim().split('');
    List.generate((widget.maxLength - texts.length), (index) => texts.add(''));
    bool hasFocus = false;
    for (int i = 0; i < widget.maxLength; i++) {
      if (texts[i].isEmpty) hasFocus = true;
      String text = texts[i];
      if (text.trim().isNotEmpty && widget.obscureText) {
        text = '*';
      }
      box.add(Container(
          height: widget.boxSize.height,
          width: widget.boxSize.width,
          decoration: hasFocus ? widget.decoration : widget.focusedDecoration,
          alignment: Alignment.center,
          child: widget.textBuilder?.call(text) ??
              Text(text, style: widget.textStyle)));
    }
    final List<Widget> children = [];
    if (spaces.isNotEmpty) {
      List.generate((box.length + 1), (int index) {
        if (index < spaces.length) {
          final Widget? space = spaces[index];
          if (space != null) children.add(space);
        }
        if (index < box.length) children.add(box[index]);
      });
    }
    return IgnorePointer(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: spaces.isNotEmpty ? children : box),
    );
  }

  void onTap() {
    if (widget.needKeyBoard) {
      // if (focusNode.hasFocus) focusNode.unfocus();
      // Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
      // });
    }
    widget.onTap?.call();
  }

  Widget get pinTextInput {
    const inputDecoration = InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        border: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none);

    final config = PINTextFieldBuilderConfig(
        focusNode: focusNode,
        controller: widget.controller,
        decoration: inputDecoration,
        autofocus: widget.autoFocus,
        keyboardType: widget.inputLimitFormatter.toKeyboardType(),
        style: const TextStyle(color: Colors.transparent),
        inputFormatters: widget.inputLimitFormatter.toTextInputFormatter()
          ..addAll([
            LengthLimitingTextInputFormatter(widget.maxLength),
            if (widget.inputFormatter != null) ...widget.inputFormatter!,
          ]));
    return widget.builder?.call(config) ??
        TextField(
            controller: config.controller,
            focusNode: config.focusNode,
            decoration: config.decoration,
            autofocus: config.autofocus,
            obscureText: config.obscureText,
            maxLines: config.maxLines,
            minLines: config.minLines,
            keyboardType: config.keyboardType,
            style: config.style,
            showCursor: config.showCursor,
            contextMenuBuilder: (context, editableTextState) =>
                const SizedBox(),
            inputFormatters: config.inputFormatters);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listener);
    if (widget.focusNode == null) focusNode.dispose();
  }
}

class PINTextFieldBuilderConfig {
  PINTextFieldBuilderConfig({
    required this.focusNode,
    required this.decoration,
    required this.style,
    required this.inputFormatters,
    required this.keyboardType,
    this.autofocus = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.showCursor = false,
    this.obscureText = false,
    this.controller,
  });

  /// [TextField] 焦点管理
  final FocusNode focusNode;

  /// [TextField] 装饰器
  final InputDecoration decoration;

  /// [TextField] 自动获取焦点
  final bool autofocus;

  /// [TextField] 自动获取焦点
  final bool obscureText;

  /// [TextField] 最大行数 默认 1
  final int maxLines;

  /// [TextField] 最小行数 默认 1
  final int minLines;

  /// [TextField] 输入文字样式
  final TextStyle style;

  /// [TextField] 是否显示光标 默认不显示
  final bool showCursor;

  /// [TextField] 输入文本格式显示
  final List<TextInputFormatter> inputFormatters;

  /// [TextField] 键盘弹出类型
  final TextInputType keyboardType;

  /// [TextField] controller
  final TextEditingController? controller;
}
