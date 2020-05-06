import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/widget/custom/CustomFlex.dart';

class CustomRichText extends StatelessWidget {
  final GestureTapCallback onTap;
  final InlineSpan text;
  final Color background;
  final AlignmentGeometry alignment;
  final TextAlign textAlign;

  CustomRichText({
    Key key,
    this.background,
    this.onTap,
    this.alignment,
    this.text,
    TextAlign textAlign,
  })
      : this.textAlign = textAlign ?? TextAlign.center,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return onTap == null
        ? richText()
        : CustomFlex(
      alignment: alignment,
      color: background,
      onTap: onTap,
      child: richText(),
    );
  }

  Widget richText() {
    return RichText(
      text: text,
      textAlign: textAlign,
    );
  }
}
