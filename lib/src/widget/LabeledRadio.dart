import 'package:flutter/material.dart';

class LabeledRadio extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets titlePadding;
  final Widget label;
  final dynamic groupValue;
  final Color activeColor;
  final dynamic value;
  final Function onChanged;

  LabeledRadio({
    Key key,
    EdgeInsets padding,
    EdgeInsets titlePadding,
    this.label,
    this.groupValue,
    this.activeColor,
    this.value,
    this.onChanged,
  })
      : this.padding = padding ?? EdgeInsets.zero,
        this.titlePadding = titlePadding ?? EdgeInsets.zero,
        super(key: key);

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
