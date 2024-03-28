import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef PINTextFieldBuilder = Widget Function(
    PINTextFieldBuilderConfig builderConfig);

typedef PINTextFieldTextBuilder = Widget? Function(String text);

class PINTextField extends StatefulWidget {
  const PINTextField(
      {super.key,
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
      this.pinDecoration,
      this.hasFocusPinDecoration,
      this.textStyle,
      this.textBuilder,
      this.boxSize = const Size(40, 40),
      this.spaces = const [],
      this.inputLimitFormatter = TextInputLimitFormatter.text,
      this.builder,
      this.controller});

  final TextEditingController? controller;

  final GestureTapCallback? onTap;

  /// 输入内容监听
  final ValueCallback<String>? onChanged;

  /// 输入完成后回调
  final ValueCallback<String>? onDone;

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

  /// 整个组件装饰器
  final Decoration? decoration;

  /// 默认输入框装饰器
  final Decoration? pinDecoration;

  /// 有文字后的输入框装饰器
  final Decoration? hasFocusPinDecoration;

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

class _PINTextFieldState extends State<PINTextField> {
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
  void didUpdateWidget(covariant PINTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spaces != widget.spaces ||
        oldWidget.focusNode != widget.focusNode) initialize();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Universal(
          isStack: true,
          height: widget.boxSize.height,
          decoration: widget.decoration,
          onTap: onTap,
          children: [
            SizedBox(height: widget.boxSize.height, child: pinTextInput),
            ValueListenableBuilder(
                valueListenable: text,
                builder: (_, String text, __) => boxRow(text)),
          ]);

  Widget boxRow(String text) {
    final List<Widget> box = [];
    List<String> texts = text.trim().split('');
    (widget.maxLength - texts.length).generate((index) => texts.add(''));
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
          decoration:
              hasFocus ? widget.pinDecoration : widget.hasFocusPinDecoration,
          alignment: Alignment.center,
          child: widget.textBuilder?.call(text) ??
              BText(text, style: widget.textStyle)));
    }
    final List<Widget> children = [];
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
        context.requestFocus(focusNode);
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

    final builderConfig = PINTextFieldBuilderConfig(
        focusNode: focusNode,
        controller: widget.controller,
        decoration: inputDecoration,
        autofocus: widget.autoFocus,
        onChanged: onChanged,
        keyboardType: widget.inputLimitFormatter.toKeyboardType(),
        maxLength: widget.maxLength,
        style: const TextStyle(color: Colors.transparent),
        inputFormatters: widget.inputLimitFormatter
            .toTextInputFormatter()
            .addAllT(widget.inputFormatter ?? []));

    return widget.builder?.call(builderConfig) ??
        TextField(
            controller: builderConfig.controller,
            focusNode: builderConfig.focusNode,
            decoration: builderConfig.decoration,
            autofocus: builderConfig.autofocus,
            obscureText: builderConfig.obscureText,
            maxLines: builderConfig.maxLines,
            minLines: builderConfig.minLines,
            onChanged: builderConfig.onChanged,
            keyboardType: builderConfig.keyboardType,
            maxLength: builderConfig.maxLength,
            style: builderConfig.style,
            showCursor: builderConfig.showCursor,
            inputFormatters: builderConfig.inputFormatters);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    text.dispose();
  }
}

class PINTextFieldBuilderConfig {
  PINTextFieldBuilderConfig(
      {required this.focusNode,
      required this.decoration,
      this.autofocus = true,
      this.maxLines = 1,
      this.minLines = 1,
      required this.onChanged,
      required this.maxLength,
      required this.style,
      this.showCursor = false,
      this.obscureText = false,
      this.controller,
      required this.inputFormatters,
      required this.keyboardType});

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

  /// [TextField] 输入内容变化
  final ValueChanged<String> onChanged;

  /// [TextField] 最大输入长度
  final int maxLength;

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
