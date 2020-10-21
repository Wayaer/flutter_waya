import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef OnDone = void Function(String text);
typedef PinBoxDecoration = BoxDecoration Function(
    Color borderColor, Color pinBoxColor,
    {double borderWidth, double radius});

/// class to provide some standard PinBoxDecoration such as standard box or underlined
/// 类提供一些标准的Pinbox装饰，例如标准框或下划线

/// Default BoxDecoration\
/// 默认框装饰
PinBoxDecoration defaultPinBoxDecoration = (Color borderColor,
        Color pinBoxColor, {double borderWidth = 2.0, double radius = 5.0}) =>
    BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        color: pinBoxColor,
        borderRadius: BorderRadius.circular(radius));

/// Underlined BoxDecoration
/// 下划线框装饰
PinBoxDecoration underlinedPinBoxDecoration = (Color borderColor,
        Color pinBoxColor, {double borderWidth = 2.0, double radius}) =>
    BoxDecoration(
        border:
            Border(bottom: BorderSide(color: borderColor, width: borderWidth)));

PinBoxDecoration roundedPinBoxDecoration = (Color borderColor,
        Color pinBoxColor, {double borderWidth = 2.0, double radius}) =>
    BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        shape: BoxShape.circle,
        color: pinBoxColor);

/// A combination of RotationTransition, DefaultTextStyleTransition, ScaleTransition
/// 一种旋转转换、变形、分级的组合
AnimatedSwitcherTransitionBuilder awesomeTransition =
    (Widget child, Animation<double> animation) => RotationTransition(
          turns: animation,
          child: DefaultTextStyleTransition(
              style: TextStyleTween(
                      begin: const TextStyle(color: Colors.pink),
                      end: const TextStyle(color: Colors.blue))
                  .animate(animation),
              child: ScaleTransition(child: child, scale: animation)),
        );

/// Simple Scaling Transition
/// 简单缩放转换
AnimatedSwitcherTransitionBuilder scalingTransition =
    (Widget child, Animation<double> animation) =>
        ScaleTransition(child: child, scale: animation);

/// No transition
AnimatedSwitcherTransitionBuilder defaultNoTransition =
    (Widget child, Animation<double> animation) => child;

/// Rotate Transition
AnimatedSwitcherTransitionBuilder rotateTransition =
    (Widget child, Animation<double> animation) =>
        RotationTransition(child: child, turns: animation);

class PinBox extends StatefulWidget {
  const PinBox({
    Key key,
    this.isCupertino = false,
    this.maxLength = 4,
    this.controller,
    this.hideCharacter = false,
    this.highlight = false,
    this.highlightAnimation = false,
    this.highlightAnimationBeginColor = Colors.white,
    this.highlightAnimationEndColor = Colors.black,
    this.highlightAnimationDuration,
    this.highlightColor = Colors.black,
    this.pinBoxDecoration,
    this.maskCharacter = ' ',
    this.pinBoxWidth = 70.0,
    this.pinBoxHeight = 70.0,
    this.pinTextStyle,
    this.onDone,
    this.defaultBorderColor = Colors.black,
    this.hasTextBorderColor = Colors.black,
    this.pinTextAnimatedSwitcherTransition,
    this.pinTextAnimatedSwitcherDuration = const Duration(),
    this.hasError = false,
    this.errorBorderColor = Colors.red,
    this.onTextChanged,
    this.autoFocus = false,
    this.focusNode,
    this.wrapAlignment = WrapAlignment.start,
    this.textDirection = TextDirection.ltr,
    this.keyboardType = TextInputType.number,
    this.pinBoxOuterPadding = const EdgeInsets.all(0),
    this.pinBoxColor,
    this.highlightPinBoxColor,
    this.pinBoxBorderWidth = 1.0,
    this.pinBoxRadius = 0,
    this.hideDefaultKeyboard = false,
    this.hasUnderline = false,
  }) : super(key: key);

  final bool isCupertino;
  final int maxLength;
  final TextEditingController controller;
  final bool hideCharacter;
  final bool highlight;
  final bool highlightAnimation;
  final Color highlightAnimationBeginColor;
  final Color highlightAnimationEndColor;
  final Duration highlightAnimationDuration;
  final Color highlightColor;
  final Color defaultBorderColor;
  final Color pinBoxColor;
  final Color highlightPinBoxColor;
  final double pinBoxBorderWidth;
  final double pinBoxRadius;
  final bool hideDefaultKeyboard;
  final PinBoxDecoration pinBoxDecoration;
  final String maskCharacter;
  final TextStyle pinTextStyle;
  final double pinBoxHeight;
  final double pinBoxWidth;
  final OnDone onDone;
  final bool hasError;
  final Color errorBorderColor;
  final Color hasTextBorderColor;
  final Function(String) onTextChanged;
  final bool autoFocus;
  final FocusNode focusNode;
  final AnimatedSwitcherTransitionBuilder pinTextAnimatedSwitcherTransition;
  final Duration pinTextAnimatedSwitcherDuration;
  final WrapAlignment wrapAlignment;
  final TextDirection textDirection;
  final TextInputType keyboardType;
  final EdgeInsets pinBoxOuterPadding;
  final bool hasUnderline;

  @override
  _PinBoxState createState() => _PinBoxState();
}

class _PinBoxState extends State<PinBox> with SingleTickerProviderStateMixin {
  AnimationController _highlightAnimationController;
  Animation<Color> _highlightAnimationColorTween;
  FocusNode focusNode;
  String text = '';
  int currentIndex = 0;
  List<String> strList = <String>[];
  bool hasFocus = false;
  double screenWidth;

  @override
  void didUpdateWidget(PinBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode = widget.focusNode ?? focusNode;
    if (oldWidget.maxLength < widget.maxLength) {
      currentIndex = text.length;
      setState(() {});
      widget.controller?.text = text;
      widget.controller?.selection =
          TextSelection.collapsed(offset: text.length);
    } else if (oldWidget.maxLength > widget.maxLength &&
        widget.maxLength > 0 &&
        text.isNotEmpty &&
        text.length > widget.maxLength) {
      text = text.substring(0, widget.maxLength);
      currentIndex = text.length;
      setState(() {});
      widget.controller?.text = text;
      widget.controller?.selection =
          TextSelection.collapsed(offset: text.length);
    }
  }

  Future<void> _calculateStrList() async {
    if (strList.length > widget.maxLength) strList.length = widget.maxLength;
    while (strList.length < widget.maxLength) strList.add('');
  }

  @override
  void initState() {
    super.initState();
    if (widget.highlightAnimation) {
      _highlightAnimationController = AnimationController(
          vsync: this,
          duration: widget.highlightAnimationDuration ??
              const Duration(milliseconds: 500));
      _highlightAnimationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _highlightAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _highlightAnimationController.forward();
        }
      });
      _highlightAnimationColorTween = ColorTween(
              begin: widget.highlightAnimationBeginColor,
              end: widget.highlightAnimationEndColor)
          .animate(_highlightAnimationController);
      _highlightAnimationController.forward();
    }
    focusNode = widget.focusNode ?? FocusNode();
    _initTextController();
    _calculateStrList();
    widget.controller?.addListener(_controllerListener);
    focusNode?.addListener(_focusListener);
  }

  void _controllerListener() {
    if (mounted == true) {
      _initTextController();
      setState(() {});
      if (widget.onTextChanged != null)
        widget.onTextChanged(widget.controller.text);
    }
  }

  void _focusListener() {
    if (mounted == true) {
      hasFocus = focusNode.hasFocus;
      setState(() {});
    }
  }

  void _initTextController() {
    if (widget.controller == null) return;
    strList.clear();
    if (widget.controller.text.isNotEmpty &&
        widget.controller.text.length > widget.maxLength) {
      throw Exception('TextEditingController length exceeded maxLength!');
    }
    text = widget.controller.text;
    for (int i = 0; i < text.length; i++)
      strList.add(widget.hideCharacter ? widget.maskCharacter : text[i]);
  }

  double get _width {
    double width = 0.0;
    for (int i = 0; i < widget.maxLength; i++) {
      width += widget.pinBoxWidth;
      if (i == 0) {
        width += widget.pinBoxOuterPadding?.left ?? 0;
      } else if (i + 1 == widget.maxLength) {
        width += widget.pinBoxOuterPadding?.right ?? 0;
      } else {
        width += widget.pinBoxOuterPadding?.left ??
            0 + widget.pinBoxOuterPadding?.right ??
            0;
      }
    }
    return width;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      focusNode?.dispose();
    } else {
      focusNode.removeListener(_focusListener);
    }
    _highlightAnimationController?.dispose();
    widget.controller?.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child =
        widget.isCupertino ? _fakeTextInputCupertino() : _fakeTextInput();
    return Stack(children: <Widget>[child, _touchPinBoxRow()]);
  }

  Widget _touchPinBoxRow() => widget.hideDefaultKeyboard
      ? _pinBoxRow(context)
      : GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (hasFocus) {
              FocusScope.of(context).requestFocus(FocusNode());
              Future<dynamic>.delayed(const Duration(milliseconds: 100), () {
                FocusScope.of(context).requestFocus(focusNode);
              });
            } else {
              FocusScope.of(context).requestFocus(focusNode);
            }
          },
          child: _pinBoxRow(context),
        );

  Widget _fakeTextInput() {
    const OutlineInputBorder transparentBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 0.0));
    return Container(
        width: _width,
        height: widget.pinBoxHeight,
        child: TextField(
            autofocus: widget.autoFocus,
            enableInteractiveSelection: false,
            focusNode: focusNode,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.keyboardType == TextInputType.number
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null,
            style: const TextStyle(height: 0.1, color: Colors.transparent),
            decoration: const InputDecoration(
                focusedErrorBorder: transparentBorder,
                errorBorder: transparentBorder,
                disabledBorder: transparentBorder,
                enabledBorder: transparentBorder,
                focusedBorder: transparentBorder,
                counterText: null,
                counterStyle: null,
                helperStyle: TextStyle(height: 0.0, color: Colors.transparent),
                labelStyle: TextStyle(height: 0.1),
                fillColor: Colors.transparent,
                border: InputBorder.none),
            cursorColor: Colors.transparent,
            showCursor: false,
            maxLength: widget.maxLength,
            onChanged: _onTextChanged));
  }

  Widget _fakeTextInputCupertino() => Container(
      width: _width,
      height: widget.pinBoxHeight,
      child: CupertinoTextField(
          autofocus: widget.autoFocus,
          focusNode: focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.keyboardType == TextInputType.number
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : null,
          style: const TextStyle(color: Colors.transparent),
          decoration:
              const BoxDecoration(color: Colors.transparent, border: null),
          cursorColor: Colors.transparent,
          showCursor: false,
          maxLength: widget.maxLength,
          onChanged: _onTextChanged));

  void _onTextChanged(String text) {
    if (widget.onTextChanged != null) widget.onTextChanged(text);
    setState(() {
      this.text = text;
      if (text.length < currentIndex) {
        strList[text.length] = '';
      } else {
        for (int i = currentIndex; i < text.length; i++) {
          strList[i] = widget.hideCharacter ? widget.maskCharacter : text[i];
        }
      }
      currentIndex = text.length;
    });
    if (text.length == widget.maxLength) {
      FocusScope.of(context).requestFocus(FocusNode());
      widget.onDone(text);
    }
  }

  Widget _pinBoxRow(BuildContext context) {
    _calculateStrList();
    // ignore: always_specify_types
    final List<Widget> pinCodes =
        List.generate(widget.maxLength, (int i) => _buildPinCode(i, context));
    return Wrap(
        direction: Axis.horizontal,
        alignment: widget.wrapAlignment,
        verticalDirection: VerticalDirection.down,
        textDirection: widget.textDirection,
        children: pinCodes);
  }

  Widget _buildPinCode(int i, BuildContext context) {
    Color borderColor;
    Color pinBoxColor;
    BoxDecoration boxDecoration;
    if (widget.hasError) {
      borderColor = widget.errorBorderColor;
    } else if (widget.highlightAnimation && _shouldHighlight(i)) {
      pinBoxColor = widget.pinBoxColor;
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimatedBuilder(
              animation: _highlightAnimationController,
              builder: (BuildContext context, Widget child) {
                if (widget.pinBoxDecoration != null) {
                  boxDecoration = widget.pinBoxDecoration(
                      _highlightAnimationColorTween.value, pinBoxColor,
                      borderWidth: widget.pinBoxBorderWidth,
                      radius: widget.pinBoxRadius);
                } else {
                  boxDecoration = defaultPinBoxDecoration(
                      _highlightAnimationColorTween.value, pinBoxColor,
                      borderWidth: widget.pinBoxBorderWidth,
                      radius: widget.pinBoxRadius);
                }
                return Container(
                    key: ValueKey<String>('container$i'),
                    child: Center(child: _animatedTextBox(strList[i], i)),
                    decoration: boxDecoration,
                    width: widget.pinBoxWidth,
                    height: widget.pinBoxHeight);
              }));
    } else if (widget.highlight && _shouldHighlight(i)) {
      borderColor = widget.highlightColor;
      pinBoxColor = widget.highlightPinBoxColor;
    } else if (i < text.length) {
      borderColor = widget.hasTextBorderColor;
      pinBoxColor = widget.highlightPinBoxColor;
    } else {
      borderColor = widget.defaultBorderColor;
      pinBoxColor = widget.pinBoxColor;
    }

    if (widget.pinBoxDecoration != null) {
      boxDecoration = widget.pinBoxDecoration(borderColor, pinBoxColor,
          borderWidth: widget.pinBoxBorderWidth, radius: widget.pinBoxRadius);
    } else {
      boxDecoration = defaultPinBoxDecoration(borderColor, pinBoxColor,
          borderWidth: widget.pinBoxBorderWidth, radius: widget.pinBoxRadius);
    }
    EdgeInsets insets;
    if (i == 0) {
      insets = EdgeInsets.only(
          top: widget.pinBoxOuterPadding.top,
          right: widget.pinBoxOuterPadding.right,
          bottom: widget.pinBoxOuterPadding.bottom);
    } else if (i == strList.length - 1) {
      insets = EdgeInsets.only(
          left: widget.pinBoxOuterPadding.left,
          top: widget.pinBoxOuterPadding.top,
          bottom: widget.pinBoxOuterPadding.bottom);
    } else {
      insets = widget.pinBoxOuterPadding;
    }
    return Universal(
      padding: insets,
      key: ValueKey<String>('container$i'),
      child: Universal(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Center(child: _animatedTextBox(strList[i], i)),
        decoration: widget.hasUnderline
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: borderColor ?? Colors.black)))
            : null,
      ),
      decoration: boxDecoration,
      width: widget.pinBoxWidth,
      height: widget.pinBoxHeight,
    );
  }

  bool _shouldHighlight(int i) =>
      hasFocus &&
      (i == text.length ||
          (i == text.length - 1 && text.length == widget.maxLength));

  Widget _animatedTextBox(String text, int i) {
    if (widget.pinTextAnimatedSwitcherTransition != null) {
      return AnimatedSwitcher(
          duration: widget.pinTextAnimatedSwitcherDuration,
          transitionBuilder: widget.pinTextAnimatedSwitcherTransition ??
              (Widget child, Animation<double> animation) => child,
          child: Text(text,
              key: ValueKey<String>('$text$i'), style: widget.pinTextStyle));
    } else {
      return Text(text,
          key: ValueKey<String>('${strList[i]}$i'), style: widget.pinTextStyle);
    }
  }
}
