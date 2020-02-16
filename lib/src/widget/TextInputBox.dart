import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/BaseEnum.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayConstant.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';

class TextInputBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  final List<TextInputFormatter> inputFormatter;
  final TextAlign textAlign; // 对齐方式
  final int maxLength; //最大长度
  final TextDirection textDirection;
  final int maxLines;

  final int minLines;
  final TextInputType keyboardType;
  final ValueChanged<String> onSubmitted;
  final InputDecoration decoration;
  final Color cursorColor; //光标颜色
  final InputTextType inputTextType;

  //显示在输入框右下方
  final String counterText;
  final TextStyle counterStyle;
  final Widget counter;

  final bool obscureText; //隐藏文字
  final Widget header;
  final Widget footer;
  final FocusNode focusNode;
  final TextStyle inputStyle;

  //输入框左边下划线外面
  final Widget icon;

  //输入框左边
  final Widget prefixIcon; //前缀
  final String prefixText;
  final Widget prefix;
  final TextStyle prefixStyle;

  //输入框右边
  final Widget suffixIcon; //后缀
  final String suffixText;
  final Widget suffix;
  final TextStyle suffixStyle;

  //显示在输入框左下角的文字提示
  final TextStyle errorStyle;
  final String errorText;
  final int errorMaxLines;

  //显示在输入框下划线下面的提示语，提示使用
  final String helperText;
  final TextStyle helperStyle;
  final String labelText; //显示在输入框内的提示语，一旦输入框获取焦点就字体缩小并上移到输入上方，作为提示使用
  final TextStyle labelStyle;
  final bool labelFloating; //默认为true，表示labelText是否上浮，true上浮，false表示获取焦点后labelText消失
  final bool isDense; //是否开启紧密
  final bool filled; //输入框颜色
  final bool enabled; //开始输入
  final InputBorder disabledBorder; //不能输入状态框
  final InputBorder enabledBorder; //开启输入状态框
  final InputBorder errorBorder; //失去焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
  final InputBorder focusedErrorBorder; //获取焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
  final InputBorder focusedBorder; //获取焦点输入框
  final InputBorder defaultBorder; //以上都未设置时 默认输入框
  final GestureTapCallback onTap;
  final Color fillColor;
  final TextStyle hintStyle;
  final String hintText;
  final int hintMaxLines;
  final EdgeInsetsGeometry contentPadding;

  TextInputBox({
    Key key,
    this.icon,
    this.controller,
    this.enabled,
    this.decoration,
    this.onSubmitted,
    this.inputStyle,
    this.keyboardType,
    this.maxLines: 1,
    this.minLines,
    this.textDirection,
    this.textAlign: TextAlign.left,
    this.maxLength,
    this.onChanged,
    this.cursorColor,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.inputFormatter,
    this.fillColor,
    this.inputTextType,
    this.prefixText,
    this.prefixIcon,
    this.isDense,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.defaultBorder,
    this.labelText,
    this.labelStyle,
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
    this.labelFloating,
    this.focusNode,
    this.header,
    this.footer,
    this.obscureText: false,
    this.hintMaxLines,
    this.counterText,
    this.counterStyle,
    this.counter,
  }) : super(key: key);

//  解决光标左移问题
//  @override
//  void initState() {
//    super.initState();
//    if ( controller == null) {
//      textController = TextEditingController.fromValue(TextEditingValue(
//          text: value.trim(), selection: TextSelection.fromPosition(TextPosition(offset: value.length))));
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return header != null || footer != null
        ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //输入框头部
            Offstage(offstage: header == null, child: header),
            textField(context),
            //输入框底部
            Offstage(offstage: footer == null, child: footer)
          ])
        : textField(context);
  }

  Widget textField(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardAppearance: Brightness.dark,
      textDirection: textDirection,
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatter ?? inputType(),
      //光标颜色
      cursorColor: cursorColor ?? getColors(black70),
      //光标圆角
      cursorRadius: Radius.circular(1),
      //光标宽度
      cursorWidth: 2,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: inputStyle ?? WayStyles.textStyleBlack70(fontSize: 16),
      controller: controller,
      onTap: onTap,
      decoration: decoration ??
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
            hasFloatingPlaceholder: labelFloating,
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
            enabled: enabled ?? true,
            //获取焦点时，下划线的样式
            focusedBorder: focusedBorder,
            //级别最低的border，没有设置其他border时显示的border
            border: defaultBorder,
//            border: InputBorder.none,
          ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled ?? true,
    );
  }

  List<TextInputFormatter> inputType() {
    switch (inputTextType) {
      case InputTextType.number:
        return [WhitelistingTextInputFormatter.digitsOnly];
      case InputTextType.password:
        return [WhitelistingTextInputFormatter(RegExp(WayConstant.regExpPassword))]; //密码常见类型
      case InputTextType.text:
        return inputFormatter;
      case InputTextType.decimal:
        return [WhitelistingTextInputFormatter(RegExp(WayConstant.regExpDecimal))]; //只允许输入小数
      case InputTextType.letter:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpLetter)),
        ]; //只允许输入字母
      case InputTextType.chinese:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpLetter)),
        ];
      case InputTextType.email:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpChinese)),
        ];
      case InputTextType.phoneNumber:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpPhoneNumber)),
        ];
      case InputTextType.mobilePhoneNumber:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpMobilePhoneNumber)),
        ];
      case InputTextType.dateTime:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpDateTime)),
        ];
      case InputTextType.idCard:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpIdCard)),
        ];
      case InputTextType.ip:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpIP)),
        ];
      case InputTextType.url:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpUrl)),
        ];
      case InputTextType.positive:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpPassword)),
        ];
      case InputTextType.negative:
        return [
          WhitelistingTextInputFormatter(RegExp(WayConstant.regExpNegative)),
        ];
      default:
        return inputFormatter;
    }
  }
}
