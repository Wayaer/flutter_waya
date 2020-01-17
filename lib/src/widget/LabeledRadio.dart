import 'package:flutter/material.dart';

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    this.label,
    this.padding = const EdgeInsets.all(0),
    this.titlePadding = const EdgeInsets.all(0),
    this.groupValue,
    this.activeColor,
    this.value,
    this.onChanged,
  });

  final Widget label;
  final EdgeInsets padding;
  final EdgeInsets titlePadding;
  final dynamic groupValue;
  final Color activeColor;
  final dynamic value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
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
