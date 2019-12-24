import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayEnum.dart';
import 'package:flutter_waya/src/constant/WayIcon.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

import 'CustomButton.dart';
import 'CustomFlex.dart';
import 'CustomIcon.dart';



class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double width;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry headMargin;
  final EdgeInsetsGeometry headPadding;
  final EdgeInsetsGeometry footPadding;
  final EdgeInsetsGeometry footMargin;
  final EdgeInsetsGeometry eyePadding;
  final EdgeInsetsGeometry eyeMargin;
  final double height;
  final double lineWidth;
  final double inputBoxWidth;
  final double inputBoxHeight;
  final EdgeInsetsGeometry inputBoxPadding;
  final EdgeInsetsGeometry inputBoxMargin;
  final Widget inputBoxRightWight;
  final Widget inputBoxOutLeftWidget;
  final Widget inputBoxLeftWight;
  final Widget inputBoxOutRightWidget;
  final String hintText;
  final Widget headLeftWight;
  final String headLeftText;
  final Widget headRightWight;
  final IconData headRightIcon;
  final Widget footLeftWight;
  final String footLeftText;
  final Widget footRightWight;
  final TextStyle hintStyle;
  final TextStyle headLeftTextStyle;
  final EdgeInsetsGeometry contentPadding;
  final Color inputBoxColor;
  final Color color;
  final TextAlign textAlign; // 对齐方式
  final int maxLength; //最大长度
  final TextDirection textDirection;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final TextStyle inputTextStyle;
  final TextStyle footLeftTextStyle;
  final ValueChanged<String> onSubmitted;
  final bool enabled;
  final bool showEye;
  final InputDecoration inputDecoration;
  final Color lineBackground;
  final Color lineFocusBackground;
  final Color cursorColor;
  final GestureTapCallback headRightIconOnTap;
  final String value;
  final double eyeIconSize;
  final IconData eyeCloseIcon;
  final IconData eyeOpenIcon;
  final Color eyeOpenColor;
  final Color eyeCloseColor;
  final Widget eyeOpenWidget;
  final Widget eyeCloseWidget;
  final LineType lineType;
  final BorderRadiusGeometry inputBoxLineBorderRadius;

  final Widget icon;

  CustomInput({
    Key key,
    this.icon,
    this.eyeCloseWidget,
    this.eyeOpenWidget,
    this.eyeIconSize,
    this.eyeCloseIcon,
    this.eyeOpenIcon,
    this.eyeOpenColor,
    this.eyeCloseColor,
    this.value,
    this.lineWidth,
    this.controller,
    this.lineBackground,
    this.lineFocusBackground,
    this.headRightIconOnTap,
    this.enabled,
    this.inputDecoration,
    this.onSubmitted,
    this.showEye: false,
    this.inputTextStyle,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.textDirection,
    this.textAlign: TextAlign.left,
    this.maxLength,
    this.onChanged,
    this.color,
    this.cursorColor,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.headLeftWight,
    this.headLeftText,
    this.headRightWight,
    this.headRightIcon,
    this.headLeftTextStyle,
    this.footLeftWight,
    this.footLeftText,
    this.footRightWight,
    this.inputBoxWidth,
    this.inputBoxHeight,
    this.inputBoxPadding,
    this.inputBoxMargin,
    this.inputBoxColor,
    this.hintText,
    this.hintStyle,
    this.inputBoxRightWight,
    this.inputBoxLeftWight,
    this.contentPadding,
    this.lineType,
    this.inputBoxLineBorderRadius,
    this.inputBoxOutLeftWidget,
    this.inputBoxOutRightWidget,
    this.headMargin,
    this.headPadding,
    this.footPadding,
    this.footMargin,
    this.eyePadding,
    this.eyeMargin,
    this.footLeftTextStyle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomInputState();
  }
}

class CustomInputState extends State<CustomInput> {
  FocusNode inputFocusNode = FocusNode();
  bool focus = false;
  bool eye = true;
  bool obscureText = false;
  InputDecoration inputDecoration;
  static String value;
  TextEditingController textController;
  Color lineBackground;
  Color lineFocusBackground;

  @override
  void initState() {
    super.initState();
    lineBackground = widget.lineBackground ?? getColors(background);
    lineFocusBackground = widget.lineFocusBackground ?? getColors(blue);
    inputFocusNode.addListener(onChangeFocus);
//    eye = !(widget.inputType == InputType.password);
    if (widget.controller == null) {
      value = widget.value ?? '';
      textController = TextEditingController.fromValue(TextEditingValue(
          text: value.trim(),
          selection:
              TextSelection.fromPosition(TextPosition(offset: value.length))));
    }
  }

  @override
  void dispose() {
    super.dispose();
    inputFocusNode.removeListener(onChangeFocus);
  }

  onChangeFocus() {
    setState(() {
      focus = inputFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.headLeftWight != null ||
            widget.headLeftText != null ||
            widget.headRightWight != null ||
            widget.headRightIcon != null ||
            widget.footLeftWight != null ||
            widget.footLeftText != null ||
            widget.footRightWight != null
        ? CustomFlex(
            mainAxisSize: MainAxisSize.min,
            decoration: BoxDecoration(
              color: widget.color,
            ),
            height: widget.height,
            width: widget.width,
            margin: widget.margin,
            padding: widget.padding,
            children: <Widget>[
                //输入框头部
                Offstage(
                    offstage: !(widget.headLeftWight != null ||
                        widget.headRightWight != null ||
                        widget.headLeftText != null),
                    child: CustomFlex(
                        margin: widget.headMargin,
                        padding: widget.headPadding,
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Offstage(
                            offstage: !(widget.headLeftWight != null ||
                                widget.headLeftText != null),
                            child: widget.headLeftText != null
                                ? Text(widget.headLeftText,
                                    style: widget.headLeftTextStyle ??
                                        WayStyles.textStyleBlack70(
                                            fontSize: 15))
                                : widget.headLeftWight,
                          ),
                          Offstage(
                            offstage: !(widget.headRightWight != null ||
                                widget.headRightIcon != null),
                            child: widget.headRightIcon != null
                                ? CustomIcon(
                                    icon: widget.headRightIcon,
                                    iconColor: getColors(blue),
                                    iconSize: WayUtils.getWidth(18),
                                    onTap: widget.headRightIconOnTap,
                                  )
                                : widget.headRightWight,
                          )
                        ])),
                inputBoxCenterRow(context),
                //输入框底部
                Offstage(
                    offstage: !(widget.footLeftWight != null ||
                        widget.footRightWight != null ||
                        widget.footLeftText != null),
                    child: CustomFlex(
                        margin: widget.footMargin ??
                            EdgeInsets.only(top: WayUtils.getHeight(5)),
                        padding: widget.footPadding,
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Offstage(
                            offstage: !(widget.footLeftWight != null ||
                                widget.footLeftText != null),
                            child: widget.footLeftText != null
                                ? Text(
                                    widget.footLeftText,
                                    style: widget.footLeftTextStyle ??
                                        WayStyles.textStyleBlack70(
                                            fontSize: 12),
                                  )
                                : widget.footLeftWight,
                          ),
                          Offstage(
                            offstage: widget.footRightWight == null,
                            child: widget.footRightWight,
                          )
                        ]))
              ])
        : inputBoxCenterRow(context);
  }

  inputBoxCenterRow(BuildContext context) {
    return widget.inputBoxOutLeftWidget != null ||
            widget.inputBoxOutRightWidget != null
        ? CustomFlex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Offstage(
                offstage: widget.inputBoxOutLeftWidget == null,
                child: widget.inputBoxOutLeftWidget,
              ),
              Expanded(child: inputBoxCenter(context)),
              Offstage(
                offstage: widget.inputBoxOutRightWidget == null,
                child: widget.inputBoxOutRightWidget,
              )
            ],
          )
        : inputBoxCenter(context);
  }

  BoxDecoration inputBoxLine() {
    if (widget.lineType == LineType.underline) {
      return BoxDecoration(
          color: widget.inputBoxColor,
          border: Border(
              bottom: BorderSide(
                  width: widget.lineWidth ?? WayUtils.getWidth(1),
                  color: focus ? lineFocusBackground : lineBackground)));
    } else if (widget.lineType == LineType.outLine) {
      return BoxDecoration(
          color: widget.inputBoxColor,
          borderRadius: widget.inputBoxLineBorderRadius,
          border: Border.all(
              width: widget.lineWidth ?? WayUtils.getWidth(1),
              color: focus ? lineFocusBackground : lineBackground));
    } else {
      return BoxDecoration();
    }
  }

  Widget inputBoxCenter(BuildContext context) {
    return CustomFlex(
      height: widget.inputBoxHeight,
      width: widget.inputBoxWidth,
      margin: widget.inputBoxMargin,
      padding: widget.inputBoxPadding,
      direction: Axis.horizontal,
      decoration: inputBoxLine(),
      children: <Widget>[
        Offstage(
          offstage: widget.inputBoxLeftWight == null,
          child: widget.inputBoxLeftWight,
        ),
        Expanded(child: inputBox(context)),
        Offstage(
          offstage: !widget.showEye,
          child: CustomCheckBox(
            value: !eye,
            padding: widget.eyePadding,
            margin: widget.eyeMargin ??
                EdgeInsets.only(right: WayUtils.getWidth(10)),
            iconSize: widget.eyeIconSize,
            uncheckIcon: widget.eyeCloseIcon ?? WayIcon.iconsEyeClose,
            checkIcon: widget.eyeOpenIcon ?? WayIcon.iconsEyeOpen,
            checkColor: widget.eyeOpenColor,
            unCheckColor: widget.eyeCloseColor,
            checkWidget: widget.eyeOpenWidget,
            uncheckWidget: widget.eyeCloseWidget,
            onChange: (value) {
              setState(() {
                eye = !value;
              });
            },
          ),
        ),
        Offstage(
          offstage: widget.inputBoxRightWight == null,
          child: widget.inputBoxRightWight,
        ),
      ],
    );
  }

  Widget inputBox(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardAppearance: Brightness.dark,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      focusNode: inputFocusNode,
      //光标颜色
      cursorColor: widget.cursorColor ?? getColors(black70),
      //光标圆角
      cursorRadius: Radius.circular(1),
      //光标宽度
      cursorWidth: 2,
      obscureText: widget.showEye == true ? eye : false,
      keyboardType: widget.keyboardType,
      style: widget.inputTextStyle ?? WayStyles.textStyleBlack70(fontSize: 16),
      controller: widget.controller ?? textController,
//        onTap:widget.onTap,
      decoration: widget.inputDecoration ??
          InputDecoration(
//            fillColor: Colors.blue,
            //显示在输入框前面的图标，在文字和下划线前面
            icon: widget.icon,
            //输入框光标前面的图标和文字
//            prefixIcon:  widget.prefixIcon,
            //显示在输入框内，光标前面的图标，注意icon是在输入框外
//                prefixText: "prefixText",
            //显示在输入框内，光标前面的文字   获得焦点后显示
//                prefixStyle: TextStyle(color: Colors.yellow),
            //显示在输入框内，光标前面的指定图片或其他Widget   获取焦点后显示。注意prefix不能与prefixIcon prefixText同时指定
//            prefix:  widget.prefix ,

            //输入框光标后面的图标和文字
            // suffixIcon: Icon(Icons.phone),
//            suffixIcon: widget.focusedHide ? null : widget.suffix,
            //显示在输入框内，光标文字后面，输入框最后面的图标
            counterText: '',
            //text无点击事件
//           suffixText: widget.suffixText,
            //显示在输入框内，输入框最后面的文字    但是在suffixIcon之前。 注意suffixText不能与suffix共存
//            suffixStyle: widget.suffixStyle,
            //显示在输入框内，最后面的指定图片或其他Widget
//            suffix: widget.suffix,

            // 显示在输入的下划线外右下角的文字提示
//            counterText: "counterText",
            //显示在输入的下划线外右下角的文字提示,会覆盖maxLength的右下角显示的字数限制。
//            counterStyle: TextStyle(color: Colors.pink),
            //显示在输入的下划线外右下角的提示,可以是任何Widget ，counterText与counter只能存在一个
//            counter: Icon(Icons.send),

            // 输入框的文字提示
//            labelText: widget.labelText,
            //显示在输入框内的提示语，一旦输入框获取焦点就字体缩小并上移到输入上方，作为提示使用
//            labelStyle: widget.labelStyle,
//            helperText: "helperText",
//            //显示在输入框下划线下面的提示语，提示使用
//            helperStyle: TextStyle(color: Colors.blue),
//            hasFloatingPlaceholder: true,
            //默认为true，表示labelText是否上浮，true上浮，false表示获取焦点后labelText消失
            hintText: widget.hintText,
            //显示在输入框内的提示信息，当输入框为空时显示，一旦开始输入内容就消失
            hintStyle:
                widget.hintStyle ?? WayStyles.textStyleBlack30(fontSize: 16),
            hintMaxLines: 1,
            //提示语的做多显示行数，超过行数显示...

            // 错误提示相关
//                errorText: "errorText",
            //在输入框下方的提示语，通常用于错误提示，比如密码错误 用户名错误等  同时输入框的下划线修改为了红色
//                errorStyle: TextStyle(color: Colors.orange),
//                errorMaxLines: 1,
            //做多显示的行数  ，超过行数显示...
//            errorBorder: underlineInputBorder(
//                borderSide: BorderSide(width: 5, color: Colors.orange, style: BorderStyle.solid)),
//            //失去焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线
//            focusedErrorBorder: underlineInputBorder(
//                borderSide: BorderSide(width: 5, color: Colors.green, style: BorderStyle.solid)),
//            //获取焦点时，error时下划线显示的边框样式，不设置则使用默认的的下划线

//            //输入框内文字 密集显示
//            isDense: false,
//            //改变输入框是否为密集型，默认为false，修改为true时，图标及间距会变小  行间距减小
//
//            //内部padding
//            contentPadding: EdgeInsets.zero,
//            //输入框的padding  对内部的文字有效
//            //背景色
//            fillColor: Colors.red,
//            //输入框内部的填充颜色  需filled=true
//            filled: false,

            //输入框禁用时，下划线的样式.如果设置了errorText，则此属性无效
//            disabledBorder: underlineInputBorder(
//                borderSide: BorderSide(
//                    width: WayUtils.getWidth( 1),
//                    color: getColors( lineBackground),
//                    style: BorderStyle.solid)),

            //输入框启用时，下划线的样式
//            enabledBorder: underlineInputBorder(
//                borderSide: BorderSide(
//                    width: WayUtils.getWidth( 1),
//                    color: getColors( lineBackground),
//                    style: BorderStyle.solid)),

            //是否启用输入框
//            enabled: true,
            //获取焦点时，下划线的样式
//            focusedBorder: underlineInputBorder(
//                borderSide: BorderSide(
//                    width: WayUtils.getWidth(1),
//                    color: Colors.blue,
//                    style: BorderStyle.solid)),

            //级别最低的border，没有设置其他border时显示的border
//            border: OutlineInputBorder(
//                borderSide: BorderSide(
//                    width: WayUtils.getWidth( 1),
//                    color: getColors( lineBackground),
//                    style: BorderStyle.solid)),
            border: InputBorder.none,
          ),
      onChanged: (text) {
        value = text;
        if (widget.onChanged is ValueChanged<String>) {
          widget.onChanged(text);
        }
      },
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled ?? true,
    );
  }
}
