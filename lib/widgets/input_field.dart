import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    int? maxLines,
    TextAlign? textAlign,
    bool? obscureText,
    bool? autoFocus,
    bool? enabled,
    bool? filled,
    bool? enableInteractiveSelection,
    TextInputAction? textInputAction,
    TextDirection? textDirection,
    Color? cursorColor,
    Radius? cursorRadius,
    double? cursorWidth,
    Brightness? keyboardAppearance,
    TextCapitalization? textCapitalization,
    FloatingLabelBehavior? floatingLabelBehavior,
    bool? readOnly,
    CrossAxisAlignment? crossAxisAlignment,
    this.icon,
    this.toolbarOptions,
    this.controller,
    this.inputDecoration,
    this.onSubmitted,
    this.inputStyle,
    this.keyboardType,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.inputFormatter,
    this.fillColor,
    this.inputTextType,
    this.isDense,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.defaultBorder,
    this.labelText,
    this.labelStyle,
    this.prefixText,
    this.prefixIcon,
    this.prefix,
    this.prefixStyle,
    this.suffixIcon,
    this.suffixText,
    this.suffix,
    this.suffixStyle,
    this.errorBorder,
    this.focusedErrorBorder,
    this.onTap,
    this.errorStyle,
    this.errorText,
    this.errorMaxLines,
    this.helperText,
    this.helperStyle,
    this.focusNode,
    this.header,
    this.footer,
    this.hintMaxLines,
    this.counterText,
    this.counterStyle,
    this.counter,
    this.buildCounter,
    this.onEditingComplete,
    this.extraSuffix,
    this.extraPrefix,
  })  : obscureText = obscureText ?? false,
        readOnly = readOnly ?? false,
        filled = filled ?? false,
        crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        floatingLabelBehavior =
            floatingLabelBehavior ?? FloatingLabelBehavior.always,

        ///  键盘大小写的显示 Only supports text keyboards  但是好像不起作用？
        ///  characters 默认为每个字符使用大写键盘
        ///  sentence 默认为每个句子的第一个字母使用大写键盘
        ///  word 默认为每个单词的第一个字母使用大写键盘。
        ///  none 默认使用小写
        textCapitalization = textCapitalization ?? TextCapitalization.none,

        ///  长按输入的文字时，true显示系统的粘贴板  false不显示
        enableInteractiveSelection = enableInteractiveSelection ?? true,

        ///  自定义数字显示   指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
        ///  光标颜色
        cursorColor = cursorColor ?? ConstColors.black70,

        ///  光标圆角
        cursorRadius = cursorRadius ?? const Radius.circular(1),

        ///  光标宽度
        cursorWidth = cursorWidth ?? 2,

        ///  键盘外观  仅ios有效
        keyboardAppearance = keyboardAppearance ?? Brightness.dark,

        ///       设置键盘上enter键的显示内容
        ///       textInputAction: TextInputAction.search, ///  搜索
        ///       textInputAction: TextInputAction.none,///  默认回车符号
        ///       textInputAction: TextInputAction.done,///  安卓显示 回车符号
        ///       textInputAction: TextInputAction.go,///  开始
        ///       textInputAction: TextInputAction.next,///  下一步
        ///       textInputAction: TextInputAction.send,///  发送
        ///       textInputAction: TextInputAction.continueAction,///  android  不支持
        ///       textInputAction: TextInputAction.emergencyCall,///  android  不支持
        ///       textInputAction: TextInputAction.newline,///  安卓显示 回车符号
        ///       textInputAction: TextInputAction.route,///  android  不支持
        ///       textInputAction: TextInputAction.join,///  android  不支持
        ///       textInputAction: TextInputAction.previous,///  安卓显示 回车符号
        ///       textInputAction: TextInputAction.unspecified,///  安卓显示 回车符号
        textInputAction = textInputAction ?? TextInputAction.done,
        autoFocus = autoFocus ?? false,
        maxLines = maxLines ?? 1,

        ///  从左边输入  光标在左边
        ///  从右边输入  光标在右边
        ///      textDirection = textDirection ?? TextDirection.rtl,
        textDirection = textDirection ?? TextDirection.ltr,
        enabled = enabled ?? true,
        textAlign = textAlign ?? TextAlign.left,
        super(key: key);
  final TextEditingController? controller;

  final List<TextInputFormatter>? inputFormatter;

  ///  工具栏 cut, copy, paste,
  final ToolbarOptions? toolbarOptions;

  ///  最大长度
  final int? maxLength;
  final TextDirection textDirection;
  final int maxLines;

  ///  文本是否可修改  当这个设置为true时，文本不能被修改
  final bool readOnly;

  ///  对齐方式
  final TextAlign textAlign;
  final int? minLines;
  final TextInputType? keyboardType;
  final InputDecoration? inputDecoration;

  ///  光标颜色
  final Color cursorColor;
  final InputTextType? inputTextType;

  ///  点击事件
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueCallback<String>? onChanged;
  final ValueCallback<String>? onSubmitted;

  ///  显示在输入框右下方
  final String? counterText;
  final TextStyle? counterStyle;
  final Widget? counter;

  /// 是否自动获取焦点  跳转到该页面后 光标自动显示到该输入框  键盘弹起
  final bool autoFocus;

  /// 是否自动获取焦点  跳转到该页面后 光标自动显示到该输入框  键盘弹起
  final bool obscureText;

  /// label自动上浮
  final FloatingLabelBehavior floatingLabelBehavior;

  final FocusNode? focusNode;
  final TextStyle? inputStyle;

  ///  输入框左边下划线外面
  final Widget? icon;

  ///  输入框左边
  final Widget? prefixIcon;

  ///  头部
  final Widget? header;

  /// 底部
  final Widget? footer;

  ///  前缀
  final String? prefixText;
  final Widget? prefix;
  final TextStyle? prefixStyle;

  ///  输入框右边
  final Widget? suffixIcon;

  ///  后缀
  final String? suffixText;
  final Widget? suffix;
  final TextStyle? suffixStyle;

  ///  显示在输入框左下角的文字提示
  final TextStyle? errorStyle;
  final String? errorText;
  final int? errorMaxLines;

  ///  显示在输入框下划线下面的提示语，提示使用
  final String? helperText;
  final TextStyle? helperStyle;
  final String? labelText;

  ///  显示在输入框内的提示语，一旦输入框获取焦点就字体缩小并上移到输入上方，作为提示使用
  final TextStyle? labelStyle;

  /// final bool labelFloating;

  ///  默认为true，表示labelText是否上浮，true上浮，false表示获取焦点后labelText消失
  final bool? isDense;

  ///  是否开启紧密
  final bool filled;

  ///  输入框颜色
  final bool enabled;

  ///  开始输入
  final InputBorder? disabledBorder;

  ///  不能输入状态框
  final InputBorder? enabledBorder;

  ///  开启输入状态框
  final InputBorder? errorBorder;

  ///  失去焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
  final InputBorder? focusedErrorBorder;

  ///  获取焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
  final InputBorder? focusedBorder;

  ///  获取焦点输入框
  final InputBorder? defaultBorder;

  ///  跟输入框同水平
  final Widget? extraSuffix;

  ///  跟输入框同水平
  final Widget? extraPrefix;

  ///  以上都未设置时 默认输入框

  final Color? fillColor;
  final TextStyle? hintStyle;
  final String? hintText;
  final int? hintMaxLines;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction textInputAction;
  final double cursorWidth;
  final Radius cursorRadius;
  final Brightness keyboardAppearance;

  ///  长按输入的文字时，true显示系统的粘贴板  false不显示
  final bool enableInteractiveSelection;

  ///  控制键盘大小写切换的   试过了 但是好像没有效果？？
  ///  textCapitalization: TextCapitalization.characters,  ///  输入时键盘的英文都是大写
  ///  textCapitalization: TextCapitalization.none,  ///  键盘英文默认显示小写
  ///  textCapitalization: TextCapitalization.sentences, ///  在输入每个句子的第一个字母时，键盘大写形式，输入后续字母时键盘小写形式
  ///  textCapitalization: TextCapitalization.words,///  在输入每个单词的第一个字母时，键盘大写形式，输入其他字母时键盘小写形式
  final TextCapitalization textCapitalization;

  ///  自定义数字显示   指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
  final InputCounterWidgetBuilder? buildCounter;
  final CrossAxisAlignment crossAxisAlignment;

  ///  解决切换后台 再切换前台输入框为null
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///    WidgetsBinding.instance.addObserver(this);
  ///    controller = widget.controller ?? TextEditingController();
  ///    setController(widget.value);
  ///  }
  ///
  ///  setController(String value) {
  ///    if (value.length > 0) {
  ///      controller.text = value;
  ///      解决光标左移问题
  ///      controller.selection = TextSelection.fromPosition(TextPosition(offset: value.length));
  ///    }
  ///  }
  ///
  ///  @override
  ///  void didChangeAppLifecycleState(AppLifecycleState state) {
  ///    super.didChangeAppLifecycleState(state);
  ///    switch (state) {
  ///      case AppLifecycleState.inactive: ///  处于这种状态的应用程序应该假设它们可能在任何时候暂停。前台
  ///        break;
  ///      case AppLifecycleState.paused: ///  应用程序不可见，后台  切换后台
  ///        break;
  ///      case AppLifecycleState.resumed: ///  应用程序可见，前台  从后台切换前台
  ///        setController(text);
  ///        break;
  ///      case AppLifecycleState.detached: ///  申请将暂时暂停
  ///        break;
  ///    }
  ///  }
  ///
  ///  @override
  ///  void dispose() {
  ///    WidgetsBinding.instance.removeObserver(this);
  ///    super.dispose();
  ///  }

  @override
  Widget build(BuildContext context) {
    Widget child = textField;
    if (extraPrefix != null || extraSuffix != null) {
      final List<Widget> row = <Widget>[];
      if (extraPrefix != null) row.add(extraPrefix!);
      row.add(Expanded(child: child));
      if (extraSuffix != null) row.add(extraSuffix!);
      child = Row(crossAxisAlignment: crossAxisAlignment, children: row);
    }
    if (header != null || footer != null) {
      final List<Widget> children = <Widget>[];
      if (header != null) children.add(header!);
      children.add(child);
      if (footer != null) children.add(footer!);
      child = Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return child;
  }

  Widget get textField => TextField(
        /// 长按输入的文字时，true显示系统的粘贴板  false不显示
        enableInteractiveSelection: enableInteractiveSelection,

        /// 自定义数字显示   指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
        buildCounter: buildCounter,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        keyboardAppearance: keyboardAppearance,
        textDirection: textDirection,
        textCapitalization: textCapitalization,
        textAlign: textAlign,
        focusNode: focusNode,
        autofocus: autoFocus,
        textInputAction: textInputAction,
        inputFormatters: inputFormatter ?? inputType,
        cursorColor: cursorColor,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style:
            const BasisTextStyle(color: ConstColors.black50).merge(inputStyle),
        controller: controller,
        decoration: inputDecoration ??
            InputDecoration(
              /// 显示在输入框前面的图标，在文字和下划线前面
              icon: icon,

              /// 输入框光标前面的图标和文字
              prefixIcon: prefixIcon,

              /// 显示在输入框内，光标前面的图标，注意icon是在输入框外
              prefixText: prefixText,

              /// 显示在输入框内，光标前面的文字   获得焦点后显示
              prefixStyle: prefixStyle,

              /// 显示在输入框内，光标前面的指定图片或其他Widget   获取焦点后显示。注意prefix不能与prefixIcon prefixText同时指定
              prefix: prefix,

              /// 输入框光标后面的图标和文字
              suffixIcon: suffixIcon,

              /// 显示在输入框内，光标文字后面，输入框最后面的图标
              /// text无点击事件
              suffixText: suffixText,

              /// 显示在输入框内，输入框最后面的文字    但是在suffixIcon之前。 注意suffixText不能与suffix共存
              suffixStyle: suffixStyle,

              /// 显示在输入框内，最后面的指定图片或其他Widget
              suffix: suffix,

              /// 显示在输入的下划线外右下角的文字提示
              counterText: counterText,

              /// 显示在输入的下划线外右下角的文字提示,会覆盖maxLength的右下角显示的字数限制。
              counterStyle: counterStyle,

              /// 显示在输入的下划线外右下角的提示,可以是任何Widget ，counterText与counter只能存在一个
              counter: counter,

              ///  输入框的文字提示
              labelText: labelText,

              /// 显示在输入框内的提示语，一旦输入框获取焦点就字体缩小并上移到输入上方，作为提示使用
              labelStyle: labelStyle,

              ///  hasFloatingPlaceholder: labelFloating,
              floatingLabelBehavior: floatingLabelBehavior,

              /// 默认为true，表示labelText是否上浮，true上浮，false表示获取焦点后labelText消失
              helperText: helperText,

              /// 显示在输入框下划线下面的提示语，提示使用
              helperStyle: helperStyle,

              hintText: hintText,

              /// 显示在输入框内的提示信息，当输入框为空时显示，一旦开始输入内容就消失
              hintStyle:
                  const BasisTextStyle(fontSize: 16, color: ConstColors.black30)
                      .merge(hintStyle),
              hintMaxLines: hintMaxLines ?? 1,

              /// 提示语的做多显示行数，超过行数显示...

              ///  错误提示相关
              errorText: errorText,

              /// 在输入框下方的提示语，通常用于错误提示，比如密码错误 用户名错误等  同时输入框的下划线修改为了红色
              errorStyle: errorStyle,
              errorMaxLines: errorMaxLines,

              /// 获取焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
              /// 输入框内文字 密集显示
              isDense: isDense ?? false,

              /// 改变输入框是否为密集型，默认为false，修改为true时，图标及间距会变小  行间距减小
              /// 内部padding
              contentPadding: contentPadding ?? EdgeInsets.zero,

              /// 输入框的padding  对内部的文字有效
              /// 背景色
              fillColor: fillColor,

              /// 输入框内部的填充颜色  需filled=true
              filled: filled,

              /// 是否启用输入框
              enabled: enabled,

              /// 做多显示的行数  ，超过行数显示...
              errorBorder: errorBorder,

              /// 失去焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
              focusedErrorBorder: focusedErrorBorder,

              /// 输入框禁用时，下划线的样式.如果设置了errorText，则此属性无效
              disabledBorder: disabledBorder,

              /// 输入框启用时，下划线的样式
              enabledBorder: enabledBorder,

              /// 获取焦点时，下划线的样式
              focusedBorder: focusedBorder,

              /// 级别最低的border，没有设置其他border时显示的border
              border: defaultBorder,

              ///            border: InputBorder.none,
            ),
        onChanged: onChanged,
        onTap: onTap,
        toolbarOptions: toolbarOptions,
        onSubmitted: onSubmitted,
        enabled: enabled,
        readOnly: readOnly,

        /// 按回车时调用 先调用此方法  然后调用onSubmitted方法
        onEditingComplete: onEditingComplete,
      );

  List<TextInputFormatter> get inputType {
    if (inputTextType == null || inputTextType == InputTextType.text)
      return <TextInputFormatter>[];
    if (inputTextType == InputTextType.number)
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    const Map<InputTextType, String> regExpMap = ConstConstant.regExp;
    final RegExp regExp = RegExp(regExpMap[inputTextType]!);
    return <TextInputFormatter>[
      FilteringTextInputFormatter(regExp, allow: true)
    ];
  }
}

class SearchBox extends Universal {
  SearchBox({
    Key? key,

    /// icon 样式
    Color? color,
    IconData icon = ConstIcon.search,
    double size = 15,

    /// [Universal]
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    Decoration? decoration,
    double? height,
    double? width,
    String? heroTag,

    /// [InputField]
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(6),
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    Color? cursorColor,
    Color? fillColor,
    bool? autoFocus,
    FocusNode? focusNode,

    /// Border
    LineType? lineType,
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    Color? focusedBorderColor,
    Color? enabledBorderColor,

    /// 文本
    String? searchText,
    String? hintText,
    TextStyle? searchStyle,
    TextStyle? hintStyle,
    TextStyle? inputStyle,

    /// 前缀和后缀
    GestureTapCallback? searchTap,
    Widget? search,
    Widget? suffixIcon,
    Widget? extraSuffix,
    Widget? prefix,
    Widget? prefixIcon,
    Widget? extraPrefix,
  }) : super(
            key: key,
            decoration: decoration,
            margin: margin,
            height: height,
            width: width,
            alignment: alignment,
            padding: padding,
            heroTag: heroTag,
            child: InputField(
                controller: controller,
                isDense: true,
                focusNode: focusNode,
                fillColor: fillColor,
                filled: true,
                focusedBorder: inputBorder(
                    color: focusedBorderColor ??
                        enabledBorderColor ??
                        ConstColors.blue,
                    borderRadius: borderRadius,
                    borderSide: borderSide,
                    lineType: lineType),
                enabledBorder: inputBorder(
                    color: enabledBorderColor ?? ConstColors.white50,
                    borderRadius: borderRadius,
                    borderSide: borderSide,
                    lineType: lineType),
                inputStyle: inputStyle,
                contentPadding: contentPadding,
                hintStyle: hintStyle,
                hintText: hintText,
                cursorColor:
                    cursorColor ?? enabledBorderColor ?? ConstColors.blue,
                prefix: prefix,
                prefixIcon: prefixIcon ?? Icon(icon, size: size, color: color),
                extraPrefix: extraPrefix,
                onChanged: onChanged,
                autoFocus: autoFocus,
                suffix: search ??
                    SimpleButton(
                        text: searchText ?? 'search',
                        onTap: searchTap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        textStyle:
                            const BasisTextStyle(color: ConstColors.white)
                                .merge(searchStyle)),
                suffixIcon: suffixIcon,
                extraSuffix: extraSuffix,
                enableInteractiveSelection: true));

  static InputBorder inputBorder(
      {required Color color,
      LineType? lineType,
      BorderRadius? borderRadius,
      BorderSide? borderSide}) {
    if (lineType == LineType.outline) {
      return OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          borderSide: borderSide ?? BorderSide(width: 0.5, color: color));
    } else if (lineType == LineType.underline) {
      return UnderlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          borderSide: borderSide ?? BorderSide(width: 0.5, color: color));
    } else {
      return InputBorder.none;
    }
  }
}

///  数字输入的精确控制
class NumberLimitFormatter extends TextInputFormatter {
  NumberLimitFormatter(this.numberLength, this.decimalLength);

  final int decimalLength;
  final int numberLength;

  RegExp exp = RegExp(ConstConstant.regExp[InputTextType.decimal]!);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const String POINTER = '.';

    ///  输入完全删除
    if (newValue.text.isEmpty) return const TextEditingValue();

    ///  只允许输入数字和小数点
    if (!exp.hasMatch(newValue.text)) return oldValue;

    ///  包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///  精度为0，即不含小数
      if (decimalLength == 0) return oldValue;

      ///  包含多个小数
      if (newValue.text.indexOf(POINTER) != newValue.text.lastIndexOf(POINTER))
        return oldValue;

      final String input = newValue.text;
      final int index = input.indexOf(POINTER);

      ///  小数点前位数
      final int lengthBeforePointer = input.substring(0, index).length;

      ///  整数部分大于约定长度
      if (lengthBeforePointer > numberLength) return oldValue;

      ///  小数点后位数
      final int lengthAfterPointer =
          input.substring(index, input.length).length - 1;

      ///  小数位大于精度
      if (lengthAfterPointer > decimalLength) return oldValue;
    } else if (

        /// 以点开头
        newValue.text.startsWith(POINTER) ||

            /// 如果第1位为0，并且长度大于1，排除00,01-09所有非法输入
            (newValue.text.startsWith('0') && newValue.text.length > 1) ||

            /// 如果整数长度超过约定长度
            newValue.text.length > numberLength) {
      return oldValue;
    }
    return newValue;
  }
}

class PinBox extends StatefulWidget {
  const PinBox({
    Key? key,
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
    this.onDone,
  }) : super(key: key);

  ///  输入内容监听
  final ValueCallback<String>? onChanged;

  ///  输入完成后回调
  final ValueCallback<String>? onDone;

  ///  输入文字类型限制
  final InputTextType? inputTextType;

  ///  是否自动获取焦点
  final bool? autoFocus;

  ///  输入框控制器
  final TextEditingController? controller;

  ///  输入框数量
  final int maxLength;

  ///  输入框内容限制
  final List<TextInputFormatter>? inputFormatter;

  ///  box 左右间距 设置 [width]后此参数失效
  final double boxSpacing;

  ///  输入框焦点管理
  final FocusNode? focusNode;

  ///  默认输入框装饰器
  final Decoration? pinDecoration;

  ///  整个组件装饰器
  final Decoration? decoration;

  ///  有文字后的输入框装饰器
  final Decoration? hasFocusPinDecoration;

  ///  box 内文字样式
  final TextStyle? pinTextStyle;

  ///  box 方框的大小
  final Size boxSize;

  ///  设置此参数后 [boxSize] 的宽度将失效
  final double? width;

  @override
  _PinBoxState createState() => _PinBoxState();
}

class _PinBoxState extends State<PinBox> {
  late FocusNode focusNode;
  late TextEditingController controller;
  late List<String> texts = <String>[];
  late Size size;

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
        alignment: Alignment.center,
        width: widget.width ?? width,
        height: size.height,
        decoration: widget.decoration,
        onTap: () => context.focusNode(focusNode),
        children: <Widget>[
          Container(alignment: Alignment.center, child: pinTextInput),
          boxRow()
        ]);
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
        child: BasisText(texts[i], style: widget.pinTextStyle),
      ));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);
  }

  Widget get pinTextInput => InputField(
        focusNode: focusNode,
        contentPadding: EdgeInsets.zero,
        isDense: true,
        inputTextType: widget.inputTextType ?? InputTextType.text,
        autoFocus: widget.autoFocus ?? true,
        counter: null,
        maxLines: 1,
        fillColor: ConstColors.transparent,
        filled: true,
        controller: controller,
        cursorColor: Colors.transparent,
        cursorWidth: 0,
        counterText: '',
        counterStyle: const BasisTextStyle(color: Colors.transparent),
        obscureText: false,
        maxLength: widget.maxLength,
        inputStyle: const BasisTextStyle(color: Colors.transparent),
        labelStyle: const BasisTextStyle(color: Colors.transparent),
        hintStyle: const BasisTextStyle(color: Colors.transparent),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        inputFormatter: widget.inputFormatter,
        textAlign: TextAlign.center,
        helperStyle: const BasisTextStyle(color: Colors.transparent),
        onChanged: (String text) {
          texts = text.trim().split('');
          if (widget.onChanged != null) widget.onChanged!(text);
          if (widget.onDone != null && text.length == widget.maxLength)
            widget.onDone!(text);
          setState(() {});
        },
      );

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}
