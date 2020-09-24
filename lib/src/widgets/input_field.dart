import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/way.dart';

class InputField extends StatelessWidget {
  InputField({
    Key key,
    int maxLines,
    TextAlign textAlign,
    bool obscureText,
    bool autoFocus,
    bool enabled,
    bool enableInteractiveSelection,
    bool maxLengthEnforced,
    TextInputAction textInputAction,
    TextDirection textDirection,
    Color cursorColor,
    Radius cursorRadius,
    double cursorWidth,
    Brightness keyboardAppearance,
    TextCapitalization textCapitalization,
    FloatingLabelBehavior floatingLabelBehavior,
    bool readOnly,
    CrossAxisAlignment crossAxisAlignment,
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
    this.filled,
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
        crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        floatingLabelBehavior = floatingLabelBehavior ?? FloatingLabelBehavior.always,

        ///键盘大小写的显示 Only supports text keyboards  但是好像不起作用？
        ///characters 默认为每个字符使用大写键盘
        ///sentence 默认为每个句子的第一个字母使用大写键盘
        ///word 默认为每个单词的第一个字母使用大写键盘。
        ///none 默认使用小写
        textCapitalization = textCapitalization ?? TextCapitalization.none,

        ///长按输入的文字时，true显示系统的粘贴板  false不显示
        enableInteractiveSelection = enableInteractiveSelection ?? true,

        ///自定义数字显示   指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
        ///光标颜色
        cursorColor = cursorColor ?? getColors(black70),

        ///光标圆角
        cursorRadius = cursorRadius ?? const Radius.circular(1),

        ///光标宽度
        cursorWidth = cursorWidth ?? 2,

        /// 键盘外观  仅ios有效
        keyboardAppearance = keyboardAppearance ?? Brightness.dark,

        ///      默认true  超过长度后输入无效  右下角数字 显示10/10   此时onchange方法依然会调用，返回值就是限制了长度的值 超过后的输入不显示
        ///      false 超过后可继续输入  右下角数字显示，比如 23/10
        maxLengthEnforced = maxLengthEnforced ?? true,

        ///       设置键盘上enter键的显示内容
        ///       textInputAction: TextInputAction.search, ///搜索
        ///       textInputAction: TextInputAction.none,///默认回车符号
        ///       textInputAction: TextInputAction.done,///安卓显示 回车符号
        ///       textInputAction: TextInputAction.go,///开始
        ///       textInputAction: TextInputAction.next,///下一步
        ///       textInputAction: TextInputAction.send,///发送
        ///       textInputAction: TextInputAction.continueAction,///android  不支持
        ///       textInputAction: TextInputAction.emergencyCall,///android  不支持
        ///       textInputAction: TextInputAction.newline,///安卓显示 回车符号
        ///       textInputAction: TextInputAction.route,///android  不支持
        ///       textInputAction: TextInputAction.join,///android  不支持
        ///       textInputAction: TextInputAction.previous,///安卓显示 回车符号
        ///       textInputAction: TextInputAction.unspecified,///安卓显示 回车符号
        textInputAction = textInputAction ?? TextInputAction.done,
        autoFocus = autoFocus ?? false,
        maxLines = maxLines ?? 1,

        ///从左边输入  光标在左边
        ///从右边输入  光标在右边
        ///      textDirection = textDirection ?? TextDirection.rtl,
        textDirection = textDirection ?? TextDirection.ltr,
        enabled = enabled ?? true,
        textAlign = textAlign ?? TextAlign.left,
        super(key: key);
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter> inputFormatter;

  ///工具栏 cut, copy, paste,
  final ToolbarOptions toolbarOptions;

  ///最大长度
  final int maxLength;
  final TextDirection textDirection;
  final int maxLines;

  ///文本是否可修改  当这个设置为true时，文本不能被修改
  final bool readOnly;

  /// 对齐方式
  final TextAlign textAlign;
  final int minLines;
  final TextInputType keyboardType;
  final InputDecoration inputDecoration;

  ///光标颜色
  final Color cursorColor;
  final InputTextType inputTextType;

  ///点击事件
  final GestureTapCallback onTap;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;

  ///显示在输入框右下方
  final String counterText;
  final TextStyle counterStyle;
  final Widget counter;

  final bool maxLengthEnforced;

  /// ///是否自动获取焦点  跳转到该页面后 光标自动显示到该输入框  键盘弹起
  final bool autoFocus;

  /// ///是否自动获取焦点  跳转到该页面后 光标自动显示到该输入框  键盘弹起
  final bool obscureText;

  //label自动上浮
  final FloatingLabelBehavior floatingLabelBehavior;

  ///隐藏文字
  final Widget header;
  final Widget footer;
  final FocusNode focusNode;
  final TextStyle inputStyle;

  ///输入框左边下划线外面
  final Widget icon;

  ///输入框左边
  final Widget prefixIcon;

  ///前缀
  final String prefixText;
  final Widget prefix;
  final TextStyle prefixStyle;

  ///输入框右边
  final Widget suffixIcon;

  ///后缀
  final String suffixText;
  final Widget suffix;
  final TextStyle suffixStyle;

  ///显示在输入框左下角的文字提示
  final TextStyle errorStyle;
  final String errorText;
  final int errorMaxLines;

  ///显示在输入框下划线下面的提示语，提示使用
  final String helperText;
  final TextStyle helperStyle;
  final String labelText;

  ///显示在输入框内的提示语，一旦输入框获取焦点就字体缩小并上移到输入上方，作为提示使用
  final TextStyle labelStyle;

//  final bool labelFloating;

  ///默认为true，表示labelText是否上浮，true上浮，false表示获取焦点后labelText消失
  final bool isDense;

  ///是否开启紧密
  final bool filled;

  ///输入框颜色
  final bool enabled;

  ///开始输入
  final InputBorder disabledBorder;

  ///不能输入状态框
  final InputBorder enabledBorder;

  ///开启输入状态框
  final InputBorder errorBorder;

  ///失去焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
  final InputBorder focusedErrorBorder;

  ///获取焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
  final InputBorder focusedBorder;

  ///获取焦点输入框
  final InputBorder defaultBorder;

  ///跟输入框同水平
  final Widget extraSuffix;

  ///跟输入框同水平
  final Widget extraPrefix;

  ///以上都未设置时 默认输入框

  final Color fillColor;
  final TextStyle hintStyle;
  final String hintText;
  final int hintMaxLines;
  final EdgeInsetsGeometry contentPadding;
  final TextInputAction textInputAction;
  final double cursorWidth;
  final Radius cursorRadius;
  final Brightness keyboardAppearance;

  ///长按输入的文字时，true显示系统的粘贴板  false不显示
  final bool enableInteractiveSelection;

  /// 控制键盘大小写切换的   试过了 但是好像没有效果？？
  /// textCapitalization: TextCapitalization.characters,  /// 输入时键盘的英文都是大写
  /// textCapitalization: TextCapitalization.none,  ///  键盘英文默认显示小写
  /// textCapitalization: TextCapitalization.sentences, /// 在输入每个句子的第一个字母时，键盘大写形式，输入后续字母时键盘小写形式
  /// textCapitalization: TextCapitalization.words,/// 在输入每个单词的第一个字母时，键盘大写形式，输入其他字母时键盘小写形式
  final TextCapitalization textCapitalization;

  /// 自定义数字显示   指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
  final InputCounterWidgetBuilder buildCounter;
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
  ///      case AppLifecycleState.inactive: ///处于这种状态的应用程序应该假设它们可能在任何时候暂停。前台
  ///        break;
  ///      case AppLifecycleState.paused: /// 应用程序不可见，后台  切换后台
  ///        break;
  ///      case AppLifecycleState.resumed: /// 应用程序可见，前台  从后台切换前台
  ///        setController(text);
  ///        break;
  ///      case AppLifecycleState.detached: /// 申请将暂时暂停
  ///        break;
  ///    }
  ///  }
  ///
  ///  @override
  ///  void dispose() {
  ///    WidgetsBinding.instance.removeObserver(this);
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    Widget child = textField(context);
    if (extraPrefix != null || extraSuffix != null) {
      final List<Widget> row = <Widget>[];
      if (extraPrefix != null) row.add(extraPrefix);
      row.add(Expanded(child: child));
      if (extraSuffix != null) row.add(extraSuffix);
      child = Row(crossAxisAlignment: crossAxisAlignment, children: row);
    }
    if (header != null || footer != null) {
      final List<Widget> children = <Widget>[];
      if (header != null) children.add(header);
      children.add(child);
      if (footer != null) children.add(footer);
      child = Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return child;
  }

  Widget textField(BuildContext context) => TextField(
        //长按输入的文字时，true显示系统的粘贴板  false不显示
        enableInteractiveSelection: enableInteractiveSelection,
        //自定义数字显示   指定maxLength后 右下角会出现字数，flutter有默认实现  可以通过这个自定义
        buildCounter: buildCounter,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        maxLengthEnforced: maxLengthEnforced,
        keyboardAppearance: keyboardAppearance,
        textDirection: textDirection,
        textCapitalization: textCapitalization,
        textAlign: textAlign,
        focusNode: focusNode,
        autofocus: autoFocus,
        textInputAction: textInputAction,
        inputFormatters: inputFormatter ?? inputType(),
        cursorColor: cursorColor,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: inputStyle ?? WayStyles.textStyleBlack70(),
        controller: controller,
        decoration: inputDecoration ??
            InputDecoration(
              //显示在输入框前面的图标，在文字和下划线前面
              icon: icon,
              //输入框光标前面的图标和文字
              prefixIcon: prefixIcon,
              //显示在输入框内，光标前面的图标，注意icon是在输入框外
              prefixText: prefixText,
              //显示在输入框内，光标前面的文字   获得焦点后显示
              prefixStyle: prefixStyle,
              //显示在输入框内，光标前面的指定图片或其他Widget   获取焦点后显示。注意prefix不能与prefixIcon prefixText同时指定
              prefix: prefix,

              //输入框光标后面的图标和文字
              suffixIcon: suffixIcon,
              //显示在输入框内，光标文字后面，输入框最后面的图标
              //text无点击事件
              suffixText: suffixText,
              //显示在输入框内，输入框最后面的文字    但是在suffixIcon之前。 注意suffixText不能与suffix共存
              suffixStyle: suffixStyle,
              //显示在输入框内，最后面的指定图片或其他Widget
              suffix: suffix,

              // 显示在输入的下划线外右下角的文字提示
              counterText: counterText,
              //显示在输入的下划线外右下角的文字提示,会覆盖maxLength的右下角显示的字数限制。
              counterStyle: counterStyle,
              //显示在输入的下划线外右下角的提示,可以是任何Widget ，counterText与counter只能存在一个
              counter: counter,
              // 输入框的文字提示
              labelText: labelText,
              //显示在输入框内的提示语，一旦输入框获取焦点就字体缩小并上移到输入上方，作为提示使用
              labelStyle: labelStyle,
//            hasFloatingPlaceholder: labelFloating,
              floatingLabelBehavior: floatingLabelBehavior,
              //默认为true，表示labelText是否上浮，true上浮，false表示获取焦点后labelText消失
              helperText: helperText,
              //显示在输入框下划线下面的提示语，提示使用
              helperStyle: helperStyle,

              hintText: hintText,
              //显示在输入框内的提示信息，当输入框为空时显示，一旦开始输入内容就消失
              hintStyle: hintStyle ?? WayStyles.textStyleBlack30(fontSize: 16),
              hintMaxLines: hintMaxLines ?? 1,
              //提示语的做多显示行数，超过行数显示...

              // 错误提示相关
              errorText: errorText,
              //在输入框下方的提示语，通常用于错误提示，比如密码错误 用户名错误等  同时输入框的下划线修改为了红色
              errorStyle: errorStyle,
              errorMaxLines: errorMaxLines,
              //做多显示的行数  ，超过行数显示...
              errorBorder: errorBorder,
              //失去焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
              focusedErrorBorder: focusedErrorBorder,
              //获取焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
              //输入框内文字 密集显示
              isDense: isDense ?? false,
              //改变输入框是否为密集型，默认为false，修改为true时，图标及间距会变小  行间距减小
              //内部padding
              contentPadding: contentPadding ?? EdgeInsets.zero,
              //输入框的padding  对内部的文字有效
              //背景色
              fillColor: fillColor,
              //输入框内部的填充颜色  需filled=true
              filled: filled,
              //输入框禁用时，下划线的样式.如果设置了errorText，则此属性无效
              disabledBorder: disabledBorder,
              //输入框启用时，下划线的样式
              enabledBorder: enabledBorder,
              //是否启用输入框
              enabled: enabled,
              //获取焦点时，下划线的样式
              focusedBorder: focusedBorder,
              //级别最低的border，没有设置其他border时显示的border
              border: defaultBorder,
//            border: InputBorder.none,
            ),
        onChanged: onChanged,
        onTap: onTap,
        toolbarOptions: toolbarOptions,
        onSubmitted: onSubmitted,
        enabled: enabled,
        readOnly: readOnly,
        //按回车时调用 先调用此方法  然后调用onSubmitted方法
        onEditingComplete: onEditingComplete,
      );

  List<TextInputFormatter> inputType() {
    switch (inputTextType) {
      case InputTextType.number:
        return <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly];
      case InputTextType.password:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpPassword), allow: true)
        ]; //密码常见类型
      case InputTextType.lettersNumbers:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpLettersNumbers), allow: true)
        ]; //字母和数字
      case InputTextType.decimal:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpDecimal), allow: true)
        ]; //只允许输入小数
      case InputTextType.letter:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpLetter), allow: true)
        ]; //只允许输入字母
      case InputTextType.chinese:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpChinese), allow: true)
        ]; //只允许输入汉字
      case InputTextType.email:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpEmail), allow: true)
        ]; //只允许输入邮箱
      case InputTextType.phone:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpPhone), allow: true)
        ]; //只允许输入国内电话号
      case InputTextType.mobilePhone:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpMobilePhone), allow: true)
        ]; //只允许输入国内手机号
      case InputTextType.idCard:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpIdCard), allow: true)
        ]; //只允许输入身份证
      case InputTextType.ip:
        return <TextInputFormatter>[FilteringTextInputFormatter(RegExp(ConstConstant.regExpIP), allow: true)]; //只允许输入IP
      case InputTextType.positive:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpPositive), allow: true)
        ]; //只允许输入正数
      case InputTextType.negative:
        return <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(ConstConstant.regExpNegative), allow: true)
        ]; //只允许输入负数
      case InputTextType.text:
        return inputFormatter;
      default:
        return inputFormatter;
    }
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
    IconData icon,
    EdgeInsetsGeometry contentPadding,
    this.controller,
    this.suffixIcon,
    this.extraSuffix,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.color,
    this.heroTag,
    double size,
    this.borderRadius,
    this.inputStyle,
    this.cursorColor,
    this.labelSpacing,
    this.searchText,
    this.defaultBorder,
    this.focusedBorder,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.margin,
    this.extraPrefix,
    this.prefixIcon,
    this.searchStyle,
    this.searchTap,
    this.search,
    this.lineType,
    this.decoration,
    this.padding,
    this.alignment,
    this.fillColor,
    this.height,
    this.width,
    this.autoFocus,
    this.focusNode,
  })  : icon = icon ?? ConstIcon.search,
        size = size ?? 15,
        contentPadding = contentPadding ?? const EdgeInsets.all(6),
        super(key: key);

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Decoration decoration;
  final String searchText;
  final Widget search;
  final TextStyle searchStyle;
  final GestureTapCallback searchTap;
  final double size;
  final Color color;
  final IconData icon;
  final Widget prefixIcon;
  final double labelSpacing;
  final LineType lineType;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle inputStyle;
  final double borderRadius;
  final Color cursorColor;
  final InputBorder defaultBorder;
  final InputBorder focusedBorder;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Widget extraPrefix;
  final Widget extraSuffix;
  final EdgeInsetsGeometry contentPadding;
  final Color fillColor;
  final double height;
  final double width;
  final bool autoFocus;
  final FocusNode focusNode;
  final Widget suffixIcon;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    if (extraSuffix == null && extraPrefix == null) {
      children = null;
    } else {
      if (extraPrefix != null) children.add(extraPrefix);
      children.add(Expanded(child: heroTextInput()));
      if (extraSuffix != null) children.add(extraSuffix);
    }
    return Universal(
        decoration: decoration,
        margin: margin,
        height: height,
        width: width,
        alignment: alignment,
        padding: padding,
        direction: Axis.horizontal,
        children: children,
        child: extraPrefix == null ? heroTextInput() : null);
  }

  Widget heroTextInput() {
    if (heroTag != null) return Hero(tag: heroTag, child: textInput());
    return textInput();
  }

  Widget textInput() {
    return InputField(
        controller: controller,
        isDense: true,
        focusNode: focusNode,
        fillColor: fillColor,
        filled: true,
        focusedBorder: inputBorder(focusedBorderColor ?? enabledBorderColor ?? getColors(blue)),
        enabledBorder: inputBorder(enabledBorderColor ?? getColors(white50)),
        inputStyle: inputStyle,
        contentPadding: contentPadding,
        hintStyle: hintStyle,
        hintText: hintText,
        cursorColor: cursorColor ?? enabledBorderColor ?? getColors(blue),
        prefixIcon: prefix(),
        onChanged: onChanged,
        autoFocus: autoFocus,
        suffix: suffix(),
        suffixIcon: suffixIcon,
        enableInteractiveSelection: true);
  }

  Widget prefix() => prefixIcon ?? Icon(icon, size: size, color: color);

  Widget suffix() {
    if (search == null) {
      return searchText == null
          ? null
          : SimpleButton(
              text: searchText,
              onTap: searchTap,
              padding: EdgeInsets.symmetric(horizontal: getWidth(4)),
              textStyle: searchStyle ?? TextStyle(color: getColors(white)));
    } else {
      return search;
    }
  }

  InputBorder inputBorder(Color color) {
    if (lineType == LineType.outline) {
      return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: getWidth(0.5), color: color));
    } else if (lineType == LineType.underline) {
      return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: getWidth(0.5), color: color));
    } else {
      return InputBorder.none;
    }
  }
}
