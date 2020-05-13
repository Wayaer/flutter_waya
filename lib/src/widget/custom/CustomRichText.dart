import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final TextAlign textAlign;
  final List<String> text;
  final List<TextStyle> textStyle;

  CustomRichText({
    Key key,
    this.text,
    TextAlign textAlign, this.textStyle,
  })
      : this.textAlign = textAlign ?? TextAlign.center,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return richText();
  }

  Widget richText() {
    List<TextSpan> children = List();
    List<TextStyle> styles = List();

    if (textStyle == null) {
      styles.add(TextStyle(fontSize: 14));
    } else {
      styles.addAll(textStyle);
    }
    if (text.length > styles.length) {
      int poor = text.length - styles.length;
      print(poor);
      for (int i = 0; i <= poor; i++) {
        styles.add(styles.last);
      }
    }
    text.map((value) {
      children.add(TextSpan(text: value, style: styles[text.indexOf(value)]));
    }).toList();
    return RichText(
      text: TextSpan(text: '', children: children),
      textAlign: textAlign,
    );
  }
}
