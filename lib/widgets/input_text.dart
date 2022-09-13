import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum BorderType { outline, underline, none, horizontal, vertical }

enum InputTextType {
  /// 字母和数字
  lettersNumbers,

  /// 密码 字母和数字和.
  password,

  /// 整数
  number,

  /// 文本
  text,

  /// 小数
  decimal,

  /// 字母
  letter,

  /// 中文
  chinese,

  /// 邮箱
  email,

  /// 手机号码
  mobilePhone,

  /// 电话号码
  phone,

  /// 身份证
  idCard,

  /// ip地址
  ip,

  /// 正数
  positive,

  /// 负数
  negative,
}

/// 按回车时调用 先调用此方法  然后调用onSubmitted方法
/// final VoidCallback? onEditingComplete;
/// final ValueCallback<String>? onSubmitted;
///
///
/// 键盘颜色  Brightness.dark 深色模式
/// final Brightness keyboardAppearance;
///
///
/// 长按输入的文字时，true显示系统的粘贴板  false不显示
/// final bool enableInteractiveSelection;
///
///
///     设置键盘上enter键的显示内容
///     textInputAction: TextInputAction.search, /// 搜索
///     textInputAction: TextInputAction.none,/// 默认回车符号
///     textInputAction: TextInputAction.done,/// 安卓显示 回车符号
///     textInputAction: TextInputAction.go,/// 开始
///     textInputAction: TextInputAction.next,/// 下一步
///     textInputAction: TextInputAction.send,/// 发送
///     textInputAction: TextInputAction.continueAction,/// android  不支持
///     textInputAction: TextInputAction.emergencyCall,/// android  不支持
///     textInputAction: TextInputAction.newline,/// 安卓显示 回车符号
///     textInputAction: TextInputAction.route,/// android  不支持
///     textInputAction: TextInputAction.join,/// android  不支持
///     textInputAction: TextInputAction.previous,/// 安卓显示 回车符号
///     textInputAction: TextInputAction.unspecified,/// 安卓显示 回车符号
/// final TextInputAction? textInputAction,
///
///
///   输入时键盘的英文都是大写
///   textCapitalization: TextCapitalization.characters,
///   键盘英文默认显示小写
///   textCapitalization:  TextCapitalization.none,
///   在输入每个句子的第一个字母时，键盘大写形式，输入后续字母时键盘小写形式
///   textCapitalization:  TextCapitalization.sentences,
///   在输入每个单词的第一个字母时，键盘大写形式，输入其他字母时键盘小写形式
///   textCapitalization: TextCapitalization.words,
/// final TextCapitalization textCapitalization;
///
/// 自定义数字显示 指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
/// final InputCounterWidgetBuilder? buildCounter;

/// [Widget] 挂件
class WidgetPendant extends StatelessWidget {
  const WidgetPendant({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.extraPrefix,
    this.extraSuffix,
    this.prefix,
    this.suffix,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.borderType = BorderType.none,
    this.borderColor = Colors.black87,
    this.borderWidth = 1,
    this.borderStyle = BorderStyle.solid,
    this.fillColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.margin,
    this.padding,
    this.extraMargin,
    this.extraPadding,
  });

  final Widget child;

  /// [child] 头部和尾部挂件
  final Widget? header;
  final Widget? footer;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? extraPrefix;
  final Widget? extraSuffix;
  final EdgeInsetsGeometry? extraMargin;
  final EdgeInsetsGeometry? extraPadding;

  /// [child] 左右两遍的挂件 在[Border] 外部
  final Widget? prefix;
  final Widget? suffix;

  /// 仅作用于 [child]
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// [child] 与 [extraPrefix]、[extraSuffix] 对齐方式
  final CrossAxisAlignment crossAxisAlignment;

  /// [child] 边框类型
  final BorderType borderType;

  /// [child] 边框颜色
  final Color borderColor;

  /// [child] 边框宽度
  final double borderWidth;

  /// [child] 边框样式
  final BorderStyle borderStyle;

  /// [child] 填充色
  final Color? fillColor;

  /// [child] 圆角
  final BorderRadiusGeometry? borderRadius;

  /// [child] 阴影
  final List<BoxShadow>? boxShadow;

  /// [child] 渐变色
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    Widget current = currentWidget;
    if (extraPrefix != null || extraSuffix != null) {
      final List<Widget> row = <Widget>[];
      if (extraPrefix != null) row.add(extraPrefix!);
      row.add(Expanded(child: current));
      if (extraSuffix != null) row.add(extraSuffix!);
      current = Universal(
          direction: Axis.horizontal,
          margin: extraMargin,
          padding: extraPadding,
          crossAxisAlignment: crossAxisAlignment,
          children: row);
    } else if (extraPadding != null || extraMargin != null) {
      current =
          Universal(margin: extraMargin, padding: extraPadding, child: current);
    }

    if (header != null || footer != null) {
      final List<Widget> children = <Widget>[];
      if (header != null) children.add(header!);
      children.add(current);
      if (footer != null) children.add(footer!);
      current = Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return current;
  }

  Widget get currentWidget {
    Widget current = child;
    Border? border;
    switch (borderType) {
      case BorderType.outline:
        border = Border.all(
            color: borderColor, width: borderWidth, style: borderStyle);
        break;
      case BorderType.underline:
        assert(borderRadius == null,
            'The current borderType, borderRadius must be null');
        border = Border(
            bottom: BorderSide(
                color: borderColor, width: borderWidth, style: borderStyle));
        break;
      case BorderType.none:
        break;
      case BorderType.horizontal:
        assert(borderRadius == null,
            'The current borderType, borderRadius must be null');
        border = Border.symmetric(
            horizontal: BorderSide(
                color: borderColor, width: borderWidth, style: borderStyle));
        break;
      case BorderType.vertical:
        assert(borderRadius == null,
            'The current borderType, borderRadius must be null');
        border = Border.symmetric(
            vertical: BorderSide(
                color: borderColor, width: borderWidth, style: borderStyle));
        break;
    }

    Decoration? decoration;
    if (border != null ||
        fillColor != null ||
        borderRadius != null ||
        boxShadow != null ||
        gradient != null) {
      decoration = BoxDecoration(
          border: border,
          color: fillColor,
          borderRadius: borderRadius,
          gradient: gradient,
          boxShadow: boxShadow);
    }
    final List<Widget> children = <Widget>[current.expandedNull];
    if (prefix != null) children.insert(0, prefix!);
    if (suffix != null) children.add(suffix!);
    current = Universal(
        decoration: decoration,
        margin: margin,
        padding: padding,
        direction: Axis.horizontal,
        child: children.length > 1 ? null : current,
        children: children.length > 1 ? children : null);
    return current;
  }
}

List<TextInputFormatter> inputTextTypeToTextInputFormatter(
    InputTextType inputTextType) {
  if (inputTextType == InputTextType.text) return <TextInputFormatter>[];
  if (inputTextType == InputTextType.number) {
    return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
  }
  const Map<InputTextType, String> regExpMap = ConstConstant.regExp;
  final RegExp regExp = RegExp(regExpMap[inputTextType]!);
  return <TextInputFormatter>[FilteringTextInputFormatter(regExp, allow: true)];
}

/// 数字输入的精确控制
class NumberLimitFormatter extends TextInputFormatter {
  NumberLimitFormatter(this.numberLength, this.decimalLength);

  final int decimalLength;
  final int numberLength;

  RegExp exp = RegExp(ConstConstant.regExp[InputTextType.decimal]!);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const String pointer = '.';

    /// 输入完全删除
    if (newValue.text.isEmpty) return const TextEditingValue();

    /// 只允许输入数字和小数点
    if (!exp.hasMatch(newValue.text)) return oldValue;

    /// 包含小数点的情况
    if (newValue.text.contains(pointer)) {
      /// 精度为0，即不含小数
      if (decimalLength == 0) return oldValue;

      /// 包含多个小数
      if (newValue.text.indexOf(pointer) !=
          newValue.text.lastIndexOf(pointer)) {
        return oldValue;
      }

      final String input = newValue.text;
      final int index = input.indexOf(pointer);

      /// 小数点前位数
      final int lengthBeforePointer = input.substring(0, index).length;

      /// 整数部分大于约定长度
      if (lengthBeforePointer > numberLength) return oldValue;

      /// 小数点后位数
      final int lengthAfterPointer =
          input.substring(index, input.length).length - 1;

      /// 小数位大于精度
      if (lengthAfterPointer > decimalLength) return oldValue;
    } else if (

        /// 以点开头
        newValue.text.startsWith(pointer) ||

            /// 如果第1位为0，并且长度大于1，排除00,01-09所有非法输入
            (newValue.text.startsWith('0') && newValue.text.length > 1) ||

            /// 如果整数长度超过约定长度
            newValue.text.length > numberLength) {
      return oldValue;
    }
    return newValue;
  }
}

typedef TextFieldBuilder = Widget Function(
    TextEditingController? controller,
    InputDecoration decoration,
    ValueChanged<String> onChanged,
    FocusNode focusNode,
    bool showCursor,
    TextStyle style,
    List<TextInputFormatter> textInputFormatter);

class PinBox extends StatefulWidget {
  const PinBox({
    super.key,
    this.onTap,
    this.onChanged,
    this.onDone,
    this.inputTextType = InputTextType.text,
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
  });

  final GestureTapCallback? onTap;

  /// 输入内容监听
  final ValueCallback<String>? onChanged;

  /// 输入完成后回调
  final ValueCallback<String>? onDone;

  /// 输入文字类型限制
  final InputTextType inputTextType;

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

  /// 输入框内容限制
  final List<TextInputFormatter>? inputFormatter;

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

  final TextInputType? keyboardType;

  final TextFieldBuilder? textFieldBuilder;

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
        counter: null,
        counterText: '',
        border: InputBorder.none);
    void onChanged(String value) {
      widget.onChanged?.call(value);
      text.value = value;
      if (value.length == widget.maxLength) {
        widget.onDone?.call(value);
      }
    }

    final inputFormatter = widget.inputFormatter ??
        inputTextTypeToTextInputFormatter(widget.inputTextType);
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
