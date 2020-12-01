import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/enums.dart';

class PinBox extends StatefulWidget {
  const PinBox(
      {Key key,
      this.inputTextType,
      this.autoFocus = true,
      this.controller,
      this.maxLength = 4,
      this.inputFormatter,
      this.boxSpacing = 1,
      this.pinDecoration,
      this.hasFocusPinDecoration,
      this.pinTextStyle,
      this.decoration,
      this.boxSize = const Size(50, 50),
      this.width,
      this.focusNode,
      this.onChanged,
      this.onDone})
      : super(key: key);

  ///  输入内容监听
  final ValueChanged<String> onChanged;

  ///  输入完成后回调
  final ValueChanged<String> onDone;

  ///  输入文字类型限制
  final InputTextType inputTextType;

  ///  是否自动获取焦点
  final bool autoFocus;

  ///  输入框控制器
  final TextEditingController controller;

  ///  输入框数量
  final int maxLength;

  ///  输入框内容限制
  final List<TextInputFormatter> inputFormatter;

  ///  box 左右间距 设置 [width]后此参数失效
  final double boxSpacing;

  ///  输入框焦点管理
  final FocusNode focusNode;

  ///  整默认输入框装饰器
  final Decoration pinDecoration;

  ///  整个组件装饰器
  final Decoration decoration;

  ///  获取焦点后的输入框装饰器
  final Decoration hasFocusPinDecoration;

  ///  box 内文字样式
  final TextStyle pinTextStyle;

  ///  box 方框的大小
  final Size boxSize;

  ///  设置此参数后 [boxSize] 的宽度将失效
  final double width;

  @override
  _PinBoxState createState() => _PinBoxState();
}

class _PinBoxState extends State<PinBox> {
  FocusNode focusNode;
  TextEditingController controller;
  List<String> texts = <String>[];
  Size size;

  @override
  void initState() {
    super.initState();
    size = widget.boxSize;
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final double width = size.width * widget.maxLength +
        widget.boxSpacing * (widget.maxLength - 1);
    return Universal(
      isStack: true,
      width: widget.width ?? width,
      height: size.height,
      decoration: widget.decoration,
      onTap: () => Tools.focusNode(context, focusNode: focusNode),
      children: <Widget>[
        Container(alignment: Alignment.center, child: pinTextInput()),
        boxRow(),
      ],
    );
  }

  Widget boxRow() {
    final List<Widget> children = <Widget>[];
    if (texts.length < widget.maxLength) {
      final int n = widget.maxLength - texts.length;
      for (int i = 0; i < n; i++) texts.add('');
    }
    bool hasFocus = false;
    for (int i = 0; i < widget.maxLength; i++) {
      if (texts[i].isEmpty) hasFocus = true;
      children.add(Container(
        height: size.height,
        width: size.width,
        decoration:
            hasFocus ? widget.pinDecoration : widget.hasFocusPinDecoration,
        alignment: Alignment.center,
        child: Text(
          texts[i],
          style: widget.pinTextStyle ?? TextStyle(color: getColors(white)),
        ),
      ));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);
  }

  Widget pinTextInput() {
    return InputField(
      focusNode: focusNode,
      contentPadding: EdgeInsets.zero,
      isDense: true,
      inputTextType: widget.inputTextType ?? InputTextType.text,
      autoFocus: widget.autoFocus ?? true,
      counter: null,
      maxLines: 1,
      fillColor: getColors(transparent),
      filled: true,
      controller: controller,
      cursorColor: Colors.transparent,
      cursorWidth: 0,
      counterText: '',
      counterStyle: const TextStyle(color: Colors.transparent),
      obscureText: false,
      maxLength: widget.maxLength,
      inputStyle: const TextStyle(color: Colors.transparent),
      labelStyle: const TextStyle(color: Colors.transparent),
      hintStyle: const TextStyle(color: Colors.transparent),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      inputFormatter: widget.inputFormatter,
      textAlign: TextAlign.center,
      helperStyle: const TextStyle(color: Colors.transparent),
      onChanged: (String text) {
        texts = text.trim().split('');
        if (widget.onChanged != null) widget.onChanged(text);
        if (widget.onDone != null && text.length == widget.maxLength)
          widget.onDone(text);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}
