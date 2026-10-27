import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/src/input/editable_text/text_field.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// PIN 输入框底层 TextField 的构建器，通过配置自定义输入框。
typedef FlPINTextFieldBuilder = Widget Function(FlPINTextFieldBuilderConfig config);

/// 根据单个方框内的字符构建显示内容。
typedef FlPINTextFieldTextBuilder = Widget? Function(String text);

/// PIN 文本变化回调，参数为当前完整文本。
typedef FlPINTextFieldValueChanged = void Function(String text);

/// PIN 验证码输入框，按位数拆分为独立方框显示。
class FlPINTextField extends StatefulWidget {
  const FlPINTextField({
    super.key,
    required this.controller,
    this.onTap,
    this.onChanged,
    this.onDone,
    this.autoFocus = true,
    this.obscureText = false,
    this.maxLength = 4,
    this.inputFormatter,
    this.decoration,
    this.focusedDecoration,
    this.textStyle,
    this.textBuilder,
    this.boxSize = const Size(40, 40),
    this.spaces = const [],
    this.inputLimitFormatter = FlTextInputLimitFormatter.text,
    this.builder,
  });

  /// 文本控制器，用于读写当前 PIN 内容。
  final TextEditingController controller;

  /// 输入框点击
  final GestureTapCallback? onTap;

  /// 输入内容监听
  final FlPINTextFieldValueChanged? onChanged;

  /// 输入完成后回调
  final FlPINTextFieldValueChanged? onDone;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 是否隐藏文本，隐藏时以 * 展示，默认 false。
  final bool obscureText;

  /// 输入框数量（PIN 位数），默认 4。
  final int maxLength;

  /// 默认输入框装饰器
  final Decoration? decoration;

  /// 有文字后的输入框装饰器
  final Decoration? focusedDecoration;

  /// 内文字样式
  final TextStyle? textStyle;

  /// text builder
  final FlPINTextFieldTextBuilder? textBuilder;

  /// box 方框的大小
  final Size boxSize;

  /// 方框之间可插入的 widget，按顺序插入，默认空列表。
  final List<Widget?> spaces;

  /// 限制文本输入类型 包括键盘类型
  final FlTextInputLimitFormatter inputLimitFormatter;

  /// 额外配置输入框内容限制
  final List<TextInputFormatter>? inputFormatter;

  /// 构建 [TextField]
  final FlPINTextFieldBuilder? builder;

  @override
  State<FlPINTextField> createState() => _PINTextFieldState();
}

class _PINTextFieldState extends FlExtendedState<FlPINTextField> {
  String lastText = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  void listener() {
    final text = widget.controller.text;
    final int textLength = text.characters.length;
    final int lastTextLength = lastText.characters.length;
    if (text != lastText) {
      widget.onChanged?.call(text);
    }
    if (textLength >= widget.maxLength && lastTextLength < widget.maxLength) {
      widget.onDone?.call(text);
    }
    lastText = text;
  }

  @override
  void didUpdateWidget(covariant FlPINTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(listener);
      widget.controller.addListener(listener);
      lastText = widget.controller.text;
    } else if (oldWidget.maxLength != widget.maxLength) {
      lastText = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.boxSize.height,
      child: Stack(
        children: [
          SizedBox(
            width: widget.maxLength * widget.boxSize.width,
            height: widget.boxSize.height,
            child: pinTextInput,
          ),
          AnimatedBuilder(
            animation: widget.controller,
            builder: (BuildContext context, Widget? child) => buildRow(widget.controller.text),
          ),
        ],
      ),
    );
  }

  Widget buildRow(String text) {
    final List<Widget> box = [];
    List<String> texts = text.characters.toList();
    bool hasFocus = false;
    for (int i = 0; i < widget.maxLength; i++) {
      String text = '';
      if (i >= texts.length) {
        text = '';
      } else {
        text = texts[i];
      }
      if (text.isEmpty) hasFocus = true;
      if (text.trim().isNotEmpty && widget.obscureText) {
        text = '*';
      }
      box.add(
        Container(
          height: widget.boxSize.height,
          width: widget.boxSize.width,
          decoration: hasFocus ? widget.decoration : widget.focusedDecoration,
          alignment: Alignment.center,
          child: widget.textBuilder?.call(text) ?? Text(text, style: widget.textStyle),
        ),
      );
    }
    final List<Widget> children = [];
    final spaces = widget.spaces;
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: spaces.isNotEmpty ? children : box),
    );
  }

  Widget get pinTextInput {
    final inputDecoration = const InputDecoration(contentPadding: EdgeInsets.zero, isDense: true).noneBorder;
    final config = FlPINTextFieldBuilderConfig(
      controller: widget.controller,
      decoration: inputDecoration,
      autofocus: widget.autoFocus,
      keyboardType: widget.inputLimitFormatter.toKeyboardType(),
      style: const TextStyle(color: Colors.transparent),
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputLimitFormatter.toTextInputFormatter()
        ..addAll([
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          LengthLimitingTextInputFormatter(widget.maxLength),
          if (widget.inputFormatter != null) ...widget.inputFormatter!,
        ]),
      contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) => const SizedBox(),
    );
    return widget.builder?.call(config) ??
        TextField(
          controller: config.controller,
          decoration: config.decoration,
          autofocus: config.autofocus,
          obscureText: config.obscureText,
          maxLines: config.maxLines,
          minLines: config.minLines,
          keyboardType: config.keyboardType,
          style: config.style,
          onTap: config.onTap,
          showCursor: config.showCursor,
          enableInteractiveSelection: config.enableInteractiveSelection,
          contextMenuBuilder: config.contextMenuBuilder,
          inputFormatters: config.inputFormatters,
        );
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }
}

/// FlPINTextField 内部 TextField 的构建配置。
class FlPINTextFieldBuilderConfig {
  const FlPINTextFieldBuilderConfig({
    required this.decoration,
    required this.style,
    required this.inputFormatters,
    required this.keyboardType,
    required this.contextMenuBuilder,
    required this.controller,
    this.enableInteractiveSelection = false,
    this.autofocus = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.showCursor = false,
    this.obscureText = false,
    this.onTap,
  });

  /// [TextField] 装饰器
  final InputDecoration decoration;

  /// [TextField] 自动获取焦点
  final bool autofocus;

  /// [TextField] 是否隐藏输入内容，默认 false
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
  final TextEditingController controller;

  /// [TextField] 是否启用选择器
  final bool enableInteractiveSelection;

  /// [TextField] 选择器ToolBar
  final EditableTextContextMenuBuilder contextMenuBuilder;

  /// 输入框点击
  final GestureTapCallback? onTap;
}
