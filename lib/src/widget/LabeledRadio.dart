import 'package:flutter/material.dart';

class LabeledRadio extends StatelessWidget {

  EdgeInsets padding;
  EdgeInsets titlePadding;
  final Widget label;
  final dynamic groupValue;
  final Color activeColor;
  final dynamic value;
  final Function onChanged;

  LabeledRadio({
    Key key,
    this.label,
    this.padding,
    this.titlePadding,
    this.groupValue,
    this.activeColor,
    this.value,
    this.onChanged,
  }) :super(key: key) {
    if (padding == null) padding = EdgeInsets.zero;
    if (titlePadding == null) titlePadding = EdgeInsets.zero;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue && onChanged != null) onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio(
              groupValue: groupValue,
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: activeColor,
              onChanged: (dynamic newValue) {
                onChanged(newValue);
              },
            ),
            Padding(
              padding: titlePadding,
              child: label,
            ),
          ],
        ),
      ),
    );
  }
}
